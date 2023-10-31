using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;


public class UIWinning : MonoBehaviour
{
    [Header("TextFields")]
    [Tooltip("Coins Collected This round")]
    public TextMeshProUGUI coins; //Coins Collected
    [Tooltip("How far you reached this round")]
    public TextMeshProUGUI metersTravelled;
    [Tooltip("KillScore this round")]
    public TextMeshProUGUI kills;
    [Tooltip("Multiplier this round")]
    public TextMeshProUGUI combo;
    [Tooltip("Total Score for this round")]
    public TextMeshProUGUI totalScore;
    [Tooltip("Total coins you have collected")]
    public TextMeshProUGUI totalcoin;
    

    [Header("GameObjects")]
    [Tooltip("Drag the player prefab")]
    [SerializeField] private GameObject player;
    [Tooltip("Drag the Start Transform for player when playing the game")]
    [SerializeField] private GameObject StartMovementPoint;
    [Tooltip("Drag the player prefab")]
    [SerializeField] private float time = 2.0f;
    [Tooltip("Drag the player prefab")]
    [SerializeField] private GameObject camera;
    [Tooltip("Drag the Start Transform for camera when playing the game")]
    [SerializeField] private GameObject CamStartMovementPoint;
    [SerializeField] private GameObject SafeArea;
    [SerializeField] private UIController uic;
    //[Tooltip("RetryButton")]
    //[SerializeField] private GameObject RetryButton;

    //Event for pressing "RESTART" 
    public void PlayAgain()
    {
        StartCoroutine(StartGame(time));
    }

    //Co routine for starting a new round
    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;
        SafeArea.SetActive(false);
        float T = 0; //LerpTime
        while (T < 1) //This lerps the Player from idle position in the beggining of game to the position for when playing
        {
            T += Time.deltaTime / 1f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }

            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }


        yield return new WaitForSecondsRealtime(time);
        SpeedModifier.GameStarted();
        GameController.IncreaseDistance = true;
        GameController.IsReturning = false;
        Vector3 cameraStartPosition = camera.transform.position;

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1) //This lerps the Camera from idle position in the beggining of game to the position for when playing
        {
            cameraT += Time.deltaTime / 1.01f; // This is the speed for the player

            if (cameraT > 1)
            {
                cameraT = 1;
            }

            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }

        yield return new WaitForSeconds(0.2f);
        uic.takeDist = true;
        
        this.gameObject.SetActive(false); // sets the Winning Screen to disabled in order to play again
    }
}
