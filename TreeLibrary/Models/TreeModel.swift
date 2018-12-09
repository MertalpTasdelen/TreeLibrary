//
//  File.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 7.09.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import UIKit


protocol TreeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class TreeModel: NSObject, URLSessionDelegate{

    weak var delegate: TreeModelProtocol!

    var data = Data()

    let urlPath = "https://12ceyrek.me/service.php"

    func downloadItems() {

        let url: URL = URL(string: urlPath)!

        var array = NSMutableArray()
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url) {
            (data, response, error) in

            if error != nil {
                print("Failed to download data")
            }else {
                guard let data = data else { return }

                array = self.parseJSON(data)
                print("The number of thee downloaded is  \(array.count)")
            }

        }

        task.resume()
        
    }

    func parseJSON(_ data: Data) -> NSMutableArray {
        do{
            guard let jsonResult = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                print("Invalid JSON structure")
                return []
            }
            
            let forest = NSMutableArray()
            
            for jsonElement in jsonResult {
                if
                    let latinName = jsonElement["latin_name"] as? String,
                    let turkishName = jsonElement["turkish_name"] as? String,
                    let seedType = jsonElement["seed_type"] as? String,
                    let leafType = jsonElement["leaf_type"] as? String,
                    let spreadingArea = jsonElement["spreading_area"] as? String,
                    let bothanicalProp = jsonElement["bothanical_prop"] as? String
                {
                    let tempTree = TreeModel()
                    
                    tempTree.latin_name = latinName
                    tempTree.turkish_name = turkishName
                    tempTree.seed_type = seedType
                    tempTree.leaf_type = leafType
                    tempTree.spreading_area = spreadingArea
                    tempTree.botanical_prop = bothanicalProp
                    
                    forest.add(tempTree)
                } else {
                    //### Do not ignore errors or invalid inputs silently.
                    print("There is an error it could be ?")
                }
            }
            
            DispatchQueue.main.async {
                self.delegate.itemsDownloaded(items: forest)
            }
            
            return forest
            
        } catch let error {
            print(error)
            return []
        }
        

    }

    
    //properties
    var latin_name: String
    var turkish_name: String
    var seed_type: String
    var leaf_type: String
    var botanical_prop: String
    var spreading_area: String
    
    //empty costurctor
    override init() {
        self.latin_name = ""
        self.turkish_name = ""
        self.seed_type = ""
        self.leaf_type = ""
        self.botanical_prop = ""
        self.spreading_area = ""
    }
    
    init(latin_name: String, turkish_name: String, seed_type: String, leaf_type: String, botanical_prop: String, spreading_area: String){

        self.latin_name = latin_name
        self.turkish_name = turkish_name
        self.seed_type = seed_type
        self.leaf_type = leaf_type
        self.botanical_prop = botanical_prop
        self.spreading_area = spreading_area

    }
    
}
