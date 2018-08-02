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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takenPhotoArea: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            takenPhotoArea.image = userPickedImage
            
            guard let metaImage = CIImage(image: userPickedImage) else {
                fatalError("CIImage'e dönüştürülemedi")
            }
            
            detect(image: metaImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK - Image tranforming area
    func detect(image: CIImage){
        
        //It's a container for our model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Converting COREML failed")
        }
        
        let visionRequest = VNCoreMLRequest(model: model) { (request, error) in
            guard let results  = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
//            print(results)
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Sosisli sandviç !"
                }else {
                    self.navigationItem.title = "Sosisli sandviç Değil :("
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([visionRequest])

        } catch {
            print(error)
        }
    }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }



}

