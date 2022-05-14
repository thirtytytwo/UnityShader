// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Thirtytwo/Class1" {
	Properties{
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)//定义一个Color属性的变量能在inspector窗口看到,Color Tint是变量名，Color是类型
	}
	SubShader{
		Pass{
			CGPROGRAM
			#pragma vertex Ver //声明Ver是包含了顶点着色器的代码
			#pragma fragment fra //声明fra是包含了片元着色器的代码

			//在这里需要声明properties里面的变量,变量名为类型名
			fixed4 _Color;

			struct a2v{
				float4 vertex : POSITION;//float4存储模型空间的顶点坐标
				float3 normal : NORMAL;//法线方向存储到float3变量
				float4 texcoord :TEXCOORD0;//用模型的第一套纹理坐标填充texcoord变量
			};

			struct v2f{//顶点着色器输出到片元着色器的数据
				float4 pos:SV_POSITION;//裁剪空间的坐标
				fixed3 color :COLOR0;//颜色信息
			};

			v2f Ver(a2v v){
				//return UnityObjectToClipPos(v.vertex);//将模型空间坐标变换到裁剪坐标
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//v.normal包含了顶点的法线信息，其范围是-1到1
				//下面操作吧分量范围映射到0到1
				//存储到o.color传递给片元着色器
				o.color = v.normal * 0.5 + fixed3(0.5,0.5,0.5);
				return o;
			}

			fixed4 fra(v2f i):SV_TARGET0{//类似这样的关键字绑定，是将这个函数返回的值存储到target0的特定物理存储位置，类似指针(个人理解)
				fixed3 c = i.color;
				c *= _Color.rgb;
				return fixed4(c,1.0);//默认颜色输出到帧缓存中
			}
			ENDCG
		}
	}
}