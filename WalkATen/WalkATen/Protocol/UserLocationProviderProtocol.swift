//
//  UserLocationProviderProtocol.swift
//  WalkATen
//
//  Created by jboro on 2/5/22.
//

import Foundation

enum UserLocationError: Error{
    case canNotBeLocated
}

typealias UserLocationCompletionBlock = (UserLocationProtocol?, UserLocationError?) -> Void

protocol UserLocationProviderProtocol {
    func findUserLocation(then: @escaping UserLocationCompletionBlock)
    func checkNextLocationMoreThan10Meters(initialLocation: Coordinate?, currentLocation: Coordinate?) -> Bool
    func calculateDistance(initialLocation: Coordinate?, currentLocation: Coordinate?) -> Double
}
