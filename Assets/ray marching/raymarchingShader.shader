Shader "Unlit/raymarchingShader"
{
    Properties
    {
        _Color ("Color", Color) =  (1,1,1,1)
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

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 wPos : TEXCOORD0;
            };

            float4 _Color;
            float _Radious;

            v2f vert (appdata v)
            {
                v2f o;
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            #define STEPS 30

            float sphere_sdf(float3 p, float3 c){
                float d = length(p-c) - _Radious;
                return d;
            }

            int raymarching(float3 ro, float3 rd){
                float total_dist = 0;
                float3 pos;

                for(int i = 0; i < STEPS; i++){
                    pos = ro + rd * total_dist;
                    float d = sphere_sdf(pos, float3(0,0,0));
                    if(d < 0.001)
                        return 1;
                    if(d > 1000)
                        return 0;

                    total_dist+= d;
                }

                return 0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = float4(0,0,0,0);
                float3 rayOrigin = _WorldSpaceCameraPos;
                float3 rayDirection = normalize(i.wPos -_WorldSpaceCameraPos);
                int rm = raymarching(rayOrigin, rayDirection);

                if(rm == 1){
                    col = _Color;
                }
                return col;
            }
            ENDCG
        }
    }
}
