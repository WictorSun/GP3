using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyController : MonoBehaviour
{
    private Transform player;
    [Header("Movement To the left and Right")]
    [SerializeField] public float moveSpeed = 2f;
    [SerializeField] private float killAddition = 0.2f;
    [SerializeField] private ParticleSystem Explode;
    [SerializeField] private string HitSound;

    private HealthComponent health; // prob will remove Health and just if collision with player, enemy dead

    //public bool targetingPlayer = false;
    void Start()
    {
        health = GetComponent<HealthComponent>();
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            AudioManager.Instance.SFX(HitSound);
            Instantiate(Explode, transform.position, Quaternion.identity);
            //health.UpdateHealth(-1); // enemy takes 1 damage
            ScoreCounter.Instance.KillMultiplier(0.1f);
            ScoreCounter.Instance.AddKill(1);
            if (!GameController.IsReturning)
            {
                GameController.AddArrow2();
            }
            
        }
    }
}
