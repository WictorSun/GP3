using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;



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

    [SerializeField] private ObjectSpawner objectSpawner;

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

    [SerializeField] private UIController uic;

    [Header("totalcoin and Highscore")]
    [SerializeField] private float totalCoins;
    [SerializeField] private float higscore;
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

    public bool debug;

    private void Awake()
    {
        startMenu.SetActive(true);
        settingsMenu.SetActive(false);
        UpgradeMenu.SetActive(false);

        if (debug)
        {
            PlayerPrefs.SetFloat("Upgrade1", 0f);
            PlayerPrefs.SetFloat("TotalCoins", 15f);
        }
        upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        totCoinMain.text = "" + totalCoins;
        totCoinUpgrade.text = "" + totalCoins;
    }

    private void Start()
    {
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        //Debug.Log(upgrade1Tier);
    }

    // PRESSING PLAY
    public void PlayButton()
    {
        StartMenu.SetBool("On", true);
        StartCoroutine(StartGame(time));
    }

    //GOING INTO SETTINGS
    public void SettingsButton()
    {
        settings.SetBool("On", true);
        AudioManager.Instance.SFX("ButtonClick"); 
        settingsMenu.SetActive(true);
    }

    //GO BACK TO MAINMENU FROM SETTINGS TAB
    public void ExitButton()
    {
        settings.SetBool("On", false);
        AudioManager.Instance.SFX("ButtonClick");
    }

    // GO INTO SHOP TAB
    public void ShopButton()
    {
        UpgradeMenu.SetActive(true);
        Shop.SetBool("On", true);
    }

    // GO BACK TO MAINMENU FROM THE SHOP
    public void ExitButtonShop()
    {
        Shop.SetBool("On", false);
        UpgradeMenu.SetActive(true);
        AudioManager.Instance.SFX("ButtonClick");
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
    }

    public void Upgrade1()
    {
        if((priceUpgrade1 <= totalCoins) && upgrade1Tier == 0f && waitUntilDoneClicking)
        {
            PlayerPrefs.SetFloat("Upgrade1", 1f);
            upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
            SC.comboIncrease = comboIncrease1;
            gemUpgrade1One.SetActive(true);
            levelUpgrade1.text = "Level 1 / 3";
            upgradeDescription1.text = itemDescription1;
            priceTextFieldUpgrade1.text = "" + priceUpgrade1;
            totalCoins = totalCoins - priceUpgrade1;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            Debug.Log(SC.comboIncrease);
        }
        else if ((priceUpgrade2 <= totalCoins) && upgrade1Tier == 1f && waitUntilDoneClicking)
        {
            PlayerPrefs.SetFloat("Upgrade1", 2f);
            upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
            SC.comboIncrease = comboIncrease2;
            gemUpgrade1Two.SetActive(true);
            levelUpgrade1.text = "Level 2 / 3";
            upgradeDescription1.text = itemDescription2;
            priceTextFieldUpgrade1.text = "" + priceUpgrade2;
            totalCoins = totalCoins - priceUpgrade2;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            Debug.Log(SC.comboIncrease);

        }
        else if ((priceUpgrade3 <= totalCoins) && upgrade1Tier == 2f && waitUntilDoneClicking)
        {
            PlayerPrefs.SetFloat("Upgrade1", 3f);
            upgrade1Tier = PlayerPrefs.GetFloat("Upgrade1");
            SC.comboIncrease = comboIncrease3;
            gemUpgrade1Three.SetActive(true);
            levelUpgrade1.text = "Level 3 / 3";
            upgradeDescription1.text = itemDescription3;
            priceTextFieldUpgrade1.text = "";
            priceButton.SetActive(false);
            totalCoins = totalCoins - priceUpgrade3;
            PlayerPrefs.SetFloat("TotalCoins", totalCoins);
            UpdateCoins();
            StartCoroutine(ClickedUpgrade(.2f));
            Debug.Log(SC.comboIncrease);
        }
    }

    //CO-ROUTINE FOR STARTING THE GAME
    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;

        float T = 0; //time for "While loop" in co-routine
        while (T < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            T += Time.deltaTime / 1f; // This is the speed for the player

            if(T > 1)
            {
                T = 1;
            }

            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }


        yield return new WaitForSecondsRealtime(time);
        SpeedModifier.GameStarted();

        Vector3 cameraStartPosition = camera.transform.position;

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1) //LERP THE PLAYER TO STARTPOSITION
        {
            cameraT += Time.deltaTime / 1.01f; // This is the speed for the player

            if(cameraT > 1)
            {
                cameraT = 1;
            }
            
            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }

        yield return new WaitForSeconds(0.2f);
        objectSpawner.canSpawnEnemy = true;
        uic.takeDist = true;
        StartMenu.SetBool("On", false);
        inGameMenu.SetActive(true);
        this.gameObject.SetActive(false);
    }
    IEnumerator ClickedUpgrade(float sec)
    {
        waitUntilDoneClicking = false;
        yield return new WaitForSeconds(sec);
        waitUntilDoneClicking = true;
    }
}
