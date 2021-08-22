Shader "Unlit/GrassShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutout ("Cutout", Range(0,1)) = 0
        _Height ("Height", float) = 1
        _Width ("Width", float) = 1

        _WindVelocity("Wind Velocity", Range(1,5)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="CutoutTransparent" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _Color;
            float _Cutout;
            float _Height;
            float _Width;

            float _WindVelocity;

            struct v2g
            {
                float4 vertex : SV_POSITION;
            };


            struct g2f {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };


            StructuredBuffer<float3> buffervv;
            v2g vert (uint id: SV_VertexID)
            {
                v2g o;
                o.vertex = float4(buffervv[id], 0);
                return o;
            }

            [maxvertexcount(4)]
            void geom(point v2g IN[1], inout TriangleStream<g2f> stream){
                
                g2f o;
                float3 v = IN[0].vertex;

                float3 wind = ((int)v.z) % 2 == 0 ? float3(0,0,1) : float3(0,0,-1); 
                wind *= cos(_Time.y * _WindVelocity);

                float3 right = float3(cos(v.x),0,cos(v.z));
                float3 up = float3(0,1,0);

                o.vertex = UnityObjectToClipPos(v);
                o.uv = float2(0,0);
                stream.Append(o);

                float3 v1 = v + right * _Width;
                o.vertex = UnityObjectToClipPos(v1);
                o.uv = float2(1,0);
                stream.Append(o);

                float3 v2 = v + up * _Height + wind;
                o.vertex = UnityObjectToClipPos(v2);
                o.uv = float2(0,1);
                stream.Append(o);

                float3 v3 = v1 + up * _Height + wind;
                o.vertex = UnityObjectToClipPos(v3);
                o.uv = float2(1,1);
                stream.Append(o);
            }

            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                clip(col.a - _Cutout);
                col.rgb = col.rgb * col.y;
                return col;
            }
            ENDCG
        }
    }
}
