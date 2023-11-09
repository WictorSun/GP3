using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.Rendering.PostProcessing;




public class UIMainMenuManager : MonoBehaviour
{
    [Header("GameObjects")]
    [Tooltip("Camera cinemachine ref.")]
    [SerializeField] private GameObject camera;
    [Tooltip("Player idle pos. ref.")]
    [SerializeField] private GameObject Ballista;
    [Tooltip("Player Game pos. ref.")]
    [SerializeField] private GameObject StartMovementPoint; // where game Beins
    [Tooltip("Camera idle pos. ref.")]
    [SerializeField] private GameObject CamBallista;
    [Tooltip("Camera Game pos. ref.")]
    [SerializeField] private GameObject CamStartMovementPoint; // where game Beins
    [Tooltip("Player ref.")]
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject player2;
    [SerializeField] private GameObject Rope;
    [SerializeField] private ObjectSpawner objectSpawner;
    public GameObject winning;

    [Header("UI Elements")]
    [SerializeField] private Slider sfxSlider;
    [SerializeField] private Slider musicSlider;
    [Tooltip("Main menu Ref.")]
    [SerializeField] private GameObject startMenu;
    [Tooltip("Settings menu Ref.")]
    [SerializeField] private GameObject settingsMenu;
    [Tooltip("Shop menu Ref.")]
    [SerializeField] private GameObject UpgradeMenu;
    [Tooltip("Pause menu Ref.")]
    [SerializeField] private GameObject inGameMenu;
    [SerializeField] private UIWinning uiWinning;
    [SerializeField] private UIController uic;
    [SerializeField] private GameObject tutorial;
    [SerializeField] private GameObject tutText1;
    [SerializeField] private GameObject tutText2;
    [SerializeField] private GameObject tutText3;


    [Header("totalcoin and Highscore")]
    [SerializeField] public float totalCoins;
    [SerializeField] public float higscore;
    [SerializeField] private TextMeshProUGUI HSText;
    [SerializeField] private TextMeshProUGUI totCoinUpgrade;
    [SerializeField] private TextMeshProUGUI totCoinMain;

    [Header("Upgrade1")]
    [SerializeField] private float upgrade1Tier;
    [SerializeField] private ScoreCounter SC;
    [SerializeField] private float comboIncrease1;
    [SerializeField] private float comboIncrease2;
    [SerializeField] private float comboIncrease3;
    [SerializeField] private float priceUpgrade1;
    [SerializeField] private float priceUpgrade2;
    [SerializeField] private float priceUpgrade3;
    [SerializeField] private GameObject gemUpgrade1One;
    [SerializeField] private GameObject gemUpgrade1Two;
    [SerializeField] private GameObject gemUpgrade1Three;
    [SerializeField] private GameObject MaxUpgrade1;
    [SerializeField] private GameObject priceButton;
    [SerializeField] private TextMeshProUGUI levelUpgrade1;
    [SerializeField] private TextMeshProUGUI upgradeDescription1;
    [SerializeField] private TextMeshProUGUI priceTextFieldUpgrade1;
    [SerializeField] private string itemDescription1;
    [SerializeField] private string itemDescription2;
    [SerializeField] private string itemDescription3;

    [Header("Upgrade2")]
    [SerializeField] private float upgrade2Tier;
    [SerializeField] private float DistanceIncrease1;
    [SerializeField] private float DistanceIncrease2;
    [SerializeField] private float DistanceIncrease3;
    [SerializeField] private float priceUpgrade2_1;
    [SerializeField] private float priceUpgrade2_2;
    [SerializeField] private float priceUpgrade2_3;
    [SerializeField] private GameObject gemUpgrade2One;
    [SerializeField] private GameObject gemUpgrade2Two;
    [SerializeField] private GameObject gemUpgrade2Three;
    [SerializeField] private GameObject MaxUpgrade2;
    [SerializeField] private GameObject priceButton2;
    [SerializeField] private TextMeshProUGUI levelUpgrade2;
    [SerializeField] private TextMeshProUGUI upgradeDescription2;
    [SerializeField] private TextMeshProUGUI priceTextFieldUpgrade2;
    [SerializeField] private string itemDescription2_1;
    [SerializeField] private string itemDescription2_2;
    [SerializeField] private string itemDescription2_3;

    [Header("Upgrade3")]
    [SerializeField] private float upgrade3Tier;
    [SerializeField] private string finalItemDescription;
    [SerializeField] private float priceUpgrade3_1;
    [SerializeField] private TextMeshProUGUI levelUpgrade3;
    [SerializeField] private TextMeshProUGUI upgradeDescription3;
    [SerializeField] private TextMeshProUGUI priceTextFieldUpgrade3;
    [SerializeField] private GameObject gemUpgrade3One;
    [SerializeField] private GameObject MaxUpgrade3;
    [SerializeField] private GameObject priceButton3;
    [SerializeField] private GameObject arrow2;
    [SerializeField] private Animator balistaAnim;
    private bool waitUntilDoneClicking = true;


