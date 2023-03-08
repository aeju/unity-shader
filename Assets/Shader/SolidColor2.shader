Shader "Unlit/SolidColor2"
{
    Properties
    {
        // 속성 블록 : 셰이더가 사용할 _Color 유니폼 변수의 정보
        // 정보 -> 유니폼 변수 이름 : Color, 벡터가 아닌 색상, 기본 값 : 흰색 (1, 1, 1, 1)
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
            ENDCG
        }
    }
}
