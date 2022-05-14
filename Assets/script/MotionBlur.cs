using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlur : PostProcessingBase {
	public Shader motionBlurShader;
	private Material motionBlurMat = null;

	public Material material{
		get{
			motionBlurMat = CheckShaderAndCreateMaterial(motionBlurShader,motionBlurMat);
			return motionBlurMat;
		}
	}

	[Range(0.0f,0.9f)] public float blurAmount = 0.5f;

	private RenderTexture accumulationTexture;

	private void OnDisable() {
		DestroyImmediate(accumulationTexture);
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		if(material != null){
			if(accumulationTexture == null || accumulationTexture.width != src.width || accumulationTexture.height != src.height){
				DestroyImmediate(accumulationTexture);
				accumulationTexture = new RenderTexture(src.width,src.height,0);
				accumulationTexture.hideFlags = HideFlags.HideAndDontSave;
				Graphics.Blit(src,accumulationTexture);//把渲染的原图存入我们创建的缓冲中
			}

			accumulationTexture.MarkRestoreExpected();//不需要提前清空所以使用这个方法

			material.SetFloat("_BlurAmount", 1.0f - blurAmount);

			Graphics.Blit(src,accumulationTexture,material);
			Graphics.Blit(accumulationTexture,dest);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
