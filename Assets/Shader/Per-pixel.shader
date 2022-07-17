Shader "Custom/Per-Pixel"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _SpecularColor("Specular Color", Color) = (0, 0, 0, 0)
        _Shininess("Shininess", Range(1, 100)) = 1
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex  vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 vertex : TEXCOORD1;
            };

            fixed4 _MainColor;
            fixed4 _SpecularColor;
            half _Shininess;

            v2f vert (appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.vertex = v.vertex;

                return o;
            }
            
            //Per-Pixel Lighting 與 Phong Lighting 差別就在於計算顏色的部分不在「頂點」著色器的部分，而是在「片段」著色器的部分
            fixed4 frag (v2f i) : SV_Target
            {
                //計算公式中的所有變量
                float3 n = UnityObjectToWorldNormal(i.normal);
                n = normalize(n);
                fixed3 l = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 view = normalize(WorldSpaceViewDir(i.vertex));

                // 漫反射的部分
                fixed ndotl = saturate(dot(n, l));
                fixed4 dif = _LightColor0 * _MainColor * ndotl;

                // 鏡面反射的部分
                float3 ref = reflect(-l, n);
                ref = normalize(ref);
                fixed rdotv = saturate(dot(ref, view));
                fixed4 spec = _LightColor0 * _SpecularColor * pow(rdotv, _Shininess);

                 // 環境光 + 漫反射 + 鏡面反射
                return unity_AmbientSky + dif + spec;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
