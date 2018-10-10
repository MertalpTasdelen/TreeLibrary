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
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareBarButton: UIBarButtonItem! // wpden gönderme mail atma vs olacak airdrop da koy!!!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    var selectedTree: TreeModel = TreeModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        navigationTitleItem.title = selectedTree.turkish_name
        
//        print("Selected Tree is: \(selectedTree.turkish_name)")
    }
}
