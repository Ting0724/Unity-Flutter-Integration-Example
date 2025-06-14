using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Box2 : MonoBehaviour
{
    private Renderer objectRenderer;
    [SerializeField] private mainListener Listener;
    [SerializeField] private string control = "Off";
    [SerializeField] private string unity_control = "Off";
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
            control = Listener.SensorData(2);
            unity_control = Listener.UnityControlData(2);
            // Toggle visibility based on the sensor value
            objectRenderer.enabled = control == "On";
        }
        if (control == "Off" || unity_control == "On")
        {
            objectRenderer.enabled = false;
        }
        else
        {
            objectRenderer.enabled = true;
        }
    }
}
