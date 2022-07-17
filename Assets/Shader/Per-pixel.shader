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
            
            //Per-Pixel Lighting �P Phong Lighting �t�O�N�b��p���C�⪺�������b�u���I�v�ۦ⾹�������A�ӬO�b�u���q�v�ۦ⾹������
            fixed4 frag (v2f i) : SV_Target
            {
                //�p�⤽�������Ҧ��ܶq
                float3 n = UnityObjectToWorldNormal(i.normal);
                n = normalize(n);
                fixed3 l = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 view = normalize(WorldSpaceViewDir(i.vertex));

                // ���Ϯg������
                fixed ndotl = saturate(dot(n, l));
                fixed4 dif = _LightColor0 * _MainColor * ndotl;

                // �譱�Ϯg������
                float3 ref = reflect(-l, n);
                ref = normalize(ref);
                fixed rdotv = saturate(dot(ref, view));
                fixed4 spec = _LightColor0 * _SpecularColor * pow(rdotv, _Shininess);

                 // ���ҥ� + ���Ϯg + �譱�Ϯg
                return unity_AmbientSky + dif + spec;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
