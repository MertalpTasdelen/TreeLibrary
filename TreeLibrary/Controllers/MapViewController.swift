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
        //addSelectedAnnotationView() Burasi uygulamayi patlatiyor su an
        checkLocationServices()
    }
    
    func addSelectedAnnotationView(scrollable: Bool? = true) {
        // 1- Init bottomSheetVC
        let selectedAnnotationVC = scrollable! ? SelectedAnnotationViewController() : SelectedAnnotationViewController()
        
        // 2- Add bottomSHeetVC as a child view
        self.addChild(selectedAnnotationVC)
        self.view.addSubview(selectedAnnotationVC.view)
        selectedAnnotationVC.didMove(toParent: self)
        
        // 3- Adjust bottomSheet frame and inital position
        let height = view.frame.height
        let width = view.frame.width
        selectedAnnotationVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height:height)
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

        for location in treeLocationArray {
            print(location.coordinate)
        }
        mapView.addAnnotations(treeLocationArray)
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
        // tree tıklandığında gerçekleşen metod
        print("Yeni sayfa açılacak")
    }
}

extension String {
    func toDouble() -> Double?{
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

