using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class UIController : MonoBehaviour
{
    [SerializeField] private float timeMod = 2.0f; // Time modifier for distance
    [SerializeField] private TextMeshProUGUI distanceText = null; // Text for distance
    [SerializeField] private GameObject ReplayButton;
    [SerializeField] private GameObject winningScreen;
    private bool endGame;
    // Start is called before the first frame update
    void Start()
    {
        endGame = true;
    }

    // Update is called once per frame
    void Update()
    {
        float modifiedTimeMod = timeMod + SpeedModifier.speed;  // Add the speed from SpeedModifier

        if (GameController.IncreaseDistance)
        {
            GameController.Distance += Time.deltaTime * modifiedTimeMod; // Increase distance by time passed
        }
        else
        {
            GameController.Distance -= Time.deltaTime * modifiedTimeMod; // Decrease distance by time passed
        }

        distanceText.text = String.Format("{0:0m}", GameController.Distance);

        if (GameController.Distance <= 0 && endGame) // If distance is 0 or less, end game
        {
            //GameController.EndGame();
            Winning();
            Time.timeScale = 0;
            
        }
    }
    public void Winning()
    {
        endGame = false;
        ScoreCounter.Instance.WinningScoreCounter();
        winningScreen.SetActive(true);
    }
}
