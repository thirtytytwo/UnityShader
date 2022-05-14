// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Thirtytwo/MultiLight"{
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)//漫反射颜色
		_Specular("Specular", Color) =(1,1,1,1)//高光反射颜色
		_Gloss("Gloss", Range(8.0,256)) = 20//高光区域系数
	}

	SubShader{
		pass{
			Tags{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				return o;
			}

			fixed4 frag(v2f f) : SV_TARGET{
				fixed3 worldNormal = normalize(f.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(f.worldPos));

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.pos));
				fixed3 halfDir = normalize(viewDir + worldLightDir);

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0,dot(worldNormal,worldLightDir));
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal,halfDir)),_Gloss);

				fixed atten = 1.0;

				return fixed4(ambient + (diffuse + specular) * atten, 1.0); 
			}

			ENDCG
		}

		pass{
			Tags{"LightMode" = "ForwardAdd"}

			Blend one one //叠加的方式

			CGPROGRAM

			#pragma multi_compile_fwdadd
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

				return o;
			}

			fixed4 frag(v2f f) : SV_TARGET{
				fixed3 worldNormal = normalize(f.worldNormal);
			#ifdef USING_DIRECTIONAL_LIGHT
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
			#else
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - f.pos.xyz);
			#endif
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldPos));
				fixed3 halfDir = normalize(viewDir + worldLightDir);

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0,dot(worldNormal,worldLightDir));
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal,halfDir)),_Gloss);

			#ifdef USING_DIRECTIONAL_LIGHT
				fixed atten = 1.0;
			#else
				float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos,1)).xyz;
				fixed atten = tex2d(_LightTexture0, dot(lightCoord,lightCoord).rr).UNITY_ATTEN_CHANNEL;
			#endif
				return fixed4((diffuse + specular) * atten, 1.0); 
			}

			ENDCG

		}
	}
	Fallback "Specular"
}