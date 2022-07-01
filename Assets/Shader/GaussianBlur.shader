Shader "Thirtytwo/GaussianBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		CGINCLUDE

		#include "UnityCG.cginc"
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;

		struct v2f{
			float4 vertex :SV_POSITION;
			half2 uv[5] : TEXCOORD0;
		};

		v2f VertBlurVertical(appdata_img v){
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			
			half2 uv = v.texcoord;

			o.uv[0] = uv;
			o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0);
			o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0);
			o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0);
			o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y * 2.0);

			return o;
		}

		v2f VertBlurHorizontal(appdata_img v){
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			
			half2 uv = v.texcoord;

			o.uv[0] = uv;
			o.uv[1] = uv + float2( _MainTex_TexelSize.x * 1.0, 0.0);
			o.uv[2] = uv - float2( _MainTex_TexelSize.x * 1.0, 0.0);
			o.uv[3] = uv + float2( _MainTex_TexelSize.x * 2.0, 0.0);
			o.uv[4] = uv - float2( _MainTex_TexelSize.x * 2.0, 0.0);

			return o;
		}

		fixed4 fragBlur(v2f i):SV_TARGET{
			float weight[3] = {0.4026,0.2442,0.0545};

			fixed3 sum = tex2D(_MainTex,i.uv[0]).rgb * weight[0];

			for(int it = 1; it < 3; it++){
				sum += tex2D(_MainTex, i.uv[it*2-1]).rgb * weight[it];
				sum += tex2D(_MainTex, i.uv[it*2]).rgb * weight[it];//根据书本，weight应该是五个数，对称的
			}

			return fixed4(sum,1.0);
		}
		ENDCG

		ZTest Always Cull off ZWrite off
		pass{
			Name"GAUSSIAN_BLUR_VERTICAL"

			CGPROGRAM
			#pragma vertex VertBlurVertical
			#pragma fragment fragBlur

			ENDCG
		}

		pass{
			Name"GAUSSIAN_BLUR_HORIZONTAL"

			CGPROGRAM
			#pragma vertex VertBlurHorizontal
			#pragma fragment fragBlur
			ENDCG
		}
	}
}
