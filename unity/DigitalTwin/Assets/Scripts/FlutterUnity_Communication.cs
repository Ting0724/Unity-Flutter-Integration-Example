using System.Collections;
using UnityEngine;
using FlutterUnityIntegration;

public class FlutterUnity_Communication : MonoBehaviour
{
    [SerializeField] private mainListener Listener;

    void Start()
    {
        StartCoroutine(DelayUpdateFunction());
    }

    private IEnumerator DelayUpdateFunction()
    {
        while (true)
        {
            yield return new WaitForSeconds(0.3f);
            MessengerToFlutter(Listener.FlutterFeedbackMessage());
        }
    }

    public void MessengerToFlutter(string message)
    {
        if (UnityMessageManager.Instance != null)
        {
            UnityMessageManager.Instance.SendMessageToFlutter(message);
            //Debug.Log("Message sent to Flutter: " + message);
        }
        else
        {
            Debug.LogError("UnityMessageManager.Instance is null!");
        }
    }

    public void MessengerFromFlutter(string message)
    {
        Debug.Log("Message from Flutter: " + message);
    }
}