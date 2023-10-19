using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestingSpawningInObs : MonoBehaviour
{
    [SerializeField] private float timeLeft;
    private float currentTime;
    [SerializeField] private GameObject[] obstacles;
    [SerializeField] private Transform spawnPoint;
    private float minWaitTime = 1f;
    private float maxWaitTime = 4f;
    private GameObject placedObj;

    private void Start()
    {
        float randomWaitTime = Random.Range(minWaitTime, maxWaitTime);
        StartCoroutine(SpawnIn(randomWaitTime));
    }

    private void SpawnInObstacles()
    {

        if(timeLeft <= currentTime)
        {

        }

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
