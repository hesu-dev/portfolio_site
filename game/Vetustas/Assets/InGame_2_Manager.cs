using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class InGame_2_Manager : MonoBehaviour {

    public CanvasGroup mStorySceneCanvasGroup;
    public CanvasScaler mStorySceneCanvasScaler;

    public Text mText_1;
    public string mText_Str = "A.A. 511 연말. 카멜롯 왕성";
    
    public char[] mText_char;

    public GameObject mpNextBtn;

    public GameObject mpFirstWindow;
    public GameObject mpSecondWindow;
    public Animator mpAnimator;

    public Transform mpCamera_Transform;

    public GameObject mpDialogWindow;
    public Text mpDialogName_Text;
    public Text mpTyping_Text;


    public int mDialog_Number = 0;

    public bool mIsMoveCameraAni = false;

    public Text mStoryText_1;
    public Image mBlind_Text;
    public Image mBlind_TextBack;
    public GameObject mStoryBack_Img;

    public bool mIsComplete_MoveAni = false;

    public CObjectAni mpGameObjectAni = null;

    public GameObject mpChoice_UI_Object = null;

    public Image[] mpChoice_Btn_Img = new Image[2];
    public Sprite[] mpChoice_Btn_Spr = new Sprite[2];

    public bool[] mIsChoice_Btn_Select = new bool[2];

    bool mIsTouch_1 = false;
    bool mIsTouch_2 = false;

    bool mIsCharTouch = false;

    public CKadan_2 mpChar_Script_1 = null;
    public CKadan_3 mpChar_Script_2 = null;

    public GameObject mpUI_Dialog = null;
    public GameObject mpUI_PlayMode = null;

    public GameObject mpChar_1 = null;
    public GameObject mpChar_2 = null;

    private void Start()
    {
        FadeManager.Instance.FadeIn_Canvas(0.0f, delegate { });
        SoundManager.StopBGMSound();
    }

    public void TypingText_1()
    {
        mText_char = mText_Str.ToCharArray();

        StartCoroutine(DoTypingText_1());
    }

    IEnumerator DoTypingText_1()
    {
        string tText = "";
        for (int tN = 0; tN < mText_char.Length; tN++)
        {
            tText += mText_char[tN];
            mText_1.text = tText;
            yield return new WaitForSeconds(0.1f);
        }
        Debug.Log("Test_1");
        mpNextBtn.SetActive(true);
    }

    public void DoEffect_PenWritning()
    {
        if (mIsTouch_2 == false)
        {
            mIsTouch_2 = true;
            Debug.Log("Test_2");
            SoundManager.Effect_Play(0);
        }
    }

    public void NextAni_1_to_2()
    {
        if (mIsTouch_1 == false)
        {
            mIsTouch_1 = true;
            Debug.Log("Test_3");
            mpFirstWindow.SetActive(false);
            mpSecondWindow.SetActive(true);

            mpAnimator.SetTrigger("NextAni_Trig");
            SoundManager.BGM_Play(2);
        }
    }

    public void MoveCameraAni()
    {
        StartCoroutine(MoveCameraCoroutin());
    }

    IEnumerator MoveCameraCoroutin()
    {
        mIsMoveCameraAni = true;
        mpDialogWindow.SetActive(false);
        float tY = 0.13f;

        while (true)
        {
            if (mpCamera_Transform.localPosition.y <= 7.0f)
            { 
                mpCamera_Transform.localPosition = new Vector3(mpCamera_Transform.localPosition.x, mpCamera_Transform.localPosition.y + tY, mpCamera_Transform.localPosition.z);
                yield return new WaitForSeconds(0.01f);
            }
            else
            {
                mpCamera_Transform.localPosition = new Vector3(mpCamera_Transform.localPosition.x, 7.0f, mpCamera_Transform.localPosition.z);
                break;
            }
        }

        yield return new WaitForSeconds(2.5f);

        while (true)
        {
            if (mpCamera_Transform.localPosition.y >= -10.0f)
            {
                mpCamera_Transform.localPosition = new Vector3(mpCamera_Transform.localPosition.x, mpCamera_Transform.localPosition.y - tY, mpCamera_Transform.localPosition.z);
                yield return new WaitForSeconds(0.01f);
            }
            else
            {
                mpCamera_Transform.localPosition = new Vector3(mpCamera_Transform.localPosition.x, -10.0f, mpCamera_Transform.localPosition.z);
                break;
            }
        }

        mIsMoveCameraAni = false;
        mpDialogWindow.SetActive(true);
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
        SoundManager.BGM_Play(2);
        mStoryText_1.gameObject.SetActive(true);
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "승전 연회", mStoryText_1, delegate { Story_2_Play(); });
    }

    void Story_2_Play()
    {
        SetStoryText(0, 24, 2.0f, 3.0f, 2.0f, "그 날, 카멜롯 왕성에서는\n캄란 기사단장인 '카단 다카르'의 승전 축하 연회가 열렸다. 그리고..", mStoryText_1, delegate {  });
    }


    public void Dialog_1()
    {
        mpFirstWindow.SetActive(false);
        mpSecondWindow.SetActive(false);
        mpDialogWindow.SetActive(true);
        string tString = "단장님을 위한 축하연회라니 꿈만 같습니다! \n 겨울 토벌을 성공했으니 더 높은 작위가 떨어질지도 모릅니다!";

        mpDialogName_Text.text = "캄란의 기사";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_2()
    {
        string tString = ".......";

        mpDialogName_Text.text = "카단 다카르";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_3()
    {
        string tString = "뭘 그리 보십니까? 단장님";

        mpDialogName_Text.text = "캄란의 기사";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_4()
    {
        string tString = "..아니다.";

        mpDialogName_Text.text = "카단 다카르";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_5()
    {
        string tString = "...가자.";

        mpDialogName_Text.text = "카단 다카르";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);

        SoundManager.BGM_Play(3);
    }

    public void MoveCharacter_Dialog_5()
    {
        mIsComplete_MoveAni = false;
        mpGameObjectAni.Start_CharMoveAni();
        mpDialogWindow.SetActive(false);
    }

    public void MoveCharacter_Dialog_5_End()
    {
        mIsComplete_MoveAni = true;
        mpDialogWindow.SetActive(true);
        //Btn_Dialog();

        Set_CharMovePlay();
    }

    public void Set_CharMovePlay()
    {
        mpChar_Script_1.mIsStart = true;
        mpChar_Script_2.mIsStart = true;

        mpChar_1.SetActive(false);
        mpChar_2.SetActive(false);

        mpUI_Dialog.SetActive(false);
        mpUI_PlayMode.SetActive(true);
    }

    public void Btn_Char()
    {
        if (mIsCharTouch == false)
        {
            mIsCharTouch = true;

            mpUI_Dialog.SetActive(true);
            mpUI_PlayMode.SetActive(false);

            mpTyping_Text.text = "";

            mpDialogName_Text.text = "카멜롯의 기사";

            Btn_Dialog();
        }        
    }

    public void Dialog_6()
    {
        string tString = "어서오십시오.";

        mpDialogName_Text.text = "카멜롯의 기사";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_7()
    {
        string tString = "소지하신 무기를 맡겨주십시오, 연회장에는 무장을 하고 들어가실 수 없습니다.";

        mpDialogName_Text.text = "카멜롯의 기사";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_8()
    {
        string tString = "연회장에는 무기를 들고 들어가실 수 없습니다.";

        mpDialogName_Text.text = "카멜롯의 기사";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Dialog_9()
    {
        string tString = "감사합니다. 이 쪽으로 들어가십시오. 즐거운 시간 보내시기를.";

        mpDialogName_Text.text = "카멜롯의 기사";
        TypingEffect.Instance.DoTypingText(mpTyping_Text, tString, 25, 0.0f, 0.05f);
    }

    public void Btn_Dialog()
    {
        if (TypingEffect.Instance.mIsTyping == true)
        {
            TypingEffect.Instance.SkipTyping();
        }
        else
        {
            if (mDialog_Number == 0)
            {
                Dialog_2();
                mDialog_Number++;
            }
            else if (mDialog_Number == 1)
            {
                MoveCameraAni();
                mDialog_Number++;
            }
            else if (mDialog_Number == 2)
            {
                if (mIsMoveCameraAni == false)
                {
                    Dialog_3();
                    mDialog_Number++;
                }
            }
            else if (mDialog_Number == 3)
            {
                Dialog_4();
                mDialog_Number++;
            }
            else if (mDialog_Number == 4)
            {
                Dialog_5();
                mDialog_Number++;
            }
            else if (mDialog_Number == 5)
            {
                if (mIsComplete_MoveAni == false)
                {
                    MoveCharacter_Dialog_5();
                    mDialog_Number++;
                    
                    if (mpChar_Script_2 != null)
                    {
                        mpChar_Script_2.SetDirection();
                    }
                }
            }
            else if (mDialog_Number == 6)
            {
                Dialog_6();
                mDialog_Number++;
            }
            else if (mDialog_Number == 7)
            {
                Dialog_7();
                mDialog_Number++;
            }
            else if (mDialog_Number == 8)
            {
                mpDialogWindow.SetActive(false);
                mpChoice_UI_Object.SetActive(true);
            }
            else if (mDialog_Number == 9)
            {
                //무기 제출 취소
                Dialog_8();
                mDialog_Number = 12;
            }
            else if (mDialog_Number == 10)
            {
                //무기 제출
                Dialog_9();
                mDialog_Number = 11;
            }
            else if (mDialog_Number == 11)
            {
                //다음씬
                Debug.Log("NEXT SCENE");
                FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
                {
                    SceneManager.LoadScene("PlayScene_3");
                }, mStorySceneCanvasGroup);
            }
            else if (mDialog_Number == 12)
            {
                mDialog_Number = 7;

                mpUI_Dialog.SetActive(false);
                mpUI_PlayMode.SetActive(true);

                if (mpChar_Script_1 != null && mpChar_Script_1.gameObject.activeSelf == true)
                {
                    mpChar_Script_1.mIsPopupWindow = false;
                }
                else
                {
                    if (mpChar_Script_2 != null && mpChar_Script_2.gameObject.activeSelf == true)
                    {
                        mpChar_Script_2.mIsPopupWindow = false;
                    }
                }

                mpTyping_Text.text = "";

                mpDialogName_Text.text = "카멜롯의 기사";

                mIsCharTouch = false;
            }
        }
    }

    public void Btn_Choice_1()
    {
        if (mIsChoice_Btn_Select[0] == true)
        {
            mpChoice_UI_Object.SetActive(false);
            mpDialogWindow.SetActive(true);
            mDialog_Number = 10;
            Btn_Dialog();
        }
        else
        {
            mIsChoice_Btn_Select[0] = true;
            mIsChoice_Btn_Select[1] = false;

            mpChoice_Btn_Img[0].sprite = mpChoice_Btn_Spr[1];
            mpChoice_Btn_Img[1].sprite = mpChoice_Btn_Spr[0];
        }
    }

    public void Btn_Choice_2()
    {
        if (mIsChoice_Btn_Select[1] == true)
        {
            mIsChoice_Btn_Select[0] = false;
            mIsChoice_Btn_Select[1] = false;

            mpChoice_Btn_Img[0].sprite = mpChoice_Btn_Spr[0];
            mpChoice_Btn_Img[1].sprite = mpChoice_Btn_Spr[0];

            mpChoice_UI_Object.SetActive(false);
            mpDialogWindow.SetActive(true);
            mDialog_Number = 9;
            Btn_Dialog();
        }
        else
        {
            mIsChoice_Btn_Select[0] = false;
            mIsChoice_Btn_Select[1] = true;

            mpChoice_Btn_Img[0].sprite = mpChoice_Btn_Spr[0];
            mpChoice_Btn_Img[1].sprite = mpChoice_Btn_Spr[1];
        }
    }
    
}
