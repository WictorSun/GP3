using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttachEnemies : MonoBehaviour
{
    public GameObject player;
    Transform myTransform;
    private bool attached = false;
    public Rigidbody rb;
    public UIController uic;


    [SerializeField] private MoveComponent moveComponent;

    [SerializeField] private EnemyController enemyController;

    [SerializeField] private HealthComponent healthComponent;

    [SerializeField] private Animator animation;

    [SerializeField] private List<GameObject> Shootpoints;
  
    [SerializeField] private GameObject Cam;
    [SerializeField] private GameObject model;
    [SerializeField] private Transform StartTransform;
    private void Start()
    {
        uic = FindObjectOfType<UIController>();
        Cam = Camera.main.gameObject;
        Shootpoints.Add(Cam);

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
    
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player") // If Player touches enemy.
        {
            if (gameObject.tag == "Enemy") // If regular Enemy, parent it to player.
            {
                // GameObject newParent = other.gameObject;

                //this.transform.SetParent(newParent.transform, true);
                //moveComponent.enabled = false;
                //uic.aE.Add(this);
                StartCoroutine(ShootAway(2f));
            }

            if (gameObject.tag == "ExplodingEnemy")
            {
                
            }

            GameController.IsReturning = true;
            GameController.IncreaseDistance = false;
            GameObject player = MoveComponent.player;
            Transform playerTransform = player.transform;
            SpeedModifier.IncreaseSpeed(1f);
            AudioManager.Instance.SFX("ArrowHit");
            
            //Debug.Log("I am Hit");

            animation.SetBool("Is Walking",false);

            if (playerTransform != null && !SpeedModifier.hasHitEnemy)
            {
                GameController.CanDespawnEnemies = false; // Disable enemy despawn
                playerTransform.gameObject.GetComponent<MonoBehaviour>().StartCoroutine(MovePlayerSmoothly(playerTransform));
                SpeedModifier.hasHitEnemy = true;
            }
        }


    }

    IEnumerator ShootAway(float sec)
    {
        int RandomOption = Random.Range(0, Shootpoints.Count);
        float T = 0; // This is the interpolation factor for the camera

        while (T < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            T += Time.deltaTime / .5f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }
            model.transform.position = Vector3.Slerp(StartTransform.position, Shootpoints[RandomOption].transform.position, T);
            //camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }
        yield return new WaitForSecondsRealtime(sec);
        T = 0; // This is the interpolation factor for the camera

        while (T < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            T += Time.deltaTime / .5f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }
            model.transform.position = Vector3.Slerp(Shootpoints[RandomOption].transform.position, StartTransform.position, T);
            //camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }
    }
    public void RemoveEnemies()
    {
        transform.parent = null;
        
    }

    

}
