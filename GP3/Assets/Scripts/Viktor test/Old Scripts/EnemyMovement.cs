using UnityEngine;

public class EnemyMovement : MonoBehaviour
{
    public float speed = 2.0f; // Speed of the enemy
    public float distance = 5.0f; // Distance to move left and right from the starting point

    private Vector3 startPos;

    void Start()
    {
        startPos = transform.position;
    }

    void Update()
    {
        // Oscillate the enemy's position left and right based on a sine wave
        Vector3 newPos = startPos;
        newPos.x += Mathf.Sin(Time.time * speed) * distance;
        transform.position = newPos;
    }
}
