 Shader "Unlit/GeomentryShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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

            struct v2g
            {
                float4 vertex : SV_POSITION;
            };


            struct g2f {
                //float2 uv: TEXCOORD0;
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

                float3 right = float3(1,0,0);
                float3 up = float3(0,1,0);
                float3 v = IN[0].vertex;

                o.vertex = UnityObjectToClipPos(v);
                stream.Append(o);

                float3 v1 = v + right;
                o.vertex = UnityObjectToClipPos(v1);
                stream.Append(o);

                float3 v2 = v + up;
                o.vertex = UnityObjectToClipPos(v2);
                stream.Append(o);

                float3 v3 = v1 + up;
                o.vertex = UnityObjectToClipPos(v3);
                stream.Append(o);
            }

            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = _Color;// tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
