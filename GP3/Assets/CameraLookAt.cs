using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraLookAt : MonoBehaviour
{
    public Transform player;
    public Transform center;
    private Transform cameraTransform;
    private float minY = -20.0f;
    private float maxY = 5.0f;

    private void Start()
    {
        cameraTransform = transform;
    }

    private void Update()
    {
        if (player != null && center != null && SpeedModifier.GameHasStarted)
        {
            // Calculate the center point
            Vector3 centerPoint = (player.position + center.position) / 2.0f;

            // Make the camera look at the center point
            cameraTransform.LookAt(centerPoint);

            // Get the current Y-axis rotation
            float currentYRotation = cameraTransform.eulerAngles.y;

            // Clamp the Y-axis rotation within the specified range
            currentYRotation = Mathf.Clamp(currentYRotation, minY, maxY);

            // Apply the clamped rotation
            cameraTransform.eulerAngles = new Vector3(61.9430122f, currentYRotation, 0);
        }
    }
}
