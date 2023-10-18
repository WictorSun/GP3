using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class UIController : MonoBehaviour
{
    [SerializeField] private float timeMod = 4.0f; // Time modifier for distance
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        GameController.Distance += Time.deltaTime * timeMod; // Increase distance by time passed
        //distanceText.text = String.Format("{0:0m}", GameController.Distance);
    }
}
