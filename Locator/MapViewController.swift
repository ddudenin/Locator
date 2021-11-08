//
//  MapViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 02.11.2021.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {
    
    // MARK: - Subviews
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Private properties
    private var locationManager = CLLocationManager()
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var isLocationUpdate: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureLocationManager()
        configureMap()
    }
    
    // MARK: - Private methods
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
    
    private func configureMap() {
        let coordinateMoscow = CLLocationCoordinate2D(latitude: 55.753215,
                                                      longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: coordinateMoscow, zoom: 17)
        self.mapView.camera = camera
        self.mapView.animate(toLocation: coordinateMoscow)
    }
    
    private func prepareNewRoute() {
        self.route?.map = nil
        self.route = GMSPolyline()
        self.route?.strokeColor = .blue
        self.route?.strokeWidth = CGFloat(5.0)
        self.routePath = GMSMutablePath()
        self.route?.map = mapView
    }
    
    private func saveRouteToRealm() {
        guard let routePath = routePath else {
            print("Failed to get route path")
            return
        }
        
        try? RealmManager.shared?.deleteAll()
        var points : [MapPoint] = []
        
        for index in 0..<routePath.count() {
            let coordinate = routePath.coordinate(at: index)
            let point = MapPoint()
            point.id = Int(index)
            point.latitude = coordinate.latitude
            point.longitude = coordinate.longitude
            points.append(point)
        }
        
        try? RealmManager.shared?.add(objects: points)
    }
    
    private func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = self.mapView
    }
    
    private func showAlertController() {
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
    }
    
    // MARK: - Actions
    @IBAction private func startRecordingButtonHandler(_ sender: Any) {
        guard !isLocationUpdate else { return }
        prepareNewRoute()
        isLocationUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    @IBAction private func stopRecordingButtonHandler(_ sender: Any) {
        guard isLocationUpdate else { return }
        
        locationManager.stopUpdatingLocation()
        saveRouteToRealm()
        isLocationUpdate = false
    }
    
    @IBAction private func showLastRouteButton(_ sender: Any) {
        guard !isLocationUpdate else {
            showAlertController()
            return
        }
        
        let realmPointsData: Results<MapPoint>? = RealmManager.shared?.getObjects()
        
        guard let points = realmPointsData,
              !points.isEmpty
        else { return }
        
        prepareNewRoute()
        
        points.forEach {
            let coordinate = CLLocationCoordinate2D(latitude: $0.latitude,
                                                    longitude: $0.longitude)
            routePath?.add(coordinate)
            addMarker(coordinate: coordinate)
        }
        
        self.route?.path = routePath
        
        let bounds = GMSCoordinateBounds(path: routePath ?? GMSMutablePath())
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: CGFloat(17)))
    }
    
}

// MARK: - MapViewController + CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isLocationUpdate else { return }
        
        guard let location = locations.last else {
            print("Failed while getting last location")
            return
        }
        
        let coordinate = location.coordinate
        addMarker(coordinate: coordinate)
        self.mapView.animate(toLocation: coordinate)
        
        self.routePath?.add(coordinate)
        self.route?.path = routePath
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with \(error.localizedDescription)")
    }
}
