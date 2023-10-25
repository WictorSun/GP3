using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.UI;

public class UISpawner : MonoBehaviour
{
    public GameObject goTo;
    private Vector2 start;
    private Vector2 End;
    public bool not;
    private Vector2 maxEnd;
    private Vector2 minEnd;
    private float timePassed;
    private float duration;

    private float speed;
    private float maxSpeed = 5000f;
    private float minSpeed = 2000f;
    private void Start()
    {
        minEnd = new Vector2((goTo.transform.position.x -80f), goTo.transform.position.y);
        maxEnd = new Vector2((goTo.transform.position.x + 80f), goTo.transform.position.y);
        start = transform.position;
        float x = Random.Range(minEnd.x, maxEnd.x);
        End = new Vector2(x, goTo.transform.position.y);
        speed = Random.Range(minSpeed, maxSpeed);
        duration = Vector2.Distance(start, End) / speed;
        timePassed = 0f;

       
    }
    private void Update()
    {
        if (not)
        {
            if (timePassed >= duration)
            {
                transform.position = End;
                Destroy(this.gameObject);
            }

            var factor = timePassed / duration;
            factor = Mathf.SmoothStep(0, 1, factor);
            transform.position = Vector3.Slerp(start, End, factor);
            timePassed += Time.deltaTime;
        }
       

    }
}
