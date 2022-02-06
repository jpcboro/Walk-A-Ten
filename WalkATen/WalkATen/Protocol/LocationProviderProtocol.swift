//
//  LocationProviderProtocol.swift
//  WalkATen
//
//  Created by jboro on 2/5/22.
//

import Foundation
import CoreLocation

protocol LocationProviderProtocol{
    var isUserAuthorized: Bool { get }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationProviderProtocol{
   
    var isUserAuthorized: Bool{
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
}
