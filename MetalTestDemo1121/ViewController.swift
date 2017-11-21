//
//  ViewController.swift
//  MetalTestDemo1121
//
//  Created by 刘李斌 on 2017/11/21.
//  Copyright © 2017年 Brilliance. All rights reserved.
//

import UIKit
import MetalKit

enum Colors {
    //绿色
    static let wenderlichGreen = MTLClearColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0)
}

class ViewController: UIViewController {

    //创建一个MTKView
    var metalView: MTKView {
        return view as! MTKView
    }
    
    var renderer: Renderer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        guard let device = metalView.device else {
            fatalError("Error!")
        }
        
        metalView.clearColor = Colors.wenderlichGreen
        
        renderer = Renderer(device: device)
        
        metalView.delegate = renderer
    }
}



























