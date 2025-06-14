using System.Collections;
using System.Net;
using Newtonsoft.Json;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using UnityEngine;



public class ServoData
{
    public int Servo1PWM { get; set; }
    public float Servo1Tem { get; set; }
    public float Servo1Vol { get; set; }
    public int Servo2PWM { get; set; }
    public float Servo2Tem { get; set; }
    public float Servo2Vol { get; set; }
    public int Servo3PWM { get; set; }
    public float Servo3Tem { get; set; }
    public float Servo3Vol { get; set; }
    public int Servo4PWM { get; set; }
    public float Servo4Tem { get; set; }
    public float Servo4Vol { get; set; }
    public int Servo5PWM { get; set; }
    public float Servo5Tem { get; set; }
    public float Servo5Vol { get; set; }
    public int Servo6PWM { get; set; }
    public float Servo6Tem { get; set; }
    public float Servo6Vol { get; set; }
}

public class Listener : MonoBehaviour
{
    Thread thread;
    public string serverAddress = "127.0.0.1"; // Server IP address or hostname
    //public string serverAddress = "192.168.100.245";
    public int serverPort = 6000;
    TcpClient client;
    bool running;
    bool connected = false;
    ServoData servoData;

    void Start()
    {
        // Run the connection logic on a separate thread
        ThreadStart ts = new ThreadStart(HandleConnection);
        thread = new Thread(ts);
        thread.Start();
        //Debug.Log("TCP/IP Start");
    }

    void OnDestroy()
    {
        running = false;

        if (client != null)
        {
            client.Close();
        }

        if (thread != null && thread.IsAlive)
        {
            thread.Abort();
        }
    }

    void HandleConnection()
    {
        running = true;

        while (running)
        {
            try
            {
                if (!connected)
                {
                    Debug.Log("Attempting to connect to the server...");
                    client = new TcpClient(serverAddress, serverPort);
                    connected = true;
                    Debug.Log("Connected to the server!");
                }

                // Listen for data from the server
                ReceiveData();
            }
            catch (SocketException)
            {
                Debug.LogWarning("Server unavailable. Retrying connection...");
                connected = false;

                // Wait for a short delay before retrying
                Thread.Sleep(2000);
            }
            catch (System.Exception e)
            {
                Debug.LogError($"Unexpected error: {e.Message}");
                connected = false;

                // Close the client if any unexpected error occurs
                if (client != null)
                {
                    client.Close();
                }
            }
        }
    }

    void ReceiveData()
    {
        NetworkStream nwStream = client.GetStream();
        byte[] buffer = new byte[client.ReceiveBufferSize];
        string partialData = string.Empty;

        while (running && connected)
        {
            try
            {
                if (nwStream.DataAvailable)
                {
                    int bytesRead = nwStream.Read(buffer, 0, buffer.Length);
                    if (bytesRead > 0)
                    {
                        partialData += Encoding.UTF8.GetString(buffer, 0, bytesRead).Trim();

                        // Split data into valid JSON objects if using a delimiter
                        while (true)
                        {
                            int startIndex = partialData.IndexOf('{');
                            int endIndex = partialData.IndexOf('}');
                            if (startIndex != -1 && endIndex > startIndex)
                            {
                                string jsonString = partialData.Substring(startIndex, endIndex - startIndex + 1);
                                partialData = partialData.Substring(endIndex + 1);

                                try
                                {
                                    servoData = JsonConvert.DeserializeObject<ServoData>(jsonString);

                                    // Handle data
                                    //Debug.Log($"Servo1 PWM: {servoData.Servo1PWM}, Temp: {servoData.Servo1Tem}, Voltage: {servoData.Servo1Vol}");
                                }
                                catch (JsonException ex)
                                {
                                    Debug.LogError($"JSON Parsing Error: {ex.Message}");
                                }
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                }
            }
            catch (SocketException)
            {
                Debug.LogWarning("Connection lost. Attempting to reconnect...");
                connected = false;
            }
        }
    }


    public float ServoFeedbackAngle(int servoID)
    {
        if (servoData == null)
        {
            Debug.LogWarning("ServoData is null. Returning default value.");
            return 0; // Return a default value or handle as needed
        }

        switch (servoID)
        {
            case 1: return servoData.Servo1PWM;
            case 2: return servoData.Servo2PWM;
            case 3: return servoData.Servo3PWM;
            case 4: return servoData.Servo4PWM;
            case 5: return servoData.Servo5PWM;
            case 6: return servoData.Servo6PWM;
            default: return 404; // Invalid servoID
        }
    }
}
