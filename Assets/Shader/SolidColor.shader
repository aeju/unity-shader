// 코드 16-1 : 셰이더 로직이 제거된 유니티 셰이더 모습 (셰이더 작동에 필요한 셰이더랩 데이터, 기본 데이터)
// 이름 + 속성 블록 + 서브셰이더 블록 + 패스 블록

Shader "Unlit/SolidColor" // 1. 이름 : 셰이더 첫 줄에서 선언
{
    Properties
    { // 2. 속성(Properties) : 셰이더의 유니폼 변수 정의  / cf. 변수 <- 유니티 GUI에서 값 바꾸기 가능 
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    { // 3. 서브셰이더(SubShader) : 완전한 셰이더 코드, 정보 (투명도, 셰이더를 어떤 LOD 레벨이 적용할 것인지 등)
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        { // 4. 패스(Pass) : 하나의 독립된 셰이더 
            CGPROGRAM
            // 셰이더 코드가 여기에 온다. <- 유니티 셰이더는 GLSL이 아닌 Cg 셰이딩 언어(장점 : 플랫폼 간의 이동성)로 작성되기 때문
            // GLSL 셰이더 사용할 경우, GLSLPROGRAM/ENDGLSL로 변경
            ENDCG
        }
    }
}
