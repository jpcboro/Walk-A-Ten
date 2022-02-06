//
//  LocationProviderMock.swift
//  WalkATenTests
//
//  Created by jboro on 2/5/22.
//

import Foundation

class LocationProviderMock: LocationProviderProtocol {
   
    var isNextLocationMoreThan10Meters: Bool = false
    
    
    var isRequestWhenInUseAuthorizationCalled = false
    var isRequestLocationCalled = false
    
    var isUserAuthorized: Bool = false
    
    func requestWhenInUseAuthorization(){
        isRequestWhenInUseAuthorizationCalled = true
    }
    
    func requestLocation(){
        isRequestLocationCalled = true
        
    }
}
