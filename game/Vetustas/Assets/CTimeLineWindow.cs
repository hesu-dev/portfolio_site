using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CTimeLineWindow : MonoBehaviour {

    public GameObject mpTimeLineWindow;

    public Text mpBottomText;

    public string[] mpBottom_String = new string[6];

    public GameObject[] mpArrow = new GameObject[6];

    public GameObject mpPopup;

    public bool[] mIsSelect = new bool[6];

    public Char_Kadan mpKadan_1;
    public CKadan_2 mpKadan_2;
    public CKadan_3 mpKadan_3;

    // Use this for initialization
    void Awake () {
        mpBottom_String[0] = "내해를 통한 포모르의 침공. 중부까지 뚫린 사상초유의 사건이 일어난다.\n이 때 전투를 승리로 이끌고, 국가적 영웅으로 등장한 카단 다카르가, 캄란 기사단장으로 임명된다.";
        mpBottom_String[1] = "현국왕 '아라운 막 아르투르'는\n왕위에 즉위한지 3년이 지난 젊은 왕이었다.";
        mpBottom_String[2] = "'그 늘'은 포모르와의 계속되는 전투에서, 연승을 축하하기 위해,\n캄란 기사단장인 '카단 다카르'를 위한 연회가 열렸다.";
        mpBottom_String[3] = "잠자고 있던 대관검 리어팔이 왕의 이름을 부른다. 바로 '카단 다카르'에게.";
        mpBottom_String[4] = "도망가는 자와, 그리고 그를 쫓는 자들.";
        mpBottom_String[5] = "카단이 리어팔을 쥐고 반기를 든다. 그리고 캄란 방패 요새는 반왕의 기반이 된다.";
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public void Btn_TimeLine(int tNum)
    {
        if (tNum == 0)
        {
            if (mIsSelect[0] == true)
            {
                mpPopup.SetActive(true);
            }
            else
            {
                mIsSelect[0] = true;
                mpBottomText.text = mpBottom_String[0];
                mpArrow[0].SetActive(true);
                mpArrow[1].SetActive(false);
                mpArrow[2].SetActive(false);
                mpArrow[3].SetActive(false);
                mpArrow[4].SetActive(false);
                mpArrow[5].SetActive(false);
            }
        }
        else if (tNum == 1)
        {
            if (mIsSelect[1] == true)
            {

            }
            else
            {
                mIsSelect[1] = true;
                mpBottomText.text = mpBottom_String[1];
                mpArrow[0].SetActive(false);
                mpArrow[1].SetActive(true);
                mpArrow[2].SetActive(false);
                mpArrow[3].SetActive(false);
                mpArrow[4].SetActive(false);
                mpArrow[5].SetActive(false);
            }
        }
        else if (tNum == 2)
        {
            if (mIsSelect[2] == true)
            {

            }
            else
            {
                mIsSelect[2] = true;
                mpBottomText.text = mpBottom_String[2];
                mpArrow[0].SetActive(false);
                mpArrow[1].SetActive(false);
                mpArrow[2].SetActive(true);
                mpArrow[3].SetActive(false);
                mpArrow[4].SetActive(false);
                mpArrow[5].SetActive(false);
            }
        }
        else if (tNum == 3)
        {
            if (mIsSelect[3] == true)
            {
                mpPopup.SetActive(true);
            }
            else
            {
                mIsSelect[3] = true;
                mpBottomText.text = mpBottom_String[3];
                mpArrow[0].SetActive(false);
                mpArrow[1].SetActive(false);
                mpArrow[2].SetActive(false);
                mpArrow[3].SetActive(true);
                mpArrow[4].SetActive(false);
                mpArrow[5].SetActive(false);
            }
        }
        else if (tNum == 4)
        {
            if (mIsSelect[4] == true)
            {
                mpPopup.SetActive(true);
            }
            else
            {
                mIsSelect[4] = true;
                mpBottomText.text = mpBottom_String[4];
                mpArrow[0].SetActive(false);
                mpArrow[1].SetActive(false);
                mpArrow[2].SetActive(false);
                mpArrow[3].SetActive(false);
                mpArrow[4].SetActive(true);
                mpArrow[5].SetActive(false);
            }
        }
        else if (tNum == 5)
        {
            if (mIsSelect[5] == true)
            {
                mpPopup.SetActive(true);
            }
            else
            {
                mIsSelect[5] = true;
                mpBottomText.text = mpBottom_String[5];
                mpArrow[0].SetActive(false);
                mpArrow[1].SetActive(false);
                mpArrow[2].SetActive(false);
                mpArrow[3].SetActive(false);
                mpArrow[4].SetActive(false);
                mpArrow[5].SetActive(true);
            }
        }
    }

    public void Btn_ClosePopup()
    {
        mpPopup.SetActive(false);
    }

    public void Btn_Open_TimeLine()
    {
        if (mpKadan_1 != null)
        {
            mpKadan_1.mIsPopupWindow = true;
        }
        else
        {
            if (mpKadan_2 != null && mpKadan_2.enabled == true)
            {
                mpKadan_2.mIsPopupWindow = true;
            }
            else
            {
                if (mpKadan_3 != null && mpKadan_3.enabled == true)
                {
                    mpKadan_3.mIsPopupWindow = true;
                }
            }
        }
        mpTimeLineWindow.SetActive(true);
    }

    public void Btn_Close_TimeLine()
    {
        if (mpKadan_1 != null)
        {
            mpKadan_1.mIsPopupWindow = false;
        }
        else
        {
            if (mpKadan_2 != null && mpKadan_2.enabled == true)
            {
                mpKadan_2.mIsPopupWindow = false;
            }
            else
            {
                if (mpKadan_3 != null && mpKadan_3.enabled == true)
                {
                    mpKadan_3.mIsPopupWindow = false;
                }
            }
        }
        mpTimeLineWindow.SetActive(false);
    }
}
