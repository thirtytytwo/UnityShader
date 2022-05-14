// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Thirtytwo/Map"
{
	Properties
	{
		_Color("Color Tint", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white"{}
		_BumpMap("Normal Map",2D) = "bump"{}
		_BumpScale("Bump Scale", float) = 1.0
		_SpecularMask("Specular Mask", 2D) = "white"{}
		_SpecularScale("Specular Scale", Float) = 1.0
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader
	{
		Pass{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex ver
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			sampler2D _BumpMap;
			float4 _MainTex_ST;//在纹理名字后面加入关键字来声明某个纹理的属性，此例的st则是获得纹理的缩放和平移值
			float4 _BumpMap_ST;
			float _BumpScale;
			sampler2D _SpecularMask;
			float4 _SpecularMask_ST;
			float _SpecularScale;
			float4 _Specular;
			float _Gloss;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;//法线信息
				float4 tangent : TANGENT;//切线信息
				float4 texcoord : TEXCOORD0;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			v2f ver (a2v v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;//因为一套uv贴图，偏移和缩放分量是一样的，所以可以只记录主贴图的uv
				//或者可以用内置方法
				//o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);内置的方法，已经在UnityCG.cginc中定义了，跟上面的公式一样
				TANGENT_SPACE_ROTATION;
				
				//rotation是上面的那句语句得来的，旋转矩阵
				o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;
				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET{
				//计算得到切线空间的normal，光线方向和观察方向，然后把这些替换掉原本光照模型中的相对应分量
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);

				fixed4 packedNormal = tex2D(_BumpMap,i.uv);
				fixed3 tangentNormal;

				tangentNormal = UnpackNormal(packedNormal);//将世界坐标下的uv解包到切线空间
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(tangentNormal,tangentLightDir));

				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);

				fixed specularMask = tex2D(_SpecularMask, i.uv).r * _SpecularScale;
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(tangentNormal,halfDir)), _Gloss) * specularMask;

				return fixed4(ambient + diffuse + specular,1.0);
			}

			ENDCG
		}
	}
	Fallback "Specular"
}
