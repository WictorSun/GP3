using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class UIWinning : MonoBehaviour
{

    public TextMeshProUGUI coins;
    public TextMeshProUGUI metersTravelled;
    public TextMeshProUGUI kills;
    public TextMeshProUGUI combo;
    public TextMeshProUGUI totalScore;
    public TextMeshProUGUI totalcoin;

    [SerializeField] private GameObject player;
    float T = 0;
    [SerializeField] private GameObject StartMovementPoint;
    [SerializeField] private float time = 2.0f;
    [SerializeField] private GameObject camera;
    [SerializeField] private GameObject CamStartMovementPoint;

    [SerializeField] private GameObject RetryButton;

    public void PlayAgain()
    {
        StartCoroutine(StartGame(time));
    }

    IEnumerator StartGame(float time)
    {
        AudioManager.Instance.SFX("ButtonClick");
        Vector3 playerStartPosition = player.transform.position;

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


        yield return new WaitForSecondsRealtime(time);
        SpeedModifier.GameStarted();

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

        yield return new WaitForSeconds(0.2f);
        
        this.gameObject.SetActive(false);
    }
}
