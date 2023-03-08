// 블린 - 퐁 셰이더 : 디퓨즈, 스펙큘러, 노말, 큐브 맵 (네 개의 텍스처를 입력으로 사용)

Shader "BlinnPhong"
{
    Properties
    {
        _Diffuse ("Texture", 2D) = "white" {}
        _Normal ("Normal", 2D) = "blue" {}
        _Specular ("Specular", 2D) = "black" {}
        _Environment ("Environment", Cube) = "white"{}
    }
    
    SubShader
    {
        Tags 
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }
        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            ENDCG
        }
    }
}