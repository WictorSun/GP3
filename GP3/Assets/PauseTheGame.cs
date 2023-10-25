using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PauseTheGame : MonoBehaviour
{
    [SerializeField] private GameObject pauseMenu;

    public void PauseGame()
    {

        StartCoroutine(PauseGame(1f));
    }
    IEnumerator PauseGame(float sec)
    {
        pauseMenu.SetActive(true);
        yield return new WaitForSecondsRealtime(sec);
       // UIInGameMenu.Instance.PauseTheGame();
    }
}
