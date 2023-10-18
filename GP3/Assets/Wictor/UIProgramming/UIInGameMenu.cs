using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIInGameMenu : MonoBehaviour
{
    [SerializeField] private GameObject settingsMenu;
    [SerializeField] private Slider sfxSlider;
    [SerializeField] private Slider musicSlider;
    [SerializeField] private GameObject pauseButton;
    private void Awake()
    {
        settingsMenu.SetActive(false);
        this.gameObject.SetActive(false);
    }

    public void PauseTheGame()
    {
        AudioManager.Instance.SFX("ButtonClick");
        settingsMenu.SetActive(true);
        Time.timeScale = 0f;
        Debug.Log(Time.timeScale);
        pauseButton.SetActive(false);
        sfxSlider.value = AudioManager.Instance.sfxSource.volume;
        musicSlider.value = AudioManager.Instance.musicSource.volume;
    }
    public void BackToGame()
    {
        AudioManager.Instance.SFX("ButtonClick");
        settingsMenu.SetActive(false);
        pauseButton.SetActive(true);
        Time.timeScale = 1f;
        Debug.Log(Time.timeScale);
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