    [Header("Floats")]
    [Tooltip("Time for WaitSec in Co-routine startgame")]
    [SerializeField] private float time = 2.0f;

    [Header("Animators")]
    [Tooltip("The animator controler for the settings TAB")]
    [SerializeField] private Animator settings;
    [Tooltip("The animator controler for the Shop TAB")]
    [SerializeField] private Animator Shop;
    [SerializeField] private Animator StartMenu;
    [SerializeField] private GameObject camAnim;

    [SerializeField] private PostProcessVolume pPv;
    private SH_PostProcessPPSSettings pP;
    public bool debug;

    private void Awake()
    {
        startMenu.SetActive(true);
        settingsMenu.SetActive(false);
        UpgradeMenu.SetActive(false);
        pPv.profile.TryGetSettings<SH_PostProcessPPSSettings>(out pP);

        if (debug)
        {
            PlayerPrefs.SetFloat("HighScore", 0f);
            PlayerPrefs.SetFloat("Upgrade1", 0f);
            PlayerPrefs.SetFloat("Upgrade2", 0f);
            PlayerPrefs.SetFloat("TotalCoins", 0f);
            PlayerPrefs.SetFloat("DistBost", 0f);
            PlayerPrefs.SetFloat("Arrow2", 0f);
            PlayerPrefs.SetFloat("Multip", 1f);
        }
        upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
        upgrade2Tier = PlayerPrefs.GetFloat("Upgrade2");
        upgrade3Tier = PlayerPrefs.GetFloat("Arrow2");
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        totCoinMain.text = "" + totalCoins;
        totCoinUpgrade.text = "" + totalCoins;
        higscore = PlayerPrefs.GetFloat("HighScore");
        HSText.text = "Best Score:" + higscore;

        Upgradesave1();
        Upgradesave2();
        Upgradesave3();
    }

    private void Start()
    {
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        SC.multipliermeter = 0f;
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        //Debug.Log(upgrade1Tier);

    }

    // PRESSING PLAY
    public void PlayButton()
    {
        StartMenu.SetBool("On", true);
        GameController.Distance = PlayerPrefs.GetFloat("DistBost");
        SC.multiplier = PlayerPrefs.GetFloat("Multip");
        arrow2.SetActive(false);
        StartCoroutine(PlayfirstAnim(2f));
        AudioManager.Instance.SFX("UIclick");

    }

    //GOING INTO SETTINGS
    public void SettingsButton()
    {
        
        settings.SetBool("On", true);
        AudioManager.Instance.SFX("UIclick");
        settingsMenu.SetActive(true);
    }

    //GO BACK TO MAINMENU FROM SETTINGS TAB
    public void ExitButton()
    {
        settings.SetBool("On", false);
        AudioManager.Instance.SFX("UIclick");
    }

    // GO INTO SHOP TAB
    public void ShopButton()
    {
        UpgradeMenu.SetActive(true);
        Shop.SetBool("On", true);
        AudioManager.Instance.SFX("UIclick");
    }

    // GO BACK TO MAINMENU FROM THE SHOP
    public void ExitButtonShop()
    {
        
            Shop.SetBool("On", false);
            UpgradeMenu.SetActive(true);
            AudioManager.Instance.SFX("UIclick");
        
        
    }
    public void Tutorial()
    {
        tutorial.SetActive(true);
        tutText1.SetActive(true);
        tutText2.SetActive(false);
        tutText3.SetActive(false);
    }
    public void NextSliderTutorial()
    {
        if (tutText1.active == true)
        {
            tutText1.SetActive(false);
            tutText2.SetActive(true);
            tutText3.SetActive(false);
        }
        else if (tutText2.active == true)
        {
            tutText1.SetActive(false);
            tutText2.SetActive(false);
            tutText3.SetActive(true);
        }
        else if (tutText3.active == true)
        {
            ExitTutorial();
        }
     


    }
    public void ExitTutorial()
    {
        tutorial.SetActive(false);
        tutText1.SetActive(false);
        tutText2.SetActive(false);
        tutText3.SetActive(false);
    }

    //SET VOLUME OF SFX
    public void SFXSlider()
    {

        AudioManager.Instance.SFXVolume(sfxSlider.value);
    }

