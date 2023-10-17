using UnityEngine;
using System.Collections.Generic;

public class WorldManager : MonoBehaviour
{
    public GameObject player; // Reference to the player object
    public GameObject groundPrefab; // The ground rectangle prefab
    public float spawnDistance = 50f; // Distance ahead of player to spawn rectangles
    public float destroyDistance = -10f; // Distance behind player to destroy rectangles
    public float groundWidth = 10f; // Width of a single ground rectangle
    public int numberOfGrounds = 5; // Number of ground rectangles to maintain
    public float spawnCooldown = 1.0f; // Cooldown in seconds 

    private Queue<GameObject> spawnedGrounds = new Queue<GameObject>(); // Queue to hold spawned ground rectangles
    private float nextSpawnTime = 0f; // Time at which the next ground rectangle can be spawned

    void Start()
    {
        // Initial spawn of ground rectangles
        for (int i = 0; i < numberOfGrounds; i++)
        {
            SpawnGround(player.transform.position.x + i * groundWidth);
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
    }

    void SpawnGround(float xPos)
    {
        // Spawn a new ground rectangle at the given x position
        GameObject newGround = Instantiate(groundPrefab, new Vector3(0, 0, xPos), Quaternion.identity);
        spawnedGrounds.Enqueue(newGround); // Add to the queue
    }

    void DestroyGround()
    {
        // Destroy the oldest ground rectangle and remove it from the queue
        GameObject oldGround = spawnedGrounds.Dequeue();
        Destroy(oldGround);
    }
}
