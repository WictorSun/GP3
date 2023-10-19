using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

public class ArrowMovement : MonoBehaviour
{
    public Rigidbody rb;

    PlayerInput playerInput;

    InputAction moveAction;

    [SerializeField] float horizontalSpeed = 10;

    [SerializeField] float tiltSpeed = 5;
    [SerializeField] float spinSpeed = 0;

    private float lateralDirection = 1f; // 1 for right, -1 for left

    void Start()
    {
        rb = GetComponent<Rigidbody>();

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

        float z = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Horizontal");
        Vector3 euler = transform.localEulerAngles;
        euler.z = Mathf.Lerp(euler.z, z, spinSpeed * Time.deltaTime);
        euler.y = Mathf.Lerp(euler.y, y, tiltSpeed);
        transform.localEulerAngles = euler;

        float groundWidth = 10f;  // Replace with the actual width of your ground
        float halfGroundWidth = groundWidth / 2f;

        Vector3 newPosition = transform.position;

        if (Mathf.Abs(newPosition.x) > halfGroundWidth)
        {
            // Reverse the direction
            lateralDirection *= -1;

            // Adjust the position to keep it within the ground
            newPosition.x = Mathf.Clamp(newPosition.x, -halfGroundWidth, halfGroundWidth);

            transform.position = newPosition;
        }



    }
}
