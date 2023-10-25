using UnityEngine;

public class DespawnGround : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        // Check if the colliding object has the "Ground" tag
        if (other.CompareTag("Ground"))
        {
            // Deactivate the ground object
            other.gameObject.SetActive(false);
        }
    }
}
