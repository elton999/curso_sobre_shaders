using System.Collections;
using UnityEngine;

public class Fire : MonoBehaviour
{

    public struct Data{
        public Vector3 pos;
        public float vel;
    }


    [Range(1,500)]
    public int amount;
    Data[] points;
    ComputeBuffer buffer;

    public Material material;
    // Start is called before the first frame update
    void Start()
    {
        points = new Data[amount];
        buffer = new ComputeBuffer(amount, 16);

        for (int i = 0; i < amount; i++)
        {
            float x = Random.Range(0, 360);
            x = Mathf.Cos(x * Mathf.Deg2Rad);

            float z = Random.Range(0, 360);
            z = Mathf.Cos(z * Mathf.Deg2Rad);

            points[i].pos = new Vector3(x,0,z);
            points[i].vel = Random.Range(0.5f, 0.1f);
        }

        buffer.SetData(points);
        material.SetBuffer("bufferv", buffer);

    }

    private void OnRenderObject() {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, buffer.count, 1);    
    }

    private void OnDestroy()
    {
        buffer.Dispose();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
