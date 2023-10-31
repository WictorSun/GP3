using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.UI;

public class UITutorial : MonoBehaviour
{


    [SerializeField] private GameObject steeringHold;
    // [SerializeField] private GameObject tilt;
    [SerializeField] private GameObject shootArrow;
   
    [SerializeField] private GameObject inGameMenu;

    private void Start()
    {
        steeringHold.SetActive(true);
        shootArrow.SetActive(false);
       
    }
    public void DoneWithFirstTutorial()
    {
        AudioManager.Instance.SFX("ButtonClick");
        steeringHold.SetActive(false);
        shootArrow.SetActive(true);
    }
    public void DoneWithSecondTutorial()
    {
        AudioManager.Instance.SFX("ButtonClick");
        steeringHold.SetActive(true);
        shootArrow.SetActive(false);
        inGameMenu.SetActive(true);
        this.gameObject.SetActive(false);

    }
    public void DoneWithyLastTutorial()
    {
        
        inGameMenu.SetActive(true);
    }

}
