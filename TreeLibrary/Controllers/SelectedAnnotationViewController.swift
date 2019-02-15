//
//  SelectedAnnotationViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 8.12.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import Foundation
import UIKit

class SelectedAnnotationViewController:UIViewController {
    
    let fullView: CGFloat = 90
//    var partialView: CGFloat{
//        let returnVal = (UIScreen.main.bounds.height)-((newPage?.latinNameTextField.frame.maxY)! + UIApplication.shared.statusBarFrame.height)
//        return returnVal
//    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        prepareBackgroundView()
    
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SelectedAnnotationViewController.panGesture))
//        view.addGestureRecognizer(gesture)
        
        
        
//        roundViews()
    }
    
//    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        let velocity = recognizer.velocity(in: self.view)
//        let y = self.view.frame.minY
//        self.view.frame = CGRect(x:0, y:y + translation.y, width:view.frame.width, height:view.frame.height)
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
//
//        if recognizer.state == .ended {
//        var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
//
//            duration = duration > 1.3 ? 1 : duration
//
//            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
//                if  velocity.y >= 0 {
//                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
//                } else {
//                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
//                }
//
//            }, completion: nil)
//        }
//    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            self.view.frame = CGRect(x:0,y:yComponent,width:frame.width,height:frame.height)
        }, completion: nil)
        
    }
    
    func roundViews(){
        view.layer.cornerRadius = 5
//        newPage?.holder.layer.cornerRadius = 3
    }
}

