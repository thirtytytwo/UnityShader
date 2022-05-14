using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeNormalAndDepth : PostProcessingBase {
	public Shader edgeShader;
	private Material edgeMat;
	public Material material{
		get{
			edgeMat = CheckShaderAndCreateMaterial(edgeShader,edgeMat);
			return edgeMat;
		}
	}

	[Range(0,1.0f)] public float edgesOnly = 0.0f;
	public Color edgeColor = Color.black;
	public Color backgroundColor = Color.white;

	public float samoleDistance = 1.0f;
	public float sensitivityDepth = 1.0f;
	public float sensitivityNormals = 1.0f;

	private void OnEnable() {
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	[ImageEffectOpaque]
	private void OnRenderImage(RenderTexture src, RenderTexture dest) {
		if(material != null){
			material.SetFloat("_EdgeOnly", edgesOnly);
			material.SetColor("_EdgeColor",edgeColor);
			material.SetColor("_BackgroundColor",backgroundColor);
			material.SetFloat("_SampleDistance",samoleDistance);
			material.SetVector("_Sensitivity", new Vector4(sensitivityNormals,samoleDistance,0,0));

			Graphics.Blit(src,dest,material);
		}
		else{
			Graphics.Blit(src,dest);
		}
	}
}
