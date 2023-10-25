using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class UIController : MonoBehaviour
{
    [SerializeField] private float timeMod = 4.0f; // Time modifier for distance
    [SerializeField] private TextMeshProUGUI distanceText = null; // Text for distance
    [SerializeField] private GameObject ReplayButton;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (GameController.IncreaseDistance)
        {
            GameController.Distance += Time.deltaTime * timeMod; // Increase distance by time passed
        }
        else
        {
            GameController.Distance -= Time.deltaTime * timeMod; // Decrease distance by time passed
        }

        distanceText.text = String.Format("{0:0m}", GameController.Distance);

        if (GameController.Distance <= 0) // If distance is 0 or less, end game
        {
            //GameController.EndGame();
            Time.timeScale = 0;
        }
    }
}
