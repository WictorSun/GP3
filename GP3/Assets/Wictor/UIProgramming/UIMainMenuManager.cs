using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIMainMenuManager : MonoBehaviour
{
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

            AudioManager.Instance.SFX("ButtonClick");
            inGameMenu.SetActive(true);
            this.gameObject.SetActive(false);

       
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
}
