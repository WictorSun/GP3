using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BiomeChange : MonoBehaviour
{
    public GameObject forest;
    public GameObject desert;
    public GameObject forestToDesert;
    public GameObject player;

   
    private bool past500;
    private bool Switch;
    [SerializeField] private MoveComponent moveComponent;

    void Start()
    {
        // Find child GameObjects by their name
        //forest = transform.Find("forest").gameObject;
        //desert = transform.Find("desert").gameObject;
        //forestToDesert = transform.Find("forestToDesert").gameObject;
    }

    void Update()
    {
        // Update past500 based on GameController.Distance
        float distance = GameController.Distance; // Assuming GameController.Distance returns a float
        past500 = (distance >= 500);
        Switch = ((distance >= 500) && (distance <= 510));
        if (GameController.IsReturning)
        {
            Switch = ((distance >= 500) && (distance <= 510));
        }
        Debug.Log($"Current Distance: {distance}, Past 500: {past500}");

        // Check if this tile is near the despawn distance
        float tileDistanceFromDespawn = transform.position.z - player.transform.position.z;//Mathf.Abs(transform.position.z - moveComponent.despawnDistance);
        if (tileDistanceFromDespawn <= -30f)
        {
            if (Switch)
            {
                EnableSwitch();
            }
            else if (past500)
            {
                EnableDesert();
            }
            else
            {
                EnableForest();
            }
        }
    }

    private void EnableDesert()
    {

        // Enable desert and disable other biomes
        desert.SetActive(true);
        forest.SetActive(false);
        forestToDesert.SetActive(false);
    }

    private void EnableForest()
    {
        Debug.Log("Forest Enabled");
        // Enable forest and disable other biomes
        forest.SetActive(true);
        desert.SetActive(false);
        forestToDesert.SetActive(false);
    }

    private void EnableSwitch()
    {
        forest.SetActive(false);
        desert.SetActive(false);
        forestToDesert.SetActive(true);
    }
}