//
//  LocationManager.swift
//  M10HomeWorkMaps
//
//  Created by Владислав Белов on 04.07.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation)->Void)?
    
    public func getUserLocation(completion: @escaping (CLLocation)->Void) {
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        self.completion = completion
    }
    
    public func resolveLoactionName(with location: CLLocation, completion: @escaping ((String) -> Void)){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion("")
                return
            }
            
            var name = ""
            if let locality = place.locality{
                name.append(locality)
            }
            completion(name)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
        
    }
    
    
    
}
