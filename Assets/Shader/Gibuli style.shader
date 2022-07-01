Shader "Custom/Gibuli style"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("Ramp Tex",2D) = "white"{}
    }
    SubShader
    {
        Tags{
            "RenderPipeline"="UniversalPipeline"
            "RenderType" = "Opaque"
        }
        
        HLSLINCLUDE

        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"

        struct Atrributes{
            float4 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS :TANGENT;
            float2 uv :TEXCOORD0;
        };

        struct Varyings{
            float4 positionCS : SV_POSITION;
            float3 positionWS : POSITION_WS;
            float2 uv : TEXCOORD0;
            float3 normalWS : NORMAL_WS;
            float4 tangenWS : TANGENT_WS;
        };
        
        TEXTURE2D(_RampTex);
        SAMPLER(sampler_RampTex);

        ENDHLSL

        pass{
            Name "ForwardUnlit"
            Tags{
                "LightMode" = "UniversalForward"
            }

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            Varyings vert(Atrributes input){

            }
            ENDHLSL
        }
    }
    FallBack "Diffuse"
}
