using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class ArrowMovement : MonoBehaviour
{
    public Rigidbody rb;

    public float rotateAngle; [Tooltip("Value in degrees to rotate, negative for left, positive for right")]

    //public float arrowSpeed; [Tooltip("Value in unity units")]

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        //rb.velocity = new Vector3(0, 0, arrowSpeed);
    }

    public void rotateLeft()
    {
        transform.Rotate(0, 0, rotateAngle, Space.Self);
    }

    public void rotateRight()
    {
        transform.Rotate(0, 0, rotateAngle, Space.Self);
    }




}
