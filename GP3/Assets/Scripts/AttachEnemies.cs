using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttachEnemies : MonoBehaviour
{
    public GameObject player;
    Transform myTransform;
    private bool attached = false;
    public Rigidbody rb;


    [SerializeField] private MoveComponent moveComponent;

    [SerializeField] private EnemyController enemyController;

    [SerializeField] private HealthComponent healthComponent;

    [SerializeField] private Animator animation;

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

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            GameObject newParent = other.gameObject;

            this.transform.SetParent(newParent.transform, true);

            GameController.IsReturning = true;
            GameController.IncreaseDistance = false;
            GameObject player = MoveComponent.player;
            Transform playerTransform = player.transform;
            SpeedModifier.IncreaseSpeed(1f);
            AudioManager.Instance.SFX("ArrowHit");


            moveComponent.enabled = false;

            animation.SetBool("Is Walking",false);
            if (playerTransform != null && !SpeedModifier.hasHitEnemy)
            {
                GameController.CanDespawnEnemies = false; // Disable enemy despawn
                playerTransform.gameObject.GetComponent<MonoBehaviour>().StartCoroutine(MovePlayerSmoothly(playerTransform));
                SpeedModifier.hasHitEnemy = true;
            }
        }


    }

    void RemoveEnemies()
    {
        transform.parent = null;
        
        Debug.Log("Remove enemies");
    }

    

}
