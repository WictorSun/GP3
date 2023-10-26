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
    [SerializeField] float totalCoins;
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
        //PlayerPrefs.SetFloat("TotalCoins", 0);
    }
    void Start()
    {

    }
    public void GetDistance(float totalDist)
    {
        metersTraveled = Mathf.FloorToInt(totalDist);
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
        //SaveManager.Instance.GetFloat("COINS I HAVE");
        coins = Mathf.FloorToInt(finalScore) / 100;
        if (coins <= 5)
        {
            coins = 5;
        }
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        totalCoins = Mathf.FloorToInt(totalCoins + coins);
        PlayerPrefs.SetFloat("TotalCoins", totalCoins);
        
        
        WinningScreen.metersTravelled.text = "" + metersTraveled + "m";
        WinningScreen.kills.text = "" + killScore;
        WinningScreen.combo.text = "" + multiplier + "X";
        WinningScreen.totalScore.text = "" + finalScore;
        WinningScreen.coins.text = "" + coins;
        WinningScreen.totalCoinsDisp.text = "" + totalCoins;

        Debug.Log(finalScore);
    }
  
}
