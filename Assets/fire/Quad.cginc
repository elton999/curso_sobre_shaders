void quad(out g2f o[4], float3 v, float s)
{
    float3 right = float3(0.5f,0,0);
    float3 up = float3(0,1,0);

    float3 view = normalize(_WorldSpaceCameraPos - v);
    float3 perp = cross(view, up);
    up = cross(view, perp);

    float3 v1 = v - perp * s;
    o[0].vertex = UnityObjectToClipPos(v1);
    o[0].wPos = mul(unity_ObjectToWorld, v1);
    o[0].uv = float2(0,0);

    float3 v2 = v + perp * s;
    o[1].vertex = UnityObjectToClipPos(v2);
    o[1].wPos = mul(unity_ObjectToWorld, v2);
    o[1].uv = float2(1,0);

    float3 v3 = v1 + up * s;
    o[2].vertex = UnityObjectToClipPos(v3);
    o[2].wPos = mul(unity_ObjectToWorld, v3);
    o[2].uv = float2(0,1);

    float3 v4 = v2 + up * s;
    o[3].vertex = UnityObjectToClipPos(v4);
    o[3].wPos = mul(unity_ObjectToWorld, v4);
    o[3].uv = float2(1,1);

}