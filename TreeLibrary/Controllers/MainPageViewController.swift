//
//  ViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 2.08.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit
import MessageUI

class MainPageViewController: UIViewController, UISearchBarDelegate {

    
    
    var forest: NSArray = NSArray()
    var locations: NSArray = NSArray()
    var treeLocation = [TreeAnnotation]()
    var arrayOfForest = [TreeModel]()
    var darkMode = false
    var searchController: UISearchController!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var searchContainerBottomEdge: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!


    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orientation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        
        let treeModel = TreeModel()
        treeModel.delegate = self
        treeModel.downloadItems()
        
        let treeAnnotation = TreeAnnotation()
        treeAnnotation.delegate = self
        treeAnnotation.downloadLocations()
        
        let number = Int.random(in: 0 ..< 5)
        let images:[UIImage] = [#imageLiteral(resourceName: "forest1"),#imageLiteral(resourceName: "forest2"),#imageLiteral(resourceName: "forest3"),#imageLiteral(resourceName: "forest4"),#imageLiteral(resourceName: "forest5")]
        backgroundImage.image = images[number]
        backgroundImage.alpha = CGFloat(0.6)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(openSearchBar))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)

        
    }
    

    
    //MARK: Sending data to another VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookViewSegue" {
            let rootNavigationViewController = segue.destination as! UINavigationController
            let destVC = rootNavigationViewController.topViewController as! BookViewController
//            destVC.feedTrees = forest
            destVC.realForest += arrayOfForest
        }
        
        if segue.identifier == "mapViewSegue" {
            let destVC = segue.destination as! MapViewController
            destVC.treeLocationArray = treeLocation
            
        }
        
        if segue.identifier == "cameraSegue" {
            let destVC = segue.destination as! CameraViewController
            destVC.treeList += arrayOfForest
        }

    }

    @objc func openSearchBar(){

            let searchResultsController = storyboard!.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            
            // Create the search controller and make it perform the results updating.
            searchController = UISearchController(searchResultsController: searchResultsController)
            searchController.searchResultsUpdater = searchResultsController as? UISearchResultsUpdating
            searchController.hidesNavigationBarDuringPresentation = false
            
            // Present the view controller.
            present(searchController, animated: true, completion: nil)
        

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //harf girildiğinde arama işlemi yapılan kısım
    }
    
    @IBAction func openCameraScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "cameraSegue", sender: self)
        
    }
    
    
    @IBAction func reportError(_ sender: UIButton) {
        //report area seçenek kutusundan hata işaretlenecek yazılacak gönderilecek.
        sendErrorMail()
        
    }
    
    //END OF CLASS
}


extension MainPageViewController: TreeAnnotationProtocol {
    func locationsDownloaded(item: NSArray) {
        locations = item
        
        for item in 0 ..< locations.count {
            treeLocation.append(locations[item] as! TreeAnnotation)
        }
    }
}

extension MainPageViewController: TreeModelProtocol {
    func itemsDownloaded(items: NSArray) {
        forest = items
        
        for item in 0 ..< forest.count {
            arrayOfForest.append(forest[item] as! TreeModel)
        }
    }
}

extension MainPageViewController: MFMailComposeViewControllerDelegate{
   
    func sendErrorMail(){
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            
            let alert = UIAlertController(title: "HATA !", message: "Mail açılırken bir sorun oluştu", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yeniden Dene", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)// hatadan sonra gösterilecek ekran oradaki mail
            return
        }
        
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self//burada hata var
        
        mail.setToRecipients(["alptasdelen@hotmail.com"])
        mail.setSubject("Uygulamada Hata")
        mail.setMessageBody("<b>Probleminizi bizimle paylaşın<b>", isHTML: true)
        
        self.present(mail, animated: true)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}




