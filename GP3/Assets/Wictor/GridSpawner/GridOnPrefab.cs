using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GridOnPrefab : MonoBehaviour
{

    [System.Serializable]
    public class GridObjects
    {
        public GameObject prefab;
    }

    public List<GridObjects> gridObjects = new List<GridObjects>();
    public int rows = 10;
    public int columns = 10;
    public float spacing = 1.0f;
    public float yOffset = 0.5f;
    public int maxOccupiedSlots = 100;

    private bool[,] gridOccupied;
    private int currentlyOccupiedSlots = 0;
    private List<Vector2Int> availablePositions = new List<Vector2Int>();

    void Start()
    {
        gridOccupied = new bool[rows, columns];
        for (int x = 0; x < rows; x++)
        {
            for (int z = 0; z < columns; z++)
            {
                gridOccupied[x, z] = false;
                availablePositions.Add(new Vector2Int(x, z));
            }
        }

        FillGridWithLimitedOccupancy();
    }

    void FillGridWithLimitedOccupancy()
    {
        int attemptCounter = 0;

        while (currentlyOccupiedSlots < maxOccupiedSlots && attemptCounter < 1000 && gridObjects.Count > 0 && availablePositions.Count > 0)
        {
            int randomObjectIndex = Random.Range(0, gridObjects.Count);
            GridObjects randomObject = gridObjects[randomObjectIndex];

            int randomPositionIndex = Random.Range(0, availablePositions.Count);
            Vector2Int chosenPosition = availablePositions[randomPositionIndex];

            GridObject sizeChecker = randomObject.prefab.GetComponent<GridObject>();
            if (sizeChecker != null)
            {
                int objectSizeX = sizeChecker.SizeX;
                int objectSizeZ = sizeChecker.SizeZ;

                if (CanPlace(objectSizeX, objectSizeZ, chosenPosition.x, chosenPosition.y)
                    && currentlyOccupiedSlots + objectSizeX * objectSizeZ <= maxOccupiedSlots)
                {
                    SpawnObject(randomObject.prefab, objectSizeX, objectSizeZ, chosenPosition.x, chosenPosition.y);
                    currentlyOccupiedSlots += objectSizeX * objectSizeZ;
                    gridObjects.RemoveAt(randomObjectIndex);
                }
                availablePositions.RemoveAt(randomPositionIndex);
            }
            else
            {
                Debug.LogWarning("The selected prefab doesn't have a GridSizeChecker component!");
                return;  // Exit the method if a prefab doesn't have the necessary component
            }

            attemptCounter++;
        }
    }

    bool CanPlace(int sizeX, int sizeZ, int posX, int posZ)
    {
        if (posX + sizeX > rows || posZ + sizeZ > columns) return false;

        for (int x = posX; x < posX + sizeX; x++)
        {
            for (int z = posZ; z < posZ + sizeZ; z++)
            {
                if (gridOccupied[x, z]) return false;
            }
        }
        return true;
    }

    void SpawnObject(GameObject prefab, int sizeX, int sizeZ, int posX, int posZ)
    {
        Vector3 spawnPosition = GetWorldPosition(posX, posZ, sizeX, sizeZ);
        GameObject spawnedObject = Instantiate(prefab, spawnPosition, Quaternion.identity);
        spawnedObject.transform.SetParent(transform);

        for (int x = posX; x < posX + sizeX; x++)
        {
            for (int z = posZ; z < posZ + sizeZ; z++)
            {
                gridOccupied[x, z] = true;
            }
        }
    }

    Vector3 GetWorldPosition(int x, int z, int sizeX = 1, int sizeZ = 1)
    {
        return new Vector3(
            x * spacing - (rows * spacing) / 2.0f + spacing / 2.0f - (sizeX - 1) * spacing / 2.0f,
            yOffset,
            z * spacing - (columns * spacing) / 2.0f + spacing / 2.0f - (sizeZ - 1) * spacing / 2.0f
        ) + transform.position;
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
