//
//  ViewController.swift
//  WalkATen
//
//  Created by jboro on 2/4/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var viewController: ViewController? {
        didSet{
            guard let viewController = viewController else{
                return
            }
            
            setupViewController(with: viewController)
        }
    }
    
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
       
        locationMngr.delegate = self
        locationMngr.desiredAccuracy = kCLLocationAccuracyBest
        locationMngr.distanceFilter = minWalkDistanceInMetersBeforeAlert
        locationMngr.requestLocation()
        
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
    
    func isLocationServicesAllowed() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            switch (CLLocationManager.authorizationStatus()){
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        }
        return false
    }
    
    
    func showToastMessage(message : String) {

        let lblToast = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        lblToast.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        lblToast.textColor = UIColor.white
        lblToast.textAlignment = .center;
        lblToast.font = UIFont(name: "Montserrat-Light", size: 12.0)
        lblToast.text = message
        lblToast.alpha = 1.0
        lblToast.layer.cornerRadius = 10;
        lblToast.clipsToBounds  =  true
        self.view.addSubview(lblToast)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
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
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
            
        if let userLocation = locations.last?.coordinate{

            if initialUserLocation == nil {
                initialUserLocation = userLocation
            }else{
                currentUserLocation = userLocation
            }
            
            userHasMoved10Meters = (locationService?.CheckNextLocationMoreThan10Meters(initialLocation: initialUserLocation, currentLocation: currentUserLocation)) ?? false
          
            if userHasMoved10Meters {
                showToastMessage(message: "Moved 10 meters")
                initialUserLocation = currentUserLocation
            }
            
         }

    }
    
}
