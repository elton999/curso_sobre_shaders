using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grass : MonoBehaviour
{
    [Range(1, 50)]
    public int amuont;

    Vector3[] points;
    ComputeBuffer buffer;
    public Material material1;
    void Start()
    {
        points = new Vector3[amuont];
        buffer = new ComputeBuffer(amuont, 12);

        for (int i = 0; i < amuont; i++)
        {
            points[i] = new Vector3(Random.Range(-10f, 10f), 0, Random.Range(-10f, 10f));
        }


        buffer.SetData(points);
        material1.SetBuffer("buffervv", buffer);
    }

    private void OnRenderObject()
    {
        material1.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, buffer.count, 1);
    }
    void Update()
    {

    }

    void OnDestroy()
    {
        buffer.Dispose();
    }
}
