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
        // GLSL Vs Gg
        // Gg : 버텍스 셰이더와 프래그먼트 셰이더를 하나의 파일에 합친다. -> 유니폼 변수를 한 곳에 정의할 수 있음(내부적으로는 별개의 두 셰이더 존재)-> 코드 중복 줄일 수 o
            CGPROGRAM
            // 셰이더 코드가 여기에 온다.
            // 어떤 함수가 버텍스 셰이더의 main() 함수이고, 프래그먼트 셰이더의 main() 함수인지 명시하는 코드 (pragma)
            #pragma vertex vert // vert라는 함수 : 버텍스 셰이더의 main()함수 
            #pragma fragment frag // frag라는 함수 : 프래그먼트 셰이더
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
