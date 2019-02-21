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
    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var bothanicalProp: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    
    //bu deger ise yukari kalkan goruntunun boyutu icin y baslangic koordinati
    let fullView: CGFloat = UIApplication.shared.statusBarFrame.height + 76
    //baslangicda alt konumda dururkenki view boyutu icin y baslangic koordinati
    var partialView: CGFloat{
        let returnVal = (UIScreen.main.bounds.height)-(60) //UIApplication.shared.keyWindow?.safeAreaInsets.top ??
            return returnVal
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if #available(iOS 11, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0.0
        }
        
        Bundle.main.loadNibNamed("CustomSelectedTree", owner: self, options: nil)
        rootView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height - (76 + topPadding))
        self.addSubview(self.rootView)
        self.layoutIfNeeded()
        rootView.layer.cornerRadius = 10
        rootView.layer.masksToBounds = true
//        rootView.frame = CGRect(x: 0, y: 76 + topPadding, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height - (76 + topPadding))
    
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
