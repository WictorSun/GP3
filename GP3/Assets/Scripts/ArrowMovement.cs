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

    [SerializeField] float speed = 5;

    [SerializeField] float tiltSpeed = 5;


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
        transform.position += new Vector3(direction.x, 0, 0) * speed * Time.deltaTime;

        float z = Input.GetAxis("Horizontal");
        Vector3 euler = transform.localEulerAngles;
        euler.z = Mathf.Lerp(euler.z, z, tiltSpeed * Time.deltaTime);
        transform.localEulerAngles = euler;

    }
}
