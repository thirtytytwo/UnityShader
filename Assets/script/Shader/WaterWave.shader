Shader "Thirtytwo/WaterWave"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("color", Color) = (1,1,1,1)
		_Magnitude("波动幅度",float) = 1//波动幅度
		_Frequency("波动频率",float) = 1
		_InvWaveLength("波长",float) = 1
		_Speed("Speed",float) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" "DisableBatching" = "True" }
		LOD 100

		Pass
		{
			Tags{
				"LightMode" = "ForwardBase"
			}
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			float _Magnitude;
			float _Frequency;
			float _InvWaveLength;
			float _Speed;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				float4 offset;
				offset.yzw = float3(0,0,0);
				offset.x = sin(_Frequency * _Time.y + v.vertex.x * _InvWaveLength + v.vertex.y * _InvWaveLength + v.vertex.z * _InvWaveLength) * _Magnitude;//正弦函数，输入进裁剪坐标，将不用的部分裁剪掉
				o.vertex = UnityObjectToClipPos(v.vertex + offset);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv += float2(_Time.y * _Speed, 0);//流动起来的代码，凡是修改uv的都是让图片动起来
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.uv);
				c.rgb *= _Color.rgb;
				return c;
			}
			ENDCG
		}
	}
}
