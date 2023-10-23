using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveComponent : MonoBehaviour
{
    [SerializeField] private float speed = 5f; // Speed at which the object will move
    [SerializeField] private float objectDistance = 50f; // Distance at which the object will spawn another object
    [SerializeField] private float despawnDistance = -30f; // Distance at which the object will despawn
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
        Vector3 forwardMovement = Vector3.zero;  // Declare forwardMovement here

        if (GameController.IsReturning == false)
        {
            forwardMovement = -transform.forward * speed * Time.deltaTime;  // Ground moves as walking forward
        }
        else if (GameController.IsReturning == true)
        {
            forwardMovement = transform.forward * speed * Time.deltaTime;  // Ground moves as walking bakwards
        }

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

        // Despawn object
        if(GameController.IsReturning == false && transform.position.z < player.transform.position.z - 10f && enemy != null)
        {
            health.ResetHealth();
            gameObject.SetActive(false);
        }
        else if(GameController.IsReturning == true && transform.position.z > player.transform.position.z + 10f && enemy != null)
        {
            health.ResetHealth();
            gameObject.SetActive(false);
        }

        // Spawn ground
        if(GameController.IsReturning == false && transform.position.z <= objectDistance && transform.tag == "Ground" && canSpawnGround)
        {
            ObjectSpawner.instance.SpawnGround();
            canSpawnGround = false;
        }
        else if(GameController.IsReturning == true && transform.position.z >= -objectDistance && transform.tag == "Ground" && canSpawnGround) // if object is past object distance, spawn another object
        {
            ObjectSpawner.instance.SpawnGround();
            canSpawnGround = false;
        }

        // Despawn ground
        if(GameController.IsReturning == false && transform.position.z <= despawnDistance) // if object is past despawn distance, deactivate
        {
            canSpawnGround = true;
            gameObject.SetActive(false);
        }
        else if(GameController.IsReturning == true && transform.position.z >= -despawnDistance)
        {
            canSpawnGround = true;
            gameObject.SetActive(false);
        }
    }
}
