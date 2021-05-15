//
//  SegmentationController.swift
//  demo_project
//
//  Created by Ge Chenkuan on 23/4/21.
//

import UIKit
import AVKit
import Vision

import CoreML

class LocaltionIdentifyController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Click Image and Select Image From your Ablum"
        label.numberOfLines = 0
        return label
    }()
    
    private let text: UITextView = {
        let tv = UITextView()
        tv.text = "Using GoogleNet to recognize the different places"
        tv.backgroundColor = .lightGray
        tv.isEditable = false
        tv.textColor = .white
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(text)
        text.textContainerInset = UIEdgeInsets(top: 7, left: 16, bottom: 0, right: 16);
        //text.setValue(UIFont.systemFont(ofSize: 50), forKeyPath: "_placeholderLabel.font")
        _ = text.anchor(topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return to Menu", style: .plain, target: self, action: #selector(handleReturn))
        
        
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)

    }
    
    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
        label.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+(view.frame.size.width-40)+10,
            width: view.frame.size.width-40,
            height: 100
        )
        text.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+(view.frame.size.width-40)+210,
            width: view.frame.size.width,
            height: 100
        )
    }
    
    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.resize(size: CGSize(width: 224, height: 224))?
                .getCVPixelBuffer() else {
            return
        }

        do {
            let config = MLModelConfiguration()
            let model = try GoogLeNetPlaces(configuration: config)
            let input = GoogLeNetPlacesInput(sceneImage: buffer)

            let output = try model.prediction(input: input)
            let text = output.sceneLabel
            label.text = "The predicted place: " + text
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // Image Picker

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
        analyzeImage(image: image)
    }
    
    
    @objc func handleReturn() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }

        mainNavigationController.viewControllers = [HomeController()]
    }



}
