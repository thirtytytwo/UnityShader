Shader "Thirtytwo/BackgroundMove"
{
	Properties
	{
		_FirstTex("First", 2D) = "white"{}
		_SecondTex("Second", 2D) = "white"{}
		_FirstSpeed("First Speed", float) = 1.0
		_SecondSpeed("Second Speed", float) = 1.0
		_Multiplier("Layer Multiplier", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _FirstTex;
			sampler2D _SecondTex;
			float4 _FirstTex_ST;
			float4 _SecondTex_ST;
			float _FirstSpeed;
			float _SecondSpeed;
			float _Multiplier;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityWorldToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv,_FirstTex) + frac(float2(_FirstSpeed,0.0) * _Time.y);
				o.uv.zw = TRANSFORM_TEX(v.uv, _SecondTex) + frac(float2(_SecondSpeed,0.0) * _Time.y);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 first = tex2D(_FirstTex,i.uv.xy);
				fixed4 second = tex2D(_SecondTex,i.uv.zw);

				fixed4 c = lerp(first,second,second.a);
				c.rgb *= _Multiplier;

				return c;
			}
			ENDCG
		}
	}
	Fallback"VertexLit"
}
