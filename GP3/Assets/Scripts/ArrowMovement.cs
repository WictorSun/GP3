using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

public class ArrowMovement : MonoBehaviour
{
    //public Rigidbody rb;

    PlayerInput playerInput;

    InputAction moveAction;

    [SerializeField] float horizontalSpeed = 10;
    [SerializeField] float tiltSpeed = 5;
    [SerializeField] float spinSpeed = 0;

    void Start()
    {
        //rb = GetComponent<Rigidbody>();

        playerInput = GetComponent<PlayerInput>();
        moveAction = playerInput.actions.FindAction("Move");
    }

    private void Update()
    {
        MoveArrow();
    }

    void MoveArrow() // Handles the movement through input actions.
    {
        Vector2 direction = moveAction.ReadValue<Vector2>();
        transform.position += new Vector3(direction.x, 0, 0) * horizontalSpeed * Time.deltaTime;

        // Log debug information when "a" or "d" is pressed.
        if (direction.x < 0)
        {
            //Debug.Log("Pressed 'a' key. Moving left.");
        }
        else if (direction.x > 0)
        {
            //Debug.Log("Pressed 'd' key. Moving right.");
        }

        float z = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Horizontal");
        Vector3 euler = transform.localEulerAngles;
        euler.z = Mathf.Lerp(euler.z, z, spinSpeed * Time.deltaTime);
        euler.y = Mathf.Lerp(euler.y, y, tiltSpeed);
        transform.localEulerAngles = euler;
    }
}
