Shader "Custom/Simplest Shader"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1) // 開放顏色屬性，_Name ("Display Name", type) = defaultValue[{options}]，type可能是 Float(浮點類型)、2D、3D(2D、3D貼圖類型)、color(顏色類型) 或是 Cube(立方體貼圖類型) 等等......
        _MainTex ("MainTex", 2D) = "white" {} // 開放紋理屬性
        _Cubemap ("Cubemap", Cube) = ""{}
        _Reflection ("Reflection", Range(0, 1)) = 0 // 開放反射屬性
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM // C for Graphic 程式開頭需要寫這個

            // pragma 為告知編譯器有特殊指示
            // vertex 代表頂點著色器，設定完之後命名為 vert，fragment 代表片段著色器，設定完之後命名為 frag，命名為以下函數使用
            #pragma vertex vert
            #pragma fragment frag

            // 宣告 紋理屬性變數 以及 ST變數，Properties 裡面宣告過的變數，在CG裏頭還要再宣告一次，使變數能夠從 Properties 讀進來
            // ST 變數意旨 Scale & Transform，表示 UV 的縮放和平移
            // UV 這名字的由來，就只是因為這二個字母是在三維的(X,Y,Z)前，沒別的意義
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            // 宣告 Cubemap 和 反射屬性變數，Cubemap是自己匯入的全景圖
            samplerCUBE _Cubemap;
            fixed _Reflection;
            
            // 這邊提供套用此 Shader 的 GameObject頂點的轉換，並輸出給片段著色器
            void vert(in float4 vertex : POSITION,
                    in float3 normal : NORMAL,
                    // in float2 uv : TEXCOORD0,
                    in float4 uv : TEXCOORD0,
                    out float4 position : SV_POSITION, // SV_POSITION 代表頂點在裁切空間中的座標
                    out float4 worldPos : TEXCOORD0,
                    out float3 worldNormal : TEXCOORD1,
                    out float2 texcoord : TEXCOORD2)
            {
                position = UnityObjectToClipPos(vertex); // 把套用此 Shader 的 GameObject 模型空間座標轉換到裁切空間座標

                worldPos = mul(unity_ObjectToWorld, vertex); // 將套用此 Shader 的 GameObject 頂點座標變換到世界空間，mul 意為執行乘法運算

                // 將套用此 Shader 的 GameObject 法向量變換到世界空間
                worldNormal = mul(normal, (float3x3)unity_WorldToObject);
                worldNormal = normalize(worldNormal);

                texcoord = uv * _MainTex_ST.xy + _MainTex_ST.zw; // 使用公式計算紋理座標，UV 先乘以平鋪值在加上偏移量，紋理才會在對的位置
            }

            void frag(in float4 position : SV_POSITION,
                    in float4 worldPos : TEXCOORD0,
                    in float3 worldNormal : TEXCOORD1,
                    in float2 texcoord : TEXCOORD2,
                    out fixed4 color : SV_TARGET)
            {
                // color = fixed4(1, 0, 0, 1); (R, G, B, W)，所以這段表示顏色是紅色
                // color = _MainColor; 開放一個屬性 MainColor 可以給使用者在 Inspector 上調整顏色
                fixed4 main = tex2D(_MainTex, texcoord) * _MainColor; // 使套用此 Shader 的 GameObject 能夠擁有紋理

                // 計算 世界空間 中從 攝像機 指向 GameObject頂點 的方向向量
                float3 viewDir = worldPos.xyz - _WorldSpaceCameraPos;
                viewDir = normalize(viewDir);

                // 套用公式計算反射向量
                float3 refDir = 2 * dot( -viewDir, worldNormal) * worldNormal + viewDir;
                refDir = normalize(refDir);

                // 對 Cubemap(全景圖) 進行採樣
                fixed4 reflection = texCUBE(_Cubemap, refDir);

                // 使用_Reflection 對 顏色 和 反射 進行線性插值計算
                color = lerp(main, reflection, _Reflection);
            }
            
            ENDCG // C for Graphic 中當一段 shader 結束時，需要用這行當結尾
        }
    }
}
