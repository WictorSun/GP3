using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveComponent : MonoBehaviour
{
    // Serialized fields for Unity Editor
    [SerializeField] private float speed = 5f;
    [SerializeField] private float objectDistance = 50f;
    [SerializeField] private float despawnDistance = -30f;
    private bool canSpawnGround = true;

    // For lateral enemy movement
    private float lateralDirection = 1f;

    // Component references
    private HealthComponent health;
    public static GameObject player;
    private EnemyController enemy;

    private void Start()
    {
        // Initialize component references
        health = GetComponent<HealthComponent>();
        player = GameObject.FindGameObjectWithTag("Player");
        enemy = GetComponent<EnemyController>();

        // Initialize lateral direction for enemies
        if (enemy != null)
        {
            lateralDirection = Random.Range(0, 2) == 0 ? -1f : 1f;
        }
    }

    private void Update()
    {
        // Determine forward movement direction based on game state
        float directionMultiplier = GameController.IsReturning ? 1f : -1f;
        Vector3 forwardMovement = transform.forward * speed * Time.deltaTime * directionMultiplier;

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
        float despawnOffset = GameController.IsReturning ? 10f : -10f;

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
        // Do nothing if it's not a ground tile or if spawning is disabled
        if (transform.tag != "Ground" || !canSpawnGround) return;

        // Determine the target distance for spawning based on game direction
        float targetDistance = GameController.IsReturning ? -objectDistance : objectDistance;

        // Spawn a new ground tile when reaching the target distance
        if (Mathf.Abs(transform.position.z - targetDistance) < 1f)
        {
            ObjectSpawner.instance.SpawnGround();
            canSpawnGround = false;
        }

        // Determine the despawn distance based on game direction
        float actualDespawnDistance = GameController.IsReturning ? -despawnDistance : despawnDistance;

        // Deactivate the ground tile when it reaches the despawn distance
        if (Mathf.Abs(transform.position.z - actualDespawnDistance) < 1f)
        {
            canSpawnGround = true;
            gameObject.SetActive(false);
            Debug.Log("Deactivating object: " + gameObject.name);
        }
    }
}
