using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectBase : MonoBehaviour
{
    private Transform mCachedTransform;
    public Transform CachedTransform
    {
        get
        {
            if (mCachedTransform == null)
                mCachedTransform = GetComponent<Transform>();

            return mCachedTransform;
        }
    }

    private GameObject mCachedGameObject;
    public GameObject CachedGameObject
    {
        get
        {
            if (mCachedGameObject == null)
                mCachedGameObject = gameObject;

            return mCachedGameObject;
        }
    }

    private RectTransform mCachedRectTransform;
    public RectTransform CachedRectTransform
    {
        get
        {
            if (mCachedRectTransform == null)
                mCachedRectTransform = GetComponent<RectTransform>();

            return mCachedRectTransform;
        }
    }

    private Animation mCachedAnimation;
    public Animation CachedAnimation
    {
        get
        {
            if (mCachedAnimation == null)
                mCachedAnimation = GetComponent<Animation>();

            return mCachedAnimation;
        }
    }

    private CanvasGroup mCachedCanvasGroup;
    public CanvasGroup CachedCanvasGroup
    {
        get
        {
            if (mCachedCanvasGroup == null)
                mCachedCanvasGroup = GetComponent<CanvasGroup>();

            return mCachedCanvasGroup;
        }
    }

}
