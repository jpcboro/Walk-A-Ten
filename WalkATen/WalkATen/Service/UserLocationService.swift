//
//  UserLocationService.swift
//  WalkATen
//
//  Created by jboro on 2/5/22.
//

import Foundation
import CoreLocation

class UserLocationService: NSObject, UserLocationProviderProtocol {

    
    fileprivate var locationProviderProtocol: LocationProviderProtocol
    fileprivate var locationCompletionBlock: UserLocationCompletionBlock?
    var isCurrentLocationMoreThan10Meters: Bool = false
    var locationDistance: Double = 0
    
    init(with locationProviderProtocol: LocationProviderProtocol) {
        self.locationProviderProtocol = locationProviderProtocol
        super.init()
    }
    
    func findUserLocation(then: @escaping UserLocationCompletionBlock) {
        self.locationCompletionBlock = then
        if locationProviderProtocol.isUserAuthorized{
            locationProviderProtocol.requestLocation()
            
        } else{
            locationProviderProtocol.requestWhenInUseAuthorization()
        }
    }
    
    func checkNextLocationMoreThan10Meters(initialLocation: Coordinate?, currentLocation: Coordinate?) -> Bool{
        
        if let initialCoordinate = initialLocation,
           let currentCoordinate = currentLocation
        {
            let initialLoc =  coord2dToLoc(coordinates: initialCoordinate)
            let currentLoc =  coord2dToLoc(coordinates: currentCoordinate)
       
            isCurrentLocationMoreThan10Meters = currentLoc.distance(from: initialLoc) > 10 ? true : false
        }
        
        
        return isCurrentLocationMoreThan10Meters
    }
    
    func calculateDistance(initialLocation: Coordinate?, currentLocation: Coordinate?) -> Double{
        
        if let initialCoordinate = initialLocation,
           let currentCoordinate = currentLocation
        {
            let initialLoc =  coord2dToLoc(coordinates: initialCoordinate)
            let currentLoc =  coord2dToLoc(coordinates: currentCoordinate)
       
            locationDistance =  currentLoc.distance(from: initialLoc)
        }
        
        return locationDistance
    }
    
    func coord2dToLoc(coordinates coord: CLLocationCoordinate2D) -> CLLocation{
        let userLatitude = coord.latitude
        let userLongitude = coord.longitude
        let newLocation = CLLocation(latitude: userLatitude, longitude:userLongitude)
        return newLocation
    }
    
    
}

extension UserLocationService: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationProviderProtocol.requestLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last{
            locationCompletionBlock?(location, nil)
        } else{
            locationCompletionBlock?(nil, .canNotBeLocated)
        }
    }
}
