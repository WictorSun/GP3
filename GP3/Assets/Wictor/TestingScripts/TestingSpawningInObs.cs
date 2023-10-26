using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestingSpawningInObs : MonoBehaviour
{
    
    [SerializeField] private GameObject[] obstacles;
    [SerializeField] private Transform spawnPoint;
    [SerializeField] private float minWaitTime = 1f;
    [SerializeField] private float maxWaitTime = 4f;
    private GameObject placedObj;

    private void Start()
    {
        float randomWaitTime = Random.Range(minWaitTime, maxWaitTime);
        StartCoroutine(SpawnIn(randomWaitTime));
    }

 
    IEnumerator SpawnIn(float WaitTime)
    {
        int objectNumber = obstacles.Length - 1;
        int randomIndexs = Random.Range(0, objectNumber);
        float randomWaitTime = Random.Range(minWaitTime, maxWaitTime);

        placedObj = Instantiate(obstacles[randomIndexs], spawnPoint.transform.position, Quaternion.identity);

        yield return new WaitForSeconds(WaitTime);
        StartCoroutine(SpawnIn(randomWaitTime));
    }
}
