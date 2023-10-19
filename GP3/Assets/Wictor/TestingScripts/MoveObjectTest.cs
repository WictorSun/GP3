using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveObjectTest : MonoBehaviour
{
    [SerializeField] private float moveSpeed;

    void Update()
    {
        transform.Translate((Vector3.forward*-1f) * Time.deltaTime * moveSpeed);
    }
}
