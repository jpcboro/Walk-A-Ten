//
//  UserLocationServiceTests.swift
//  WalkATenTests
//
//  Created by jboro on 2/5/22.
//

import Foundation
import XCTest
import WalkATen

class UserLocationServiceTests: XCTestCase{
    
    var sut: UserLocationService!
    var locationProvider : LocationProviderMock!
    
    override func setUp() {
        super.setUp()
        locationProvider = LocationProviderMock()
        sut = UserLocationService(with: locationProvider)
    }
    
    override func tearDown() {
        sut = nil
        locationProvider = nil
        super.tearDown()
    }
    
    func testRequestUserLocation_NotAuthorized_ShouldRequestAuthorization(){
        
        locationProvider.isUserAuthorized = false
        
        sut.findUserLocation{_, _ in}
        
        XCTAssertTrue(locationProvider.isRequestWhenInUseAuthorizationCalled)
    }
    
    func testRequestUserLocation_Authorized_ShouldNotRequestAuthorization(){
        
        locationProvider.isUserAuthorized = true
        
        sut.findUserLocation{_, _ in}
        
        XCTAssertFalse(locationProvider.isRequestWhenInUseAuthorizationCalled)
    }
    
    func testUserChangesLocation_LocationMoreThan10Meters_ShouldReturnTrue(){
        
        locationProvider.isUserAuthorized = true
        
        let initialLocation = Coordinate(latitude: -37.810492416004465, longitude: 144.9607932391293)
        let currentLocation = Coordinate(latitude: -37.81053600866252, longitude: 144.96059425641937)
      
       

        XCTAssertTrue( sut.CheckNextLocationMoreThan10Meters(initialLocation: initialLocation, currentLocation: currentLocation))
        
    }
    
    func testUserDoesNotChangeLocation_ShouldReturnFalse(){
        
        locationProvider.isUserAuthorized = true
        
        let initialLocation = Coordinate(latitude: -37.810492416004465, longitude: 144.9607932391293)
        let currentLocation = Coordinate(latitude: -37.810492416004465, longitude: 144.9607932391293)
      
        XCTAssertFalse( sut.CheckNextLocationMoreThan10Meters(initialLocation: initialLocation, currentLocation: currentLocation))
        
    }
    
    func testUserChangesLocation_LocationLessThan10Meters_ShouldReturnFalse(){
        
        locationProvider.isUserAuthorized = true
        
        let initialLocation = Coordinate(latitude: -37.810492416004465, longitude: 144.9607932391293)

        let currentLocation = Coordinate(latitude: -37.810498730570345, longitude: 144.960776208709)

        XCTAssertFalse( sut.CheckNextLocationMoreThan10Meters(initialLocation: initialLocation, currentLocation: currentLocation))
        
    }
    
}
