//
//  BookViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 8.09.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
    }
    // Called when the user switched the scope
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    //feedTrees comes with preloaded data from MainPageViewController.swift
    var feedTrees: NSArray = NSArray()
    var filteredTree: NSArray = NSArray()
    
    
    var realForest = [TreeModel]()
    var filteredForest = [TreeModel]()
    
    let searchController = UISearchController(searchResultsController: nil) //creating searchbar with programmatically
    var selectedTreeForNextCV: TreeModel = TreeModel()

    @IBOutlet weak var treeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(realForest)
        //table view delegats and datasource declaration
        self.treeTableView.delegate = self
        self.treeTableView.dataSource = self
        
        treeTableView.rowHeight = CGFloat(65.0)
        setupNavBar()
               
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ağaç ismi giriniz"
        searchController.searchBar.scopeButtonTitles = ["Hepsi", "İ.Yaprak", "G.Yaprak", "A.Tohum", "K.Tohum"]
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering(){
            return filteredForest.count
        }
        
        return realForest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = treeTableView.dequeueReusableCell(withIdentifier: "basicCell")!
        let item: TreeModel
        
        if isFiltering(){
            item = filteredForest[indexPath.row]
        }else {
            item = realForest[indexPath.row]
        }
        
        cell.textLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.textLabel!.text = item.turkish_name
        cell.detailTextLabel!.text = item.botanical_prop
        cell.detailTextLabel!.textColor = UIColor.lightGray
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering(){
            //
            selectedTreeForNextCV = realForest[indexPath.row]
        }else {
            selectedTreeForNextCV = realForest[indexPath.row]
        }
        
        treeTableView.deselectRow(at: indexPath, animated: false)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! SelectedTreeViewController
        detailVC.selectedTree = selectedTreeForNextCV
    }
    
    func isFiltering() -> Bool {
        
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func searchBarIsEmpty()-> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Hepsi"){
        let doesCategoryMatch = (scope == "Hepsi") || (scope == "İ.Yaprak") || (scope == "G.Yaprak") || (scope == "A.Tohum" || (scope == "K.Tohumz"))
        //doescategorymach seçilen scope a eşitlemen gerek ardından seçilen scope a göre return statemente düzelteceksin seçilen index path deki ağacın PK sı ile realForesttan ağacı bul ve diğer viwecontrollera gönder!
        filteredForest = realForest.filter({ (tree: TreeModel) -> Bool in
            //filitreleme işlemi
            if searchBarIsEmpty() {
                return doesCategoryMatch
            }else {
                return doesCategoryMatch &&
                tree.turkish_name.lowercased().contains(searchText.lowercased())
            }
            
        })
        
        treeTableView.reloadData()
    }
    
    @IBAction func goBackMainPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

