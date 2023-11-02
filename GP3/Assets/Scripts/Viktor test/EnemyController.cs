using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyController : MonoBehaviour
{
    private Transform player;
    [Header("Movement To the left and Right")]
    [SerializeField] public float moveSpeed = 2f;
    [SerializeField] private float killAddition = 0.2f;

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
            //health.UpdateHealth(-1); // enemy takes 1 damage
            ScoreCounter.Instance.KillMultiplier(0.02f);
            ScoreCounter.Instance.AddKill(1);
        }
    }
}
