using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IR_Box2 : MonoBehaviour
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
            control = Listener.SensorData(2);
        }
        if (control == "Off")
        {
            objectRenderer.material.color = new Color(0.4f, 0.6f, 0.8f);
        }
        else
        {
            objectRenderer.material.color = Color.red;
        }
    }
}
