//
//  RoadSegController.swift
//  demo_project
//
//  Created by Ge Chenkuan on 25/4/21.
//

import UIKit

import CoreML

class RoadSegController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static  let deepLabSegmentColors: [[UInt8]] = [
         [0, 0, 0, 255], // background is black
         
         [0, 0, 127, 255],        // aeroplane
         [0, 0, 255, 255],       // bicycle
         [0, 127, 255, 255],       // bird
         [0, 127, 127, 255],       // boat
         [0, 127, 0, 255],      // bottle
         
         [0, 255, 0, 255],     // bus
         [0, 255, 127, 255],     // car
         [0, 255, 255, 255],     // cat
         [127, 255, 255, 255],    // chair
         [255, 255, 255, 255],   // cow
         
         [255, 255, 127, 255],   // dining table
         [255, 255, 0, 255],   // dog
         [255, 127, 0, 255],   // horse
         [255, 0, 0, 255],   // motorbike
         [255, 0, 127, 255],    // person
         
         [255, 0, 255, 255],     // poted plant
         [127, 0, 255, 255], // sheep
         [0, 0, 255, 255], // sofa
         [127, 127, 255, 255],  // train
         [127, 127, 127, 255]    // tv
         
     ]
    
    // set view
    private let imgViewPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = nil
        //imageView.image = UIImage(named: "page1")
        return imageView
    }()
    
    private let imgViewSegments: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = nil
        // imageView.image = UIImage(named: "page1")?.resized(newSize: CGSize(width: screenWidth, height: 800))
        return imageView
    }()
    
    private let sliderSegmentAlpha: UISlider = {
        let slider = UISlider();
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        slider.tintColor = UIColor.blue
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        slider.value = 0.5
        return slider
    }()
    
    private let leftsign: UILabel = {
        let label = UILabel()
        label.text = "Original Photo"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        //label.text = "Analyzing the image ..."
        return label
    }()
    
    private let rightsign: UILabel = {
        let label = UILabel()
        label.text = "Segment Photo"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        //label.text = "Analyzing the image ..."
        return label
    }()
    
    private let labelInfo: UILabel = {
        let label = UILabel()
        label.text = "Please select one photo from ablum or take a photo "
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        //label.text = "Analyzing the image ..."
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activty = UIActivityIndicatorView()
        activty.stopAnimating()
        return activty
    }()
    
    private let legendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Legends", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(CheckLegend), for: .touchUpInside)
        return button
    }()
    
    
    private let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Return to Home", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let saveB = UIButton(type: .system)
        saveB.setTitle("Save Segment Photo", for: .normal)
        saveB.setTitleColor(UIColor(red: 20/255, green: 154/255, blue: 160/255, alpha: 1), for: .normal)
        saveB.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
       return saveB
    }()
    
    private let saveButton2: UIButton = {
        let saveB = UIButton(type: .system)
        saveB.setTitle("Concat and Save Photo", for: .normal)
        saveB.setTitleColor(UIColor(red: 20/255, green: 154/255, blue: 160/255, alpha: 1), for: .normal)
        saveB.addTarget(self, action: #selector(savePhoto2), for: .touchUpInside)
        
       return saveB
    }()
    
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        //print("Slider value changed")
        
        imgViewSegments.alpha = CGFloat(sender.value)
        // labelInfo.text = " \(CGFloat(sender.value))"
        
    }
    
    
    var selectedPhoto: UIImage!

    
    let model = PSPNet()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // return to the home page
        navigationItem.title = "Scene Segmentation"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped(_:)))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return to Menu", style: .plain, target: self, action: #selector(handleReturn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ablums", style: .plain, target: self, action: #selector(handleAblum))
        
        
        AddSubView()
        Setlayout()
        
        
    }
    
    func AddSubView() {
        view.addSubview(imgViewPhoto)
        view.addSubview(imgViewSegments)
        //view.addSubview(viewSliderContainer)
        view.addSubview(legendButton)
        view.addSubview(sliderSegmentAlpha)
        view.addSubview(leftsign)
        view.addSubview(rightsign)
        view.addSubview(labelInfo)
        view.addSubview(activityIndicator)
        view.addSubview(returnButton)
        view.addSubview(saveButton)
        view.addSubview(saveButton2)
    }
    
    func Setlayout() {
        imgViewPhoto.frame = CGRect(
            x: 0,
            y: 160,
            width: view.frame.size.width,
            height: view.frame.size.width
        )
        
        imgViewSegments.frame = CGRect(
            x: 0,
            y: 160,
            width: view.frame.size.width,
            height: view.frame.size.width
        )
        
        
        sliderSegmentAlpha.frame = CGRect(
            x: 20,
            y: 650,
            width: view.frame.size.width - 40,
            height: 30
        )
        
        leftsign.frame = CGRect(x: 20, y: 670, width: 100, height: 24)
        rightsign.frame = CGRect(x: 300, y: 670, width: 100, height: 24)
        
        labelInfo.frame = CGRect(
            x: 0,
            y: 700,
            width: view.frame.size.width,
            height: 96
        )
        
        activityIndicator.frame = CGRect(
            x: view.frame.size.width / 2,
            y: view.frame.size.height / 2,
            width: 37,
            height: 37
        )
        
        legendButton.frame = CGRect(x: 280, y: 100, width: 150, height: 40)
        returnButton.frame = CGRect(x: 2, y: 100, width: 150, height: 40)
        saveButton.frame = CGRect(x: 0, y: 750, width: view.frame.size.width, height: 50)
        saveButton2.frame = CGRect(x: 0, y: 800, width: view.frame.size.width, height: 50)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // if a sample has been selected, classify it
        if (selectedPhoto != nil) {
            // set image
            imgViewPhoto.image = selectedPhoto
            
            // clear the result photo anyway
            imgViewSegments.image = nil
            
            // reset slider
            //viewSliderContainer.isHidden = true
            sliderSegmentAlpha.value = 0.5
            
            // start classification in background
            labelInfo.text = "Analyzing Image..."
            activityIndicator.startAnimating()
            
            DispatchQueue.global(qos: .background).async {
                self.classifyImage(img: self.selectedPhoto)
            }
        }
    }
    
    // slider
