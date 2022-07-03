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
			
			#pragma vertex vert
			#pragma fragment frag
			
			// 包含檔中 .cginc (cg include 縮寫)，包含檔中定義了很多內置的輔助函數和數據結構體(Struct Type)
			#include "UnityCG.cginc"
			
			// 聲明 燈光變數 包含檔
			#include "UnityLightingCommon.cginc"
			
			// struct 寫完務必記得加上 ";" 符號
			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed4 dif : COLOR0;
			};
			
			fixed4 _MainColor;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				
				o.pos = UnityObjectToClipPos(v.vertex);
				
				float3 n = UnityObjectToWorldNormal(v.normal);
				n = normalize(n);
				
				fixed3 l = normalize(_WorldSpaceLightPos0.xyz);
				
				fixed ndotl = dot(n, l);
				o.dif = _LightColor0 * _MainColor * saturate(ndotl); // 將 x 的範圍擷取到 [0, 1] 之間
				// Lambert 算法的缺點是背光面試「全黑的」，若增加輔助光照會不利於性能優化，因此可以用 Half-Lambert 算法改進
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_TARGET
			{
				return i.dif;
			}
			
			ENDCG
		}
	}
}