//
//  SelectedTreeViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 4.10.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import UIKit


class SelectedTreeViewController: UIViewController {
   
    @IBOutlet weak var labelLatinName: UILabel!
    @IBOutlet weak var labelSeedType: UILabel!
    @IBOutlet weak var labelLeafType: UILabel!
    @IBOutlet weak var imageOfSelectedTreeBody: UIImageView!
    @IBOutlet weak var bothanicalPropertieHeader: UILabel!
    @IBOutlet weak var textViewBothanicalProperty: UITextView!
    @IBOutlet weak var imageOfSelectedTreeLeaf: UIImageView!
    @IBOutlet weak var spreadingAreaHeader: UILabel!
    @IBOutlet weak var textViewSpreadingArea: UITextView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareBarButton: UIBarButtonItem! 
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    var selectedTree: TreeModel = TreeModel()
    
    @IBAction func denemeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func treeShareButton(_ sender: Any) {
        print("Sharing...")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    //if the program download so many data this will clear the cache
    override func didReceiveMemoryWarning() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        doneButton.title = "Tamam"
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myTreeUrl")
        URLCache.shared = urlCache
        
        setupTopView()
        setupContentOfPage()

    }

    func setupTopView(){
        navigationTitleItem.title = selectedTree.turkish_name
        
    }
    
    func setupContentOfPage() {
        
        labelLatinName.text = selectedTree.latin_name
        if selectedTree.seed_type == "1" {
            labelSeedType.text = "Açık Tohum"
        } else {
            labelSeedType.text = "Kapalı Tohum"
        }
        
        if selectedTree.leaf_type == "1" {
            labelLeafType.text = "İğne Yaprak"
        } else {
            labelLeafType.text = "Kapalı Yaprak"
        }
        
        let rootUrl = "https://12ceyrek.me/tree_images/"
        let hostUrl = selectedTree.latin_name.replacingOccurrences(of: " ", with: "-")
        let leafEndPointUrl = "-leaf.jpg"
        let treeEndPointUrl = "-tree.jpg"
        
        
        print(rootUrl + hostUrl + treeEndPointUrl)
        
        let treeUrl: URL = URL(string: rootUrl + hostUrl + treeEndPointUrl)!
        let leafUrl: URL = URL(string: rootUrl + hostUrl + leafEndPointUrl)!
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let treeImage = defaultSession.dataTask(with: treeUrl) { (data, respornse, error) in
            if error != nil {
                print(error!)
            }else {
                print("Geldii")
                let treeImage = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    self.imageOfSelectedTreeBody.image = treeImage
                }
            }
        }
        
        treeImage.resume()
        
        let leafImage = defaultSession.dataTask(with: leafUrl) { (data, response, error) in
            if error != nil {
                print(error!)
            }else {
                let leafImage = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    self.imageOfSelectedTreeLeaf.image = leafImage
                }
            }
        }
        
        leafImage.resume()
        
        bothanicalPropertieHeader.text = "Botanik Özellikleri"
        textViewBothanicalProperty.text = selectedTree.botanical_prop
        spreadingAreaHeader.text = "Yayılış Alanları"
        textViewSpreadingArea.text = selectedTree.spreading_area
   
    }
}
