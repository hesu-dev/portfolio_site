using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SelectSceneManager : MonoBehaviour {


    // 0 : On   1 : Off
    public Sprite[] mKamelot_Sprite = new Sprite[2];
    public Sprite[] mCamlan_Sprite = new Sprite[2];

    public Image mKamelotBtn_Img;
    public Image mCamlanBtn_Img;

    public CanvasGroup mSelectSceneCanvasGroup;
    public CanvasScaler mSelectSceneCanvasScaler;

    public bool mIsFadeComplete = false;

    public bool mIsCanClick = false;

    private void Awake()
    {
        CanvasManager.Instance.SetCanvasScreen(mSelectSceneCanvasScaler);

        mIsCanClick = false;

        if (GameDataManager.mUser_Kingdom == 0)
        {
            mKamelotBtn_Img.sprite = mKamelot_Sprite[0];
            mCamlanBtn_Img.sprite = mCamlan_Sprite[1];
        }
        else
        {
            mKamelotBtn_Img.sprite = mKamelot_Sprite[1];
            mCamlanBtn_Img.sprite = mCamlan_Sprite[0];
        }
    }

    private void Start()
    {
        FadeManager.Instance.FadeIn_Canvas(1.0f, delegate { mIsFadeComplete = true; mIsCanClick = true; }, mSelectSceneCanvasGroup);
    }

    public void Btn_Kamelot_Select()
    {
        if (mIsFadeComplete != false && mIsCanClick != false)
        {
            if (GameDataManager.mUser_Kingdom == 1)
            {
                GameDataManager.mUser_Kingdom = 0;
                mKamelotBtn_Img.sprite = mKamelot_Sprite[0];
                mCamlanBtn_Img.sprite = mCamlan_Sprite[1];
            }
        }
    }

    public void Btn_Camlan_Select()
    {
        if (mIsFadeComplete != false && mIsCanClick != false)
        {
            if (GameDataManager.mUser_Kingdom == 0)
            {
                GameDataManager.mUser_Kingdom = 1;
                mKamelotBtn_Img.sprite = mKamelot_Sprite[1];
                mCamlanBtn_Img.sprite = mCamlan_Sprite[0];
            }
        }
    }

    public void Btn_Select()
    {
        if (mIsFadeComplete != false && mIsCanClick != false)
        {
            mIsCanClick = false;
            SoundManager.Effect_Play(1);
            FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
            {
                SceneManager.LoadScene("CharacterScene");
            }, mSelectSceneCanvasGroup);
        }
    }

    public void Btn_Back()
    {
        if (mIsFadeComplete != false && mIsCanClick != false)
        {
            mIsCanClick = false;
            SoundManager.Effect_Play(6);
            GameManager.mLogoSceneType = 1;
            FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
            {
                SceneManager.LoadScene("LogoScene");
            }, mSelectSceneCanvasGroup);
        }
    }
}
