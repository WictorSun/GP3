using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Cinemachine;

[System.Serializable]
public class GameController : MonoBehaviour
{
    private static float distance = 0;
    public static bool IncreaseDistance = true;
    public static bool CanDespawnEnemies = true; // disable enemy despawn during lerp whe
    private static float difficultyMultiplier = 1;
    private static float difficultyOffset = 100f; // Difficulty increases by 1% every 100 units
    private static int enemyCount = 0;
    public static bool IsReturning = false; // If player is returning
    public static bool getDist = false;
    public static float Distance { get => distance; set => distance = value; }
    public static float DifficultyMultiplier { get => difficultyMultiplier; set => difficultyMultiplier = value; }
    public static float DifficultyOffset { get => difficultyOffset; set => difficultyOffset = value; }
    public static int EnemyCount { get => enemyCount; set => enemyCount = value; }

    public static GameController instance;
    [SerializeField] private static GameObject Arrow2;
    [SerializeField] private static GameObject player;

    [SerializeField] public static GameObject ArrowFront;
    [SerializeField] public static GameObject ArrowBack;
    public GameObject fakeArrow;
    public GameObject fakePlayer;

    public GameObject FakePlayer1;

    public GameObject ArrowBack1;
   

    public BoxCollider FakeCol;
    [SerializeField] public static BoxCollider col;


    void Awake()
    {
        instance = this;
        Arrow2 = fakeArrow;
        player = fakePlayer;
        ArrowFront = FakePlayer1;
        ArrowBack = ArrowBack1;
        col = FakeCol;
       
    }

    void Update()
    {
        difficultyMultiplier = 1 + (distance / difficultyOffset); // Difficulty increases by 1% every 100 units
        if (IsReturning && !getDist)
        {
            GetDistance();
        }
    }
    public static void AddArrow2()
    {
        ArrowFront.SetActive(false);
        col.size = new Vector3(2,2,4);
        ArrowBack.SetActive(true);
       
        float arrow2 = PlayerPrefs.GetFloat("Arrow2");
        if(arrow2 == 1f)
        {
            Arrow2.SetActive(true);
            Arrow2.transform.position = player.transform.position;
        }
    }
    public void GetDistance()
    {

            ScoreCounter.Instance.GetDistance(Distance);
            getDist = true;

    }
}
