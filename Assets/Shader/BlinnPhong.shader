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
        // 기존 패스 
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
            
            sampler2D _Normal;
            sampler2D _Diffuse;
            sampler2D _Specular;
            samplerCUBE _Environment;
            float4 _LightColor0;
            
            float4 frag(vOUT i) : SV_TARGET
            {
                // 일반 벡터
                float3 unpackNormal = UnpackNormal(tex2D(_Normal, i.uv));
                float3 nrm = normalize(mul(transpose(i.tbn), unpackNormal));
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 halfVec = normalize(viewDir + _WorldSpaceLightPos0.xyz);
                float3 env = texCUBE(_Environment, reflect(-viewDir, nrm)).rgb;
                float3 sceneLight = lerp(_LightColor0, env + _LightColor0 * 0.5, 0.5);
                
                // 라이팅 계산
                float diffAmt = max(dot(nrm, _WorldSpaceCameraPos.xyz), 0.0);
                float specAmt = max(0.0, dot(halfVec, nrm));
                specAmt = pow(specAmt, 4.0);
                
                // 텍스처 샘플링
                float4 tex = tex2D(_Diffuse, i.uv);
                float4 specMask = tex2D(_Specular, i.uv);
                
                // 스펙큘러 색상 계산
                float3 specCol = specMask.rgb * specAmt;
                
                // 라이팅 결과를 합친다.
                float3 finalDiffuse = sceneLight * diffAmt * tex.rgb;
                //float3 finalSpec = specCol * _ sceneLight;
                float3 finalSpec = specCol * sceneLight;
                float3 finalAmbient = UNITY_LIGHTMODEL_AMBIENT.rgb * tex.rgb;
                
                return float4( finalDiffuse + finalSpec + finalAmbient, 1.0);
            }
            ENDCG
        }
        
        // 새로운 패스 (멀티라이트 지원)
        Pass {
            Tags {"LightMode" = "ForwardAdd" "Queue"="Geometry"}
            Blend One One // 가산 블렌딩 (이미 백 버퍼에 있는 색상과 그냥 더한다)
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase
            
            struct vIN{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };
            
            struct vOUT{
                float4 pos : SV_POSITION;
                float3x3 tbn : TEXCOORD0;
                float2 uv : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                LIGHTING_COORDS(5,6) // 두 슬롯 사용
            }
            ENDCG
        }
    }
}