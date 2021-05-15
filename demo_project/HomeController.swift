//
//  HomeController.swift
//  demo_project
//
//  Created by Ge Chenkuan on 23/4/21.
//

import UIKit

//protocol SegmentationControllerDelegate: class {
//    func isStartSegment()
//}

class HomeController: UIViewController {
    
    let logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "homepage").resized(newSize: CGSize(width: 414 - 20, height: 414 - 120)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let image_segButton: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Real-time Segment (MobileNetv2)", for: .normal)
        
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        button.addTarget(self, action: #selector(segment), for: .touchUpInside)
        return button
    }()
    
    lazy var object_Button: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Object Identifier", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        button.addTarget(self, action: #selector(recognize), for: .touchUpInside)
        return button
    }()
    
    lazy var seg_Button: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Real-time Video Seg (Slow)", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        button.addTarget(self, action: #selector(segmentation), for: .touchUpInside)
        return button
    }()
    
    lazy var road_Button: BtnPleinLarge = {
        let button = BtnPleinLarge()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Road Scene Segmentation", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 1, height: 5)
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = true
        button.clipsToBounds = false
        button.contentHorizontalAlignment = .left
        button.layoutIfNeeded()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleEdgeInsets.left = 0
        button.addTarget(self, action: #selector(road_seg), for: .touchUpInside)
        return button
    }()
    
//    weak var delegate: SegmentationControllerDelegate?
    
    
    @objc func segment() {
        // we only need to lines to do this
        isStartSegment()
    }
    
    @objc func recognize() {
        // we only need to lines to do this
        isStartRecognize()
    }
    
    @objc func segmentation() {
        // we only need to lines to do this
        isStartSegmentation()
    }
    
    @objc func road_seg() {
        // we only need to lines to do this
        isStartRoadSeg()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Welcome to APP"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
        
        view.backgroundColor = .white
        
        view.addSubview(logo)
        view.addSubview(image_segButton)
        view.addSubview(object_Button)
        view.addSubview(seg_Button)
        view.addSubview(road_Button)
        
        setLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //禁止横屏
            appDelegate.isLandscape = false
        }
        //强制为竖屏
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        super.viewWillDisappear(animated)
    }

    func setLayout() {
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 20).isActive = true
        
        image_segButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image_segButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        image_segButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        image_segButton.bottomAnchor.constraint(equalTo: object_Button.topAnchor, constant: -40).isActive = true
        
        object_Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        object_Button.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        object_Button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        object_Button.bottomAnchor.constraint(equalTo: seg_Button.topAnchor, constant: -40).isActive = true
        
        seg_Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seg_Button.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        seg_Button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        seg_Button.bottomAnchor.constraint(equalTo: road_Button.topAnchor, constant: -40).isActive = true
        
        road_Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        road_Button.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        road_Button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        road_Button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }
    
    @objc func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func isStartSegment() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }
        
        mainNavigationController.viewControllers = [ViewController()]
        
        dismiss(animated: true, completion: nil)
    }
    
    func isStartRecognize() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }
        
        mainNavigationController.viewControllers = [RecognizeController()]
        
        dismiss(animated: true, completion: nil)
    }
    
    func isStartSegmentation() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }
        
        mainNavigationController.viewControllers = [VideoSegController()]
        
        dismiss(animated: true, completion: nil)
    }
    
    func isStartRoadSeg() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }
        
        mainNavigationController.viewControllers = [RoadSegController()]
        
        dismiss(animated: true, completion: nil)
    }
    
}
