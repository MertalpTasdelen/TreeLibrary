//
//  CustomSelectedTree.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 15.02.2019.
//  Copyright © 2019 Mertalp Taşdelen. All rights reserved.
//

import UIKit

class CustomSelectedTreeViewController: UIView {
    
    var topPadding: CGFloat = 0.0
    let rootUrl = "https://12ceyrek.me/tree_images/"
    let treeEndPointUrl = "-tree.jpg"
    
    
    @IBOutlet weak var swipeButton: UIButton!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var treeTurkishName: UILabel!
    @IBOutlet weak var seedType: UILabel!
    @IBOutlet weak var leafType: UILabel!
    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var bothanicalProp: UITextView!
    
    //bu deger ise yukari kalkan goruntunun boyutu
    let fullView: CGFloat = UIApplication.shared.statusBarFrame.height + 76
    //baslangicda alt konumda dururkenki view boyutu
    var partialView: CGFloat{
        let returnVal = (UIScreen.main.bounds.height)-( 60) //UIApplication.shared.keyWindow?.safeAreaInsets.top ??
            return returnVal
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if #available(iOS 11, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0.0
        }
        
        Bundle.main.loadNibNamed("CustomSelectedTree", owner: self, options: nil)
        self.addSubview(self.rootView)
        
        rootView.layer.cornerRadius = 10
        rootView.layer.masksToBounds = true
    
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