    //SET VOLUME OF MUSIC
    public void MusicSlider()
    {
        AudioManager.Instance.MusicVolume(musicSlider.value);
    }
     public void UpdateCoins()
    {
        totCoinMain.text = "" + totalCoins;
        totCoinUpgrade.text = "" + totalCoins;
        uiWinning.totalcoin.text = "" + totalCoins;
    }

    public void Upgrade1()
    {
        AudioManager.Instance.SFX("UIclick");
        if ((priceUpgrade1 <= totalCoins) && upgrade1Tier == 0f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Upgrade1", 1f);
            upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
            SC.multiplier = comboIncrease1;
            PlayerPrefs.SetFloat("Multip", comboIncrease1);
            gemUpgrade1One.SetActive(true);
            levelUpgrade1.text = "Level 1 / 3";
            upgradeDescription1.text = itemDescription1;
            priceTextFieldUpgrade1.text = "" + priceUpgrade2;
            totalCoins = totalCoins - priceUpgrade1;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            
        }
        else if ((priceUpgrade2 <= totalCoins) && upgrade1Tier == 1f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Upgrade1", 2f);
            upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
            SC.multiplier = comboIncrease2;
            PlayerPrefs.SetFloat("Multip", comboIncrease2);
            gemUpgrade1Two.SetActive(true);
            levelUpgrade1.text = "Level 2 / 3";
            upgradeDescription1.text = itemDescription2;
            priceTextFieldUpgrade1.text = "" + priceUpgrade3;
            totalCoins = totalCoins - priceUpgrade2;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            

        }
        else if ((priceUpgrade3 <= totalCoins) && upgrade1Tier == 2f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Upgrade1", 3f);
            upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
            SC.multiplier = comboIncrease3;
            PlayerPrefs.SetFloat("Multip", comboIncrease3);
            gemUpgrade1Three.SetActive(true);
            levelUpgrade1.text = "Level 3 / 3";
            upgradeDescription1.text = itemDescription3;
            priceTextFieldUpgrade1.text = "";
            priceButton.SetActive(false);
            totalCoins = totalCoins - priceUpgrade3;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            MaxUpgrade1.SetActive(true);
        }
    }
    public void Upgradesave1()
    {   
        if(upgrade1Tier == 0f)
        {
            SC.multiplier = 1f;
        }
        if(upgrade1Tier == 1f)
        {
            SC.multiplier = comboIncrease1;
            gemUpgrade1One.SetActive(true);
            levelUpgrade1.text = "Level 1 / 3";
            upgradeDescription1.text = itemDescription1;
            priceTextFieldUpgrade1.text = "" + priceUpgrade2;
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
        }
        if (upgrade1Tier == 2f)
        {
            SC.multiplier = comboIncrease2;
            gemUpgrade1Two.SetActive(true);
            gemUpgrade1One.SetActive(true);
            levelUpgrade1.text = "Level 2 / 3";
            upgradeDescription1.text = itemDescription2;
            priceTextFieldUpgrade1.text = "" + priceUpgrade3;
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
        }
        if (upgrade1Tier == 3f)
        {
            SC.multiplier = comboIncrease3;
            gemUpgrade1Two.SetActive(true);
            gemUpgrade1One.SetActive(true);
            gemUpgrade1Three.SetActive(true);
            levelUpgrade1.text = "Level 3 / 3";
            upgradeDescription1.text = itemDescription3;
            priceTextFieldUpgrade1.text = "" + priceUpgrade3;
            priceButton.SetActive(false);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            MaxUpgrade1.SetActive(true);
        }
    }

    public void Upgrade2()
    {
        AudioManager.Instance.SFX("UIclick");
        if ((priceUpgrade2_1 <= totalCoins) && upgrade2Tier == 0f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Upgrade2", 1f);
            upgrade2Tier = PlayerPrefs.GetFloat("Upgrade2");
            PlayerPrefs.SetFloat("DistBost", DistanceIncrease1);
            //GameController.Distance = DistanceIncrease1;
            gemUpgrade2One.SetActive(true);
            levelUpgrade2.text = "Level 1 / 3";
            upgradeDescription2.text = itemDescription2_1;
            priceTextFieldUpgrade2.text = "" + priceUpgrade2_2;
            totalCoins = totalCoins - priceUpgrade2_1;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            
        }
        else if ((priceUpgrade2_2 <= totalCoins) && upgrade2Tier == 1f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Upgrade2", 2f);
            upgrade2Tier = PlayerPrefs.GetFloat("Upgrade2");
            PlayerPrefs.SetFloat("DistBost", DistanceIncrease2);
            //GameController.Distance = DistanceIncrease2;
            gemUpgrade2Two.SetActive(true);
            levelUpgrade2.text = "Level 2 / 3";
            upgradeDescription2.text = itemDescription2_2;
            priceTextFieldUpgrade2.text = "" + priceUpgrade2_3;
            totalCoins = totalCoins - priceUpgrade2_2;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            

        }
        else if ((priceUpgrade2_3 <= totalCoins) && upgrade2Tier == 2f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Upgrade2", 3f);
            upgrade2Tier = PlayerPrefs.GetFloat("Upgrade2");
            PlayerPrefs.SetFloat("DistBost", DistanceIncrease3);
            //GameController.Distance = DistanceIncrease3;
            gemUpgrade2Three.SetActive(true);
            levelUpgrade2.text = "Level 3 / 3";
            upgradeDescription2.text = itemDescription2_3;
            priceTextFieldUpgrade2.text = "";
            priceButton2.SetActive(false);
            totalCoins = totalCoins - priceUpgrade2_3;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            MaxUpgrade2.SetActive(true);

        }
    }

