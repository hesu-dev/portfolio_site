using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayScene_2_Manager : MonoBehaviour {

    public CanvasGroup mPlaySceneCanvasGroup;
    public CanvasScaler mPlaySceneCanvasScaler;

    public CanvasGroup mStorySceneCanvasGroup;
    public CanvasScaler mStorySceneCanvasScaler;

    private void Awake()
    {
        CanvasManager.Instance.SetCanvasScreen(mPlaySceneCanvasScaler);
        CanvasManager.Instance.SetCanvasScreen(mStorySceneCanvasScaler);
    }
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
