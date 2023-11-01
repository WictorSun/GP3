using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
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

    private float lateralDirection = 1f; // 1 for right, -1 for left

    void Start()
    {
        //rb = GetComponent<Rigidbody>();

        playerInput = GetComponent<PlayerInput>();
        moveAction = playerInput.actions.FindAction("Move");
    }

    private void Update()
    {
        MoveArrow();

        TiltArrow();

        if (leftButtonPressed && leftButtonStillDown)
        {
            transform.position += new Vector3(-1 * horizontalSpeed, 0, 0) * Time.deltaTime;
        }

        if (rightButtonPressed && rightButtonStillDown)
        {
            transform.position += new Vector3(1 * horizontalSpeed, 0, 0) * Time.deltaTime;
        }
    }

    void TiltArrow()
    {
        float z = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Horizontal");
        Vector3 euler = transform.localEulerAngles;
        euler.z = Mathf.Lerp(euler.z, z, spinSpeed * Time.deltaTime);
        euler.y = Mathf.Lerp(euler.y, y, tiltSpeed);
        transform.localEulerAngles = euler;
    }

    void MoveArrow() // Handles the movement through input actions.
    {

        float groundWidth = 10f;  // Replace with the actual width of your ground
        float halfGroundWidth = groundWidth / 2f;

        Vector3 newPosition = transform.position;

        if (!leftButtonPressed && !rightButtonPressed) //Checks to see if touch inputs are being pressed to not double movement.
        {
            Vector2 direction = moveAction.ReadValue<Vector2>();
            transform.position += new Vector3(direction.x, 0, 0) * horizontalSpeed * Time.deltaTime;
        }

        if (Mathf.Abs(newPosition.x) > halfGroundWidth) // Keeps arrow within ground limit.
        {
            // Reverse the direction
            lateralDirection *= -1;

            // Adjust the position to keep it within the ground
            newPosition.x = Mathf.Clamp(newPosition.x, -halfGroundWidth, halfGroundWidth);

            transform.position = newPosition;
        }
    }

    static bool leftButtonPressed;
    static bool rightButtonPressed;

    static bool leftButtonStillDown;
    static bool rightButtonStillDown;

    public void LeftTouchMovement() // Call when pressing left side of screen.
    {
        leftButtonStillDown = true;
        leftButtonPressed = true;
    }

    public void RightTouchMovement() // Call when pressing right side of screen.
    {
        rightButtonStillDown = true;
        rightButtonPressed = true;
    }

    public void LeftPointerUp() // Lift left finger & check if still holding down right finger.
    {
        leftButtonStillDown = false;
        leftButtonPressed = false;

        if (rightButtonStillDown)
        {
            rightButtonPressed = true;
            rightButtonStillDown = true;
        }
    }

    public void RightPointerUp() // Lift right finger & check if still holding down left finger.
    {
        rightButtonStillDown = false;
        rightButtonPressed = false;

        if (leftButtonStillDown)
        {
            leftButtonPressed = true;
            leftButtonStillDown = true;
        }
    }
}