//    @IBAction func alphaChanged(_ sender: UISlider) {
//        imgViewSegments.alpha = CGFloat(sender.value)
//    }
    
    // use camera to take a photo for classification
    @objc func cameraButtonTapped(_ sender: Any) {
        // cannot take photos on simulator
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }

        // clear previous sample, if any
        selectedPhoto = nil

        // open camera
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = true

        present(cameraPicker, animated: true)
    }
    
    //MARK: Image Picker Delegate
    
    // show the selected photo and perform classification
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        // set image
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        imgViewPhoto.image = image
        imgViewSegments.image = nil
        
        // start classification in background
        labelInfo.text = "Analyzing Image..."
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            self.classifyImage(img: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dod not pick a photo
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Classification
    func classifyImage(img:UIImage) {
        // conversion to the correct input size,
        // and get the image data to a pixel buffer
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 513, height: 513), true, 2.0)
        img.draw(in: CGRect(x: 0, y: 0, width: 513, height: 513))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        // forward pass with time measurement
        let start = DispatchTime.now()
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // processing time in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000 // convert to milliseconds, for ease of reading
        
        var resultString: String = ""
        //print(timeInterval)
        resultString += String(format:"\n(%f milliseconds)", timeInterval)
        
        
        let multiArray: MLMultiArray = prediction.semanticPredictions
        //print(multiArray.count)
        
        // update results on main thread
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            // update results
            self.imgViewSegments.image = getPSPNetResultImage(result: multiArray)
            self.imgViewSegments.alpha = 0.5
            //self.labelInfo.text = resultString
            self.labelInfo.text = "Time: \(timeInterval) milliseconds"
            // show slider
            //self.viewSliderContainer.isHidden = false
        }
    }
    
    //MARK: Select Sample
    func setSelectedPhoto(img:UIImage) {
        selectedPhoto = img
    }

    
    
    
    // return to home page
    @objc func handleReturn() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }

        mainNavigationController.viewControllers = [HomeController()]
    }
    
    @objc func handleAblum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func CheckLegend() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }

        mainNavigationController.viewControllers = [LegendViewController()]
    }
    
    @objc func savePhoto() {
        if(imgViewSegments.image != nil){
            UIImageWriteToSavedPhotosAlbum(imgViewSegments.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            return
        }
    }
    
    @objc func savePhoto2() {
        if(imgViewSegments.image != nil && imgViewPhoto.image != nil){
            let bottomImage = imgViewPhoto.image
            let topImage = imgViewSegments.image
            let size = CGSize(width: view.frame.size.width, height: view.frame.size.width)
            UIGraphicsBeginImageContext(size)

            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            bottomImage!.draw(in: areaSize)

            topImage!.draw(in: areaSize, blendMode: .normal, alpha: 0.5)

            let newimage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(newimage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            return
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your segmented image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
   
}


