using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ScoreCounter : MonoBehaviour
{
    public static ScoreCounter Instance;

    [Header("Scores")]
    [Tooltip("Dont do anything here its only for debugging purposes")]
    [SerializeField] private float metersTraveled;
    [Tooltip("Dont do anything here its only for debugging purposes")]
    [SerializeField] private int killScore;
    [Tooltip("Dont do anything here its only for debugging purposes")]
    [SerializeField] public float multiplier = 1;
    [SerializeField] private TextMeshProUGUI ComboNumber;

    private float addedScore;
    private float coins;
    public float multipliermeter;
    [SerializeField]public UIMainMenuManager uim;

    [Tooltip("Dont do anything here its only for debugging purposes")]
    [SerializeField] private float multiplierComboLimit;
    [Tooltip("Dont do anything here its only for debugging purposes")]
    [SerializeField] private float finalScore;
    [Tooltip("Dont do anything here its only for debugging purposes")]
    [SerializeField] private int finalScoreWithMultiplier;
    [Tooltip("Drag in the WinningScreen Canvas")]
    [SerializeField] private UIWinning WinningScreen;
    [Tooltip("Drag in the GameController in the Scene")]
    [SerializeField] private GameController GC;

    [SerializeField] private Slider ComboSlider;
    [SerializeField] private GameObject ComboGO;

    [Header("Combo Stuff")]
    [Tooltip("Change howe much faster the combo//multiplier multiplies, its here for designers to mess around with")]
    public float comboIncrease = 1.2f;
    float totalCoins;

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
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        ComboNumber.text = "" + multiplier + "X";
    }
    void Start()
    {

    }
    //GET THE DISTANCE REACHED
    public void GetDistance(float totalDist)
    {
        metersTraveled = Mathf.FloorToInt(totalDist);
    }
    //ADDS TO THE KILLCOUNTER WHEN CALLED UPON
    public void AddKill(int killvalue)
    {
        killScore = killScore + killvalue;
    }
   
    //CALUCULATES THE MULTIPLIER THAT GETS ADDED IN THE END
    public void KillMultiplier(float killMultiplieraddition)
    {
        
        if (multipliermeter < multiplierComboLimit)
        {
            multipliermeter = multipliermeter + killMultiplieraddition;
            Debug.Log(multipliermeter);
            StartCoroutine(LerpCombo());
           
            //ComboSlider.value =  multipliermeter / 1f;
        }
        else
        {
            multipliermeter = 0f;
            multiplier = multiplier + 1;
            ComboNumber.text = "" + multiplier + "X";
            multiplierComboLimit = multiplierComboLimit * comboIncrease;
        }
    }
    //CALCULATES THE WHOLE SCORE IN THE END
    public void WinningScoreCounter()
    {
        addedScore = metersTraveled + killScore;
        finalScore = addedScore * multiplier;
        coins = Mathf.FloorToInt(finalScore) / 10;
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
        WinningScreen.totalcoin.text = "" + totalCoins;
        if(finalScore > uim.higscore)
        {
            uim.higscore = finalScore;
            PlayerPrefs.SetFloat("HighScore", finalScore);
        }
        //Debug.Log(finalScore);
    }
  IEnumerator LerpCombo()
    {
        float T = 0;
        while (T < 1f)
        {
            T += Time.deltaTime / .5f;

            if (T > 1f)
            {
                T = 1f;
            }
            ComboSlider.value = Mathf.Lerp(ComboSlider.value, multipliermeter / 1f, T);
            yield return null;
        }
       
    }
}
