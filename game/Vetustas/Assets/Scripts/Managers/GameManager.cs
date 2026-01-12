using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : Singleton<GameManager> {

    public static int mLogoSceneType = 0;
    public static bool mIsPause = false;
    public static float mGameTimeScale = 1.0f;

    public RectTransform mSceneCamera;
    public static float mGameDeltaTime
    {
        get
        {
            return Time.deltaTime * mGameTimeScale;
        }
    }

    private void Awake()
    {
        if (GameManager.Instance != null && GameManager.Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        DontDestroyOnLoad(this);
    }

    //해상도 조절
    public void SetScreenScale()
    {
        Screen.SetResolution(1280, 720, true);
        float tTargetWidthAspect = 16.0f;
        float tTargetHeightAspect = 9.0f;

        Camera tMainCamera = Camera.main;
        tMainCamera.aspect = tTargetWidthAspect / tTargetHeightAspect;

        float tWidthRatio = (float)Screen.width / tTargetWidthAspect;
        float tHeightRatio = (float)Screen.height / tTargetHeightAspect;

        float tHeightAdd = ((tWidthRatio / (tHeightRatio / 100)) - 100) / 200;
        float tWidthAdd = ((tHeightRatio / (tWidthRatio / 100)) - 100) / 200;

        if (tHeightRatio > tWidthRatio)
        {
            tWidthAdd = 0.0f;
        }
        else
        {
            tHeightAdd = 0.0f;
        }

        tMainCamera.rect = new Rect(
            tMainCamera.rect.x + Mathf.Abs(tWidthAdd),
            tMainCamera.rect.y + Mathf.Abs(tHeightAdd),
            tMainCamera.rect.width + (tWidthAdd * 2),
            tMainCamera.rect.height + (tHeightAdd * 2));
    }

    public void ShakeCamera(float tDuration, float tMagnitude)
    {
        StartCoroutine(Shake(tDuration, tMagnitude));
    }

    IEnumerator Shake (float tDuration, float tMagnitude)
    {
        if (mSceneCamera != null)
        { 
            Vector3 tOriginalPos = mSceneCamera.transform.localPosition;

            float tElapsed = 0.0f;

            while (tElapsed < tDuration)
            {
                float tX = Random.Range(-1.0f, 1.0f) * tMagnitude;
                float tY = Random.Range(-1.0f, 1.0f) * tMagnitude;

                mSceneCamera.transform.localPosition = new Vector3(tX, tY, tOriginalPos.z);

                tElapsed += Time.deltaTime;

                yield return null;
            }

            mSceneCamera.transform.localPosition = tOriginalPos;
        }
    }
}
