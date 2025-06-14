using System.Collections;
using System.Collections.Generic;
using System.Net.Sockets;
using UnityEngine;

public class Joint1_Motion : MonoBehaviour
{
    //[SerializeField] private TCPListener tcpListener;
    [SerializeField] private mainListener Listener;
    [SerializeField] private Servo_MathModel servo_mathModel;
    public GameObject RotatePoint;

    private float angle;
    private int PWM;
    void Update()
    {
        //PWM = tcpListener.ServoFeedbackAngle(1);
        angle = Listener.ServoFeedbackAngle(1);
        //angle = servo_mathModel.Servo1Model(PWM);
        //angle = PWM / 10.0f;
        //-(angle - 130f)
        RotatePoint.transform.localRotation = Quaternion.Euler(-(angle - 130f), -90.0f, -90.0f);
    }
}
