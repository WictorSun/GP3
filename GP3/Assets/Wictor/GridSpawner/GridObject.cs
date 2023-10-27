using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridObject : MonoBehaviour
{
    [Tooltip("Set this to the same value as the 'spacing' in your GridOnPrefab script")]
    public float gridSpacing = 1.0f;

    public int SizeX { get; private set; }
    public int SizeZ { get; private set; }

    void Awake()
    {
        ComputeGridSize();
    }

    private void ComputeGridSize()
    {
        Collider collider = GetComponent<Collider>();

        if (collider == null)
        {
            Debug.LogError("Object doesn't have a collider, so can't determine grid size!");
            return;
        }

        Vector3 objectSize = collider.bounds.size;

        SizeX = Mathf.Max(1, Mathf.RoundToInt(objectSize.x / gridSpacing));
        SizeZ = Mathf.Max(1, Mathf.RoundToInt(objectSize.z / gridSpacing));
        Debug.Log(SizeX);
        Debug.Log(SizeZ);
    }
}
