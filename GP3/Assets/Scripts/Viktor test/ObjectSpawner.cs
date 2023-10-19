using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectSpawner : MonoBehaviour
{
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
        [Tooltip("This is the minimum and maximum time between spawns.")]
        public float minWait; // min and max wait time between spawns
        public float maxWait;
        [Tooltip("This is the maximum number of objects of this type that can be spawned.")]
        public int maxObjects; // max objects of this type that can be spawned
    }
    private float totalWeight; 
    private bool spawningObject = false;
    [SerializeField] private float groundSpawnDistance = 50f; 
    public List<Spawnable> spawnableObjects = new List<Spawnable>(); // list of spawnable objects that can be spawned
    public List<Spawnsettings> spawnSettings = new List<Spawnsettings>(); // list of spawn settings for different objects

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
