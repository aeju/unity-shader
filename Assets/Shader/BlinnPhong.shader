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
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            
            struct vIN{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };
            
            struct vOUT {
                float4 pos : SV_POSITION;
                float3x3 tbn : TEXCOORD0;
                float2 uv : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
            };
            
            vOUT vert(vIN v)
            {
                vOUT o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 worldBitan = cross(worldNormal, worldTangent);
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.tbn = float3x3( worldTangent, worldBitan, worldNormal);
                
                return o;
            }
            ENDCG
        }
    }
}