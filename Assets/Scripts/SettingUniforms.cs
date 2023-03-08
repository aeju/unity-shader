using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// C#에서 셰이더로 데이터를 전달할 수 있는 방법 : 2가지
// 1. 특정 재질의 유니폼 변수의 값을 정하는 것
// 2. 프로젝트 안의 모든 셰이더가 볼 수 있는 전역 유니폼 변수의 값을 정하는 것 
public class SettingUniforms : MonoBehaviour
{
    public Material mat; 
    public Texture2D myTexture;
    
    // Start is called before the first frame update
    void Start()
    {
        mat.SetFloat("_FloatName", 1.0f);
        mat.SetVector("_VectorName", Vector4.zero);
        mat.SetTexture("_TextureName", myTexture);
        
        Shader.SetGlobalFloat("_GlobalFloat", 1.0f);
        Shader.SetGlobalVector("_GlobalVector", Vector4.one);
        Shader.SetGlobalTexture("_GlobalTexture", myTexture);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
