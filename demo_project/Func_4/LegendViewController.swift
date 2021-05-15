//
//  LegendViewController.swift
//  SimpleCoreMLDemo
//
//  Created by Chamin Morikawa on 2020/06/26.
//  Copyright © 2020 Chamin Morikawa. All rights reserved.
//

import Foundation
import UIKit

class LegendViewController: UIViewController, UITableViewDelegate {
    //@IBOutlet weak var tableViewLegend: UITableView!
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
    
    
    private let image0: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[0]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    
    private let image1: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[1]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image2: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[2]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image3: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[3]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image4: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[4]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image5: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[5]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image6: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[6]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image7: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[7]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image8: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[8]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image9: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[9]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image10: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[10]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image11: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[11]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image12: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[12]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image13: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[13]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image14: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[14]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image15: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[15]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image16: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[16]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image17: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[17]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image18: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[18]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image19: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[19]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    private let image20: UIImageView = {
        let img = UIImageView()
        let pixelVals: [UInt8] = (Constants.deepLabSegmentColors)[20]
        img.backgroundColor = UIColor(red: CGFloat(Double(pixelVals[2])/255.0),
                                      green: CGFloat(Double(pixelVals[1])/255.0),
                                      blue: CGFloat(Double(pixelVals[0])/255.0),
                                      alpha: CGFloat(Double(pixelVals[3])/255.0))
        return img
    }()
    
    
    // ----- labels
    
    private let label0: UILabel = {
        let lab = UILabel()
        lab.text = "Background"
        return lab
    }()
    
