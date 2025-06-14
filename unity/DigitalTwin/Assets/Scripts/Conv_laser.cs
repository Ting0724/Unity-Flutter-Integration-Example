using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Conv_laser : MonoBehaviour
{
    private Renderer objectRenderer;
    [SerializeField] private mainListener Listener;
    [SerializeField] private string control = "Off";
    private int LaserValue = 1000;
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
            control = Listener.SensorData(6);
            //Debug.Log($"This the laser: {control}");
            if (control != "")
            {
                LaserValue = int.Parse(control);
            }
            else
            {
                LaserValue = 1000;
            }
            // Toggle visibility based on the sensor value
            objectRenderer.enabled = control == "On";
        }
        if (LaserValue < 70)
        {
            objectRenderer.enabled = true;
        }
        else
        {
            objectRenderer.enabled = false;
        }
    }
}
