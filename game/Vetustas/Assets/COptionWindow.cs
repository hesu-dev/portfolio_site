using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class COptionWindow : MonoBehaviour {

    public GameObject mpOptionWindow;

    public GameObject[] mpSoundCheck = new GameObject[2];
    public bool[] mIsSoundCheck = new bool[2];
    public bool mIsOpen = false;

    public Char_Kadan mpKadan_1;
    public CKadan_2 mpKadan_2;
    public CKadan_3 mpKadan_3;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKey(KeyCode.Escape))
        {
            if (mIsOpen == true)
            {            
                Btn_Close_OptionWindow();
            }
        }
	}

    public void Btn_Open_OptionWindow()
    {
        mIsOpen = true;
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
        mpOptionWindow.SetActive(true);
    }

    public void Btn_Close_OptionWindow()
    {
        mIsOpen = false;
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
        mpOptionWindow.SetActive(false);
    }

    public void Btn_Sound_Check(int tNum)
    {
        if (tNum == 0)
        {
            if (mIsSoundCheck[0] == true)
            {
                mIsSoundCheck[0] = false;
                mpSoundCheck[0].SetActive(false);
            }
            else
            {
                mIsSoundCheck[0] = true;
                mpSoundCheck[0].SetActive(true);
            }
        }
        else
        {
            if (mIsSoundCheck[1] == true)
            {
                mIsSoundCheck[1] = false;
                mpSoundCheck[1].SetActive(false);
            }
            else
            {
                mIsSoundCheck[1] = true;
                mpSoundCheck[1].SetActive(true);
            }
        }
    }

    public void Btn_GameExit()
    {
        Application.Quit();
    }
}
