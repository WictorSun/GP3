using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveComponent : MonoBehaviour
{
    [SerializeField] private float speed = 5f; // Speed at which the object will move
    [SerializeField] private float objectDistance = -40f; // Distance at which the object will spawn another object
    [SerializeField] private float despawnDistance = -110f; // Distance at which the object will despawn
    private bool canSpawnGround = true; // Bool to check if ground can spawn

    private float lateralDirection = 1f; // 1 for right, -1 for left

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
        if (GetComponent<EnemyController>() != null)
        {
            enemy = GetComponent<EnemyController>();
            
            // Randomly set initial lateral direction
            lateralDirection = Random.Range(0, 2) == 0 ? -1f : 1f;
        }
    }

    void Update()
    {
    Vector3 forwardMovement = -transform.forward * speed * Time.deltaTime;
    Vector3 lateralMovement = Vector3.zero;

    float groundWidth = 10f;  // Replace with the actual width of your ground
    float halfGroundWidth = groundWidth / 2f;

    if (enemy != null)
    {
        // Linear lateral movement
        lateralMovement = Vector3.right * lateralDirection * enemy.moveSpeed * Time.deltaTime;

        // Calculate new position
        Vector3 newPosition = transform.position + forwardMovement + lateralMovement;

        // Check if the new position is outside the ground
        if (Mathf.Abs(newPosition.x) > halfGroundWidth)
        {
            // Reverse the direction
            lateralDirection *= -1;

            // Adjust the position to keep it within the ground
            newPosition.x = Mathf.Clamp(newPosition.x, -halfGroundWidth, halfGroundWidth);
        }

        // Update the position
        transform.position = newPosition;
    }
    else // if not an enemy, move as the ground does
    {
        transform.position += forwardMovement;
    }




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
