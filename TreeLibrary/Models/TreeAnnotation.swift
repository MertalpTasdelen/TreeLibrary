//
//  TreeAnnotation.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 24.10.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import MapKit

protocol TreeAnnotationProtocol: class {
    func locationsDownloaded(item: NSArray)
}

class TreeAnnotation: NSObject, URLSessionDelegate, MKAnnotation {
    
    
    weak var delegate: TreeAnnotationProtocol!
    
    var data = Data()
    
    let urlPath = "https://12ceyrek.me/location_service.php"
    
    func downloadLocations(){
        
        let url: URL = URL(string: urlPath)!
        
        var array = NSMutableArray()
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Gene bir sorun var ya of....")
            }else {
                guard let data = data else {return}

//                let dataAsString = String(data: data, encoding: .utf8)

                array = self.parseJSON(data) as! NSMutableArray
                print("The number of the location is: \(array.count)")
            }
        }
        task.resume()
        
    }
    
    func parseJSON(_ data: Data) -> NSArray {
        do {
            guard let jsonResult = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                print("Invalid JSON structure")
                return []
            }
            let locations = NSMutableArray()
            
            for jsonElement in jsonResult {
                if
                    let tempLatinName = jsonElement["tree_latin_name"] as? String,
                    let tempLongitude = jsonElement["geo_longitude"] as? String,
                    let tempLatitude = jsonElement["geo_latitude"] as? String

                {
                    let tempLocation = TreeAnnotation()
                    
                    tempLocation.latin_name = tempLatinName
                    tempLocation.longitude = Double(tempLongitude) ?? 35.112321
                    tempLocation.latitude = Double(tempLatitude) ?? 35.112321
                    tempLocation.coordinate = CLLocationCoordinate2DMake(tempLocation.longitude, tempLocation.latitude)

                    locations.add(tempLocation)
                }else {
                    print("JsonElement çevrilemedi")
                }
            }
            
            DispatchQueue.main.async {
                self.delegate.locationsDownloaded(item: locations)
            }
            
            return locations
            
        }catch let error {
            print(error)
            return []
        }
    }
    
    
    
    
    var latin_name: String
    var longitude: Double
    var latitude: Double
    var coordinate: CLLocationCoordinate2D

    
    override init() {
        self.latin_name = "Null"
        self.longitude = 1.000000
        self.latitude = 1.000000
        self.coordinate = CLLocationCoordinate2DMake(0, 0)
    }
    
    init(latin_name: String, longitude: Double, latitude: Double, coordinate: CLLocationCoordinate2D){
        self.latin_name = latin_name
        self.longitude = longitude
        self.latitude = latitude
        self.coordinate = coordinate
    }
    
    
}
