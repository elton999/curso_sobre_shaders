using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trail : MonoBehaviour
{
    int pointsCount = 16;
    Vector3[] points;
    ComputeBuffer buffer;

    public Material material;

    public ComputeShader Compute;
    int kernel;

    [Range(0, 10)]
    public float velocity;
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


        kernel = Compute.FindKernel("Move");
        Compute.SetBuffer(kernel, "bufferv", buffer);
    }

    private void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, buffer.count, 1);
    }

    void Update()
    {
        Compute.SetFloat("velocity", velocity);
        Compute.SetVector("position", transform.position);
        Compute.Dispatch(kernel, buffer.count / 16, 1, 1);
    }

    void OnDestroy()
    {
        buffer.Dispose();
    }
}
