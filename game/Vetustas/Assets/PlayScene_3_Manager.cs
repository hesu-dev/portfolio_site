using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayScene_3_Manager : MonoBehaviour {

    public CanvasGroup mStorySceneCanvasGroup;
    public CanvasScaler mStorySceneCanvasScaler;

    private void Awake()
    {
        CanvasManager.Instance.SetCanvasScreen(mStorySceneCanvasScaler);
        FadeManager.Instance.FadeIn_Canvas(1.0f, delegate { });
    }
}
