//
//  ViewController.swift
//  HelloMetal
//
//  Created by Matt Amerige on 9/21/16.
//  Copyright © 2016 BuildThings. All rights reserved.
//

import UIKit
import Metal

class ViewController: UIViewController {
  var device: MTLDevice!
  var metalLayer: CAMetalLayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    device = MTLCreateSystemDefaultDevice()
    
    metalLayer = CAMetalLayer()
    metalLayer.device = device
    metalLayer.pixelFormat = .bgra8Unorm
    metalLayer.framebufferOnly = true
    metalLayer.frame = view.layer.frame
    
  }
  
}

