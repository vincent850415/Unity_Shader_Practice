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
			#include "UnityCG.cginc"


		}
	}
}
