using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttachEnemies : MonoBehaviour
{
    public GameObject player;
    Transform myTransform;
    private bool attached = false;

    [SerializeField] private MoveComponent moveComponent;

    [SerializeField] private EnemyController enemyController;

    [SerializeField] private HealthComponent healthComponent;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            GameObject newParent = other.gameObject;

            this.transform.SetParent(newParent.transform, true);

            moveComponent.enabled = false;
            enemyController.enabled = false;
            healthComponent.enabled = false;


            //myTransform.parent = collision.transform;
            Debug.Log("I attached");
        }
    }


    private void Update()
    {
        if(attached == true)
        {

        }
    }

    void RemoveEnemies()
    {
        transform.parent = null;
        
        Debug.Log("Remove enemies");
    }

}
