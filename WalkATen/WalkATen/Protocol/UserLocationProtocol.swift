//
//  UserLocationProtocol.swift
//  WalkATen
//
//  Created by jboro on 2/5/22.
//

import Foundation
import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

protocol UserLocationProtocol{
    var coordinate: Coordinate { get }
}

extension CLLocation: UserLocationProtocol {}
