using System.Collections;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public GameObject enemyPrefab; // Reference to the enemy prefab
    public GameObject movingGround; // Reference to the moving ground object
    public float spawnInterval = 5f; // Time interval between enemy spawns (in seconds)

    private void Start()
    {
        StartCoroutine(SpawnEnemies());
    }

    IEnumerator SpawnEnemies()
    {
        while (true)
        {
            yield return new WaitForSeconds(spawnInterval);

            // Calculate position relative to the moving ground
            Vector3 groundPosition = movingGround.transform.position;
            Vector3 spawnPosition = new Vector3(groundPosition.x, groundPosition.y, groundPosition.z);

            // Optionally, you could add some random offset to the spawn position here

            // Instantiate enemy
            Instantiate(enemyPrefab, spawnPosition, Quaternion.identity);
        }
    }
}
