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

    [SerializeField] private ObjectSpawner objectSpawner;
    [Header("GameObjects")]
    [Tooltip("Drag the player prefab")]
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject player2;
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
    [SerializeField] private Animator winningAnim;
    [SerializeField] private ScoreCounter SC;
    [SerializeField] private Slider comboSlider;

    //Event for pressing "RESTART" 
    public void PlayAgain()
    {
        GameController.Distance = PlayerPrefs.GetFloat("DistBost");
        SC.multiplier = PlayerPrefs.GetFloat("Multip");
        StartCoroutine(StartGame(time));
        SC.multipliermeter = 0f;
        GameController.ArrowFront.SetActive(true);
        GameController.ArrowBack.SetActive(false);
    }

    //Co routine for starting a new round
    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;
        GameObject[] enemies;
        GameObject[] eEnemies;
        winningAnim.SetBool("On", false);
        enemies = GameObject.FindGameObjectsWithTag("Enemy");
        eEnemies = GameObject.FindGameObjectsWithTag("ExplodingEnemy");
        foreach (GameObject enem in enemies)
        {
            enem.SetActive(false);
        }
        foreach (GameObject enem in eEnemies)
        {
            enem.SetActive(false);
        }
        float T = 0; //LerpTime
        while (T < 1) //This lerps the Player from idle position in the beggining of game to the position for when playing
        {
            T += Time.deltaTime / .5f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }

            player.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            player2.transform.position = Vector3.Lerp(playerStartPosition, StartMovementPoint.transform.position, T);
            yield return null;
        }


        yield return new WaitForSecondsRealtime(time);        
        SafeArea.SetActive(false);
        SpeedModifier.GameStarted();
        
        GameController.IncreaseDistance = true;
        GameController.IsReturning = false;
        Vector3 cameraStartPosition = camera.transform.position;

        float cameraT = 0; // This is the interpolation factor for the camera

        while (cameraT < 1) //This lerps the Camera from idle position in the beggining of game to the position for when playing
        {
            cameraT += Time.deltaTime / .5f; // This is the speed for the player

            if (cameraT > 1)
            {
                cameraT = 1;
            }

            camera.transform.position = Vector3.Lerp(cameraStartPosition, CamStartMovementPoint.transform.position, cameraT);
            yield return null;
        }

        yield return new WaitForSeconds(0.0001f);
        uic.takeDist = true;
        uic.endGame = true;
        SpeedModifier.speed = 1f;
        objectSpawner.canSpawnEnemy = true;
        comboSlider.value = 0f;
        this.gameObject.SetActive(false); // sets the Winning Screen to disabled in order to play again
    }
}
