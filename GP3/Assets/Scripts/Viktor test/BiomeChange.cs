using UnityEngine;

public class BiomeChange : MonoBehaviour
{
    public GameObject forest;
    public GameObject desert;
    public GameObject forestToDesert;
    public GameObject player;
    public GameObject[] forrestPrefabs;

   
    private bool past500;
    private bool Switch;
    [SerializeField] private MoveComponent moveComponent;

    void Start()
    {
        // Find child GameObjects by their name
        //forest = transform.Find("forest").gameObject;
        //desert = transform.Find("desert").gameObject;
        //forestToDesert = transform.Find("forestToDesert").gameObject;
    }

    void Update()
    {
        // Update past500 based on GameController.Distance
        float distance = GameController.Distance; // Assuming GameController.Distance returns a float
        past500 = (distance >= 100);
        Switch = ((distance >= 100) && (distance <= 110));
        if (GameController.IsReturning)
        {
            Switch = ((distance >= 100) && (distance <= 110));
        }
        //Debug.Log($"Current Distance: {distance}, Past 500: {past500}");

        // Check if this tile is near the despawn distance
        float tileDistanceFromDespawn = transform.position.z - player.transform.position.z;//Mathf.Abs(transform.position.z - moveComponent.despawnDistance);
        if (tileDistanceFromDespawn <= -30f && !GameController.IsReturning)
        {
            if (Switch)
            {
                EnableSwitch();
            }
            else if (past500)
            {
                EnableDesert();
            }
            else
            {
                EnableForest();
            }
        }
        else if (tileDistanceFromDespawn <= -40f && GameController.IsReturning)
        {
            if (Switch)
            {
                EnableSwitch();
                
            }
            else if (past500)
            {
                EnableDesert();
            }
            else
            {
                EnableForest();
            }
        }
    }

    private void EnableDesert()
    {
        foreach (GameObject prefab in forrestPrefabs)
        {
            prefab.SetActive(false);
        }
        // Enable desert and disable other biomes
        desert.SetActive(true);
        forest.SetActive(false);
        forestToDesert.SetActive(false);
    }

    private void EnableForest()
    {
        //Debug.Log("Forest Enabled");
        // Enable forest and disable other biomes
        int RandomOption = Random.Range(0, forrestPrefabs.Length);
        foreach (GameObject prefab in forrestPrefabs)
        {
            prefab.SetActive(false);
        }
        desert.SetActive(false);
        forestToDesert.SetActive(false);
        forrestPrefabs[RandomOption].SetActive(true);
       
    }

    private void EnableSwitch()
    {
        
        forest.SetActive(false);
        desert.SetActive(false);
        forestToDesert.SetActive(true);
    }
}

