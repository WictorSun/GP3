using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightChange : MonoBehaviour
{
    Light lt;
    Color color0 = Color.blue;
    Color color1 = Color.red;


    void Start()
    {
        lt = GetComponent<Light>();
    }

    public void ChangeToBlue()
    {
        lt.color = color0;
    }

    public void ChangeToRed()
    {
        lt.color = color1;
    }


}
