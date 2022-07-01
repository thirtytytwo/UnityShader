Shader "Thirtytwo/StencilMask"
{
    Properties
    {
        _Mask_ID("mask ID",Int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry+1"}
        LOD 200
        ColorMask 0
        ZWrite off

        Stencil{
            Ref[_Mask_ID]
            Comp always
            Pass replace
        }

        pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            struct appdata{
                float4 vertex :POSITION;
            };

            struct v2f{
                float4 pos:SV_POSITION;
            };

            v2f vert(appdata i){
                v2f o;
                o.pos = UnityObjectToClipPos(i.vertex);
                return o;
            }

            fixed4 frag(v2f i):SV_TARGET{
                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
