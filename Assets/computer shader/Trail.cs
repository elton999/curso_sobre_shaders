using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trail : MonoBehaviour
{
    int pointsCount = 16;
    Vector3[] points;
    ComputeBuffer buffer;

    public Material material;
    void Start()
    {
        points = new Vector3[pointsCount];
        buffer = new ComputeBuffer(pointsCount, 12);

        for (int i = 0; i < pointsCount; i++)
        {
            points[i] = Vector3.zero;
        }

        buffer.SetData(points);
        material.SetBuffer("bufferv", buffer);
    }

    private void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, buffer.count, 1);
    }

    void OnDestroy()
    {
        buffer.Dispose();
    }

    // Update is called once per frame
    void Update()
    {

    }
}
