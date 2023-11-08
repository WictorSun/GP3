using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using UnityEngine.Rendering.PostProcessing;

public class UIWinning : MonoBehaviour
{
    [Header("TextFields")]
    [Tooltip("Coins Collected This round")]
    public TextMeshProUGUI coins; //Coins Collected
    [Tooltip("How far you reached this round")]
    public TextMeshProUGUI metersTravelled;
    [Tooltip("KillScore this round")]
    public TextMeshProUGUI kills;
    [Tooltip("Multiplier this round")]
    public TextMeshProUGUI combo;
    [Tooltip("Total Score for this round")]
    public TextMeshProUGUI totalScore;
    [Tooltip("Total coins you have collected")]
    public TextMeshProUGUI totalcoin;

    public GameObject MainMenu;
    public UIMainMenuManager UIM;

    [SerializeField] private ObjectSpawner objectSpawner;
    [Header("GameObjects")]
    [Tooltip("Drag the player prefab")]
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject player2;
    [Tooltip("Drag the Start Transform for player when playing the game")]
    [SerializeField] private GameObject StartMovementPoint;
    [Tooltip("Drag the player prefab")]
    [SerializeField] private float time = 2.0f;
    [Tooltip("Drag the player prefab")]
    [SerializeField] private GameObject camera;
    [Tooltip("Drag the Start Transform for camera when playing the game")]
    [SerializeField] private GameObject CamStartMovementPoint;
    [SerializeField] private GameObject SafeArea;
    [SerializeField] private UIController uic;
    [SerializeField] private Animator winningAnim;
    [SerializeField] private ScoreCounter SC;
    [SerializeField] private Slider comboSlider;
    [SerializeField] private GameObject UpgradeMenu;

    [SerializeField] private Animator Shop;
    public GameObject Startgameb;
    public GameObject panelMM;
    public GameObject mmBG;
    public GameObject thisPanel;
    public float newCoin;
    public TextMeshProUGUI upgradeCoins;
    public Animator ballista;
    

    [SerializeField] private PostProcessVolume pPv;
    private SH_PostProcessPPSSettings pP;

    private void Awake()
    {
        pPv.profile.TryGetSettings<SH_PostProcessPPSSettings>(out pP);
       
    }
    //Event for pressing "RESTART" 
    public void PlayAgain()
    {
        AudioManager.Instance.SFX("UIclick");
        GameController.Distance = PlayerPrefs.GetFloat("DistBost");
        SC.multiplier = PlayerPrefs.GetFloat("Multip");
        StartCoroutine(StartGame(time));
        SC.multipliermeter = 0f;
        GameController.ArrowFront.SetActive(true);
        GameController.ArrowBack.SetActive(false);
        
    }
    public void Upgrade()
    {
        AudioManager.Instance.SFX("UIclick");
        MainMenu.SetActive(true);
        Startgameb.SetActive(false);
        panelMM.SetActive(false);
        mmBG.SetActive(false);
        UpgradeMenu.SetActive(true);
        Shop.SetBool("On", true);
        winningAnim.SetBool("On", false);
        newCoin = PlayerPrefs.GetFloat("TotalCoins");
        upgradeCoins.text = "" + newCoin;
        UIM.totalCoins = PlayerPrefs.GetFloat("TotalCoins");
    }
    public void ExitButtonShop()
    {
        AudioManager.Instance.SFX("UIclick");
        if (MainMenu.active == true)
        {
            StartCoroutine(closeShop(.5f));
        }
        
       
        //AudioManager.Instance.SFX("ButtonClick");
    }
    //Co routine for starting a new round
    IEnumerator closeShop(float sec)
    {
        Shop.SetBool("On", false);
       winningAnim.SetBool("On", true);
        yield return new WaitForSecondsRealtime(sec);
        
        
        UpgradeMenu.SetActive(false);
        Startgameb.SetActive(true);
        panelMM.SetActive(true);
        mmBG.SetActive(true);
        MainMenu.SetActive(false);
        Debug.Log("fffffffffff");
    }
    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;
        GameObject[] enemies;
        GameObject[] eEnemies;
        winningAnim.SetBool("On", false);
        enemies = GameObject.FindGameObjectsWithTag("Enemy");
        eEnemies = GameObject.FindGameObjectsWithTag("ExplodingEnemy");
        foreach (GameObject enem in enemies)
        {
            enem.SetActive(false);
        }
        foreach (GameObject enem in eEnemies)
        {
            enem.SetActive(false);
        }
        ballista.SetBool("Is Walking", false);
        float T = 0; //LerpTime
        while (T < 1) //This lerps the Player from idle position in the beggining of game to the position for when playing
        {
            T += Time.deltaTime / .5f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }

            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            player2.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }


        yield return new WaitForSecondsRealtime(time);        
        SafeArea.SetActive(false);
        SpeedModifier.GameStarted();
        
        GameController.IncreaseDistance = true;
        GameController.IsReturning = false;
        Vector3 cameraStartPosition = camera.transform.position;

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1) //This lerps the Camera from idle position in the beggining of game to the position for when playing
        {
            cameraT += Time.deltaTime / .5f; // This is the speed for the player

            if (cameraT > 1)
            {
                cameraT = 1;
            }

            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }

        yield return new WaitForSeconds(0.0001f);
        float f = 0; // This is the interpolation factor for the camera

        while (f < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            f += Time.deltaTime / 1f; // This is the speed for the player

            if (f > 1)
            {
                f = 1;
            }

            pP._Fraction.value = Mathf.Lerp(pP._Fraction.value, pP._Fraction.value = .25f, f);
            pP._Brightness.value = Mathf.Lerp(pP._Brightness.value, pP._Brightness.value = 1.25f, f);
            pP._Desaturate_Edge.value = Mathf.Lerp(pP._Desaturate_Edge.value, pP._Desaturate_Edge.value = 0.5f, f);
            yield return null;
        }
        uic.takeDist = true;
        uic.endGame = true;
        uic.startPostProcess = true;
        SpeedModifier.speed = 1f;
        objectSpawner.canSpawnEnemy = true;
        comboSlider.value = 0f;
        ballista.SetBool("Is Walking", false);
        this.gameObject.SetActive(false); // sets the Winning Screen to disabled in order to play again
    }
}
