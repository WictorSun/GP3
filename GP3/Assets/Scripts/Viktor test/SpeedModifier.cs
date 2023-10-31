using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpeedModifier : MonoBehaviour
{
    public static SpeedModifier instance;
    public static float speed;
    public static bool GameHasStarted = false;
    public static bool hasHitEnemy;

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
        speed += increment;
    }
}
