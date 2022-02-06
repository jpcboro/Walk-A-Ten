//
//  UserLocationProviderMock.swift
//  WalkATenTests
//
//  Created by jboro on 2/5/22.
//

import Foundation
import WalkATen

struct UserLocationMock: UserLocationProtocol{
    var coordinate: Coordinate{
        return Coordinate(latitude: -37.810492, longitude: 144.960793)
    }

}

struct UserLocationMock2: UserLocationProtocol{
    var coordinate: Coordinate{
        return Coordinate(latitude: -37.81053600866252, longitude: 144.96059425641937)
    }

}

class UserLocationProviderMock: UserLocationProviderProtocol{
    
    func CheckNextLocationMoreThan10Meters(initialLocation: Coordinate?, currentLocation: Coordinate?) -> Bool {
        return false
    }
    
    
    var locationBlockLocationValue: UserLocationProtocol?
    var locationBlockErrorValue: UserLocationError?
    
    func findUserLocation(then: @escaping UserLocationCompletionBlock) {
        then(locationBlockLocationValue, locationBlockErrorValue)
    }
    
  
}
