//
//  LocationModel.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 11.03.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import MapKit

protocol DummyAnnotationProtocol: class {
    func dummyLocationsDownloaded(item: NSArray)
}

class LocationModel: NSObject, URLSessionDelegate, MKAnnotation {
    
    weak var delegate: DummyAnnotationProtocol!
    var data = Data()
    
    let urlPath = "https://12ceyrek.me/dummy_locations.php"
    
    func downloadLocations(){
        
        let url: URL = URL(string: urlPath)!
        
        var array = NSMutableArray()
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("gene bir sorun var")
            }else {
                guard let data = data else {return}
                
                array = self.parseJSON(data) as! NSMutableArray
                print("Number of the locations are: \(array.count)")
            }
        }
        task.resume()
        
    }
    
    func parseJSON(_ data: Data) -> NSArray {
        do{
            guard let jsonResult = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                print("Invalid JSON structure")
                return []
            }
            
            let locations = NSMutableArray()
            
            for jsonElement in jsonResult {
                if
                    let tempLongitude = jsonElement["geo_latitude"] as? Double,
                    let tempLatitude = jsonElement["geo_longitute"] as? Double,
                    let tempId = jsonElement["id"] as? Double {
                    
                    let tempLocation = LocationModel()
                    
                    tempLocation.longitute = tempLongitude
                    tempLocation.latitude = tempLatitude
                    tempLocation.Id = tempId
                    tempLocation.coordinate = CLLocationCoordinate2D(latitude: tempLocation.latitude, longitude: tempLocation.longitute)
                    
                    
                    locations.add(tempLocation)
                } else {
                    print("JsonElement cant convert")
                }
            }
            
            DispatchQueue.global(qos:.userInitiated).async {
                self.delegate.dummyLocationsDownloaded(item: locations)
            }
            
            return locations
        }catch let error {
            print(error)
            return []
        }
    }
    
    var longitute: Double
    var latitude: Double
    var Id: Double
    var coordinate: CLLocationCoordinate2D
    
    override init() {
        self.longitute = 1.0000000
        self.latitude = 1.0000000
        self.Id = 0
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    init(longitute: Double, latitude: Double, Id: Double, coordinate: CLLocationCoordinate2D){
        self.longitute = longitute
        self.latitude = latitude
        self.Id = Id
        self.coordinate = coordinate
    }
}
