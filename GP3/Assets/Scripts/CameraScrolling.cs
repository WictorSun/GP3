using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraScrolling : MonoBehaviour
{
    public Rigidbody cameraBody;

    public float cameraSpeed; [Tooltip("Value in unity units, same as arrow to keep up")]

    void Start()
    {
        cameraBody = GetComponent<Rigidbody>();
    }


    private void FixedUpdate()
    {
        cameraBody.velocity = new Vector3(0, 0, cameraSpeed);
    }
}
