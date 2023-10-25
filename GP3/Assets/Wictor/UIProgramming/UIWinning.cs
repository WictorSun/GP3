using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class UIWinning : MonoBehaviour
{
    [SerializeField] private Animator shop;
    public TextMeshProUGUI coins;
    public TextMeshProUGUI metersTravelled;
    public TextMeshProUGUI kills;
    public TextMeshProUGUI combo;
    public TextMeshProUGUI totalScore;

    public void Shop()
    {
        shop.SetBool("On", true);
    }
    public void ExitShop()
    {
        shop.SetBool("On", false);
    }
}
