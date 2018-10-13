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
   

    var treeSpecifications:[Slider] = []
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareBarButton: UIBarButtonItem! // wpden gönderme mail atma vs olacak airdrop da koy!!!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    var selectedTree: TreeModel = TreeModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myTreeUrl")
        URLCache.shared = urlCache
        
        setupTopView()
        treeSpecifications = createSlideShow()
        setupSlideScrollView(slides: treeSpecifications)
        
        pageControl.numberOfPages = treeSpecifications.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        
//        print("Selected Tree is: \(selectedTree.turkish_name)")
    }

    func setupTopView(){
        navigationTitleItem.title = selectedTree.turkish_name
        
    }
    
    func createSlideShow() -> [Slider] {
        let urlPath = "http://www.12ceyrek.com/mertalp/tree_images/Araucaria-Araucana-(Molina)-K-Koch-tree.jpg"
        let url: URL = URL(string: urlPath)!
        let defaultSesion = URLSession(configuration: URLSessionConfiguration.default)

        let pageOne = Bundle.main.loadNibNamed("Slider", owner: self, options: nil)?.first as! Slider
        pageOne.latinTreeName.text = selectedTree.latin_name
        if selectedTree.seed_type == "1" {
            pageOne.treeSeedType.text = "Açık Tohum"
        }else {
            pageOne.treeSeedType.text = "Kapalı Tohum"
        }
        
        if selectedTree.leaf_type == "1" {
            pageOne.treeLeafType.text = "İğne Yaprak"
        }else {
            pageOne.treeLeafType.text = "Geniş Yaprak"
        }
        
        let treeImage = defaultSesion.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            }else {
                let image = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    pageOne.imageView.image = image
                    //Buraya loader koyabilirsin !! resim inene kadar dönen bir loading
                }
            }
        }
            
        treeImage.resume()
        
        pageOne.bothanicalPropertieExplanation.text = selectedTree.botanical_prop
        pageOne.bothanicalPropHeader.text = "Botanik Özellikleri"
        return [pageOne]
    }
    
    func setupSlideScrollView(slides: [Slider]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
}
