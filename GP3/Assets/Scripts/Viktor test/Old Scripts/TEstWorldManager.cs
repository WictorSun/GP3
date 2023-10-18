using UnityEngine;
using System.Collections.Generic;

public class TEstWorldManager : MonoBehaviour
{
    [Tooltip("Reference to the player object")]
    public GameObject player; // Reference to the player object
    [Tooltip("Reference to the Chunks prefabs")]
    public List<GameObject> groundPrefabs;
    public float spawnDistance = 50f; // Distance ahead of player to spawn rectangles
     [Tooltip("Distance behind player to destroy Chunks")]
    public float destroyDistance = -10f; // Distance behind player to destroy rectangles
    public int numberOfGrounds = 5; // Number of ground rectangles to maintain at beginning
    public float spawnCooldown = 1.0f; // Cooldown in seconds
    public float groundSpeed;
    private Queue<GameObject> spawnedGrounds = new Queue<GameObject>(); // Queue to hold spawned ground rectangles
    private float nextSpawnTime = 0f; // Time at which the next ground rectangle can be spawned
    private int nextPrefabIndex = 0;  // Index of the next prefab to spawn
    private bool isReversed = false;  // Is the player going back?

    void Start()
    {
        // Initial spawn of ground rectangles
        for (int i = 0; i < numberOfGrounds; i++)
        {
            SpawnGround(player.transform.position.x + i);
        }
    }

    void Update()
    {
        // Get player's position
        Vector3 playerPos = player.transform.position;

        // Get the position of the last spawned ground
        GameObject lastGround = spawnedGrounds.Peek();
        float distanceToLastGround = lastGround.transform.position.z - playerPos.z;

        // Spawn new ground if the last one is within spawnDistance units ahead of the player
        if (Time.time >= nextSpawnTime && distanceToLastGround < spawnDistance)
        {
            SpawnGround(player.transform.position.z + spawnDistance);
            nextSpawnTime = Time.time + spawnCooldown;
        }

        // Get the position of the first spawned ground
        GameObject firstGround = spawnedGrounds.Peek();
        float distanceToFirstGround = firstGround.transform.position.z - playerPos.z;

        // Destroy the first ground if it's more than destroyDistance units behind the player
        if (distanceToFirstGround < destroyDistance)
        {
            DestroyGround();
        }

        // Move all spawned grounds
        foreach (GameObject ground in spawnedGrounds)
        {
            ground.transform.Translate(Vector3.forward * groundSpeed * Time.deltaTime);
        }
    }

    void SpawnGround(float zPos)
    {
        Vector3 spawnPosition = new Vector3(player.transform.position.x + spawnDistance, 0f, 0f);
        // Determine which prefab to spawn next
        GameObject nextPrefab = groundPrefabs[nextPrefabIndex];

        // Instantiate the next ground prefab at the spawn position
        Instantiate(nextPrefab, spawnPosition, Quaternion.identity);

        // Update the index for the next prefab to spawn
        if (isReversed)
        {
            nextPrefabIndex = (nextPrefabIndex - 1 + groundPrefabs.Count) % groundPrefabs.Count;
        }
        else
        {
            nextPrefabIndex = (nextPrefabIndex + 1) % groundPrefabs.Count;
        }
    }

    // Call this method when the player reaches the end and turns around
    public void ReverseOrder()
    {
        isReversed = !isReversed;
    }

    void DestroyGround()
    {
        // Destroy the oldest ground rectangle and remove it from the queue
        GameObject oldGround = spawnedGrounds.Dequeue();
        Destroy(oldGround);
    }
}