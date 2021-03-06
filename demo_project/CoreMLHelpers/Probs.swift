//
//  Probs.swift
//  Tiramisu
//
//  Created by James Kauten on 10/16/18.
//  Copyright © 2018 Kautenja. All rights reserved.
//

import Foundation
import UIKit
import CoreML

/// Convert probability tensor into an image
func codesToImage(_ _probs: MLMultiArray) -> UIImage? {
    // TODO: dynamically load a label map instead of hard coding
    // can this bonus data be included in the model file?
    let label_map = [
        0:  [255, 255, 255,0],
        1:  [0, 0, 0,100],
        2:  [0, 0, 142],
        3:  [153, 153, 153],
        4:  [190, 153, 153],
        5:  [220, 20, 60],
        6:  [128, 64, 128],
        7:  [244, 35, 232],
        8:  [220, 220, 0],
        9:  [70, 130, 180],
        10: [107, 142, 35],
        11: [0, 0, 0]
        
    ]
    // convert the MLMultiArray to a MultiArray
    var codes = MultiArray<Float32>(_probs)
    // get the shape information from the probs
    let height = codes.shape[1]
    let width = codes.shape[2]
    // initialize some bytes to store the image in
    var bytes = [UInt8](repeating: 255, count: height * width * 4)
    // iterate over the pixels in the output probs
    for h in 0 ..< height {
        for w in 0 ..< width {
            // get the array offset for this word
            let offset = h * width * 4 + w * 4
            // get the RGB value for the highest probability class
            //let m = codes[0, h, w]
            var rgb = label_map[Int(codes[0, h, w])]
           /* if m>0.5{
                rgb=label_map[11]
            }
            else{
                rgb = label_map[1]
            }*/
            
            // set the bytes to the RGB value and alpha of 1.0 (255)
            bytes[offset + 0] = UInt8(rgb![0])
            bytes[offset + 1] = UInt8(rgb![1])
            bytes[offset + 2] = UInt8(rgb![2])
            //bytes[offset + 3] = UInt8(rgb![3])
            
            
        }
    }
    // create a UIImage from the byte array
    return UIImage.fromByteArray(bytes, width: width, height: height,
                                 scale: 0, orientation: .up,
                                 bytesPerRow: width * 4,
                                 colorSpace: CGColorSpaceCreateDeviceRGB(),
                                 alphaInfo: .premultipliedLast)
}
