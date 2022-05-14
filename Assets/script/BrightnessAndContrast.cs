using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrightnessAndContrast : PostProcessingBase {
	public Shader briSatConShader;
	private Material briSatConMat;
	public Material material{
		get{
			briSatConMat = CheckShaderAndCreateMaterial(briSatConShader,briSatConMat);
			return briSatConMat;
		}
	}

	[Range(0,3)]public float brightness = 1.0f;//亮度
	[Range(0,3)]public float saturation = 1.0f;//饱和度
	[Range(0,3)]public float contrast = 1.0f;//对比度

//类似start的函数，一个供程序员编写的自定义接口
	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		if(material != null){
			material.SetFloat("_Brightness",brightness);
			material.SetFloat("_Saturation",saturation);
			material.SetFloat("_Contrast", contrast);

			Graphics.Blit(src,dest,material);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
