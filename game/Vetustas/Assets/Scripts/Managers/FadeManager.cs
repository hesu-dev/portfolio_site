using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeManager : Singleton<FadeManager> {

    public CanvasGroup mFadeCanvas = null;
    
    public void FadeIn_Image(float fadeInTime, System.Action nextEvent = null, Image tImage = null)
    {
        StartCoroutine(CoFadeIn_Image(fadeInTime, nextEvent, tImage));
    }

    public void FadeOut_Image(float fadeOutTime, System.Action nextEvent = null, Image tImage = null)
    {
        StartCoroutine(CoFadeOut_Image(fadeOutTime, nextEvent, tImage));
    }

    public void FadeIn_Canvas(float fadeInTime, System.Action nextEvent = null, CanvasGroup mCanvasGroup = null)
    {
        StartCoroutine(CoFadeIn_Canvas(fadeInTime, nextEvent, mCanvasGroup));
    }

    public void FadeOut_Canvas(float fadeOutTime, System.Action nextEvent = null, CanvasGroup mCanvasGroup = null)
    {
        StartCoroutine(CoFadeOut_Canvas(fadeOutTime, nextEvent, mCanvasGroup));
    }

    public void FadeInAndOut_Canvas(float fadeInTime, float fadeStayTime, float fadeOutTime, System.Action nextEvent = null, CanvasGroup mCanvasGroup = null)
    {
        StartCoroutine(CoFadeInAndOut_Canvas(fadeInTime, fadeStayTime, fadeOutTime, nextEvent, mCanvasGroup));
    }

    public void FadeOutAndIn_Image(float fadeInTime, float fadeStayTime, float fadeOutTime, System.Action nextEvent = null, Image tImage = null)
    {
        StartCoroutine(CoFadeOutAndIn_Image(fadeInTime, fadeStayTime, fadeOutTime, nextEvent, tImage));
    }

    // 
    IEnumerator CoFadeInAndOut_Canvas(float fadeInTime, float fadeStayTime, float fadeOutTime, System.Action nextEvent = null, CanvasGroup mCanvasGroup = null)
    {
        if (mFadeCanvas != null)
        {
            mFadeCanvas.blocksRaycasts = true;
            float tTemp = mFadeCanvas.alpha;

            while (tTemp > 0.0f)
            {
                tTemp -= GameManager.mGameDeltaTime / fadeInTime;
                mFadeCanvas.alpha = tTemp;

                if (tTemp <= 0.0f)
                {
                    tTemp = 0.0f;
                }

                yield return null;
            }
            mFadeCanvas.alpha = tTemp;

            yield return new WaitForSeconds(fadeStayTime);

            while (tTemp < 1.0f)
            {
                tTemp += GameManager.mGameDeltaTime / fadeOutTime;
                mFadeCanvas.alpha = tTemp;

                if (tTemp >= 1.0f)
                {
                    tTemp = 1.0f;
                    mFadeCanvas.blocksRaycasts = false;
                }

                yield return null;
            }
            mFadeCanvas.alpha = tTemp;

            if (nextEvent != null)
            {
                nextEvent();
            }
        }
    }

    IEnumerator CoFadeOutAndIn_Image(float fadeInTime, float fadeStayTime, float fadeOutTime, System.Action nextEvent = null, Image tImage = null)
    {
        if (tImage != null)
        {
            Color tempColor = tImage.color;


            while (tempColor.a > 0f)
            {
                tempColor.a -= GameManager.mGameDeltaTime / fadeOutTime;
                tImage.color = tempColor;

                if (tempColor.a <= 0f)
                {
                    tempColor.a = 0f;
                }

                yield return null;
            }
            tImage.color = tempColor;

            yield return new WaitForSeconds(fadeStayTime);

            while (tempColor.a < 1.0f)
            {
                tempColor.a += GameManager.mGameDeltaTime / fadeInTime;
                tImage.color = tempColor;

                if (tempColor.a >= 1f)
                {
                    tempColor.a = 1f;
                }

                yield return null;
            }
            tImage.color = tempColor;

            if (nextEvent != null)
            {
                nextEvent();
            }
        }
    }

    // 투명 -> 불투명
    IEnumerator CoFadeIn_Image(float fadeInTime, System.Action nextEvent = null, Image tImage = null)
    {        
        Color tempColor = tImage.color;
        while (tempColor.a < 1f)
        {
            tempColor.a += GameManager.mGameDeltaTime / fadeInTime;
            tImage.color = tempColor;

            if (tempColor.a >= 1f) tempColor.a = 1f;

            yield return null;
        }
        tImage.color = tempColor;
        if (nextEvent != null) nextEvent();
    }

    // 불투명 -> 투명
    IEnumerator CoFadeOut_Image(float fadeOutTime, System.Action nextEvent = null, Image tImage = null)
    {        
        Color tempColor = tImage.color;
        while (tempColor.a > 0f)
        {
            tempColor.a -= GameManager.mGameDeltaTime / fadeOutTime;
            tImage.color = tempColor;

            if (tempColor.a <= 0f) tempColor.a = 0f;

            yield return null;
        }
        tImage.color = tempColor;
        if (nextEvent != null) nextEvent();
    }

    IEnumerator CoFadeIn_Canvas(float fadeInTime, System.Action nextEvent = null, CanvasGroup mCanvasGroup = null)
    {
        if (mFadeCanvas != null)
        {
            mFadeCanvas.blocksRaycasts = true;
            float tTemp = mFadeCanvas.alpha;
            while (tTemp > 0.0f)
            {
                tTemp -= GameManager.mGameDeltaTime / fadeInTime;
                mFadeCanvas.alpha = tTemp;

                if (tTemp <= 0.0f)
                {
                    tTemp = 0.0f;
                    mFadeCanvas.blocksRaycasts = false;
                }

                yield return null;                              
            }
            mFadeCanvas.alpha = tTemp;
            if (nextEvent != null)
            {
                nextEvent();
            }
        }
    }
    IEnumerator CoFadeOut_Canvas(float fadeOutTime, System.Action nextEvent = null, CanvasGroup mCanvasGroup = null)
    {
        if (mFadeCanvas != null)
        {
            mFadeCanvas.blocksRaycasts = true;
            float tTemp = mFadeCanvas.alpha;
            while (tTemp < 1.0f)
            {
                tTemp += GameManager.mGameDeltaTime / fadeOutTime;
                mFadeCanvas.alpha = tTemp;

                if (tTemp >= 1.0f)
                {
                    tTemp = 1.0f;
                    mFadeCanvas.blocksRaycasts = false;
                }

                yield return null;
            }
            mFadeCanvas.alpha = tTemp;
            if (nextEvent != null)
            {
                nextEvent();
            }
        }

        //yield return null;
    }
}
