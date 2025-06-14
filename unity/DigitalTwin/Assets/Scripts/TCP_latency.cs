using System;
using System.Net.Sockets;
using System.Text;
using UnityEngine;

public class TCPClient : MonoBehaviour
{
    private TcpClient client;
    private NetworkStream stream;
    private byte[] data;
    [SerializeField] private mainListener Listener;

    void Start()
    {
        try
        {
            // Connect to Python Server
            client = new TcpClient("127.0.0.1", 5005); // Change IP & port if necessary
            stream = client.GetStream();
            Debug.Log("Connected to Python server");

            if (Listener == null)
            {
                Listener = FindObjectOfType<mainListener>();
            }
        }
        catch (Exception e)
        {
            Debug.LogError("Failed to connect: " + e.Message);
        }
    }

    void Update()
    {
        if (client == null || !client.Connected)
        {
            return; // Skip if not connected
        }

        if (Listener != null)
        {
            double latency = Listener.LatencyValue();
            SendLatency(latency);
        }
    }

    void SendLatency(double latency)
    {
        try
        {
            string message = latency.ToString("F3"); // Convert to string with 3 decimal places
            data = Encoding.UTF8.GetBytes(message);
            stream.Write(data, 0, data.Length);
            Debug.Log("Sent latency: " + message);
        }
        catch (Exception e)
        {
            Debug.LogError("Error sending data: " + e.Message);
        }
    }

    private void OnApplicationQuit()
    {
        // Close connection when Unity quits
        stream?.Close();
        client?.Close();
    }
}
