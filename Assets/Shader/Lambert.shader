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

            // �]�t�ɤ� .cginc (cg include �Y�g)�A�]�t�ɤ��w�q�F�ܦh���m�����U��ƩM�ƾڵ��c��(Struct Type)
			#include "UnityCG.cginc"

            // �n�� �O���ܼ� �]�t��
			#include "UnityLightingCommon.cginc"

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
				o.dif = _LightColor0 * _MainColor * saturate(ndotl);

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
