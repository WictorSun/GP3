using System.Collections;
using UnityEngine;

public class HealthComponent : MonoBehaviour
{
    public float maxHealth;
    public float currentHealth;
    private static bool hasMovedBackward = false;

    void Start()
    {
        currentHealth = maxHealth; // Set current health to max health
    }
    private IEnumerator MovePlayerSmoothly(Transform playerTransform)
    {
        float distanceToMove = 20.0f; // Distance to move the player
        float duration = 1.0f; // Duration of the movement in seconds
        float elapsedTime = 0.0f; // Time elapsed since the movement started

        Vector3 originalPosition = playerTransform.position;
        Vector3 targetPosition = originalPosition + (playerTransform.forward * distanceToMove);

        while (elapsedTime < duration)
        {
            float t = elapsedTime / duration;
            playerTransform.position = Vector3.Lerp(originalPosition, targetPosition, t);
            elapsedTime += Time.deltaTime;
            yield return null; // Wait for the next frame
        }

        // Ensure the player reaches the target position
        playerTransform.position = targetPosition;

        GameController.CanDespawnEnemies = true; // Re-enable enemy despawn, Why i do this is cause enemies in front of player got disabled during the lerp
    }

    void Update()
    {
        // If you Hit Enemy
        if(currentHealth <= 0) // If the object's health is 0 or less, reset health and deactivate
        {
            if(gameObject.tag == "Enemy")
            {
                GameController.EnemyCount--;
                currentHealth = maxHealth;
                gameObject.SetActive(false);

                GameController.IsReturning = true; // player start returning

                GameController.IncreaseDistance = false; // Decrease distance

                GameObject player = MoveComponent.player;
                Transform playerTransform = player.transform;

                AudioManager.Instance.SFX("HitEnemy");

                // Move the player 20 units forward
                if (playerTransform != null && !hasMovedBackward)
                {
                    GameController.CanDespawnEnemies = false; // Disable enemy despawn
                    playerTransform.gameObject.GetComponent<MonoBehaviour>().StartCoroutine(MovePlayerSmoothly(playerTransform));
                    hasMovedBackward = true;
                }
            }
        }
    }

    public void UpdateHealth(float amt) // Update the object's health by the amount passed in
    {
        currentHealth += amt;
    }
    public void ResetHealth()
    {
        currentHealth = maxHealth;
    }
}
