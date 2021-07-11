Shader "Unlit/LightShader"
{
    Properties
    {
        _ObjectColor("object color", Color) = (1,1,1,1)
        _LColor("Light Color", Color) = (1,1,1,1)
        _Ambient("Ambient", Range(0,1)) = 1

        _Diffuse("Diffuse", Range(0,1)) = 0
        _Specular("Specular", Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _ObjectColor;
            float4 _LColor;
            float _Ambient;

            float _Diffuse;
            float _Specular;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 wPos : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // diffuse
                float4 ambient = _LColor * _Ambient;
                float4 diffuse = _LColor * dot(i.normal, _WorldSpaceLightPos0) * _Diffuse;
                
                // specular
                float3 r = reflect(_WorldSpaceLightPos0, i.normal);
                float3 viewDir = - normalize(_WorldSpaceCameraPos - i.wPos); //view direction
                
                float spec = dot(r, viewDir);
                float4 specular = _LColor * pow(max(0, spec), _Specular); 

                fixed4 col = _ObjectColor * (ambient + diffuse + specular);
                return col;
            }
            ENDCG
        }
    }
}
