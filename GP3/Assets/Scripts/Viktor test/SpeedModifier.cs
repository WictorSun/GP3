using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class SpeedModifier : MonoBehaviour
{
 
    public static SpeedModifier instance;
    public static float speed;
    public static bool GameHasStarted = false;
    public static bool hasHitEnemy;

    [SerializeField] private static float speedCap;
    public float number;

    private void Awake()
    {
        instance = this;
        speedCap = number;
    }

    private void Start()
    {
        hasHitEnemy = false;
    }
    public static void GameStarted()
    {
        GameHasStarted = true;
    }

    public static void GameEnded()
    {
    
        GameHasStarted = false;
       
    }
    public static void ResetHit()
    {
        hasHitEnemy = false;
    }
    public static void IncreaseSpeed(float increment)
    {

        if(speed<= speedCap)
        {
            speed += increment;
        }
    }
}
