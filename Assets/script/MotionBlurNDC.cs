using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurNDC : PostProcessingBase {
	public Shader motionBlurShader;
	private Material motionBlurMat = null;
	public Material material{
		get{
			motionBlurMat = CheckShaderAndCreateMaterial(motionBlurShader,motionBlurMat);
			return motionBlurMat;
		}
	}

	[Range(0.0f,1f)] public float blurSize = 0.5f;

	private Camera myCam;
	public Camera camera{
		get{
			if(myCam == null){
				myCam = GetComponent<Camera>();
			}
			return myCam;
		}
	}

	private Matrix4x4 previousViewProjectionMatrix;

	private void OnEnable() {
		camera.depthTextureMode |= DepthTextureMode.Depth;
	}

	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		if(material != null){
			material.SetFloat("_BlurAmount",blurSize);
			material.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);

			Matrix4x4 currentViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix; //用摄像机投影矩阵和视角矩阵相乘
			Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;//上面矩阵的逆矩阵

			material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
			previousViewProjectionMatrix = currentViewProjectionMatrix;

			Graphics.Blit(src,dest,material);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
