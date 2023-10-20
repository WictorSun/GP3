using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthComponent : MonoBehaviour
{
    public float maxHealth;
    public float currentHealth;

    void Start()
    {
        currentHealth = maxHealth; // Set current health to max health
    }

    void Update()
    {
        // If you Hit Enemy
        if(currentHealth <= 0) // If the object's health is 0 or less, reset health and deactivate
        {
            if(gameObject.tag == "Enemy")
            {
                GameController.EnemyCount--;
                currentHealth = maxHealth;
                gameObject.SetActive(false);

                GameController.IsReturning = true;
                Debug.Log("Hook is getting Reeled!");
            }
        }
    }

    public void UpdateHealth(float amt) // Update the object's health by the amount passed in
    {
        currentHealth += amt;
    }
    public void ResetHealth()
    {
        currentHealth = maxHealth;
    }
}
