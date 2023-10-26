using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpeedModifier : MonoBehaviour
{
    public static SpeedModifier instance;
    public static float speed;

    public static void IncreaseSpeed(float increment)
    {
        speed += increment;
    }
}
