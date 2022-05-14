using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection : PostProcessingBase {
	public Shader edgeShader;
	public Material edgeMat;
	public Material material{
		get{
			edgeMat = CheckShaderAndCreateMaterial(edgeShader,edgeMat);
			return edgeMat;
		}
	}

	[Range(0,1)]public float edgeOnly = 1.0f;//边缘和背景的权重
	public Color edgeColor = Color.black;//边缘颜色
	public Color backgroundColor = Color.white;//背景颜色

//类似start的函数，一个供程序员编写的自定义接口
	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		if(material != null){
			material.SetFloat("_EdgeOnly", edgeOnly);
			material.SetColor("_EdgeColor", edgeColor);
			material.SetColor("_BackgroundColor", backgroundColor);

			Graphics.Blit(src,dest,material);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
