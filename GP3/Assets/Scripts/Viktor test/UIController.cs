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
    [SerializeField] private ReturnSequence[] listReturnsequence;

    public GameObject SafeArea;
    public bool endGame = true;
    
    public bool takeDist; 
    // Start is called before the first frame update
    void Start()
    {
        takeDist = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (takeDist)
        {
            TakeDist();
        }
    }

    public void TakeDist()
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

            Winning();

        }
        
    }
    public void Winning()
    {
        
        endGame = false;
        ScoreCounter.Instance.WinningScoreCounter();
        
        foreach(ReturnSequence obj in listReturnsequence)
        {
            obj.ReturnToStart();
        }
        StartCoroutine(StartGame(time));
    }

    IEnumerator StartGame(float time)
    {
        SpeedModifier.GameEnded();
        takeDist = false;
        Vector3 cameraStartPosition = camera.transform.position;
        

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1)
        {
            cameraT += Time.deltaTime / 1.01f; // This is the speed for the player

            if (cameraT > 1)
            {
                cameraT = 1;
            }

            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }
        yield return new WaitForSecondsRealtime(time);

       
        Vector3 playerStartPosition = player.transform.position;
        float T = 0;
        while (T < 1)
        {
            T += Time.deltaTime / 1f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }
            
            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }

        yield return new WaitForSeconds(0.2f);
        winningScreen.SetActive(true);
        SafeArea.SetActive(true);
        endGame = true;
        SpeedModifier.ResetHit();
    }
}
