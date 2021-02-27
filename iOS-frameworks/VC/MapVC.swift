//
//  MapVC.swift
//  iOS-frameworks
//
//  Created by Vit K on 17.02.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import Realm
import RealmSwift

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lastTrackButton: UIButton!
    @IBOutlet weak var startNewTrackButton: UIButton!
    @IBOutlet weak var stopTrackButton: UIButton!
    
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var marker: GMSMarker?
    var locationManager: CLLocationManager?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        configureMap()
        configureLocationManager()
    }
    
    // MARK: - Actions
    
    @IBAction func showLastTrack(_ sender: Any) {
        lastTrackButton.pulsate()
        lastTrackButton.flash()
        
        let realm = try! Realm()
        let coords = realm.objects(RouteDots.self)
        routePath = GMSMutablePath()
        coords.forEach({ i in
            if let lat = Double(i.lattitude!),
               let lon = Double(i.longitude!) {
                let coord = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(lon))
                routePath?.add(coord)
            }
        })
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: routePath!.coordinate(at: routePath!.count()-1), zoom: 17)
        mapView.animate(to: position)
    }
    
    @objc func startNewTrack() {
        startNewTrackButton.pulsate()
        startNewTrackButton.flash()
        
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }
    
    @objc func stopTrack() {
        stopTrackButton.pulsate()
        stopTrackButton.flash()
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        var dotsArray : [RouteDots]  = []
        for i in 0..<(routePath!.count() ) {
            let model = RouteDots()
            model.lattitude = routePath?.coordinate(at: i).latitude.description
            model.longitude = routePath?.coordinate(at: i).longitude.description
            dotsArray.append(model)
        }
        saveDataBase(dotsArray)
        locationManager?.stopUpdatingLocation()
    }
    
    // MARK: - Save to Data Base
    
    func saveDataBase(_ objects: [Object]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(objects)
        }
    }
    
    // MARK: - Configure
    
    func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 11)
        mapView.camera = camera // Москва целиком со спутника
        mapView.mapType = .satellite
        
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = 100.0;
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
    }
    
    func configureButtons() {
        lastTrackButton.applyGradient(colours: [.lightGray, .white ], locations: [0.2, 0.5, 0.8])
        lastTrackButton.setTitle(" Прошлый ", for: .normal)
        lastTrackButton.setTitleColor(UIColor.darkGray, for: .normal)
        lastTrackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        startNewTrackButton.addTarget(self, action: #selector(self.startNewTrack), for: .touchUpInside)
        startNewTrackButton.setTitle("  Новый маршрут  ", for: .normal)
        startNewTrackButton.setTitleColor(UIColor.darkGray, for: .normal)
        startNewTrackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        
        stopTrackButton.addTarget(self, action: #selector(self.stopTrack), for: .touchUpInside)
        stopTrackButton.setTitle(" Стоп маршрут ", for: .normal)
        stopTrackButton.setTitleColor(UIColor.darkGray, for: .normal)
        stopTrackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first as Any)
        guard let location = locations.last else { return }
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        let marker = GMSMarker(position: location.coordinate)
        marker.map = mapView
        self.marker = marker
        routePath?.add(location.coordinate)
        route?.path = routePath
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
