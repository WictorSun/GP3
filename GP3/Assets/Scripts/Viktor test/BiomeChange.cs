using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BiomeChange : MonoBehaviour
{
    private bool past500;

    // Update is called once per frame
    void Update()
    {
        if (GameController.Distance >= 500 && !past500)
        {
            past500 = true;
            BiomeForest();
        }
    }

    private void BiomeForest()
    {
        // Change biome

    }
}
