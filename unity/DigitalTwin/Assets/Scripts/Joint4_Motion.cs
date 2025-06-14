using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Joint4_Motion : MonoBehaviour
{
    //[SerializeField] private TCPListener tcpListener;
    [SerializeField] private mainListener Listener;
    [SerializeField] private Servo_MathModel servo_mathModel;
    public GameObject RotatePoint;

    private float angle;
    private int PWM;
    void Update()
    {
        angle = Listener.ServoFeedbackAngle(4);
        //angle = servo_mathModel.Servo4Model(PWM);
        //angle = PWM / 10.0f;
        RotatePoint.transform.localRotation = Quaternion.Euler(0, 0, -(angle - 130f));
    }
}
