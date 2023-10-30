using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReturnSequence : MonoBehaviour
{
    public Vector3 startPosition;

    // Start is called before the first frame update
    public void Start()
    {
        startPosition = transform.position;
    }

    public void ReturnToStart()
    {
        transform.position = startPosition;
    } 
}
