//
//  MapViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 02.11.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func currentLocationButtonHandler(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Failed while getting last location")
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { location, error in
            //print(location.debugDescription)
        })
        
        let deltaDegrees: CLLocationDegrees = 0.01
        let coordinates = location.coordinate
        
        let center = CLLocationCoordinate2D(latitude: coordinates.latitude,
                                            longitude: coordinates.longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: deltaDegrees,
                                                               longitudeDelta: deltaDegrees))
        
        self.mapView.setRegion(region, animated: true)
        
        if !self.mapView.annotations.isEmpty {
            let annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        pointAnnotation.title = "position \(self.mapView.annotations.count)"
        self.mapView.addAnnotation(pointAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with \(error.localizedDescription)")
    }
}
