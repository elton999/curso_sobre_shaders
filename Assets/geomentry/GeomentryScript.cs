using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeomentryScript : MonoBehaviour
{
    Vector3[] points;
    ComputeBuffer buffer;
    public Material material1;
    void Start()
    {
        points = new Vector3[1];
        buffer = new ComputeBuffer(1, 12);

        points[0] = Vector3.zero;

        buffer.SetData(points);
        material1.SetBuffer("buffervv", buffer);
    }

    private void OnRenderObject()
    {
        material1.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Triangles, 4, 1);
    }
    void Update()
    {

    }

    void OnDestroy()
    {
        buffer.Dispose();
    }

}
