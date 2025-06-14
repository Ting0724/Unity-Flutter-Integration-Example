using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCamera : MonoBehaviour
{
    [Header("Movement Settings")]
    [SerializeField] private float moveSpeed = 1000f;
    [SerializeField] private float fastMoveSpeed = 25f; // When holding Shift
    [SerializeField] private float rotationSpeed = 100f;
    [SerializeField] private float zoomSpeed = 300f;
    [SerializeField] private float smoothTime = 0.15f; // Smoothing factor

    private Vector3 _moveVelocity;
    private float _currentSpeed;
    private bool _isRotating;

    void Update()
    {
        HandleRotation();
        HandleMovement();
        HandleZoom();
    }

    private void HandleRotation()
    {
        // Right-click and drag to rotate
        if (Input.GetMouseButtonDown(1))
        {
            _isRotating = true;
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
        }

        if (Input.GetMouseButtonUp(1))
        {
            _isRotating = false;
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }

        if (_isRotating)
        {
            float mouseX = Input.GetAxis("Mouse X") * rotationSpeed * Time.deltaTime;
            float mouseY = Input.GetAxis("Mouse Y") * rotationSpeed * Time.deltaTime;

            transform.Rotate(Vector3.up, mouseX, Space.World);
            transform.Rotate(Vector3.left, mouseY, Space.Self);
        }
    }

    private void HandleMovement()
    {
        // Hold Shift to move faster
        _currentSpeed = Input.GetKey(KeyCode.LeftShift) ? fastMoveSpeed : moveSpeed;

        Vector3 moveInput = new Vector3(
            Input.GetAxis("Horizontal"),
            Input.GetAxis("Vertical"),
            Input.GetKey(KeyCode.Q) ? -1 : (Input.GetKey(KeyCode.E) ? 1 : 0)
        );

        // Smooth movement using SmoothDamp
        Vector3 targetPosition = transform.position +
            (transform.forward * moveInput.z +
             transform.right * moveInput.x +
             transform.up * moveInput.y) * _currentSpeed * Time.deltaTime;

        transform.position = Vector3.SmoothDamp(
            transform.position,
            targetPosition,
            ref _moveVelocity,
            smoothTime
        );
    }

    private void HandleZoom()
    {
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (Mathf.Abs(scroll) > 0.01f)
        {
            Vector3 zoomDirection = transform.forward * scroll * zoomSpeed;
            transform.position += zoomDirection;
        }
    }
}
