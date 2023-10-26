using System.Collections.Generic;
using UnityEngine;

public class ObjectPooler : MonoBehaviour
{
    [System.Serializable] // allows for editing in inspector
    public class Pool
    {
        public string type;
        public GameObject prefab;
        [Tooltip("Number of pre instanciated objects in pool.")]
        public int size;
    }

    public static ObjectPooler instance;

    private void Awake() // sets instance to this object
    {
        instance = this;
    }

    public List<Pool> pools; // list of pools

    public Dictionary<string, Queue<GameObject>> poolDictionary;
    GameObject objectToSpawn;

    void Start() // creates pools
    {
        poolDictionary = new Dictionary<string, Queue<GameObject>>();

        foreach(Pool pool in pools)
        {
            Queue<GameObject> objectPool = new Queue<GameObject>();

            for(int i = 0; i < pool.size; i++)
            {
                GameObject obj = Instantiate(pool.prefab);
                obj.SetActive(false);
                objectPool.Enqueue(obj);
            }

            poolDictionary.Add(pool.type, objectPool);
        }
    }

    public GameObject SpawnFromPool(string type, Vector3 position, Quaternion rotation) // spawns object from pool
    {
        if(!poolDictionary.ContainsKey(type)) // if pool does not exist, return null
        {
            Debug.LogWarning("Pool with tag " + type + " doesn't exist.");
            return null;
        }

        objectToSpawn = poolDictionary[type].Dequeue(); // sets object to spawn to the first object in the pool

        objectToSpawn.SetActive(true);
        objectToSpawn.transform.position = position; // sets position and rotation of object to spawn
        objectToSpawn.transform.rotation = rotation;

        poolDictionary[type].Enqueue(objectToSpawn); // adds object back to pool

        return objectToSpawn;
    }
}
