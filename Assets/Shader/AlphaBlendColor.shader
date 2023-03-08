Shader "AlphaBlendColor"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            // _Color를 출력하는 셰이더 코드
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
                        }; //;가 없어서 오류 뜸!
                        
                        v2f vert (appdata v) 
                        {
                            // 버텍스 로직은 여기에 온다.
                            v2f o;
                            o.vertex = UnityObjectToClipPos(v.vertex);
                            return o;
                        }
                        
                        float4 _Color;
                        float4 frag (v2f i) : SV_Target
                        {
                            // 프래그먼트 로직은 여기에 온다.
                            return _Color;
                        }
            ENDCG
        }
    }
}
