//
//  Renderer.swift
//  MetalTestDemo1121
//
//  Created by 刘李斌 on 2017/11/21.
//  Copyright © 2017年 Brilliance. All rights reserved.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    //创建设备以及命令的队列
    let device: MTLDevice!
    let commandQueue: MTLCommandQueue!
    
    //创建一个数组存放三角形的三个顶点  x,y,z,  屏幕的center在正中心
    var vertices:[Float] = [
        0,1,0,
        -1,-1,0,
        1,-1,0
    ]
    
    //创建管道状态及缓冲区(用来存放顶点)
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        
        buildModel()
    }
    
    //处理顶点
    private func buildModel(){
        //创建顶点缓冲区,保存了顶点数组中的顶点位置
        //每一个条目都是一个float, 所以缓冲区的长度也就是顶点的数量
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
    }
    
    //处理管道状态
    private func buildPipelineState(){
        //储存GPU中的事项
        let libary = device.makeDefaultLibrary()
        
        //调用metal中的方法
        //顶点操作
        let vertextFunction = libary?.makeFunction(name: "vertex_shader")
        //上色操作
        let fragmentFunction = libary?.makeFunction(name: "fragment_shader")
        
        //创建蓝图
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertextFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            //画出三个顶点
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension Renderer: MTKViewDelegate{
    //每次视图大小改变时被调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    //绘制图形(调用次数和帧数有关, 例如: 有60帧,那么没秒钟调用这个方法60次)
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor,
            let pipelineState = pipelineState else { return  }
        
        //创建缓冲区 commandbuffer
        let commandbuffer = commandQueue.makeCommandBuffer()
        //把命令进行编码
        let commandEncode = commandbuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        //设置管道状态
        commandEncode?.setRenderPipelineState(pipelineState)
        /**
         offset偏移量: 读取数组的起始位置,0就是从第一组数据(0,1,0)开始拿, 1就是从第二组数据开始(-1,-1,0)
         index: 顶点缓冲区的编号
         */
        commandEncode?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncode?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        //结束编码
        commandEncode?.endEncoding()
        //绘制
        commandbuffer?.present(drawable)
        //命令结束
        commandbuffer?.commit()
    }
    
    
}
