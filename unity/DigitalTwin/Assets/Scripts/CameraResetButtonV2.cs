using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CameraResetButtonV2 : MonoBehaviour
{
    [Header("References")]
    public CinemachineVirtualCamera vcam;

    [Header("Reset Pose")]
    public Vector3 resetPosition = new Vector3(419.619f, 909.6365f, -1365.486f);
    public Vector3 resetRotation = new Vector3(32.713f, -6.701f, -0.011f);
    public Vector3 resetOffset = new Vector3(0, 3, -5);

    private CinemachineTransposer transposer;
    private Transform previousFollow;
    private Transform previousLookAt;

    void Start()
    {
        // Initialize components
        if (vcam != null)
        {
            transposer = vcam.GetCinemachineComponent<CinemachineTransposer>();
            previousFollow = vcam.Follow;
            previousLookAt = vcam.LookAt;
        }

        // Button setup
        Button button = GetComponent<Button>();
        if (button == null) return;

        TMP_Text buttonText = GetComponentInChildren<TMP_Text>(true);
        if (buttonText == null) return;

        buttonText.text = "INIT CAM";
        buttonText.fontStyle = FontStyles.Bold;
        buttonText.fontSize = 30;
        buttonText.color = Color.black;

        ColorBlock colors = button.colors;
        colors.normalColor = new Color32(66, 133, 244, 255);
        colors.highlightedColor = new Color32(82, 149, 255, 255);
        colors.pressedColor = colors.highlightedColor;
        button.colors = colors;

        button.onClick.AddListener(ResetVirtualCamera);
    }

    public void ResetVirtualCamera()
    {
        if (vcam == null) return;

        // Disable tracking temporarily
        vcam.Follow = null;
        vcam.LookAt = null;

        // Apply reset pose
        vcam.transform.SetPositionAndRotation(resetPosition, Quaternion.Euler(resetRotation));
        if (transposer != null) transposer.m_FollowOffset = resetOffset;

        // Restore tracking
        StartCoroutine(RestoreTracking());
    }

    IEnumerator RestoreTracking()
    {
        yield return null; // Critical wait for one frame
        vcam.Follow = previousFollow;
        vcam.LookAt = previousLookAt;
    }
}
