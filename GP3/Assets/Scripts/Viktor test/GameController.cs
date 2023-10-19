using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GameController : MonoBehaviour
{
    private static float distance = 0;
    private static float difficultyMultiplier = 1; //
    private static float difficultyOffset = 10f; // Difficulty increases by 1% every 10 units
    private static int enemyCount = 0;



    public static float Distance { get => distance; set => distance = value; }
    public static float DifficultyMultiplier { get => difficultyMultiplier; set => difficultyMultiplier = value; }
    public static float DifficultyOffset { get => difficultyOffset; set => difficultyOffset = value; }
    public static int EnemyCount { get => enemyCount; set => enemyCount = value; }

    public static GameController instance;

    void Awake()
    {
        instance = this;
    }

    void Update()
    {
        difficultyMultiplier = 1 + (distance / difficultyOffset); // Difficulty increases by 1% every 100 units
    }
}
