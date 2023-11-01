using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;

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




    [Header("Floats")]
    [Tooltip("Total of coins collected")]
    [SerializeField] private float totalCoins;
    [Tooltip("Time for WaitSec in Co-routine startgame")]
    [SerializeField] private float time = 2.0f;

    [Header("Animators")]
    [Tooltip("The animator controler for the settings TAB")]
    [SerializeField] private Animator settings;
    [Tooltip("The animator controler for the Shop TAB")]
    [SerializeField] private Animator Shop;
    [SerializeField] private Animator StartMenu;



    private void Awake()
    {
        startMenu.SetActive(true);
        settingsMenu.SetActive(false);
        UpgradeMenu.SetActive(false);
      
       
    }

    private void Start()
    {
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        
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
}
