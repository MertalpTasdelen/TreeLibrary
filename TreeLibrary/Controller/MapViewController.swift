//
//  MapViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 8.09.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var treeLocationArray = [TreeAnnotation]()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 150000

    @IBAction func backToMainPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let orientation = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        setNeedsStatusBarAppearanceUpdate()
        
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        }
    }
    
    
    private func addAnnotations(){
//        let myHome = MKPointAnnotation()
        

        
        for item in treeLocationArray{
            let treeAnnotation = MKPointAnnotation()

            let treeLatitude = Double(treeLocationArray[0].latitude)!
            let treeLongitude = Double(treeLocationArray[0].longitude)!
            
            print(treeLatitude)
            print(treeLongitude)
//            if let tempLatitude = Double(item.latitude) {  print(tempLatitude)  }
//            if let tempLongitude = Double(item.longitude) { print(tempLongitude) }

            treeAnnotation.title = item.latin_name
            treeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.379398, longitude: 35.320441)

            mapView.addAnnotation(treeAnnotation)
        }
//        print(treeLongitude)
//        print(treeLatitude)
//        myHome.title = treeLocationArray[0].latin_name
//        myHome.coordinate = CLLocationCoordinate2D(latitude: 37.379398, longitude: 35.320441)
//
//        mapView.addAnnotation(myHome)
    }
    
    //to set the user location in center of the map
    private func setCurrentLocation(){
        guard let location = locationManager.location else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    

    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        addAnnotations()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

extension MapViewController: MKMapViewDelegate {

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //perform the segue with the selected tree
        print("Yeni sayfa açılacak")
    }
}

extension String {
    func toDouble() -> Double?{
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

