//
//  ViewControllerTests.swift
//  WalkATenTests
//
//  Created by jboro on 2/5/22.
//

import Foundation
import XCTest
import CoreLocation

class ViewControllerTests: XCTestCase{

    var sut: ViewController!
    var locationProvider: UserLocationProviderMock!
    
    override func setUp() {
        super.setUp()
        locationProvider = UserLocationProviderMock()
        sut = ViewController(locationProviderProtocol: locationProvider)

    }
    
    override func tearDown() {
        sut = nil
        locationProvider = nil
        
        super.tearDown()
    }
    
    func testRequestUserLocation_Not_Authorized_ShouldFail()
    {
        locationProvider.locationBlockLocationValue = UserLocationMock()
        locationProvider.locationBlockErrorValue = UserLocationError.canNotBeLocated
        
        sut.requestUserLocation()
        
        XCTAssertNil(sut.userLocation)
    }
    
    func testRequestUserLocation_Authorized_ShouldReturnUserLocation(){
        
        locationProvider.locationBlockLocationValue = UserLocationMock()
        
        sut.requestUserLocation()
        
        XCTAssertNotNil(sut.userLocation)
    }
    
    
    func testUserMoves10Meters_UserLocationReturned(){
        
        locationProvider.locationBlockLocationValue = UserLocationMock()
        
        
        sut.requestUserLocation()

        
        locationProvider.locationBlockLocationValue = UserLocationMock2()

        sut.requestUserLocation()
        
        let coordinate1 = CLLocation(latitude: sut.userLocation!.coordinate.latitude, longitude: sut.userLocation!.coordinate.longitude)
        
        let coordinate2 = CLLocation(latitude: sut.tenMeterLocation!.coordinate.latitude, longitude: sut.tenMeterLocation!.coordinate.longitude)
      
         let distanceInMeters = coordinate1.distance(from: coordinate2)
    
         XCTAssertGreaterThan(distanceInMeters, 10)
        
    }
    
}
