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

class CameraViewController: UIViewController {
    
//    var searchedTreeVC: SelectedTreeViewController!
    var treeList = [TreeModel]()
    var searchedTree: TreeModel!
    let cameraController = CameraConfigurationController()
    var searchedTreeLatinName = ""
    var topPadding: CGFloat = 0.0
    var effect: UIVisualEffect!
    var hostUrl = ""
    var confidenceEdgeValue: Float = 0.998

    @IBOutlet weak var topButtonArea: UIView!
    @IBOutlet weak var searchedTreeView: CustomSelectedTreeViewController!
    @IBOutlet var capturePreviewView: UIView!
    @IBOutlet weak var toogleFlashButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraScreen: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    @IBAction func goBack(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchedTreeView.frame.origin.y != searchedTreeView.fullView {
            didPressTakeAnother()
        }
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
    
    //MARK: Burada foto cekme yeni sayfa acma ve tanima islemleri yapiliyor
    @IBAction func captureImage(_ sender: Any) {
        
        if #available(iOS 11, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0.0
        }
        
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
                
            //            try? PHPhotoLibrary.shared().performChangesAndWait {
            //                PHAssetChangeRequest.creationRequestForAsset(from: image)
            //            }
            }

    }
    
    //MARK : Detecting image
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: TreeImageClassifier().model) else {
            fatalError("Loading CoreML model failed.")
        }
        
        //Completion handler !!
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed to process Image")
            }

            if results.first?.confidence ?? 0.999  > self.confidenceEdgeValue {
                self.searchedTreeLatinName = results.first?.identifier ?? "Lorem Implus"
                self.searchedTree = self.treeList.first{ $0.latin_name == self.searchedTreeLatinName}
                
                self.prepareCustomSelectedTreeViewController(capturedTree: self.searchedTree!)
                self.downloadCapturedTreeImage(selectedTree: self.searchedTree?.latin_name ?? "Lorem Implus")
                //self.slide()
                
                print("I am in")
                
            }else {
                self.searchedTreeLatinName = "Lorem Implus"
                self.searchedTree = self.treeList.first{ $0.latin_name == self.searchedTreeLatinName}

                self.prepareCustomSelectedTreeViewController(capturedTree: self.searchedTree!)
                self.downloadCapturedTreeImage(selectedTree: self.searchedTree?.latin_name ?? "Lorem Implus")
                //self.slide()
                print("Cant match")
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5){
                self.slide()

            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            
        try handler.perform([request])
        
        } catch {
            print(error)
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
        
        print(searchedTreeView.heightAnchor)
        
        effect = blurEffectView.effect
        blurEffectView.effect = nil
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        searchedTreeView.swipeButton.addGestureRecognizer(gesture)

        cameraScreen.isHidden = true
        func configureCameraViewController(){
            cameraController.prepare { (error) in
                if let error = error {
                    print(error)
                }

                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }
        
        styleCaptureButton()
        configureCameraViewController()
        
    }
  
}

// MARK: Buttons and Views Animations

extension CameraViewController{
    
    func flash(){
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.2
        animation.fromValue = 1
        animation.toValue = 0.2
        animation.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 1
        
        captureButton.layer.add(animation, forKey: nil)
    }
    
    func slide(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionCurlUp],
                       animations: {
                        self.searchedTreeView.frame = CGRect(x: 0, y: self.topButtonArea.frame.height + self.topPadding ,width: self.view.frame.maxX, height: UIScreen.main.bounds.height - (self.topButtonArea.frame.height + self.topPadding))
                        self.searchedTreeView.layoutIfNeeded()
                        print("Top padding \(self.topPadding)")
                        print("Olmasi gereken uzunluk 682 ama \(self.searchedTreeView.frame.height)")
                        self.performBlurEffect()
        }, completion: nil)
    }
    
    func styleCaptureButton(){
        captureButton.layer.borderColor = UIColor.darkGray.cgColor
        captureButton.layer.borderWidth = 7
        captureButton.layer.cornerRadius = min(captureButton.frame.width,captureButton.frame.height) / 2
    }
    
    //MARK: Blur effect is hard to implement
    fileprivate func performBlurEffect() {
    
        if searchedTreeView.frame.origin.y == searchedTreeView.fullView {
            blurEffectView.effect = effect
            topButtonArea.isUserInteractionEnabled = false
            cameraScreen.isUserInteractionEnabled = false
            
        }else {
            self.blurEffectView.effect = nil
            topButtonArea.isUserInteractionEnabled = true
            cameraScreen.isUserInteractionEnabled = true
        }

    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: searchedTreeView)
        let velocity = recognizer.velocity(in: searchedTreeView) //velocityDirection is more sense for better understanding
        
        let y = searchedTreeView.frame.minY
        searchedTreeView.frame = CGRect(x:0, y:y + translation.y, width:searchedTreeView.frame.width, height:searchedTreeView.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: searchedTreeView)
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - searchedTreeView.fullView) / -velocity.y) : Double((searchedTreeView.partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.searchedTreeView.frame = CGRect(x: 0, y: self.searchedTreeView.partialView, width: self.searchedTreeView.frame.width, height:  self.searchedTreeView.frame.height)
                    self.performBlurEffect()
                    
                } else {
                    //ekranin yukari kalkmasi
                    self.searchedTreeView.frame = CGRect(x: 0, y: self.searchedTreeView.fullView, width: self.searchedTreeView.frame.width, height: self.searchedTreeView.frame.height)
                    self.performBlurEffect()
                }
                
            }, completion: nil)
        }
    }
    
}

extension CameraViewController {
    
    func downloadCapturedTreeImage(selectedTree: String){
        let hostUrl = selectedTree.replacingOccurrences(of: " ", with: "-")
        let treeUrl = URL(string: searchedTreeView.rootUrl + hostUrl + searchedTreeView.treeEndPointUrl)!
        print(treeUrl)
        let defaultSession  = URLSession(configuration: URLSessionConfiguration.default)
        
        let treeImage = defaultSession.dataTask(with: treeUrl) { (data, responso, error) in
            if error != nil {
                print(error!)
            }else {
                print("Foto geldi olley be")
                let treeImage = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    self.searchedTreeView.treeImage.image = treeImage
                }
            }
        }
        treeImage.resume()
    }
    
    func prepareCustomSelectedTreeViewController(capturedTree tree: TreeModel) {
        
        searchedTreeView.treeTurkishName.text = tree.turkish_name
        searchedTreeView.bothanicalProp.text = tree.botanical_prop
//        searchedTreeView.sizeToFit()
//        searchedTreeView.layoutIfNeeded()
    
    }
    
    fileprivate func prepareAutoLayoutForCustomSelectedTreeView(){
        searchedTreeView.bothanicalProp.translatesAutoresizingMaskIntoConstraints = false
        
        searchedTreeView.bothanicalProp.topAnchor.constraint(equalTo: searchedTreeView.stackView.bottomAnchor).isActive = true
        searchedTreeView.bothanicalProp.leadingAnchor.constraint(equalTo: searchedTreeView.rootView.leadingAnchor).isActive = true
        searchedTreeView.bothanicalProp.trailingAnchor.constraint(equalTo: searchedTreeView.rootView.trailingAnchor).isActive = true
        searchedTreeView.bothanicalProp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }

}

