//
//  ViewController.swift
//  WalkATen
//
//  Created by jboro on 2/4/22.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    var viewController: ViewController? {
        didSet{
            guard let viewController = viewController else{
                return
            }
            
            setupViewController(with: viewController)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    private func setupViewController(with viewController: ViewController)
    {
        viewController.requestUserLocation()
    }
    var locationMngr = CLLocationManager()
    var locationProviderProtocol: UserLocationProviderProtocol?

    var userLocation: UserLocationProtocol?
    var userLocationLatitude : Double = 0.0
    
    var tenMeterLocation : UserLocationProtocol?
    var tenMeterLocationLatitude : Double = 0.0
    var newLocationLatitude : Double = 0.0
    var locationService: UserLocationService?
    
    var initialUserLocation: CLLocationCoordinate2D?
    var currentUserLocation: CLLocationCoordinate2D?
    var userLocationAfte10MeterWalk: CLLocation?
    let start = Date()
    let set_time_before_showing_alert : TimeInterval = 10
    let minWalkDistanceInMetersBeforeAlert = 10.0
    var userHasMoved10Meters : Bool = false
    
    init(locationProviderProtocol: UserLocationProviderProtocol)
    {
        super.init(nibName: nil, bundle: nil)
        self.locationProviderProtocol = locationProviderProtocol
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
       checkLocationServicesIfAllowed()

    }
    
    func setLocationManager()
    {
        locationMngr.delegate = self
        locationMngr.desiredAccuracy = kCLLocationAccuracyBest
        locationMngr.distanceFilter = minWalkDistanceInMetersBeforeAlert
        locationMngr.requestLocation()
      
    }
    
    func setLocationService()
    {
        locationService = UserLocationService(with: locationMngr)
        locationService?.findUserLocation{_, _ in}
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    func requestUserLocation()
    {
        locationProviderProtocol?.findUserLocation{
            [weak self] location, error in
            if error == nil {
                
                if self?.userLocation == nil {
                    self?.userLocation = location
                    self?.userLocationLatitude = location?.coordinate.latitude ?? 0
                    
                    self?.tenMeterLocationLatitude = self?.userLocationLatitude ?? 0
                    
                }else{
                    self?.tenMeterLocation = location

                }
                
            }else{
                print("User cannot be located")
            }
        }
        
     }
       

    func isLocationNotifyAllowed() -> Bool {
       
       let startNotifyDistance = Date().timeIntervalSince(start) > set_time_before_showing_alert
      print("start notify? \(startNotifyDistance)")
       return startNotifyDistance
   }
    
    func checkLocationServicesIfAllowed(){
        if CLLocationManager.locationServicesEnabled(){
            setLocationManager()
            checkLocationPermissions()
            setLocationService()
            
        }else{
            showAlert(title: "Alert", message: "Please allow Location Services in Settings")
        }
    }

    func checkLocationPermissions(){
        
        switch (CLLocationManager.authorizationStatus()){
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            centerOnUserLocation(regionInMeters: 1000)
            locationMngr.startUpdatingLocation()
            
            
        break
        case .denied:
            showAlert(title: "Denied", message: "Location Access denied, please check Walk-A-Ten's Location Access in Settings")
        break
        case .notDetermined:
            locationMngr.requestWhenInUseAuthorization()

        break
        case .restricted:
            showAlert(title: "Restricted", message:"Location Access restricted, please check Walk-A-Ten's Location Access in Settings")

        break
        @unknown default:
        break
        }
        
    }
    
    func centerOnUserLocation(regionInMeters: Double)
    {
        DispatchQueue.main.async {
            if let location = self.locationMngr.location?.coordinate{
           
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                self.mapView.setRegion(region, animated: true)
            }
        }

    }
    
    func showAlert(title: String, message: String)
    {
        DispatchQueue.main.async {
            let dialogAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)

            dialogAlert.addAction(okButton)
            
            self.present(dialogAlert, animated: true, completion: nil)
        }
           
    }
    
    func showToastMessage(message : String, duration: Double = 4) {

        let lblToast = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 170, y: self.view.frame.size.height-140, width: 330, height: 35))
        lblToast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        lblToast.textColor = UIColor.white
        lblToast.textAlignment = .center;
        lblToast.font = UIFont(name: "Montserrat-Light", size: 12.0)
        lblToast.text = message
        lblToast.alpha = 1.0
        lblToast.layer.cornerRadius = 10;
        lblToast.clipsToBounds  =  true
        self.view.addSubview(lblToast)
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            lblToast.alpha = 0.0
        }, completion: {(isCompleted) in
            lblToast.removeFromSuperview()
        })
    }
    
}


extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        if let userLocation = locations.last?.coordinate{

            if initialUserLocation == nil {
                initialUserLocation = userLocation
            }else{
                currentUserLocation = userLocation
            }
            
            userHasMoved10Meters = (locationService?.checkNextLocationMoreThan10Meters(initialLocation: initialUserLocation, currentLocation: currentUserLocation)) ?? false
          
            if userHasMoved10Meters {

                let moveDistance = locationService?.calculateDistance(initialLocation: initialUserLocation, currentLocation: currentUserLocation) ?? 0
                let moveDistanceRounded = round(moveDistance * 100) / 100.0
                showToastMessage(message: "You have moved more than \(moveDistanceRounded) meters")
                centerOnUserLocation(regionInMeters: 100)
                initialUserLocation = currentUserLocation
            }
            
         }

    }
    
}
