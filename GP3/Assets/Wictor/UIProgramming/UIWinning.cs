using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIWinning : MonoBehaviour
{
    [SerializeField] private Animator shop;

    public void Shop()
    {
        shop.SetBool("On", true);
    }
    public void ExitShop()
    {
        shop.SetBool("On", false);
    }
}
