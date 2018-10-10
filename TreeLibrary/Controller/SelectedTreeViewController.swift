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
    
    var selectedTree: TreeModel = TreeModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        label.center = self.view.center
        label.textAlignment = .center
        label.text = selectedTree.turkish_name
        self.view.addSubview(label)
//        print("Selected Tree is: \(selectedTree.turkish_name)")
    }
}
