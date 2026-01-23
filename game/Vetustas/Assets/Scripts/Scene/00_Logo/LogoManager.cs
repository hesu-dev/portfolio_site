using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class LogoManager : MonoBehaviour {
    
    public CanvasGroup mLogoCanvasGroup;
    public CanvasScaler mLogoCanvasScaler;

    public GameObject mLogo_1;
    public GameObject mLogo_2;
    public Image mLogo_BG;
    public GameObject mTip;
    public GameObject mBtn_Start;
    public GameObject mLoadingBar;
    public Image mLoadingMaxBar;

    private void Awake()
    {
        CanvasManager.Instance.CalScreenScale();
        CanvasManager.Instance.SetCanvasScreen(mLogoCanvasScaler);
    }

    // Use this for initialization
    void Start () {
        if (GameManager.mLogoSceneType == 0)
        {
            Logo_Ani_0();
        }
        else
        {
            mLogo_1.SetActive(false);
            mLogo_2.SetActive(true);
            mLogo_BG.color = new Color(1.0f, 1.0f, 1.0f, 1.0f);
            mLogo_BG.gameObject.SetActive(true);

            FadeManager.Instance.FadeIn_Canvas(0.5f, delegate { SoundManager.BGM_Play(0); mBtn_Start.SetActive(true); });
        }
    }

    public void Logo_Ani_0()
    {
        FadeManager.Instance.FadeIn_Canvas(2.5f, delegate { Logo_Ani_1(); }, mLogoCanvasGroup);
    }

    public void Logo_Ani_1()
    {
        FadeManager.Instance.FadeOut_Canvas(1.0f, delegate { Logo_Ani_2(); }, mLogoCanvasGroup);
    }

    public void Logo_Ani_2()
    {
        mLogo_1.SetActive(false);
        mLogo_2.SetActive(true);
        mLogo_BG.gameObject.SetActive(true);
        SoundManager.BGM_Play(0);

        FadeManager.Instance.FadeIn_Canvas(2.0f, null, mLogoCanvasGroup);
        StartCoroutine(MoveLogo());
        FadeManager.Instance.FadeIn_Image(1.5f, delegate { Logo_Ani_3(); }, mLogo_BG);
    }

    IEnumerator MoveLogo()
    {
        RectTransform mTrans = mLogo_2.CachedRectTransform();
        Vector2 tVec = new Vector2(0, 0);
        WaitForSeconds tWaitSec = new WaitForSeconds(0.01f);
        float tY = 0.0f;

        for (int tNum = 0; tNum < 100; tNum++)
        {
            tY += 1.0f;
            tVec.y = tY;
            mTrans.localPosition = tVec;
            yield return tWaitSec;
        }
    }

    public void Logo_Ani_3()
    {
        mTip.SetActive(true);
        mLoadingBar.SetActive(true);

        StartCoroutine(mLoadingBar_Action(0.5f, delegate { Logo_Ani_4(); }, mLoadingMaxBar));
    }

    IEnumerator mLoadingBar_Action(float tTime, System.Action tAction = null, Image tGage = null)
    {
        float tTemp = tGage.fillAmount;

        while (tTemp < 1.0f)
        {
            tTemp += GameManager.mGameDeltaTime / tTime;
            tGage.fillAmount = tTemp;

            if (tTemp >= 1.0f)
            {
                tTemp = 1.0f;
            }

            yield return null;
        }

        tGage.fillAmount = tTemp;

        if (tAction != null)
        {
            tAction();
        }
    }

    public void Logo_Ani_4()
    {
        mTip.SetActive(false);
        mLoadingBar.SetActive(false);
        mBtn_Start.SetActive(true);
    }

    public void Btn_Start()
    {
        FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
        {
            SceneManager.LoadScene("SelectScene");
        }
        , mLogoCanvasGroup);        
    }
}
