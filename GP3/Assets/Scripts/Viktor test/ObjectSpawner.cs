using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawner : MonoBehaviour
{
    [System.Serializable]
    public struct Spawnable
    {
        public string type;
        public float weight;
    }

    [System.Serializable]
    public struct Spawnsettings
    {
        public string type; // this could be like enemies, trees, obstacles ect.
        public float minWait;
        public float maxWait;
        public int maxObjects;
    }
    private float totalWeight;
    private bool spawningObject = false;
    [SerializeField] private float groundSpawnDistance = 20f; 
    public List<Spawnable> enemySpawnables = new List<Spawnable>();
    public List<Spawnsettings> spawnSettings = new List<Spawnsettings>();

    public static ObjectSpawner instance;

    private void Awake() // sets instance to this object
    {
        instance = this;
        totalWeight = 0;
        foreach(Spawnable spawnable in enemySpawnables)
        {
            totalWeight += spawnable.weight;
        }
         
    }

    public void SpawnGround() // spawns ground at set distance
    {
        ObjectPooler.instance.SpawnFromPool("ground", new Vector3(0, 0, groundSpawnDistance), Quaternion.identity);
    }

    private IEnumerator SpawnObject(string type, float time) // spawns object after set time
    {
        yield return new WaitForSeconds(time);
        ObjectPooler.instance.SpawnFromPool(type, new Vector3(Random.Range(-4.4f, 4.4f), 0.5f, -11f), Quaternion.identity);
        spawningObject = false;
        GameController.EnemyCount++;
    }

    void Update()
    {
        if(!spawningObject && GameController.EnemyCount < spawnSettings[0].maxObjects) // if not spawning object and enemy count is less than max objects, spawn object
        {
            spawningObject = true;
            float pick = Random.value * totalWeight;
            int chosenIndex = 0;
            float cumulativeWeight = enemySpawnables[0].weight;

            while(pick > cumulativeWeight && chosenIndex < enemySpawnables.Count - 1) // picks random enemy to spawn
            {
                chosenIndex++;
                cumulativeWeight += enemySpawnables[chosenIndex].weight;
            }

            // spawns enemy
            StartCoroutine(SpawnObject(enemySpawnables[chosenIndex].type, Random.Range(spawnSettings[0].minWait / GameController.DifficultyMultiplier, spawnSettings[0].maxWait / GameController.DifficultyMultiplier)));
        }
    }
}
