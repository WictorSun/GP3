using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveComponent : MonoBehaviour
{
    [SerializeField] private float speed = 5f; // Speed at which the object will move
    [SerializeField] private float objectDistance = -40f; // Distance at which the object will spawn another object
    [SerializeField] private float despawnDistance = -110f; // Distance at which the object will despawn
    private bool canSpawnGround = true; // Bool to check if ground can spawn

    private HealthComponent health;
    private GameObject player;
    private EnemyController enemy;

    void Start()
    {
        if(GetComponent<HealthComponent>() != null) // If the object has a health component, set health to that component
        {
            health = GetComponent<HealthComponent>();
        }

        player = GameObject.FindGameObjectWithTag("Player"); // Set player to the player object

        if(GetComponent<EnemyController>() != null) // If the object has an enemy controller, set enemy to that component
        {
            enemy = GetComponent<EnemyController>();
        }
    }

    void Update()
    {
        transform.position += -transform.forward * speed * Time.deltaTime;

        if(transform.position.z < player.transform.position.z - 10f && enemy != null) // If the object has an enemy controller and is behind the player, reset health and deactivate
        {
            health.ResetHealth();
            gameObject.SetActive(false);
        }

        if(transform.position.z <= objectDistance && transform.tag == "Ground" && canSpawnGround) // If the object is a ground object and can spawn ground, spawn ground
        {
            ObjectSpawner.instance.SpawnGround();
            canSpawnGround = false;
        }

        if(transform.position.z <= despawnDistance) // If the object is behind the player, deactivate
        {
            canSpawnGround = true;
            gameObject.SetActive(false);
        }
    }
}
