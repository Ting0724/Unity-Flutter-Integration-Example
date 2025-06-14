using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lime : MonoBehaviour
{
    private Renderer objectRenderer;
    [SerializeField] private mainListener Listener;
    [SerializeField] private string control = "Off";
    void Start()
    {
        objectRenderer = GetComponent<Renderer>();

        if (Listener == null)
        {
            Listener = FindObjectOfType<mainListener>();
        }
    }

    void Update()
    {
        if (Listener != null)
        {
            // Get the latest IRBoxConveyor value
            control = Listener.UnityControlData(6);
            // Toggle visibility based on the sensor value
            objectRenderer.enabled = control == "On";
        }
        if (control == "Good_lime")
        {
            objectRenderer.material.color = Color.green;
            objectRenderer.enabled = true;
        }
        else if (control == "Bad_lime")
        {
            objectRenderer.material.color = Color.black;
            objectRenderer.enabled = true;
        }
        else
        {
            objectRenderer.enabled = false;
        }
    }
}
