using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIInGameMenu : MonoBehaviour
{
    public static UIInGameMenu Instance;
    [SerializeField] private GameObject settingsMenu;
    [SerializeField] private GameObject mainPauseMenu;
    [SerializeField] private Slider sfxSlider;
    [SerializeField] private Slider musicSlider;
    [SerializeField] private GameObject pauseButton;
    [SerializeField] private GameObject StartMenu;
    [SerializeField] private GameObject LeftTouch;
    [SerializeField] private GameObject RightTouch;



    private float storedValueSFX;
    private float storedValueMusic;
    private bool muted;

    [Header("Animators")]
    [SerializeField] private Animator settings;
    [SerializeField] private Animator pauseMenu;
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
        Debug.Log(Time.timeScale);
        //pauseButton.SetActive(false);
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
        storedValueSFX = sfxSlider.value;
       

    }
    public void MusicSlider()
    {

        AudioManager.Instance.MusicVolume(musicSlider.value);
        storedValueMusic = musicSlider.value;
       
    }
    public void QuitGame()
    {
       
       
        StartCoroutine(QuitGame(1f));

    }
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
