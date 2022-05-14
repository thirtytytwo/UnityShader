Shader "Thirtytwo/Class3" {
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
	}
	SubShader{
		pass{
			Tags{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			fixed4 frag(v2f f):SV_TARGET{
				//获取全局环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//获取世界法线
				fixed3 worldNormal = normalize(f.worldNormal);
				//获取世界光照方向
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				//光照公式
				//fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

				//半条命的半兰伯特模型
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * dot(worldNormal, worldLightDir) * 0.5 + 0.5;

				//最后输出到颜色的参数上
				fixed3 color = ambient + diffuse;

				return fixed4(color,1.0); 
			}

			ENDCG
		}
	}

	Fallback "Diffuse"
}
