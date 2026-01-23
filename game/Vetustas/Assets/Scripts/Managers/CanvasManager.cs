using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CanvasManager : Singleton<CanvasManager> {

    protected Vector2 mScreenSize;

    protected float mSetCanvasRatio;

    protected float mScreenRatio;
    protected float mBasicScreenRatio;


    public void CalScreenScale()
    {
        mBasicScreenRatio = 16.0f / 9.0f;

        mScreenSize = new Vector2(Screen.width, Screen.height);
        mScreenRatio = mScreenSize.y / mScreenSize.x;
    }

    public void SetCanvasScreen(CanvasScaler tCanvasScaler)
    {
        if (mBasicScreenRatio <= mScreenRatio)
        {
            mSetCanvasRatio = 0.0f;
        }
        else
        {
            mSetCanvasRatio = 1.0f;
        }

        tCanvasScaler.matchWidthOrHeight = mSetCanvasRatio;
    }
}
