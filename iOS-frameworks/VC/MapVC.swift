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
    var locationManager = LocationManager.instance
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var img : UIImage? = nil
    
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
        locationManager.startUpdatingLocation()
    }
    
    @objc func stopTrack() {
        stopTrackButton.pulsate()
        stopTrackButton.flash()

        var dotsArray : [RouteDots]  = []
        for i in 0..<(routePath!.count() ) {
            let model = RouteDots()
            model.lattitude = routePath?.coordinate(at: i).latitude.description
            model.longitude = routePath?.coordinate(at: i).longitude.description
            dotsArray.append(model)
        }
        RealmService.saveDataToRealm(dotsArray)
        locationManager.stopUpdatingLocation()
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
    
//    func configureLocationManager() {
//        locationManager
//            .location
//            .asObservable()
//            .bind { [weak self] location in
//                guard let location = location else { return }
//                self?.routePath?.add(location.coordinate)
//                self?.route?.path = self?.routePath
//                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
//                self?.mapView.animate(to: position)
//            }
//    }
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
                if self?.marker != nil {
                    self?.marker!.map = nil
                }
                self?.marker = GMSMarker(position: location.coordinate)
                if let image = self?.img {
                    self?.marker!.icon =  self?.drawImageWithProfilePic(pp: image, image: GMSMarker.markerImage(with: .red))
                }
                self?.marker!.map = self?.mapView
            }
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
    
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 7
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        return newImage
    }
    
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
}
