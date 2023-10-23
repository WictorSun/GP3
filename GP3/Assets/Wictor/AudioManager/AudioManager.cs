using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance;
    [Tooltip("The Music AudioClips")]
    [SerializeField] private Sound[] musicSounds;
    [Tooltip("The SFX AudioClips")]
    [SerializeField]private Sound[] sfxSounds;
    

    [Header("Sources")]
    [Tooltip("The AudioSource for Music")]
    [SerializeField] public AudioSource musicSource;
    [Tooltip("The AudioSource for SFX")]
    [SerializeField] public AudioSource sfxSource;

    private void Awake()
    {
        if(Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }
    private void Start()
    {
        PlayBackGroundMusic("BGSounds");
    }

    // Call on this where we want to play BGSounds/Music with the name of the sound/Music in the musicSounds list in inspector
    public void PlayBackGroundMusic(string name)
    {
        Sound s = Array.Find(musicSounds, x => x.name == name);
        if (s == null)
        {
            Debug.Log("Sound Not Found");
        }

        else
        {
            musicSource.clip = s.clip;
            musicSource.Play();
        }
    }

    // Call on this where we want to play soundeffect with the name of the sound in the sfxSounds list in inspector
    public void SFX(string name)
    {
        Sound s = Array.Find(sfxSounds, x => x.name == name);
        if (s == null)
        {
            Debug.Log("Sound Not Found");
        }

        else
        {
            sfxSource.PlayOneShot(s.clip);
        }
    }
    public void MusicVolume(float volume)
    {
        musicSource.volume = volume;

    }
    public void SFXVolume(float volume)
    {
        sfxSource.volume = volume;

    }
}
