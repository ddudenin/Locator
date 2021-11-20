//
//  LocationManager.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 16.11.2021.
//

import GoogleMaps
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    
    static let instance = LocationManager()
    
    private var isLocationUpdating: Bool = false
    
    var isTracking: Bool {
        return isLocationUpdating
    }
    
    private override init() {
        super.init()
        
        configureLocationManager()
    }
    
    let locationManager = CLLocationManager()
    
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    func startUpdatingLocation() -> Bool {
        guard !isLocationUpdating else { return false }
        
        isLocationUpdating = true
        locationManager.startUpdatingLocation()
        
        return true
    }
    
    func stopUpdatingLocation() -> Bool {
        guard isLocationUpdating else { return false }
        
        isLocationUpdating = false
        locationManager.stopUpdatingLocation()
        
        return true
    }
    
    private func configureLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.pausesLocationUpdatesAutomatically = false
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
