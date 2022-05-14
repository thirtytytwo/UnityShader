using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostProcessingBase : MonoBehaviour {
	protected void CheckResources(){
		bool isSurpport = CheckSupport();

		if(isSurpport == false){
			NotSurpport();
		}
	}
	protected bool CheckSupport(){
		if(SystemInfo.supportsImageEffects == false){
			return false;
		}
		else{
			return true;
		}
	}
	protected void NotSurpport(){
		enabled = false;
	}

	protected Material CheckShaderAndCreateMaterial(Shader shader, Material material){
		if(shader == null){
			return null;
		}

		if(shader.isSupported && material != null && material.shader == shader){
			return material;
		}

		if(!shader.isSupported){
			return null;
		}

		else{
			material = new Material(shader);
			material.hideFlags = HideFlags.DontSave;
			if(material){
				return material;
			}
			else{
				return null;
			}
		}
	}

	private void Start() {
		CheckResources();
	}
}
