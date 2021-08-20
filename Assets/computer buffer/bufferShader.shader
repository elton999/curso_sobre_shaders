Shader "Unlit/bufferShader"
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
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };
            float4 _Color;
            
            StructuredBuffer<float3> buffer;

            v2f vert (uint id: SV_VERTEXID)
            {
                ///sad
                v2f o;
                o.vertex = UnityObjectToClipPos(buffer[id]);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                return _Color;
            }
            ENDCG
        }
    }
}
