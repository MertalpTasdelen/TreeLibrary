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
        case rightPanelCollapsed
        case rightPanelExpanded
    }
    
    var mainViewController: MainPageViewController!
    var cameraViewController: CameraViewController!
    var currentState: SlideOutState = .rightPanelCollapsed
    
    var sideBarState = false
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    

    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var sideBarLeadingEdge: NSLayoutConstraint!
    
    @IBOutlet weak var sideMenuBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(sender: )))
        pan.edges = .right
        view.addGestureRecognizer(pan)
        
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        view.addGestureRecognizer(leftGesture)
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightGesture.direction = .left
        view.addGestureRecognizer(rightGesture)

//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
//        startRunningCaptureSession()

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
    

    
    func setupCaptureSession(){
        //seting the photo quality
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        //setup the device camera for our capture
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        
        do{
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)

        } catch {
            print(error)
        }
        
    }
    
    func setupPreviewLayer(){
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession(){
        
        captureSession.startRunning()
        
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
        
        let gestureIsDraggingFromLeftToRight = (sender.velocity(in: view).x > 0)
        
        //        switch sender.state {
        //        case .began:
        //            <#code#>
        //        default:
        //            <#code#>
        //        }
        
    }
}

private extension UIStoryboard {
    
     static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func cameraViewController() -> CameraViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
    }
}




