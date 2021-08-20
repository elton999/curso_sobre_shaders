using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeomentryScript : MonoBehaviour
{
    Vector3[] points;
    ComputeBuffer buffer;
    public Material Material;
    void Start()
    {
        points = new Vector3[1];
        buffer = new ComputeBuffer(1, 12);

        points[0] = Vector3.zero;

        buffer.SetData(points);
        Material.SetBuffer("buffer", buffer);
    }

    void OnRenderObject()
    {
        Material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Triangles, 1, 1);
    }
    void Update()
    {

    }
}
