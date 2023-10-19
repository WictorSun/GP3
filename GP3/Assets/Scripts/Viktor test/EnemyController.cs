using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyController : MonoBehaviour
{
    private Transform player;
    [SerializeField] public float moveSpeed = 2f;

    private HealthComponent health; // prob will remove Health and just if collision with player, enemy dead

    //public bool targetingPlayer = false;
    void Start()
    {
        health = GetComponent<HealthComponent>();
    }

    void OnTriggerStay(Collider other) // if enemy collides with player, enemy takes damage
    {
        if (other.tag == "Player")
        {
            health.UpdateHealth(-1); // enemy takes 1 damage
        }
    }
}
