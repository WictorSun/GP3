using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawner : MonoBehaviour
{
    [Header("Enemy spawn in front of player.")]
    [SerializeField] private float enemySpawnInFront = 30f;
    [Header("Enemy spawn behind of player.")]
    [SerializeField] private float enemySpawnBehind = -30f;

    [System.Serializable]
    public struct Spawnable // struct for enemies that can be spawned
    {
        [Tooltip("This is the type of object that will be spawned.")]
        public string type; 
        [Tooltip("This is the weight of the object. The higher the weight, the more likely it is to be spawned.")]
        public float weight; // here we can ex. have small enemy with 0.75 weight, and big enemy with 0.25 weight. So small enemy will be spawned 75% of the time, and big enemy 25% of the time
    }

    [System.Serializable]
    public struct Spawnsettings
    {
        [Tooltip("This is the type of object that will be spawned.")]
        public string type; // this could be like enemies, trees, obstacles ect.
        [Tooltip("This is the maximum time between spawns.")]
        public float minWait; // min and max wait time between spawns
        [Tooltip("This is the minimum time between spawns.")]
        public float maxWait;
        [Tooltip("This is the maximum number of objects of this type that can be spawned.")]
        public int maxObjects; // max objects of this type that can be spawned
    }
    private float totalWeight; 
    private bool spawningObject = false;
    [Header("In front of player where ground will spawn.")]
    [SerializeField] private float groundSpawnDistance = 10f;
    public List<Spawnable> spawnableObjects = new(); // list of spawnable objects that can be spawned
    public List<Spawnsettings> spawnSettings = new(); // list of spawn settings for different objects
    public Transform playerTransform; // reference to player position
    public static ObjectSpawner instance;

    private void Awake() // sets instance to this object
    {
        instance = this;
        totalWeight = 0;
        foreach(Spawnable spawnable in spawnableObjects) // adds up total weight of enemies
        {
            totalWeight += spawnable.weight;
        }
    }


    // this could just be in MoveComponent
    // Ground Isn't pooled any more, 
    public void MoveGroundBack(GameObject ground) // spawns ground at set distance
    {
        if(GameController.IsReturning == false)
        {
            ground.transform.position = ground.transform.position + Vector3.forward * groundSpawnDistance;
        }
        else
        {
            ground.transform.position = ground.transform.position - Vector3.forward * groundSpawnDistance;
        }
    }

    private IEnumerator SpawnObject(string type, float time) // spawns object after set time
    {
        yield return new WaitForSeconds(time);
        
        if (playerTransform == null)
        {
            yield break; // exit the coroutine if playerTransform is null
        }

        Vector3 spawnPosition;

        // if player is returning, spawn enemy behind player
        if(GameController.IsReturning == false)
        {
            spawnPosition = playerTransform.position + new Vector3(Random.Range(-4.4f, 4.4f), 0.5f, enemySpawnInFront);
        }
        else
        {
            spawnPosition = playerTransform.position + new Vector3(Random.Range(-4.4f, 4.4f), 0.5f, enemySpawnBehind);
        }
        
        ObjectPooler.instance.SpawnFromPool(type, spawnPosition, Quaternion.identity);
        spawningObject = false;
        GameController.EnemyCount++;
    }

    void Update()
    {
        if(SpeedModifier.GameHasStarted)
        {
            if(!spawningObject && GameController.EnemyCount < spawnSettings[0].maxObjects) // if not spawning object and enemy count is less than max objects, spawn object
            {
                spawningObject = true;
                float pick = Random.value * totalWeight; // picks random enemy to spawn
                int chosenIndex = 0;
                float cumulativeWeight = spawnableObjects[0].weight; 

                while(pick > cumulativeWeight && chosenIndex < spawnableObjects.Count - 1) // loops through enemies and picks one to spawn
                {
                    chosenIndex++;
                    cumulativeWeight += spawnableObjects[chosenIndex].weight;
                }

                // spawns enemy
                StartCoroutine(SpawnObject(spawnableObjects[chosenIndex].type, Random.Range(spawnSettings[0].minWait / GameController.DifficultyMultiplier, spawnSettings[0].maxWait / GameController.DifficultyMultiplier)));
            }
        }
    }
}