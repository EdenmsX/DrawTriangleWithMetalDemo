//
//  Shader.metal
//  MetalTestDemo1121
//
//  Created by 刘李斌 on 2017/11/21.
//  Copyright © 2017年 Brilliance. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//处理顶点,进来什么就原原本本的返回什么,这里有两个参数,一个是顶点的数量,一个是顶点的ID
vertex float4 vertex_shader(const device packed_float3 * vertices[[buffer(0)]], uint vertexId[[vertex_id]]) {
    return float4(vertices[vertexId], 1);
}

//上色
fragment half4 fragment_shader(){
    //红色
    return half4(1,0,0,1);
}





