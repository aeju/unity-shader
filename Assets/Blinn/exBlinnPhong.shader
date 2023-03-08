Shader "exBlinnPhong"
{
	Properties
	{
		_Diffuse ("Texture", 2D) = "white" {}
		_Normal ("Normal", 2D) = "blue"{}
		_Specular ("Specular", 2D) = "black"{}
		_Environment ("Environment", Cube) = "white"{}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }
		LOD 100

		Pass
		{
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			struct vIN
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
			};

			struct vOUT
			{
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

				o.tbn = float3x3(worldTangent, worldBitan, worldNormal);
				
				
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				return o;
			}

			sampler2D _Normal;
			sampler2D _Diffuse;
			sampler2D _Specular;
			samplerCUBE _Environment;
			float4 _LightColor0;

			float4 frag(vOUT i) : SV_TARGET
			{
				//common vectors 
				float3 unpackNormal = UnpackNormal(tex2D(_Normal, i.uv)); 
				float3 nrm = normalize(mul(transpose(i.tbn), unpackNormal));
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos); 
				float3 halfVec = normalize(viewDir + _WorldSpaceLightPos0.xyz);
				float3 env = texCUBE(_Environment, reflect(-viewDir, nrm)).rgb; 
				float3 sceneLight = lerp(_LightColor0, env + _LightColor0 * 0.5, 0.5); 

				//light amounts
				float diffAmt = max(dot(nrm, _WorldSpaceLightPos0.xyz), 0.0); 
				float specAmt = max(0.0, dot(halfVec, nrm));
				specAmt = pow(specAmt, 4.0);

				//sample maps
				float4 tex = tex2D(_Diffuse, i.uv);
				float4 specMask = tex2D(_Specular, i.uv);

				//compute specular color
				float3 specCol = specMask.rgb * specAmt;
 
				//incorporate data aboout light color and ambient
				float3 finalDiffuse = sceneLight * diffAmt * tex.rgb;
				float3 finalSpec = specCol * sceneLight;
				float3 finalAmbient = UNITY_LIGHTMODEL_AMBIENT.rgb * tex.rgb;

				return float4( finalDiffuse + finalSpec + finalAmbient, 1.0);
			}

			ENDCG
		}

	}
}
