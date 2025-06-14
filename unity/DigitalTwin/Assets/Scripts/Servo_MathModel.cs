using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class Servo_MathModel : MonoBehaviour
{
    // Coefficients for Servo 1
    private const float Servo1_p1 = 0.1355f;
    private const float Servo1_p2 = -68.9502f;  

    // Coefficients for Servo 2
    private const float Servo2_p1 = 0.1345f;
    private const float Servo2_p2 = -65.8601f;

    // Coefficients for Servo 3
    private const float Servo3_p1 = 0.1352f;
    private const float Servo3_p2 = -69.1186f;

    // Coefficients for Servo 4
    private const float Servo4_p1 = 0.1337f;
    private const float Servo4_p2 = -75.3556f;

    // Coefficients for Servo 5
    private const float Servo5_p1 = 0.3136f;
    private const float Servo5_p2 = 0.8976f;
    private const float Servo5_p3 = -90.9239f;

    // Coefficients for Servo 6
    private const float Servo6_p1 = 0.1343f;
    private const float Servo6_p2 = -73.0095f;

    // Method for Servo 1 model
    public float Servo1Model(int x)
    {
        return (Servo1_p1 * x) + Servo1_p2;
    }

    // Method for Servo 2 model
    public float Servo2Model(int x)
    {
        return (Servo2_p1 * x) + Servo2_p2;
    }

    // Method for Servo 3 model
    public float Servo3Model(int x)
    {
        return (Servo3_p1 * x) + Servo3_p2;
    }

    // Method for Servo 4 model
    public float Servo4Model(int x)
    {
        return (Servo4_p1 * x) + Servo4_p2;
    }

    // Method for Servo 5 model
    public float Servo5Model(int x)
    {
        return (Servo5_p1 * (float)Math.Pow(x, Servo5_p2)) + Servo5_p3;
    }

    // Method for Servo 6 model
    public float Servo6Model(int x)
    {
        return (Servo6_p1 * x) + Servo6_p2;
    }
}
