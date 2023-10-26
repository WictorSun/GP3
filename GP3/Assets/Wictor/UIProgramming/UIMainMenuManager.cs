using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;

public class UIMainMenuManager : MonoBehaviour
{
    [SerializeField] private GameObject camera;
    [SerializeField] private float time = 2.0f;
    [SerializeField] private GameObject Ballista;
    [SerializeField] private GameObject StartMovementPoint; // where game Beins
    [SerializeField] private GameObject CamBallista;
    [SerializeField] private GameObject CamStartMovementPoint; // where game Beins
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject startMenu;
    [SerializeField] private GameObject settingsMenu;
    [SerializeField] private GameObject UpgradeMenu;
    [SerializeField] private GameObject inGameMenu;
    [SerializeField] private Slider sfxSlider;
    [SerializeField] private Slider musicSlider;
    //[SerializeField] private GameObject tutorialCanvas;
    //private bool firstGame;
    [SerializeField] private float totalCoins;
    [SerializeField] private TextMeshProUGUI totalCoinsText;
    [Header("Animators")]
    [SerializeField] private Animator settings;
    [SerializeField] private Animator Shop;

    float T = 0;

    private void Awake()
    {
        startMenu.SetActive(true);
        settingsMenu.SetActive(false);
        UpgradeMenu.SetActive(false);
       // firstGame = true;
       
    }
    private void Start()
    {
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
        totalCoins = PlayerPrefs.GetFloat("TotalCoins");
        
        totalCoinsText.text = "" + totalCoins;
    }
    public void PlayButton()
    {
        StartCoroutine(StartGame(time));
    }

    public void SettingsButton()
    {
        settings.SetBool("On", true);
        AudioManager.Instance.SFX("ButtonClick"); 
        //startMenu.SetActive(false);
        settingsMenu.SetActive(true);
    }
    public void ExitButton()
    {
        settings.SetBool("On", false);
        AudioManager.Instance.SFX("ButtonClick");
        //startMenu.SetActive(true);
        //settingsMenu.SetActive(false);
    }
    public void ShopButton()
    {
        UpgradeMenu.SetActive(true);
        Shop.SetBool("On", true);
    }
    public void ExitButtonShop()
    {
        Shop.SetBool("On", false);
        UpgradeMenu.SetActive(true);
        AudioManager.Instance.SFX("ButtonClick");
        //startMenu.SetActive(true);
        //settingsMenu.SetActive(false);
    }
    public void SFXSlider()
    {

        AudioManager.Instance.SFXVolume(sfxSlider.value);
    }
    public void MusicSlider()
    {
        AudioManager.Instance.MusicVolume(musicSlider.value);
    }

    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");

        while (T < 1)
        {
            T += Time.deltaTime / 2f;

            if(T > 1) // q: 
            {
                T = 1;
            }

            player.transform.position = Vector3.Lerp(player.transform.position, StartMovementPoint.transform.position, T);
            camera.transform.position = Vector3.Lerp(camera.transform.position, CamStartMovementPoint.transform.position, T);
            yield return null;
        }

        yield return new WaitForSecondsRealtime(time);
        SpeedModifier.GameStarted();

        yield return new WaitForSeconds(0.2f);
        inGameMenu.SetActive(true);
        this.gameObject.SetActive(false);
    }
}
