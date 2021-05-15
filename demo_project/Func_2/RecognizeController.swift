//
//  RecognizeController.swift
//  demo_project
//
//  Created by Ge Chenkuan on 24/4/21.
//

import UIKit
import AVKit
import Vision

import CoreML

class RecognizeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let objectView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Object"
        label.numberOfLines = 2
        return label
    }()
    
    let accView: UILabel = {
        let tv = UILabel()
        tv.text = "Accuracy"
        tv.backgroundColor = .white
        tv.textColor = .black
        tv.textAlignment = .center
        tv.numberOfLines = 1
        return tv
    }()
    
    
    var model = Resnet50().model

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return to Menu", style: .plain, target: self, action: #selector(handleReturn))
        

        
        //camera
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        // The camera is now created!
        
        view.addSubview(objectView)
        view.addSubview(accView)
        
        
        let  dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        objectView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 700,
            width: view.frame.size.width,
            height: 20
        )
        accView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 720,
            width: view.frame.size.width,
            height: 20
        )
    }
    
    
    @objc func handleReturn() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }

        mainNavigationController.viewControllers = [HomeController()]
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            let name: String = firstObservation.identifier
            let acc: Int = Int(firstObservation.confidence * 100)
            
            DispatchQueue.main.async {
                //self.textView.text
                if (acc > 10){
                    self.objectView.text = "Objects: \(name)"
                    self.accView.text = "Accuracy: \(acc)%"
                }
                else{
                    self.objectView.text = "Environment is unclear"
                    self.accView.text = "Accuracy is lower than 10%"
                }
                    
//                self.objectNameLabel.text = name
//                self.accuracyLabel.text = "Accuracy: \(acc)%"
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
