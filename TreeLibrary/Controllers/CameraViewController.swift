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
    
    let cameraController = CameraConfigurationController()
    
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
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed to process Image")
            }
            
            print(results)
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
    
}



