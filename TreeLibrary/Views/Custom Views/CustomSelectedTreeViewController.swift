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
    @IBOutlet weak var swipeButton: UIButton!
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var treeTurkishName: UILabel!
    @IBOutlet weak var seedType: UILabel!
    @IBOutlet weak var leafType: UILabel!
    @IBOutlet weak var treeImage: UIImageView!
    @IBOutlet weak var bothanicalProp: UITextView!
    
    
    
    let fullView: CGFloat = UIApplication.shared.statusBarFrame.height + 76
    var partialView: CGFloat{
        let returnVal = (UIScreen.main.bounds.height)-(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 60)
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
    
    
//        @objc func panGesture(recognizer: UIPanGestureRecognizer) {
//
//            let translation = recognizer.translation(in: rootView)
//            let velocity = recognizer.velocity(in: rootView)
//
//            let y = rootView.frame.minY
//            rootView.frame = CGRect(x:0, y:y + translation.y, width:rootView.frame.width, height:rootView.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: rootView)
//
//            if recognizer.state == .ended {
//            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
//
//                duration = duration > 1.3 ? 1 : duration
//
//                UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
//                    if  velocity.y >= 0 {
//                        self.rootView.frame = CGRect(x: 0, y: self.partialView, width: self.rootView.frame.width, height: self.rootView.frame.height)
//                    } else {
//                        self.rootView.frame = CGRect(x: 0, y: self.fullView, width: self.rootView.frame.width, height: self.rootView.frame.height)
//                    }
//
//                }, completion: nil)
//            }
//        }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
