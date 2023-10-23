using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridOnPrefab : MonoBehaviour
{
    public GameObject objectToSpawn; // The prefab to spawn
    public int rows = 10;            // Number of rows
    public int columns = 10;         // Number of columns
    public float spacing = 1.0f;     // Space between objects
    public float yOffset = 0.5f;     // Y Offset for spawned objects
    public int pathWidth = 1;        // Width of the path

    private bool[,] pathGrid;        // To track the path within the grid

    void Start()
    {
        SpawnGrid();
    }

    void GenerateRandomPath()
    {
        pathGrid = new bool[rows, columns];
        int currentColumn = Random.Range(pathWidth, columns - pathWidth);

        for (int x = 0; x < rows; x++)
        {
            int moveDirection = Random.Range(-1, 2);
            currentColumn += moveDirection;
            currentColumn = Mathf.Clamp(currentColumn, pathWidth, columns - pathWidth - 1);

            for (int w = -pathWidth; w <= pathWidth; w++)
            {
                pathGrid[x, currentColumn + w] = true;
            }
        }
    }

    void SpawnGrid()
    {
        GenerateRandomPath();

        for (int x = 0; x < rows; x++)
        {
            for (int z = 0; z < columns; z++)
            {
                if (pathGrid[x, z]) continue;

                Vector3 position = new Vector3(
                    x * spacing - (rows * spacing) / 2.0f + spacing / 2.0f,
                    yOffset,
                    z * spacing - (columns * spacing) / 2.0f + spacing / 2.0f
                );

                position += transform.position;

                GameObject spawnedObject = Instantiate(objectToSpawn, position, Quaternion.identity);
                spawnedObject.transform.SetParent(transform);
            }
        }
    }
    void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;

        for (int x = 0; x <= rows; x++)
        {
            Gizmos.DrawLine(
                transform.position + new Vector3(x * spacing - (rows * spacing) / 2.0f, 0, -(columns * spacing) / 2.0f),
                transform.position + new Vector3(x * spacing - (rows * spacing) / 2.0f, 0, (columns * spacing) / 2.0f)
            );
        }

        for (int z = 0; z <= columns; z++)
        {
            Gizmos.DrawLine(
                transform.position + new Vector3(-(rows * spacing) / 2.0f, 0, z * spacing - (columns * spacing) / 2.0f),
                transform.position + new Vector3((rows * spacing) / 2.0f, 0, z * spacing - (columns * spacing) / 2.0f)
            );
        }
    }
}
