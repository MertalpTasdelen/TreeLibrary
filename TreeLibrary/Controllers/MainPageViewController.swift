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

    
    
    private var myTableView: UITableView!
    var blurEffectView = UIVisualEffectView()
    var forest: NSArray = NSArray()
    var locations: NSArray = NSArray()
    var treeLocation = [TreeAnnotation]()
    var filteredTrees = [TreeModel]()
    var arrayOfForest = [TreeModel]()
    var darkMode = false
    var searchController = UISearchController(searchResultsController: nil)
    //This property used for peparing the bacground randomly
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    
    @IBOutlet weak var sliderSearchLabel: UIButton!
    @IBOutlet weak var sliderSearchButton: UIButton!
    //Bu ikisi ilerideki arama kısmının açılması için eklendi
    @IBOutlet weak var searchContainerBottomEdge: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!


    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        slideAnimation(animatedButton: sliderSearchLabel)
        slideAnimation(animatedButton: sliderSearchButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Ağaç Ara"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        prepareTableView()
        
        //let orientation = UIInterfaceOrientation.portrait.rawValue
        //UIDevice.current.setValue(orientation, forKey: "orientation")
        
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
        sliderSearchButton.addGestureRecognizer(swipeDown)
        sliderSearchLabel.isEnabled = false
        
    }
    

    @objc func openSearchBar(){

        //MARK: Blur Effect If you want to use it
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(blurEffectView)
        
        // Present the view controller
        present(searchController,animated: true, completion: nil)
        self.view.addSubview(myTableView)
        
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
        
//        if segue.identifier == "selectedTreeSegue" {
//            if let indexPath = myTableView.indexPathForSelectedRow{
//                let tree: TreeModel
//                if isFiltering(){
//                    tree = filteredTrees[indexPath.row]
//                }else {
//                    tree = arrayOfForest[indexPath.row]
//                }
//
//                let nextVC = segue.destination as! SelectedTreeViewController
//                nextVC.selectedTree = tree
//
//            }
//        }
        

    }
    
    @IBAction func openCameraScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "cameraSegue", sender: self)
        
    }
    
    
    @IBAction func reportError(_ sender: UIButton) {
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

//MARK: Animations
extension MainPageViewController {
    
    //complition handler ekle animasyon bitince yazı ve ok kaybolmasını sağla
    func slideAnimation(animatedButton item: UIButton){
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.7
        shake.repeatCount = 3
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: item.frame.midX, y: item.frame.midY)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: item.frame.midX, y: item.frame.midY + 7)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        item.layer.add(shake, forKey: "position")

    }
    

}

extension MainPageViewController: UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //TODO
        filteredContentForSearchText(searchController.searchBar.text!)
    }
    
    // Returns true if the text is empty or nil
    func searchBarIsEmpty() -> Bool{
         return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filteredContentForSearchText(_ searchText: String, scope: String = "Hepsi"){
        filteredTrees = arrayOfForest.filter({ (tree: TreeModel) -> Bool in
            return tree.turkish_name.lowercased().contains(searchText.lowercased())
        })
        
        myTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredTrees.count
        }
        
        return arrayOfForest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item: TreeModel
        
        if isFiltering(){
            item = filteredTrees[indexPath.row]
        }else {
            item = arrayOfForest[indexPath.row]
        }
        
        cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.textLabel!.text = item.turkish_name
//        Burasi hata veriyor nedenini arastir
//        cell.detailTextLabel!.text = item.botanical_prop
//        cell.detailTextLabel!.textColor = UIColor.lightGray
        return cell
    }
    
    func prepareTableView(){
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + searchController.searchBar.frame.height - 1
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.backgroundColor = UIColor.lightGray
        myTableView.rowHeight = CGFloat(65.0)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        myTableView.removeFromSuperview()
//        blurEffectView.removeFromSuperview()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //burasi calismiyor neden bilmiyorum
        let storyBoard  = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectedTreeViewController") as! SelectedTreeViewController
        
        let nav = UINavigationController(rootViewController: vc )
        let backButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(closeVC))
        nav.navigationItem.leftBarButtonItem = backButton
        
        if let indexPath = myTableView.indexPathForSelectedRow{
            let tree: TreeModel
            if isFiltering(){
                tree = filteredTrees[indexPath.row]
            }else {
                tree = arrayOfForest[indexPath.row]
            }
            vc.selectedTree = tree
        }
        
        if searchController.isActive {
            self.searchController.dismiss(animated: false) {
                // Do what you want here like perform segue or present
                self.myTableView.removeFromSuperview()
                self.present(nav, animated: true, completion: nil)
            }
        }
        
        myTableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func closeVC(){
        dismiss(animated: true, completion: nil)
    }
}




