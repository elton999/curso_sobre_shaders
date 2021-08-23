Shader "Unlit/FireShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Width ("Width", float) = 1
        _Height ("Height", float) = 1
        _Radius ("Radius", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Cull off
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            #include "Structs.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Width;
            float _Height;
            float _Radius;


            StructuredBuffer<DataScript> bufferv;

            v2g vert (uint id : SV_VertexID)
            {   
                float3 v = bufferv[id].pos * _Radius;
                v.y += _Time.y * bufferv[id].vel;
                v2g o;
                o.vertex = float4(v, 0);
                return o;
            }

            

            [maxvertexcount(4)]
            void geom(point v2g IN[1], inout TriangleStream<g2f> stream){

                float3 right = float3(1,0,0);
                float3 up = float3(0,1,0);

                float3 v = IN[0].vertex;
                g2f o;

                o.vertex = UnityObjectToClipPos(v);
                o.uv = float2(0,0);
                stream.Append(o);

                float3 v1 = v + right * _Width;
                o.vertex = UnityObjectToClipPos(v1);
                o.uv = float2(1,0);
                stream.Append(o);

                float3 v2 = v + up * _Height;
                o.vertex = UnityObjectToClipPos(v2);
                o.uv = float2(0,1);
                stream.Append(o);

                float3 v3 = v1 + up * _Height;
                o.vertex = UnityObjectToClipPos(v3);
                o.uv = float2(1,1);
                stream.Append(o);
                
            }

            fixed4 frag (g2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
