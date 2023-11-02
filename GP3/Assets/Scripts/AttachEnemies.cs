using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttachEnemies : MonoBehaviour
{
    public GameObject player;
    Transform myTransform;
    private bool attached = false;

    private void OnCollisionEnter(Collision collision)
    {
        if (gameObject.tag == "Player")
        {
            myTransform.parent = collision.transform;
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
