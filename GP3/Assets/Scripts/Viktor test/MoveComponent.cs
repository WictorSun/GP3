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
        Vector3 forwardMovement = -transform.forward * speed * Time.deltaTime; // Move the object forward
        Vector3 lateralMovement = Vector3.zero; //Latteral is "Left and right"

        if(enemy != null)
        {
            // Add lateral movement based on the moveSpeed in EnemyController
            lateralMovement = Vector3.right * Mathf.Sin(Time.time * enemy.moveSpeed) * enemy.moveSpeed;

            // Combine forward and lateral movements
            //transform.position += forwardMovement + lateralMovement;

            // Calculate new position
            Vector3 newPosition = transform.position + forwardMovement + lateralMovement;

            float groundWidth = 10f;
            float halfGroundWidth = groundWidth / 2f;

            // Check if the new position is outside the ground
            if (Mathf.Abs(newPosition.x) > halfGroundWidth)
            {
                // Adjust the position to keep it within the ground
                newPosition.x = Mathf.Clamp(newPosition.x, -halfGroundWidth, halfGroundWidth);
            }

            // Update the position
            transform.position = newPosition;
        }
        
        else // if not enemy move as ground does
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
