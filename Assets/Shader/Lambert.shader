Shader "Custom/Lambert"
{
	Properties
	{
		_MainColor ("Main Color", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM

			#Pragma Vertex vert
			#Pragma Fragment frag
			// 包含檔中 .cginc (cg include 縮寫)，包含檔中定義了很多內置的輔助函數和數據結構體(Struct Type)
			#include "UnityCG.cginc"


		}
	}
}
