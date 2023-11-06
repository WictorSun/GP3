using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraLookAt : MonoBehaviour
{
    public Transform target;
    public bool fuckyoucode;

    // Add these two variables to control the rotation limits
    public float minYRotation = -90.0f; // Minimum Y rotation
    public float maxYRotation = 90.0f;  // Maximum Y rotation

    private void Start()
    {

    }

    void Update()
    {
        if (!GameController.IsReturning)
        {
            // Rotate the camera every frame so it keeps looking at the target
            transform.LookAt(target);

            // Same as above, but setting the worldUp parameter to Vector3.left in this example turns the camera on its side
            //transform.LookAt(target, Vector3.up);
        }
        else if (GameController.IsReturning)
        {
            StartCoroutine(lerpBack(.2f));
        }

        //Clamp the Y rotation of the camera
        Vector3 currentRotation = transform.localRotation.eulerAngles;
        currentRotation.y = Mathf.Clamp(currentRotation.y, minYRotation, maxYRotation);
        transform.rotation = Quaternion.Euler(currentRotation);
    }

    public IEnumerator lerpBack(float sec)
    {
        Quaternion cur = transform.rotation;
        Quaternion rot = Quaternion.Euler(61.9429321f, 0.0922606811f, 0f);
        float T = 0f;
        while (T < 1)
        {
            T += Time.deltaTime / 1f; // This is the speed for the player

            if (T > 1)
            {
                T = 1;
            }
            transform.rotation = Quaternion.Slerp(cur, rot, T);

            yield return null;
        }
        yield return new WaitForSeconds(sec);
        fuckyoucode = false;
    }
}
