Shader "Thirtytwo/MotionBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlurAmount("模糊的系数",float) = 1
	}
	SubShader
	{
		CGINCLUDE

		#include "UnityCG.cginc"
		
		sampler2D _MainTex;
		fixed _BlurAmount;
		
		struct v2f{
			float4 vertex :SV_POSITION;
			half2 uv : TEXCOORD0;
		};

		v2f vertex(appdata_img v){
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord;

			return o;
		}

		fixed4 fragRGB(v2f i):SV_TARGET{
			return fixed4(tex2D(_MainTex,i.uv).rgb, _BlurAmount);
		}

		half4 fragA(v2f i):SV_TARGET{
			return tex2D(_MainTex,i.uv);
		}
		ENDCG

		ZTest Always ZWrite off Cull off

		pass{
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB//这个关键字将RGB和A通道分开了

			CGPROGRAM

			#pragma vertex vertex
			#pragma fragment fragRGB

			ENDCG
		}

		pass{
			Blend one zero
			ColorMask A

			CGPROGRAM

			#pragma vertex vertex
			#pragma fragment fragA

			ENDCG
		}
	}

	Fallback off
}
