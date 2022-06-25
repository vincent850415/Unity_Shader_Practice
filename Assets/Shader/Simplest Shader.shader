Shader "Custom/Simplest Shader"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1) // �}���C���ݩʡA_Name ("Display Name", type) = defaultValue[{options}]�Atype�i��O Float(�B�I����)�B2D�B3D(2D�B3D�K������)�Bcolor(�C������) �άO Cube(�ߤ���K������) ����......
        _MainTex ("MainTex", 2D) = "white" {} // �}�񯾲z�ݩ�
        _Cubemap ("Cubemap", Cube) = ""{}
        _Reflection ("Reflection", Range(0, 1)) = 0 // �}��Ϯg�ݩ�
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM // C for Graphic �{���}�Y�ݭn�g�o��

            // pragma ���i���sĶ�����S�����
            // vertex �N���I�ۦ⾹�A�]�w������R�W�� vert�Afragment �N����q�ۦ⾹�A�]�w������R�W�� frag�A�R�W���H�U��ƨϥ�
            #pragma vertex vert
            #pragma fragment frag

            // �ŧi ���z�ݩ��ܼ� �H�� ST�ܼơAProperties �̭��ŧi�L���ܼơA�bCG���Y�٭n�A�ŧi�@���A���ܼƯ���q Properties Ū�i��
            // ST �ܼƷN�� Scale & Transform�A��� UV ���Y��M����
            // UV �o�W�r���ѨӡA�N�u�O�]���o�G�Ӧr���O�b�T����(X,Y,Z)�e�A�S�O���N�q
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            // �ŧi Cubemap �M �Ϯg�ݩ��ܼơACubemap�O�ۤv�פJ��������
            samplerCUBE _Cubemap;
            fixed _Reflection;
            
            // �o�䴣�ѮM�Φ� Shader �� GameObject���I���ഫ�A�ÿ�X�����q�ۦ⾹
            void vert(in float4 vertex : POSITION,
                    in float3 normal : NORMAL,
                    // in float2 uv : TEXCOORD0,
                    in float4 uv : TEXCOORD0,
                    out float4 position : SV_POSITION, // SV_POSITION �N���I�b�����Ŷ������y��
                    out float4 worldPos : TEXCOORD0,
                    out float3 worldNormal : TEXCOORD1,
                    out float2 texcoord : TEXCOORD2)
            {
                position = UnityObjectToClipPos(vertex); // ��M�Φ� Shader �� GameObject �ҫ��Ŷ��y���ഫ������Ŷ��y��

                worldPos = mul(unity_ObjectToWorld, vertex); // �N�M�Φ� Shader �� GameObject ���I�y���ܴ���@�ɪŶ��Amul �N�����歼�k�B��

                // �N�M�Φ� Shader �� GameObject �k�V�q�ܴ���@�ɪŶ�
                worldNormal = mul(normal, (float3x3)unity_WorldToObject);
                worldNormal = normalize(worldNormal);

                texcoord = uv * _MainTex_ST.xy + _MainTex_ST.zw; // �ϥΤ����p�⯾�z�y�СAUV �����H���Q�Ȧb�[�W�����q�A���z�~�|�b�諸��m
            }

            void frag(in float4 position : SV_POSITION,
                    in float4 worldPos : TEXCOORD0,
                    in float3 worldNormal : TEXCOORD1,
                    in float2 texcoord : TEXCOORD2,
                    out fixed4 color : SV_TARGET)
            {
                // color = fixed4(1, 0, 0, 1); (R, G, B, W)�A�ҥH�o�q����C��O����
                // color = _MainColor; �}��@���ݩ� MainColor �i�H���ϥΪ̦b Inspector �W�վ��C��
                fixed4 main = tex2D(_MainTex, texcoord) * _MainColor; // �ϮM�Φ� Shader �� GameObject ����֦����z

                // �p�� �@�ɪŶ� ���q �ṳ�� ���V GameObject���I ����V�V�q
                float3 viewDir = worldPos.xyz - _WorldSpaceCameraPos;
                viewDir = normalize(viewDir);

                // �M�Τ����p��Ϯg�V�q
                float3 refDir = 2 * dot( -viewDir, worldNormal) * worldNormal + viewDir;
                refDir = normalize(refDir);

                // �� Cubemap(������) �i��ļ�
                fixed4 reflection = texCUBE(_Cubemap, refDir);

                // �ϥ�_Reflection �� �C�� �M �Ϯg �i��u�ʴ��ȭp��
                color = lerp(main, reflection, _Reflection);
            }
            
            ENDCG // C for Graphic ����@�q shader �����ɡA�ݭn�γo�����
        }
    }
}
