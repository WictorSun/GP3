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

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            GameObject newParent = other.gameObject;

            this.transform.SetParent(newParent.transform, true);

            GameController.IsReturning = true;
            GameController.IncreaseDistance = false;

            moveComponent.enabled = false;

            animation.SetBool("Is Walking",false);
        }
    }

    void RemoveEnemies()
    {
        transform.parent = null;
        
        Debug.Log("Remove enemies");
    }

}
