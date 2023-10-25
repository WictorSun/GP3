using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreCounter : MonoBehaviour
{
    public static ScoreCounter Instance;

    [Header("Scores")]
    [SerializeField] private float metersTraveled;
    [SerializeField] private int killScore;
    [SerializeField] private float multiplier;
    private float addedScore;
    private float coins;
    private float multipliermeter;
    [SerializeField] private float multiplierComboLimit;
    [SerializeField] private float finalScore;
    [SerializeField] private int finalScoreWithMultiplier;
    [SerializeField] private UIWinning WinningScreen;
    [SerializeField] private GameController GC;
   

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }
    void Start()
    {

    }
    public void GetDistance(float totalDist)
    {
        metersTraveled = totalDist;
    }
    public void AddKill(int killvalue)
    {
        killScore = killScore + killvalue;
    }
   
    public void KillMultiplier(float killMultiplieraddition)
    {
       
        if (multipliermeter < multiplierComboLimit)
        {
            multipliermeter = multipliermeter + killMultiplieraddition;
        }
        else
        {
            multipliermeter = 0f;
            multiplier = multiplier + 1;
            multiplierComboLimit = multiplierComboLimit * 1.1f;
        }
    }
    public void WinningScoreCounter()
    {
        addedScore = metersTraveled + killScore;
        finalScore = addedScore * multiplier;
        coins = finalScore / 100;
        WinningScreen.metersTravelled.text = "" + metersTraveled + "m";
        WinningScreen.kills.text = "" + killScore;
        WinningScreen.combo.text = "" + multiplier + "X";
        WinningScreen.totalScore.text = "" + finalScore;
        WinningScreen.coins.text = "" + coins;

        Debug.Log(finalScore);
    }
  
}
