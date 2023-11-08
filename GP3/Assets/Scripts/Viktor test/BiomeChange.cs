using UnityEngine;

public class BiomeChange : MonoBehaviour
{
    public GameObject forest;
    public GameObject desert;
    public GameObject forestToDesert;
    public GameObject player;
    public GameObject[] forrestPrefabs;
    public GameObject[] autumnPrefabs;
    public GameObject[] desertPrefabs;
    public GameObject forestToAutmn;
    public GameObject autumnToDesert;

    

    private bool Forrest;
    private bool Autumn;
    private bool Desert;
    private bool Switch;
    private bool Switch2;
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
        float distance = GameController.Distance;
      
            Forrest = (distance <= 100);
            Switch = ((distance >= 100) && (distance <= 105));
            Autumn = ((distance >= 105) && (distance <= 200));
            Switch2 = ((distance >= 200) && (distance <= 210));
            Desert = ((distance >= 211));
       
       
        float tileDistanceFromDespawn = transform.position.z - player.transform.position.z;//Mathf.Abs(transform.position.z - moveComponent.despawnDistance);
        if (tileDistanceFromDespawn <= -30f && !GameController.IsReturning)
        {
            if (Forrest)
            {
                EnableForest();
            }
            else if (Switch)    
            {
                EnableSwitchAutumn();
            }
            else if(Autumn)
            {
                EnableAutumn();
            }
            else if (Switch2)
            {
                EnableSwitchDesert();
            }
            else if (Desert)
            {
                EnableDesert();
            }
        }
        else if (tileDistanceFromDespawn <= -40f && GameController.IsReturning)
        {
            if (Forrest)
            {
                EnableForest();
            }
            else if (Switch)
            {
                EnableSwitchAutumn();
            }
            else if (Autumn)
            {
                EnableAutumn();
            }
            else if (Switch2)
            {
                EnableSwitchDesert();
            }
            else if (Desert)
            {
                EnableDesert();
            }
        }
    }

    private void EnableDesert()
    {
        int RandomOption = Random.Range(0, desertPrefabs.Length);
        foreach (GameObject prefab in forrestPrefabs)
        {
            prefab.SetActive(false);
        }
        foreach (GameObject prefab in autumnPrefabs)
        {
            prefab.SetActive(false);
        }
        foreach (GameObject prefab in desertPrefabs)
        {
            prefab.SetActive(false);
        }
        // Enable desert and disable other biomes
        forest.SetActive(false);
        desert.SetActive(false);
        forestToDesert.SetActive(false);
        forestToAutmn.SetActive(false);
        autumnToDesert.SetActive(false);
        desertPrefabs[RandomOption].SetActive(true);
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
        foreach (GameObject prefab in autumnPrefabs)
        {
            prefab.SetActive(false);
        }
        foreach (GameObject prefab in desertPrefabs)
        {
            prefab.SetActive(false);
        }
        forest.SetActive(false);
        desert.SetActive(false);
        forestToDesert.SetActive(false);
        forestToAutmn.SetActive(false);
        autumnToDesert.SetActive(false);
        forrestPrefabs[RandomOption].SetActive(true);
       
    }
    private void EnableAutumn()
    {
        int RandomOption = Random.Range(0, autumnPrefabs.Length);
        foreach (GameObject prefab in autumnPrefabs)
        {
            prefab.SetActive(false);
        }

        foreach (GameObject prefab in forrestPrefabs)
        {
            prefab.SetActive(false);
        }
        foreach (GameObject prefab in desertPrefabs)
        {
            prefab.SetActive(false);
        }
        forest.SetActive(false);
     desert.SetActive(false);
     forestToDesert.SetActive(false);
     forestToAutmn.SetActive(false);
     autumnToDesert.SetActive(false);
     autumnPrefabs[RandomOption].SetActive(true);
    }
    private void EnableSwitchAutumn()
    {
        foreach (GameObject prefab in autumnPrefabs)
        {
            prefab.SetActive(false);
        }

        foreach (GameObject prefab in forrestPrefabs)
        {
            prefab.SetActive(false);
        }
        foreach (GameObject prefab in desertPrefabs)
        {
            prefab.SetActive(false);
        }
        forest.SetActive(false);
        desert.SetActive(false);
        forestToDesert.SetActive(false);
        forestToAutmn.SetActive(true);
        autumnToDesert.SetActive(false);
    }
    private void EnableSwitchDesert()
    {
        foreach (GameObject prefab in autumnPrefabs)
        {
            prefab.SetActive(false);
        }

        foreach (GameObject prefab in forrestPrefabs)
        {
            prefab.SetActive(false);
        }
        foreach (GameObject prefab in desertPrefabs)
        {
            prefab.SetActive(false);
        }
        forest.SetActive(false);
        desert.SetActive(false);
        forestToDesert.SetActive(false);
        forestToAutmn.SetActive(false);
        autumnToDesert.SetActive(true);
    }
}