    public void Upgradesave2()
    {
        if (upgrade2Tier == 1f)
        {
            gemUpgrade2One.SetActive(true);
            levelUpgrade2.text = "Level 1 / 3";
            upgradeDescription2.text = itemDescription2_1;
            priceTextFieldUpgrade2.text = "" + priceUpgrade2_2;
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
        }
        if (upgrade2Tier == 2f)
        {
            gemUpgrade2One.SetActive(true);
            gemUpgrade2Two.SetActive(true);
            levelUpgrade2.text = "Level 2 / 3";
            upgradeDescription2.text = itemDescription2_2;
            priceTextFieldUpgrade2.text = "" + priceUpgrade2_3;
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
        }
        if (upgrade2Tier == 3f)
        {
            gemUpgrade2One.SetActive(true);
            gemUpgrade2Two.SetActive(true);
            gemUpgrade2Three.SetActive(true);
            levelUpgrade2.text = "Level 3 / 3";
            upgradeDescription2.text = itemDescription2_3;
            priceTextFieldUpgrade2.text = "" + priceUpgrade2_3;
            priceButton2.SetActive(false);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            MaxUpgrade2.SetActive(true);
        }
    }
    public void upgrade3()
    {
        AudioManager.Instance.SFX("UIclick");
        if ((priceUpgrade3_1 <= totalCoins) && upgrade3Tier == 0f && waitUntilDoneClicking)
        {
            
            PlayerPrefs.SetFloat("Arrow2", 1f);
            upgrade3Tier = PlayerPrefs.GetFloat("Arrow2");
            gemUpgrade3One.SetActive(true);
            priceButton3.SetActive(false);
            totalCoins = totalCoins - priceUpgrade3_1;
            upgradeDescription3.text = "" + finalItemDescription;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            MaxUpgrade3.SetActive(true);

        }
    }
    public void Upgradesave3()
    {
        if (upgrade3Tier == 1f)
        {

            gemUpgrade3One.SetActive(true);
            priceButton3.SetActive(false);
            upgradeDescription3.text = "" + finalItemDescription;
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            MaxUpgrade3.SetActive(true);
        }
       
    }
    IEnumerator PlayfirstAnim(float sec)
    {
        camAnim.SetActive(false);
        //camAnim.SetBool("On", true);
        yield return new WaitForSecondsRealtime(sec);
        Rope.SetActive(true);
        balistaAnim.SetBool("Is Walking", false);
        StartCoroutine(StartGame(time));
    }
    //CO-ROUTINE FOR STARTING THE GAME
    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;
        AudioManager.Instance.PlayBackGroundMusic("Shop");

        float T = 0; //time for "While loop" in co-routine
        while (T < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            T += Time.deltaTime / .5f; // This is the speed for the player

            if(T > 1)
            {
                T = 1;
            }

            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            player2.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }


        yield return new WaitForSecondsRealtime(time);
        SpeedModifier.GameStarted();

        Vector3 cameraStartPosition = camera.transform.position;

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            cameraT += Time.deltaTime / .5f; // This is the speed for the player

            if(cameraT > 1)
            {
                cameraT = 1;
            }
            
            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }
      
       
        yield return new WaitForSeconds(0.2f);
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
       
        objectSpawner.canSpawnEnemy = true;
        uic.takeDist = true;
        StartMenu.SetBool("On", false);
        inGameMenu.SetActive(true);
        AudioManager.Instance.PlayBackGroundMusic("Gameplay");
        balistaAnim.SetBool("Is Walking", true);
        this.gameObject.SetActive(false);
    }
    IEnumerator ClickedUpgrade(float sec)
    {
        waitUntilDoneClicking = false;
        yield return new WaitForSeconds(sec);
        waitUntilDoneClicking = true;
    }
}
