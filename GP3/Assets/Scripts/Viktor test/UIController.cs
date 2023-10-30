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
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject StartMovementPoint; // where game Beins
    [SerializeField] private GameObject camera;
    [SerializeField] private GameObject CamStartMovementPoint; // where game Beins
    [SerializeField] private float time = 2.0f;
    [SerializeField] private ReturnSequence[] returnSequence;
    public bool endGame = true;
    float T = 0;

    // Start is called before the first frame update
    void Start()
    {
        
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
            //Time.timeScale = 0;
            
        }
    }
    public void Winning()
    {
        endGame = false;
        ScoreCounter.Instance.WinningScoreCounter();

        for (int i = 0; i < returnSequence.Length; i++)
        {
            returnSequence[i].ReturnToStart();
        }
        GameController.IsReturning = false;
        StartCoroutine(StartGame(time));
    }

    IEnumerator StartGame(float time)
    {
        SpeedModifier.GameEnded();
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;

        while (T < 1)
        {
            T += Time.deltaTime / 1f; // This is the speed for the player

            if(T > 1)
            {
                T = 1;
            }
            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }

        yield return new WaitForSecondsRealtime(time);

        Vector3 cameraStartPosition = camera.transform.position;

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1)
        {
            cameraT += Time.deltaTime / 1.01f; // This is the speed for the player

            if(cameraT > 1)
            {
                cameraT = 1;
            }
            
            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }

        yield return new WaitForSeconds(0.2f);
        winningScreen.SetActive(true);
    }
}
