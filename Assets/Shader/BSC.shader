Shader "Thirtytwo/BSC"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("亮度",float) = 1
		_Saturation("饱和度",float) = 1
		_Contrast("对比度",float) = 1
	}
	SubShader
	{
		Pass
		{
			ZTest Always
			Cull Off
			ZWrite off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			half _Brightness;
			half _Saturation;
			half _Contrast;
			
			v2f vert (appdata_img v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex,i.uv);

				fixed3 finalColor = renderTex.rgb * _Brightness;

				fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;//全灰的,乘上了灰度值
				fixed3 luminanceColor = fixed3(luminance,luminance,luminance);
				finalColor = lerp(luminanceColor,finalColor,_Saturation);//从全灰向最终颜色过度

				fixed3 avgColor = fixed3(0,0,0);
				finalColor = lerp(avgColor,finalColor,_Contrast);

				return fixed4(finalColor,renderTex.a);
			}
			ENDCG
		}
	}
}
