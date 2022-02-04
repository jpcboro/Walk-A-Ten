//
//  ViewController.swift
//  WalkATen
//
//  Created by jboro on 2/4/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var locationMngr = CLLocationManager()
    var currentUserLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMngr.delegate = self
        locationMngr.desiredAccuracy = kCLLocationAccuracyBest
        locationMngr.distanceFilter = 10
        locationMngr.requestLocation()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestUserLocation()
    }

    func requestUserLocation()
    {
        if isLocationServicesAllowed() {
            locationMngr.startUpdatingLocation()
        }else{
            locationMngr.requestWhenInUseAuthorization()
        }
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
    
    func showAlert()
    {
        var dialogAlert = UIAlertController(title: "Alert!", message: "You have moved more than 10 meters, congratulations!", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        dialogAlert.addAction(okButton)
        
        self.present(dialogAlert, animated: true, completion: nil)
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
        
        if let currentUserLocation = locations.last{
            print("Current location: \(currentUserLocation)")
            showAlert()
        }
     
    }
    
}
