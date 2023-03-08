Shader "Unlit/SolidColor"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            // 셰이더 코드가 여기에 온다.
            #pragma vertex vert
            #pragma fragment frag
            
            struct appdata
            {
                float4 vertex : POSITION;
            };
            
            struct v2f
            {
                float4 vertex : SV_POSITION;
            }
            
            v2f vert (appdata v) 
            {
            // 버텍스 로직은 여기에 온다.
            }
            float4 frag (v2f i) : SV_Target
            {
            // 프래그먼트 로직은 여기에 온다.
            }
            ENDCG
        }
    }
}
