using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewNormals : MonoBehaviour
{
    [Range(0, 10)]
    public float length = 1;
    public Vector3[] normals;
    public Vector3[] vertices;
    void Start()
    {
        vertices = GetComponent<MeshFilter>().mesh.vertices;
        normals = GetComponent<MeshFilter>().mesh.normals;
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        for (int i = 0; i < vertices.Length; i++)
        {
            Gizmos.DrawLine(vertices[i], vertices[i] + normals[i] * length);
        }
    }
}
