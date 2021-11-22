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
    @IBOutlet private weak var mapView: GMSMapView!
    
    // MARK: - Private properties
    private let locationManager = LocationManager.instance
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private let mapZoom: Float = 17
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureMap()
    }
    
    // MARK: - Private methods
    private func configureMap() {
        _ = locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                self?.addMarker(coordinate: location.coordinate)
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.camera = position
                self?.mapView.animate(to: position)
            }
    }
    
    private func prepareNewRoute() {
        self.route?.map = nil
        self.route = GMSPolyline()
        self.route?.strokeColor = .blue
        self.route?.strokeWidth = CGFloat(5.0)
        self.routePath = GMSMutablePath()
        self.route?.map = self.mapView
    }
    
    private func saveRouteToRealm() {
        guard let routePath = routePath else {
            print("Failed to get route path")
            return
        }
        
        do {
            try RealmManager.shared?.deleteAll()
            var points: [MapPoint] = []
            
            for index in 0..<routePath.count() {
                let coordinate = routePath.coordinate(at: index)
                let point = MapPoint()
                point.id = Int(index)
                point.latitude = coordinate.latitude
                point.longitude = coordinate.longitude
                points.append(point)
            }
            
            try RealmManager.shared?.add(objects: points)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func loadRouteFromRealm() {
        let realmPointsData: Results<MapPoint>? = RealmManager.shared?.getObjects()
        
        guard let points = realmPointsData,
              !points.isEmpty
        else { return }
        
        prepareNewRoute()
        
        points.forEach {
            let coordinate = CLLocationCoordinate2D(latitude: $0.latitude,
                                                    longitude: $0.longitude)
            self.routePath?.add(coordinate)
            addMarker(coordinate: coordinate)
        }
        
        self.route?.path = self.routePath
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
        guard self.locationManager.startUpdatingLocation() else { return }
        
        prepareNewRoute()
    }
    
    @IBAction private func stopRecordingButtonHandler(_ sender: Any) {
        guard self.locationManager.stopUpdatingLocation() else { return }
        
        saveRouteToRealm()
    }
    
    @IBAction private func showLastRouteButton(_ sender: Any) {
        guard !self.locationManager.isTracking else {
            showAlertController()
            return
        }
        
        loadRouteFromRealm()
        
        guard let routePath = self.routePath else {
            print("Failed to get route path from Realm")
            return
        }
        
        let bounds = GMSCoordinateBounds(path: routePath)
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds,
                                                       withPadding: CGFloat(self.mapZoom)))
    }
    
}

// MARK: - MapViewController + CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard self.locationManager.isTracking else { return }
        
        guard let location = locations.last else {
            print("Failed while getting last location")
            return
        }
        
        let coordinate = location.coordinate
        addMarker(coordinate: coordinate)
        self.mapView.animate(toLocation: coordinate)
        
        self.routePath?.add(coordinate)
        self.route?.path = self.routePath
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with \(error.localizedDescription)")
    }
}
