using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Joint5_Motion : MonoBehaviour
{
    //[SerializeField] private TCPListener tcpListener;
    [SerializeField] private mainListener Listener;
    [SerializeField] private Servo_MathModel servo_mathModel;
    public GameObject RotatePoint;

    private float angle;
    private int PWM;
    void Update()
    {
        angle = Listener.ServoFeedbackAngle(5);
        //angle = 185.00f;
        //angle = servo_mathModel.Servo5Model(PWM);
        //angle = PWM / 10.0f;
        RotatePoint.transform.localRotation = Quaternion.Euler(0, -(angle - 130f), 0);
    }
}
