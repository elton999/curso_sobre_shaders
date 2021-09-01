Shader "Unlit/raymarchingShader"
{
    Properties
    {
        _Color ("Color", Color) =  (1,1,1,1)
        _Center ("Center", Vector) = (0,0,0,0)
        _Radious ("Radious", float) = 1.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Structs.cginc"
            #include "RayMarching.cginc"

            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 pos;
                float4 col = float4(0,0,0,0);
                float3 rayOrigin = _WorldSpaceCameraPos;
                float3 rayDirection = normalize(i.wPos -_WorldSpaceCameraPos);
                int rm = raymarching(rayOrigin, rayDirection, pos);

                if(rm == 1){
                    float3 normal = calculate_normal(pos);
                    col = _Color;
                    col.rgb *= dot(normal, _WorldSpaceLightPos0);
                }
                return col;
            }
            ENDCG
        }
    }
}
