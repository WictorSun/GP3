using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIMainMenuManager : MonoBehaviour
{
    [SerializeField] private GameObject startMenu;
    [SerializeField] private GameObject settingsMenu;
   // [SerializeField] private GameObject inGameMenu;
    [SerializeField] private Slider sfxSlider;
    [SerializeField] private Slider musicSlider;
    //[SerializeField] private GameObject tutorialCanvas;
    //private bool firstGame;

    [Header("Animators")]
    [SerializeField] private Animator settings;
    [SerializeField] private Animator Shop;



    private void Awake()
    {
        startMenu.SetActive(true);
        settingsMenu.SetActive(false);
       // firstGame = true;
       
    }
    private void Start()
    {
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
        
    }
    public void PlayButton()
    {
      //  if(firstGame)
        //{
            AudioManager.Instance.SFX("ButtonClick");
            //tutorialCanvas.SetActive(true);
            this.gameObject.SetActive(false);
          //  firstGame = false;
        //}
       // else
       // {
            AudioManager.Instance.SFX("ButtonClick");
            //inGameMenu.SetActive(true);
            this.gameObject.SetActive(false);
       // }
       
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
        Shop.SetBool("On", true);
    }
    public void ExitButtonShop()
    {
        Shop.SetBool("On", false);
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
