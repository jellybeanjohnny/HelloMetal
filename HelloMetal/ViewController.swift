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
  var piplineState: MTLRenderPipelineState!
  
  var timer: CADisplayLink!
  
  let vertexData: [Float] = [
    0.0, 1.0, 0.0,
    -1.0, -1.0, 0.0,
    1.0, -1.0, 0.0
  ]
  
  var vertexBuffer: MTLBuffer!
  
  var commandQueue: MTLCommandQueue!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    device = MTLCreateSystemDefaultDevice()
    
    metalLayer = CAMetalLayer()
    metalLayer.device = device
    metalLayer.pixelFormat = .bgra8Unorm
    metalLayer.framebufferOnly = true
    metalLayer.frame = view.layer.frame
    view.layer.addSublayer(metalLayer)
    
    let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
    
    let defaultLibrary = device.newDefaultLibrary()
    let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
    let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
    
    let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
    pipelineStateDescriptor.vertexFunction = vertexProgram
    pipelineStateDescriptor.fragmentFunction = fragmentProgram
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    
    
    do {
       piplineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    } catch {
      print(error)
    }
    
    commandQueue = device.makeCommandQueue()
    
    timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
    timer.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    
  }
  
  func render() {
    //TODO
    let renderPassDescriptor = MTLRenderPassDescriptor()
    renderPassDescriptor.colorAttachments[0].texture = metalLayer.nextDrawable()?.texture
    renderPassDescriptor.colorAttachments[0].loadAction = .clear
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
    
    let commandBuffer = commandQueue.makeCommandBuffer()
    
    let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
    renderEncoder.setRenderPipelineState(piplineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
    renderEncoder.endEncoding()
    
    commandBuffer.present(metalLayer.nextDrawable()!)
    commandBuffer.commit()
    
    
  }
  
   func gameloop() {
    autoreleasepool {
      self.render()
    }
  }
  
  
  
  
  
}

