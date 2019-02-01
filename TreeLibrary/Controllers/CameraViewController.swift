//
//  CameraViewController.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 7.08.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision
import Photos
import FloatingPanel

class CameraViewController: UIViewController, FloatingPanelControllerDelegate {
    
    var searchedTreeVC: SelectedTreeViewController!
    var fpc: FloatingPanelController!
    var treeList = [TreeModel]()
    let cameraController = CameraConfigurationController()
    var searchedTreeLatinName = ""
    
    
    @IBOutlet var capturePreviewView: UIView!
    @IBOutlet weak var toogleFlashButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraScreen: UIImageView!
    @IBAction func goBack(_ sender: Any) {
       dismiss(animated: true, completion: nil) // düzgün şekilde olması için comletion kısmını doldurman gerek bence araştır
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didPressTakeAnother()
    }
}

extension CameraViewController {
    
    @IBAction func toogleFlah(_ sender: Any) {
        if cameraController.flashMode == .off {
            cameraController.flashMode = .on
            toogleFlashButton.setImage(UIImage(named: "flash-on-indicator"), for: .normal)
        }
        else {
            cameraController.flashMode = .off
            toogleFlashButton.setImage(UIImage(named: "flash-off"), for: .normal)
        }
    }
    
    @IBAction func captureImage(_ sender: Any) {
        flash()
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.cameraScreen.image = image
            guard let ciImage = CIImage(image: image) else {
                fatalError("Could not conver to CIImage")
            }
            self.detect(image: ciImage)
            self.cameraScreen.isHidden = false
            
            // Initialize a `FloatingPanelController` object.
            self.fpc = FloatingPanelController()
           //Assign self as the delegate of the controller
            self.fpc.delegate = self//Optional
          
           // Initialize FloatingPanelController and add the view
            self.fpc.surfaceView.backgroundColor = .clear
            self.fpc.surfaceView.cornerRadius = 9.0
            self.fpc.surfaceView.shadowHidden = false
          
           //Set a content view controller
            self.fpc.set(contentViewController: self.searchedTreeVC)
            self.fpc.isRemovalInteractionEnabled = true
         
           // Track a scroll view(or the siblings) in the content view controller.
            self.fpc.track(scrollView: self.searchedTreeVC.scrollView) //HATA VERİYOR
           
            self.fpc.addPanel(toParent: self)
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
        

    }
    
    //MARK : Detecting image
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: TreeImageClassifier().model) else {
            fatalError("Loading CoreML model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed to process Image")
            }
            
            self.searchedTreeLatinName = results.first?.identifier as! String
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            
        try handler.perform([request])
        
        } catch {
            print(error)
        }
        
        // TO DO : burada bir sıkıntı olabilir tekrar dön buraya
        let searchedTree = self.treeList.first{ $0.latin_name == searchedTreeLatinName}
        
        if let unwrappedTreeName = searchedTree?.turkish_name {
            print(unwrappedTreeName)
        } else{
            print("Eroro while printing treeName")
        }
        
    }
    
    func didPressTakeAnother() {
        
        if cameraScreen.isHidden == false {
            
            cameraScreen.isHidden = true
            
        } else {
            cameraController.captureSession?.startRunning()
            
        }
    }
    
}


extension CameraViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cameraScreen.isHidden = true
        func configureCameraViewController(){
            cameraController.prepare { (error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        
        func styleCaptureButton(){
            captureButton.layer.borderColor = UIColor.darkGray.cgColor
            captureButton.layer.borderWidth = 7
            
            captureButton.layer.cornerRadius = min(captureButton.frame.width,captureButton.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraViewController()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Remove the views managed by the `FloatingPanelController` object from self.view.
//        fpc.removePanelFromParent(animated: true)
//    }
    
    // MARK: FloatingPanelControllerDelegate
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        switch newCollection.verticalSizeClass {
        case .compact:
            fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
            fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
            return SelectedPanelLandscapeLayout()
        default:
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.backgroundColor = nil
            return nil
        }
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        let y = vc.surfaceView.frame.origin.y
        let tipY = vc.originYOfSurface(for: .tip)
        if y > tipY - 44.0 {
            let progress = max(0.0, min((tipY  - y) / 44.0, 1.0))
            self.searchedTreeVC.scrollView.alpha = progress
        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc.position == .full {
            print("Babacım burası ne yapıyor anlamadım valla...")
        }
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        if targetPosition == .tip {
                            self.searchedTreeVC.scrollView.alpha = 0.0
                        } else {
                            self.searchedTreeVC.scrollView.alpha = 1.0
                        }
        }, completion: nil)
    }
    
}

// MARK: Button Animations
extension CameraViewController{
    func flash(){
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.5
        animation.fromValue = 1
        animation.toValue = 0.2
        animation.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 1
        
        captureButton.layer.add(animation, forKey: nil)
    }
}

// MARK: SelectedTreePanelClass

public class SelectedPanelLandscapeLayout: FloatingPanelLayout {
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return 16.0
        case .tip:
            return 69.0
        default:
            return nil
        }
    }
    
    public var initialPosition: FloatingPanelPosition{
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        if #available(iOS 11.0, *){
            return [
                surfaceView.leftAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291),
            ]
        } else {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291),
            ]
        }
    }
    
    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}



