using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIInGameMenu : MonoBehaviour
{
    public static UIInGameMenu Instance;

    [Header("GameObjects")]
    [Tooltip("drag in the settings menu")]
    [SerializeField] private GameObject settingsMenu;
    [Tooltip("drag in the MainPause menu")]
    [SerializeField] private GameObject mainPauseMenu;
    [Tooltip("drag in the Pausebutton")]
    [SerializeField] private GameObject pauseButton;
    [Tooltip("drag in the Main MainMenu menu")]
    [SerializeField] private GameObject StartMenu;
    [Tooltip("drag in the LeftTouch button")]
    [SerializeField] private GameObject LeftTouch;
    [Tooltip("drag in the Right touch Button")]
    [SerializeField] private GameObject RightTouch;

    [Tooltip("drag in the SfX Slider")]
    [SerializeField] private Slider sfxSlider;
    [Tooltip("drag in the Music Slider")]
    [SerializeField] private Slider musicSlider;

    private bool muted; //MUTE / UNMUTE SOUNDS

    [Header("Animators")]
    [Tooltip("drag in the Settings animator")]
    [SerializeField] private Animator settings;
    [Tooltip("drag in the Pausemenu Animator")]
    [SerializeField] private Animator pauseMenu;
    [Tooltip("drag in the CountDown Animator")]
    [SerializeField] private Animator CountDown;
    private void Awake()
    {
        muted = false;
        settingsMenu.SetActive(false);
        //this.gameObject.SetActive(false);
      
    }

    public void PauseTheGame()
    {
        AudioManager.Instance.SFX("ButtonClick");
        pauseMenu.SetBool("On", true);
        mainPauseMenu.SetActive(true);
        RightTouch.SetActive(false);
        LeftTouch.SetActive(false);
        Time.timeScale = 0f;


        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
    }
    public void ResumeGame()
    {
        StartCoroutine(ContinuePlayGame(1f, 2f));


    }
    public void BackToGame()
    {
        AudioManager.Instance.SFX("ButtonClick");
        mainPauseMenu.SetActive(false);
        pauseButton.SetActive(true);
        Time.timeScale = 1f;
        Debug.Log(Time.timeScale);
    }
    public void Settings()
    {
        settings.SetBool("On", true);
        settingsMenu.SetActive(true);
        musicSlider.value = AudioManager.Instance.musicSource.volume;
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        
    }
    public void Mute()
    {
        Debug.Log(muted);
        if (!muted)
        {
            AudioManager.Instance.SFXVolume(sfxSlider.value = 0);
            AudioManager.Instance.MusicVolume(musicSlider.value = 0);
            muted = true;
        }
        else
        {
            AudioManager.Instance.SFXVolume(sfxSlider.value = 0.75f);
            AudioManager.Instance.MusicVolume(musicSlider.value = 0.75f);
            muted = false;
        }
      
    }
    public void ExitSettings()
    {
        settings.SetBool("On", false);
    }
    public void SFXSlider()
    {
        
        AudioManager.Instance.SFXVolume(sfxSlider.value);
       
       

    }
    public void MusicSlider()
    {

        AudioManager.Instance.MusicVolume(musicSlider.value);
        
       
    }
    public void QuitGame()
    {
       
       
        StartCoroutine(QuitGame(1f));

    }
    //CO-ROUTINE FOR CONTINUE THE GAME WITH A COUNTDOWN UNTIL THE TOUCH INPUT WORKS AGAIN
    IEnumerator ContinuePlayGame(float WaitForSecs, float OtherSec)
    {
        pauseMenu.SetBool("On", false);
        yield return new WaitForSecondsRealtime(WaitForSecs);
        CountDown.SetBool("On", true);

        yield return new WaitForSecondsRealtime(OtherSec);
        CountDown.SetBool("On", false);
        Time.timeScale = 1f;
        Debug.Log(Time.timeScale);
        RightTouch.SetActive(true);
        LeftTouch.SetActive(true);
    }

    //CO-ROUTINE FOR RESETING THE GAME AND GOING BACK TO THE STARTSCREEN
    IEnumerator QuitGame(float sec)
    {
        pauseMenu.SetBool("On", false);
        yield return new WaitForSecondsRealtime(sec);
        Time.timeScale = 1f;
        Debug.Log(Time.timeScale);
        StartMenu.SetActive(true);
        this.gameObject.SetActive(false);
    }
}
