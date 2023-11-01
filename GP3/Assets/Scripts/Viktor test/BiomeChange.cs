using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BiomeChange : MonoBehaviour
{
    private bool past500 = false;

    // Update is called once per frame
    void Update()
    {
        if (GameController.Distance >= 500 && !past500)
        {
            past500 = true;
            BiomeForestToDesert();
        }
    }

    private void BiomeForestToDesert()
    {
        // enable forestToDesert once
        past500 = true;
    }
}
