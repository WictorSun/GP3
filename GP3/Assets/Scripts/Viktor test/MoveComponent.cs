using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveComponent : MonoBehaviour
{
    // Serialized fields for Unity Editor
    [SerializeField] private float speed = 5f;
    [Header("Ground spawn settings")]
    [SerializeField] private float objectDistance = 50f; // Q: WHAT THIS DO? A: This is the distance between the player and the object that will spawn
    [SerializeField] private float despawnDistance = -30f;

    // For lateral enemy movement
    private float lateralDirection = 1f;

    // Component references
    private HealthComponent health;
    private GameObject ground;
    public static GameObject player;
    private EnemyController enemy;
    private SpeedModifier speedModifier;


    private void Start()
    {
        // Initialize component references
        health = GetComponent<HealthComponent>();
        player = GameObject.FindGameObjectWithTag("Player");
        enemy = GetComponent<EnemyController>();

        speedModifier = GetComponent<SpeedModifier>();
        
        // Initialize lateral direction for enemies
        if (enemy != null)
        {
            lateralDirection = Random.Range(0, 2) == 0 ? -1f : 1f;
        }
    }


    private void Update()
    {
        // Determine forward movement direction based on game state
        float directionMultiplier;
        if (gameObject.tag == "Enemy" && GameController.IsReturning)
        {
            directionMultiplier = 0.5f; // this gives visual loousion of approaching enemies correctly when returning
        }
        else
        {
            directionMultiplier = GameController.IsReturning ? 1f : -1f;
        }

        Vector3 forwardMovement = transform.forward * (speed + SpeedModifier.speed) * Time.deltaTime * directionMultiplier;
        // Handle movement, despawning, and ground spawning
        MoveObject(forwardMovement);
        HandleDespawn();
        HandleGroundSpawn();
    }

    // Handles the movement of the object (either enemy or ground)
    private void MoveObject(Vector3 forwardMovement)
    {
        // If it's not an enemy, just move forward
        if (enemy == null)
        {
            transform.position += forwardMovement;
            return;
        }

        // Handle lateral enemy movement
        float groundWidth = 10f;
        float halfGroundWidth = groundWidth / 2f;
        Vector3 lateralMovement = Vector3.right * lateralDirection * enemy.moveSpeed * Time.deltaTime;
        Vector3 newPosition = transform.position + forwardMovement + lateralMovement;

        // Keep the enemy within the ground boundaries
        if (Mathf.Abs(newPosition.x) > halfGroundWidth)
        {
            lateralDirection *= -1;
            newPosition.x = Mathf.Clamp(newPosition.x, -halfGroundWidth, halfGroundWidth);
        }

        // Update the position
        transform.position = newPosition;
    }

    // Handles the despawning of enemies
    private void HandleDespawn()
    {
        // Despawn offset based on game direction
        float despawnOffset = GameController.IsReturning ? 22f : -22f; // 24 cause then not see the dissapear when reeled back

        // If it's not an enemy or despawning is disabled, do nothing
        if (enemy == null || !GameController.CanDespawnEnemies) return;

        // Despawn the enemy when it's far enough from the player
        if (Mathf.Abs(transform.position.z - (player.transform.position.z + despawnOffset)) < 1f)
        {
            health.ResetHealth();
            gameObject.SetActive(false);
        }
    }

    // Handles the spawning of new ground tiles
    private void HandleGroundSpawn()
    {
        // Determine the target distance for spawning based on game direction
        float targetDistance = GameController.IsReturning ? -objectDistance * 2 : objectDistance;

        // // Spawn a new ground tile when reaching the target distance
        // if (Mathf.Abs(transform.position.z - targetDistance) < 1f) // this is the distance between the player and the object that will spawn
        // {
        //     ObjectSpawner.instance.MoveGroundBack(gameObject);
        //     Debug.Log("Spawn ground");
        // }

        // Determine the despawn distance based on game direction
        float actualDespawnDistance = GameController.IsReturning ? -despawnDistance * 2 : despawnDistance;

        // Deactivate the ground tile when it reaches the despawn distance
        if (Mathf.Abs(transform.position.z - actualDespawnDistance) < 1f)
        {
            // gameObject.SetActive(false);
            ObjectSpawner.instance.MoveGroundBack(gameObject);
        }
    }
}
