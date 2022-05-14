using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostProcessingBase {
	public Shader gaussianBlurShader;
	public Material gaussianBlurMat = null;
	public Material material{
		get{
			gaussianBlurMat = CheckShaderAndCreateMaterial(gaussianBlurShader,gaussianBlurMat);
			return gaussianBlurMat;
		}
	}

	[Range(0,4)] public int iterations = 3;//迭代次数
	[Range(0.2f,3.0f)] public float blurSpread = 0.6f;
	[Range(1,8)] public int downSample = 2;

	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		if(material != null){
			int rtw = src.width;
			int rth = src.height;//可以对图像进行降采样，减少采样的像素,也就是对数据除downsample

			RenderTexture buffer = RenderTexture.GetTemporary(rtw,rth,0);//分配一块缓冲区

			Graphics.Blit(src,buffer,material,0);//第0个pass是在我们分配的缓冲区上进行计算的
			Graphics.Blit(buffer,dest,material,1);//第1个pass是以我们分配的缓冲区为源，到dest进行计算

			RenderTexture.ReleaseTemporary(buffer);//释放缓冲区
		}	
		else{
			Graphics.Blit(src,dest);
		}
	}
}
