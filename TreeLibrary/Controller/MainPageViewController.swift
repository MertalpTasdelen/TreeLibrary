//
//  ViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 2.08.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

class MainPageViewController: UIViewController {
    
    enum SlideOutState {
        case rightScreenCollapsed
        case rightScreenOpened
    }
    
    var delegate: MainPageViewControllerDelegate?
    var mainViewController: MainPageViewController!
    var cameraViewController: CameraViewController!
    var currentState: SlideOutState = .rightScreenCollapsed
    var centerNavigationViewController: UINavigationController!
    let centerPanelExpandedOffset: CGFloat = 0
    
    var sideBarState = false
    
    @IBOutlet weak var sideBarLeadingEdge: NSLayoutConstraint!
    
    @IBOutlet weak var sideMenuBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewController = UIStoryboard.centerViewController()
        mainViewController.delegate = self
        
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(sender: )))
        pan.edges = .right
        view.addGestureRecognizer(pan)
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(leftGesture)
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightGesture.direction = .left
        view.addGestureRecognizer(rightGesture)
        
        centerNavigationViewController = UINavigationController(rootViewController: mainViewController)
        
        addChildViewController(centerNavigationViewController)
        centerNavigationViewController.didMove(toParentViewController: self)

    }
    
    @IBAction func openSideBar(_ sender: UIBarButtonItem) {
        
        if (sideBarState == false) {
            
            sideBarLeadingEdge.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            sideMenuBar.layer.shadowOpacity = 0.85
            sideMenuBar.layer.shadowRadius = 10
            
            
        } else {
            
            sideBarLeadingEdge.constant = -180
            sideMenuBar.layer.shadowOpacity = 0
            sideMenuBar.layer.shadowRadius = 0
            UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            }
            
            
        }
        
        sideBarState = !sideBarState
        
    }
    
    //END OF CLASS
}


//MARK - Extension for gestures
extension MainPageViewController: UIGestureRecognizerDelegate {
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        if (sideBarState == false && sender.direction == .right) {
            
            sideBarLeadingEdge.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            sideMenuBar.layer.shadowOpacity = 0.85
            sideMenuBar.layer.shadowRadius = 10
        }else if (sideBarState == true && sender.direction == .left) {
            
            sideBarLeadingEdge.constant = -180
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            sideMenuBar.layer.shadowOpacity = 0
            sideMenuBar.layer.shadowRadius = 0
        }
        
        sideBarState = !sideBarState
    }
    
    
    @objc func handlePan(sender: UIPanGestureRecognizer){
        
        let gestureIsDraggingRightToLeft = (sender.velocity(in: view).x > 0)
        
     
        switch sender.state {
            
        case .began:
            if currentState == .rightScreenCollapsed {
                
                if gestureIsDraggingRightToLeft {
                    addCameraScreenViewController()
                }
            }
            
        case .changed:
            if let rview = sender.view {
                rview.center.x = rview.center.x + sender.translation(in: view).x
                sender.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            if let _ = cameraViewController,
                let rview = sender.view {
                // animate the side panel open or closed based on whether the view
                // has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateCameraScreen(shouldOpened: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
        
    }
}

//MARK - extension for the Opening camera screen
extension MainPageViewController: MainPageViewControllerDelegate{
    func openCameraScreen() {
        
        let notAlreadyOpened = (currentState != .rightScreenOpened )
        
        if notAlreadyOpened {
            
            addCameraScreenViewController()
            
        }
        
        animateCameraScreen(shouldOpened: notAlreadyOpened)
    }
    
    func addCameraScreenViewController(){
        
        guard cameraViewController == nil else {return}
        
        if let vc = UIStoryboard.cameraViewController(){
//            vc.startRunningCaptureSession()
            addChildSidePanelController(vc)
            cameraViewController = vc
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: CameraViewController){
//        view.insertSubview(sidePanel.view, at: 0)
        view.addSubview(sidePanelController.view)
        addChildSidePanelController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
        
    }
    
    
    func animateCameraScreen(shouldOpened: Bool){
        
        if shouldOpened {
            currentState = .rightScreenOpened
            animateCenterPanelXPosition(targetPosition: centerNavigationViewController.view.frame.width - centerPanelExpandedOffset)
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationViewController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}









private extension UIStoryboard {
    
     static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func cameraViewController() -> CameraViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
    }
    
    static func centerViewController() -> MainPageViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MainPageViewController") as? MainPageViewController
        
    }
}




