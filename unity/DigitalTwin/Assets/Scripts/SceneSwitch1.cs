using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class SceneSwitch1 : MonoBehaviour
{
    [Header("Settings")]
    public int targetSceneBuildIndex = 1; // Set this in Inspector
    public string buttonText = "SCENE 2";

    void Start()
    {
        // Get or create button components
        Button button = GetComponent<Button>();
        if (button == null) button = gameObject.AddComponent<Button>();

        // Setup button visuals (if using TextMeshPro)
        TMP_Text textComponent = GetComponentInChildren<TMP_Text>();
        if (textComponent != null)
        {
            textComponent.text = buttonText;
            textComponent.fontSize = 24;
            textComponent.color = Color.white;
        }

        // Set button colors
        ColorBlock colors = button.colors;
        colors.normalColor = new Color32(75, 175, 75, 255); // Green
        colors.highlightedColor = new Color32(100, 200, 100, 255);
        colors.pressedColor = colors.highlightedColor;
        button.colors = colors;

        // Add click handler
        button.onClick.AddListener(() => {
            SwitchToScene(targetSceneBuildIndex);
        });
    }

    public void SwitchToScene(int buildIndex)
    {
        // Optional: Add fade effect before loading
        StartCoroutine(LoadSceneAsync(buildIndex));
    }

    IEnumerator LoadSceneAsync(int buildIndex)
    {
        // Optional: Add loading screen logic here
        AsyncOperation asyncLoad = SceneManager.LoadSceneAsync(buildIndex);

        while (!asyncLoad.isDone)
        {
            float progress = Mathf.Clamp01(asyncLoad.progress / 0.9f);
            Debug.Log($"Loading progress: {progress * 100}%");
            yield return null;
        }
    }
}
