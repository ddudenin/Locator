//
//  MapViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 02.11.2021.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var isLocationUpdate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureLocationManager()
    }
    
    @IBAction private func startRecordingButtonHandler(_ sender: Any) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        locationManager.startUpdatingLocation()
        isLocationUpdate = true
    }
    
    @IBAction private func stopRecordingButtonHandler(_ sender: Any) {
        guard isLocationUpdate else { return }
        
        locationManager.stopUpdatingLocation()
        saveRouteToRealm()
        isLocationUpdate = false
    }
    
    @IBAction private func showLastRouteButton(_ sender: Any) {
        guard !isLocationUpdate else {
            let alert = UIAlertController(title: "Ошибка",
                                          message: "Необходимо завершить отслеживание",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { _ in
                self.stopRecordingButtonHandler(self)
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена",
                                          style: .cancel,
                                          handler: nil))
            
            self.present(alert,
                         animated: true,
                         completion: nil)
            
            return
        }
        
        let realmPointsData: Results<MapPoint>? = RealmManager.shared?.getObjects()
        
        guard let points = realmPointsData,
              !points.isEmpty
        else { return }
        
        points.forEach {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude,
                                                                longitude: $0.longitude)
            self.mapView.addAnnotation(pointAnnotation)
        }
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
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
    
    private func saveRouteToRealm() {
        try? RealmManager.shared?.deleteAll()
        var points : [MapPoint] = []
        let pathPointsCount = self.mapView.annotations.count
        
        for index in 0..<pathPointsCount {
            let coordinate = self.mapView.annotations[index].coordinate
            let point = MapPoint()
            point.id = index
            point.longitude = coordinate.longitude
            point.latitude = coordinate.latitude
            points.append(point)
        }
        
        try? RealmManager.shared?.add(objects: points)
    }
    
    private func setMapRegion(coordinate: CLLocationCoordinate2D) {
        let deltaDegrees: CLLocationDegrees = 0.01
        
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                            longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: center,
                                        span: MKCoordinateSpan(latitudeDelta: deltaDegrees,
                                                               longitudeDelta: deltaDegrees))
        
        self.mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isLocationUpdate else { return }
        
        guard let location = locations.last else {
            print("Failed while getting last location")
            return
        }
        
        let coordinate = location.coordinate
        self.setMapRegion(coordinate: coordinate)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = "position \(self.mapView.annotations.count)"
        self.mapView.addAnnotation(pointAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with \(error.localizedDescription)")
    }
}
