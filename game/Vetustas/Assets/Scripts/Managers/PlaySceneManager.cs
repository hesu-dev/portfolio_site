using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class PlaySceneManager : MonoBehaviour {

    public CanvasGroup mPlaySceneCanvasGroup;
    public CanvasScaler mPlaySceneCanvasScaler;

    public CanvasGroup mStorySceneCanvasGroup;
    public CanvasScaler mStorySceneCanvasScaler;

    public RectTransform mSceneCamera;

    public Text mStoryText_1;
    public Image mBlind_Text;
    public Image mBlind_TextBack;
    public GameObject mStoryBack_Img;

    public GameObject mDialogObject;
    public Text mDialogName_Text_1;
    public Text mDialog_Text_1;

    public List<string> mDialog_Name_List_1;
    public List<string> mDialog_Text_List_1;
    public List<int> mDialog_TextSize_List_1;
    public List<float> mDialogFirstDelay_List_1;
    public List<float> mDialogTypingDelay_List_1;

    public int mDialog_ListNumber_1 = 0;

    public bool mIsFadeComplete = false;
    public GameObject mFocusLine;
    public GameObject mUI_Dialog;
    public GameObject mStroyImg_2;
    public GameObject mStroyImg_3;

    public GameObject mArawnObject_1;
    public GameObject mArawnObject_2;

    public Animator mStroyAnimator_1;

    private bool mIsPlayAction_1 = false;

    public GameObject mpEffectObject;

    public GameObject[] mpCharTurn_1 = new GameObject[2];
    public GameObject[] mpCharTurn_2 = new GameObject[2];
    public GameObject[] mpCharTurn_3 = new GameObject[2];
    public GameObject[] mpCharTurn_4 = new GameObject[2];
    public GameObject[] mpCharTurn_5 = new GameObject[2];


    private void Awake()
    {
        CanvasManager.Instance.SetCanvasScreen(mPlaySceneCanvasScaler);
        CanvasManager.Instance.SetCanvasScreen(mStorySceneCanvasScaler);
        SetDialog_1_Text();
        GameManager.Instance.mSceneCamera = mSceneCamera;
    }

    private void Start()
    {
        mpCharTurn_1[0].SetActive(true);
        mpCharTurn_1[1].SetActive(false);
        mpCharTurn_2[0].SetActive(true);
        mpCharTurn_2[1].SetActive(false);
        mpCharTurn_3[0].SetActive(true);
        mpCharTurn_3[1].SetActive(false);
        mpCharTurn_4[0].SetActive(true);
        mpCharTurn_4[1].SetActive(false);
        mpCharTurn_5[0].SetActive(true);
        mpCharTurn_5[1].SetActive(false);

        if (GameDataManager.mUser_GameStory_Phase == 0)
        {
            //mIsFadeComplete = true;
            //Story_1_Play();
            FadeManager.Instance.FadeIn_Canvas(1.0f, delegate { mIsFadeComplete = true; Story_1_Play(); }, mStorySceneCanvasGroup);
        }
        else
        {
            FadeManager.Instance.FadeIn_Canvas(1.0f, delegate { mIsFadeComplete = true; }, mPlaySceneCanvasGroup);
        }

    }

    void SetStoryText(int Font_Num, int Font_Size, float Fade_In_Sec, float Fade_Stay_Sec, float Fade_Out_Sec, string StoryText, Text Change_Text, System.Action mNextStory = null)
    {
        if (Change_Text != null)
        {
            Change_Text.text = StoryText;
            Change_Text.fontSize = Font_Size;
            FadeManager.Instance.FadeOutAndIn_Image(Fade_In_Sec, Fade_Stay_Sec, Fade_Out_Sec, mNextStory, mBlind_Text);
        }
    }

    void Story_1_Play()
    {
        SoundManager.BGM_Play(1);
        mStoryText_1.gameObject.SetActive(true);
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "옛날, <B>투아하 데 다난</B>이라고 불리는 신족이 이 지상을 지배하고 있었다.", mStoryText_1, delegate { Story_2_Play(); });
    }

    void Story_2_Play()
    {
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "그러나 인간의 영웅은 그에 반기를 들었고,\n결국 전쟁에서 승리해, 인간의 왕국을 세웠다.", mStoryText_1, delegate { Story_3_Play(); });
    }

    void Story_3_Play()
    {
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "이에 패배한 신들의 왕이 지상을 떠나가며\n다음과 같은 말을 남겼다고 한다.", mStoryText_1, delegate { Story_4_Play(); });
    }

    void Story_4_Play()
    {
        mStoryText_1.color = Color.red;
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "\"우리가 돌아오는 날 인간의 왕국은, 일흔 일곱개로 쪼개져 핏물에 가라앉으리라!\"", mStoryText_1, delegate { Story_5_Play(); });
    }

    void Story_5_Play()
    {
        mStoryText_1.color = Color.white;
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "이에 승리한 인간의 왕은,\n\n거성을 짓고 병력을 길러 돌아올 전쟁에 대비하도록 했다.\n\n이것이 아르투르 왕조의 시작.", mStoryText_1, delegate { Story_6_Play(); });
    }

    void Story_6_Play()
    {
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "그리고, 현국왕 <B>'아라운 막 아르투르'</B>는\n왕위에 즉위한지 3년이 지난 젋은 왕이었다.", mStoryText_1, delegate { Story_7_Play(); });
    }

    void Story_7_Play()
    {
        mBlind_Text.enabled = false;
        mStoryText_1.enabled = false;
        mStoryBack_Img.SetActive(true);
        StartCoroutine(MoveBlind());
    }

    void Story_8_Play()
    {
        mBlind_Text.enabled = true;
        mStoryText_1.enabled = true;
        mDialogObject.SetActive(false);

        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "날붙이의 부딪힘보다,\n시와 노래가 더 가치있고,", mStoryText_1, delegate { Story_9_Play(); });

        mStroyAnimator_1.SetTrigger("Event_5");
    }

    void Story_9_Play()
    {
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "인간 노예들의 필사적인 전쟁을,\n서사시속의 허상으로만 즐기게 된 시대가\n그런 시대가 온 것이다.", mStoryText_1, delegate {
            mBlind_Text.enabled = false;
            mStoryText_1.enabled = false;
            mDialogObject.SetActive(true);
            mStroyAnimator_1.SetTrigger("Event_5");
            mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
            TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                               mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
            mDialog_ListNumber_1 += 1;
        });
    }

    IEnumerator MoveBlind()
    {
        float tX = mBlind_TextBack.rectTransform.localPosition.x;

        while (tX > - 1400.0f)
        {
            tX -= GameManager.mGameDeltaTime / 0.75f * 1400.0f;

            mBlind_TextBack.rectTransform.localPosition = new Vector2(tX, mBlind_TextBack.rectTransform.localPosition.y);

            if (tX < - 1400.0f)
            {
                mBlind_TextBack.rectTransform.localPosition = new Vector2(-1200.0f, mBlind_TextBack.rectTransform.localPosition.y);
                mBlind_TextBack.enabled = false;
            }

            yield return null;
        }
        mDialogObject.SetActive(true);
        mUI_Dialog.SetActive(true);
        mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
        TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                           mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
        mDialog_ListNumber_1 += 1;
    }

    public void Btn_Dialog_1()
    {
        if (TypingEffect.Instance.mIsTyping == false)
        {
            if (mUI_Dialog.activeSelf == false)
            {
                mUI_Dialog.SetActive(true);
            }

            if (mDialog_Name_List_1.Count > mDialog_ListNumber_1)
            { 
                if (mDialog_ListNumber_1 == 1)
                {
                    StartCoroutine(Dialog_1_Action_1());
                }
                else if (mDialog_ListNumber_1 == 2)
                {
                    mFocusLine.SetActive(false);
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 4)
                {
                    //@Bump 느낌표 이펙트 장면
                    mpCharTurn_1[0].SetActive(false);
                    mpCharTurn_1[1].SetActive(true);
                    mpCharTurn_2[0].SetActive(false);
                    mpCharTurn_2[1].SetActive(true);
                    mpCharTurn_3[0].SetActive(false);
                    mpCharTurn_3[1].SetActive(true);
                    mpCharTurn_4[0].SetActive(false);
                    mpCharTurn_4[1].SetActive(true);
                    mpCharTurn_5[0].SetActive(false);
                    mpCharTurn_5[1].SetActive(true);
                    mpEffectObject.SetActive(true);

                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 5)
                {
                    if (mIsPlayAction_1 == false)
                    {
                        mpEffectObject.SetActive(false);
                        mStroyAnimator_1.enabled = true;
                        StartCoroutine(Dialog_1_Action_2());
                    }
                }
                else if (mDialog_ListNumber_1 == 7)
                {
                    mStroyImg_2.SetActive(true);
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 8)
                {
                    mStroyImg_2.SetActive(false);
                    StartCoroutine(Dialog_1_Arawn_Fun());
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 9)
                {
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 11)
                {
                    
                    StartCoroutine(Dialog_1_Action_1());
                }
                else if (mDialog_ListNumber_1 == 12)
                {
                    mFocusLine.SetActive(false);
                    StartCoroutine(Dialog_1_Arawn_Fun());
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 13)
                {                    
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else if (mDialog_ListNumber_1 == 14)
                {

                    Story_8_Play();
                    
                }
                else if (mDialog_ListNumber_1 == 15)
                {
                    mStroyImg_3.SetActive(true);
                    //mStroyAnimator_1.enabled = false;
                    SoundManager.Effect_Play(3);
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
                else
                { 
                    mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
                    TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                                       mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
                    mDialog_ListNumber_1 += 1;
                }
            }
            else
            {
                Debug.Log("End");
                FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
                {
                    SceneManager.LoadScene("PlayScene_2");
                }, mStorySceneCanvasGroup);
            }
        }
        else
        {
            TypingEffect.Instance.SkipTyping();
        }
    }

    public void Skip_TutorialBtn()
    {
        Debug.Log("End");
        FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
        {
            SceneManager.LoadScene("PlayScene_2");
        }, mStorySceneCanvasGroup);
    }

    IEnumerator Dialog_1_Arawn_Fun()
    {
        mArawnObject_1.SetActive(false);
        mArawnObject_2.SetActive(true);
        yield return new WaitForSeconds(1.0f);
        mArawnObject_1.SetActive(true);
        mArawnObject_2.SetActive(false);

    }

    IEnumerator Dialog_1_Action_1()
    {
        mFocusLine.SetActive(true);
        GameManager.Instance.ShakeCamera(0.6f, 20.0f);
        mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
        TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                           mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
        mDialog_ListNumber_1 += 1;
        yield return new WaitForSeconds(1.0f);
    }

    IEnumerator Dialog_1_Action_2()
    {
        mIsPlayAction_1 = true;
        mStroyAnimator_1.SetTrigger("Trigger_1");
        mUI_Dialog.SetActive(false);
        yield return new WaitForSeconds(3.9f);
        mDialogName_Text_1.text = mDialog_Name_List_1[mDialog_ListNumber_1];
        TypingEffect.Instance.DoTypingText(mDialog_Text_1, mDialog_Text_List_1[mDialog_ListNumber_1],
                                           mDialog_TextSize_List_1[mDialog_ListNumber_1], mDialogFirstDelay_List_1[mDialog_ListNumber_1], mDialogTypingDelay_List_1[mDialog_ListNumber_1]);
        mDialog_ListNumber_1 += 1;

        
    }

    public void SetDialog_1_Text()
    {
        PutDialog_1("신하로보이는남자", "왕명으로 그대의 백작 작위를 폐하며, 사형에 처한다! \n그대는 봉신의 세 의무인 노역, 군역, 금전의 의무를 다하지 않고, 반역을 꾀했으며…", 25, 0.0f);
        PutDialog_1("억울해보이는 남자", "<b><i>반역이라니!</i></b>", 35, 0.0f, 0.0f);
        PutDialog_1("억울해보이는 남자", "<b><i>더는 군비를 증강할 필요가 없는 것은, 경들도 모두 아시지 않소!?!</i></b>", 35, 0.0f, 0.0f);
        PutDialog_1("억울해보이는 남자", "<b><i>이 평화로운 시대에 매번 사병을 보낼 필요가..대체 어디 있단 말입니까!!</i></b>", 35, 0.0f, 0.0f);
        PutDialog_1("아라운 막 아르투르", "-인간아.", 25, 0.0f);
        PutDialog_1("아라운 막 아르투르", "그대의 칼날을 날카롭게 갈라, 쉬지 않고 대비하라.\n영광된 왕국은 너무나 멀고, 우리는 굴종에 발을 담그고 있다.", 25, 0.0f);
        PutDialog_1("아라운 막 아르투르", "건국왕께서는 마지막 순간까지 <b><Color=#ff0000>'돌아올 전쟁에 대비하라'</color></b>는 유훈을 남기셨지.", 25, 0.0f, 0.0f);
        PutDialog_1("아라운 막 아르투르", "평화로운 시대라 군사력을 줄이라는 사람이, 사병은 또 왜 저렇게나 많은지?", 25, 0.0f);
        PutDialog_1("아라운 막 아르투르", "자네 말만 들으면 마치 내가 과한 요구를 한 것만 같아.\n하하, 억울해서 눈물이 날 지경이야.", 25, 0.0f);
        PutDialog_1("억울해보이는 남자", "..네놈은..", 25, 0.0f);
        PutDialog_1("억울해보이는 남자", "..네놈은, 정당한 왕이 아니야!", 25, 0.0f);
        PutDialog_1("억울해보이는 남자", "뭐가 전쟁에 대비한다는 말이냐! 대관식도 제대로 치르지 못한 반푼이가! \n대관검(戴冠劍) 리어팔은 진정한 왕을 고른다!", 25, 0.0f, 0.0f);
        PutDialog_1("아라운 막 아르투르", "하하, 그래, 그래, 맞아, 맞아.\n자네 말이 다 맞을지도 몰라.", 25, 0.0f);
        PutDialog_1("아라운 막 아르투르", "..하지만 그 검의 인정이 왜 필요하지?", 25, 0.0f);
        PutDialog_1("칼비스탄", "..왕국에,", 25, 0.0f);
        PutDialog_1("칼비스탄", "<b>영광 있으라.</b>", 25, 0.0f, 0.0f);
    }

    private void PutDialog_1(string tName = "", string tText = "", int tSize = 25, float tFirstDelay = 0.0f, float tTypingDelay = 0.05f)
    {
        mDialog_Name_List_1.Add(tName);
        mDialog_Text_List_1.Add(tText);
        mDialog_TextSize_List_1.Add(tSize);
        mDialogFirstDelay_List_1.Add(tFirstDelay);
        mDialogTypingDelay_List_1.Add(tTypingDelay);
    }
}