    private let label1: UILabel = {
        let lab = UILabel()
        
        lab.text = "Aeroplane"
        
        return lab
    }()
    private let label2: UILabel = {
        let lab = UILabel()
        
        lab.text = "Bicycle"
        
        return lab
    }()
    private let label3: UILabel = {
        let lab = UILabel()
        
        lab.text = "Bird"
        
        return lab
    }()
    private let label4: UILabel = {
        let lab = UILabel()
        
        lab.text = "Boat"
        
        return lab
    }()
    private let label5: UILabel = {
        let lab = UILabel()
        
        lab.text = "Bottle"
        
        return lab
    }()
    private let label6: UILabel = {
        let lab = UILabel()
        
        lab.text = "Bus"
        
        return lab
    }()
    private let label7: UILabel = {
        let lab = UILabel()
        
        lab.text = "Car"
        
        return lab
    }()
    private let label8: UILabel = {
        let lab = UILabel()
        
        lab.text = "Cat"
        
        return lab
    }()
    private let label9: UILabel = {
        let lab = UILabel()
        
        lab.text = "Chair"
        
        return lab
    }()
    private let label10: UILabel = {
        let lab = UILabel()
        
        lab.text = "Cow"
        
        return lab
    }()
    private let label11: UILabel = {
        let lab = UILabel()
        
        lab.text = "Dining table"
        
        return lab
    }()
    private let label12: UILabel = {
        let lab = UILabel()
        
        lab.text = "Dog"
        
        return lab
    }()
    private let label13: UILabel = {
        let lab = UILabel()
        
        lab.text = "Horse"
        
        return lab
    }()
    private let label14: UILabel = {
        let lab = UILabel()
        
        lab.text = "Motorbike"
        
        return lab
    }()
    private let label15: UILabel = {
        let lab = UILabel()
        
        lab.text = "Person"
        
        return lab
    }()
    private let label16: UILabel = {
        let lab = UILabel()
        
        lab.text = "Potted Plant"
        
        return lab
    }()
    private let label17: UILabel = {
        let lab = UILabel()
        
        lab.text = "Sheep"
        
        return lab
    }()
    private let label18: UILabel = {
        let lab = UILabel()
        
        lab.text = "Sofa"
        
        return lab
    }()
    private let label19: UILabel = {
        let lab = UILabel()
        
        lab.text = "Train"
        
        return lab
    }()
    private let label20: UILabel = {
        let lab = UILabel()
        
        lab.text = "TV"
        
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to Segment", style: .plain, target: self, action: #selector(return_seg))
        addsubview()
        autoLayout()
        
    }
    
    
    func addsubview() {
        view.addSubview(image0)
        view.addSubview(image1)
        view.addSubview(image2)
        view.addSubview(image3)
        view.addSubview(image4)
        view.addSubview(image5)
        view.addSubview(image6)
        view.addSubview(image7)
        view.addSubview(image8)
        view.addSubview(image9)
        view.addSubview(image10)
        view.addSubview(image11)
        view.addSubview(image12)
        view.addSubview(image13)
        view.addSubview(image14)
        view.addSubview(image15)
        view.addSubview(image16)
        view.addSubview(image17)
        view.addSubview(image18)
        view.addSubview(image19)
        view.addSubview(image20)
        view.addSubview(label0)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        view.addSubview(label6)
        view.addSubview(label7)
        view.addSubview(label8)
        view.addSubview(label9)
        view.addSubview(label10)
        view.addSubview(label11)
        view.addSubview(label12)
        view.addSubview(label13)
        view.addSubview(label14)
        view.addSubview(label15)
        view.addSubview(label16)
        view.addSubview(label17)
        view.addSubview(label18)
        view.addSubview(label19)
        view.addSubview(label20)
    }
    private let extra = 0
    private let extra1 = 60
    private let extra2 = 18

    
    func autoLayout() {
        image0.frame = CGRect(x: 0, y: 80 + extra, width: 40 + extra1, height: 20 + extra2)
        image1.frame = CGRect(x: 0, y: 120 + extra, width: 40 + extra1, height: 20 + extra2)
        image2.frame = CGRect(x: 0, y: 160 + extra, width: 40 + extra1, height: 20 + extra2)
        image3.frame = CGRect(x: 0, y: 200 + extra, width: 40 + extra1, height: 20 + extra2)
        image4.frame = CGRect(x: 0, y: 240 + extra, width: 40 + extra1, height: 20 + extra2)
        image5.frame = CGRect(x: 0, y: 280 + extra, width: 40 + extra1, height: 20 + extra2)
        image6.frame = CGRect(x: 0, y: 320 + extra, width: 40 + extra1, height: 20 + extra2)
        image7.frame = CGRect(x: 0, y: 360 + extra, width: 40 + extra1, height: 20 + extra2)
        image8.frame = CGRect(x: 0, y: 400 + extra, width: 40 + extra1, height: 20 + extra2)
        image9.frame = CGRect(x: 0, y: 440 + extra, width: 40 + extra1, height: 20 + extra2)
        image10.frame = CGRect(x: 0, y: 480 + extra, width: 40 + extra1, height: 20 + extra2)
        image11.frame = CGRect(x: 0, y: 520 + extra, width: 40 + extra1, height: 20 + extra2)
        image12.frame = CGRect(x: 0, y: 560 + extra, width: 40 + extra1, height: 20 + extra2)
        image13.frame = CGRect(x: 0, y: 600 + extra, width: 40 + extra1, height: 20 + extra2)
        image14.frame = CGRect(x: 0, y: 640 + extra, width: 40 + extra1, height: 20 + extra2)
        image15.frame = CGRect(x: 0, y: 680 + extra, width: 40 + extra1, height: 20 + extra2)
        image16.frame = CGRect(x: 0, y: 720 + extra, width: 40 + extra1, height: 20 + extra2)
        image17.frame = CGRect(x: 0, y: 760 + extra, width: 40 + extra1, height: 20 + extra2)
        image18.frame = CGRect(x: 0, y: 800 + extra, width: 40 + extra1, height: 20 + extra2)
        image19.frame = CGRect(x: 0, y: 840 + extra, width: 40 + extra1, height: 20 + extra2)
        image20.frame = CGRect(x: 0, y: 880 + extra, width: 40 + extra1, height: 20 + extra2)
        label0.frame = CGRect(x: 100  + extra1, y: 80 + extra, width: 400 + extra1, height: 20 + extra2)
        label1.frame = CGRect(x: 100  + extra1, y: 120 + extra, width: 400 + extra1, height: 20 + extra2)
        label2.frame = CGRect(x: 100  + extra1, y: 160 + extra, width: 400 + extra1, height: 20 + extra2)
        label3.frame = CGRect(x: 100  + extra1, y: 200 + extra, width: 400 + extra1, height: 20 + extra2)
        label4.frame = CGRect(x: 100  + extra1, y: 240 + extra, width: 400 + extra1, height: 20 + extra2)
        label5.frame = CGRect(x: 100  + extra1, y: 280 + extra, width: 400 + extra1, height: 20 + extra2)
        label6.frame = CGRect(x: 100  + extra1, y: 320 + extra, width: 400 + extra1, height: 20 + extra2)
        label7.frame = CGRect(x: 100  + extra1, y: 360 + extra, width: 400 + extra1, height: 20 + extra2)
        label8.frame = CGRect(x: 100  + extra1, y: 400 + extra, width: 400 + extra1, height: 20 + extra2)
        label9.frame = CGRect(x: 100  + extra1, y: 440 + extra, width: 400 + extra1, height: 20 + extra2)
        label10.frame = CGRect(x: 100  + extra1, y: 480 + extra, width: 400 + extra1, height: 20 + extra2)
        label11.frame = CGRect(x: 100  + extra1, y: 520 + extra, width: 400 + extra1, height: 20 + extra2)
        label12.frame = CGRect(x: 100  + extra1, y: 560 + extra, width: 400 + extra1, height: 20 + extra2)
        label13.frame = CGRect(x: 100  + extra1, y: 600 + extra, width: 400 + extra1, height: 20 + extra2)
        label14.frame = CGRect(x: 100  + extra1, y: 640 + extra, width: 400 + extra1, height: 20 + extra2)
        label15.frame = CGRect(x: 100  + extra1, y: 680 + extra, width: 400 + extra1, height: 20 + extra2)
        label16.frame = CGRect(x: 100  + extra1, y: 720 + extra, width: 400 + extra1, height: 20 + extra2)
        label17.frame = CGRect(x: 100  + extra1, y: 760 + extra, width: 400 + extra1, height: 20 + extra2)
        label18.frame = CGRect(x: 100  + extra1, y: 800 + extra, width: 400 + extra1, height: 20 + extra2)
        label19.frame = CGRect(x: 100  + extra1, y: 840 + extra, width: 400 + extra1, height: 20 + extra2)
        label20.frame = CGRect(x: 100  + extra1, y: 880 + extra, width: 400 + extra1, height: 20 + extra2)
    }
    
    @objc func return_seg() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }

        mainNavigationController.viewControllers = [RoadSegController()]
    }
}
