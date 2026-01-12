using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CMapWindow : MonoBehaviour {

    public GameObject mpMapWindow;

    public GameObject[] mpMap_Img = new GameObject[5];
    public GameObject[] mpMap_Pointer = new GameObject[5];
    public bool[] mIsSelect = new bool[5];

    public Char_Kadan mpKadan_1;
    public CKadan_2 mpKadan_2;
    public CKadan_3 mpKadan_3;

    public void Btn_OpenMap()
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

        mpMapWindow.SetActive(true);
    }

    public void Btn_CloseMap()
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

        mpMapWindow.SetActive(false);
    }

    public void Btn_MapSelect(int tNum)
    {
        if (tNum == 0)
        {
            if (mIsSelect[0] == false)
            {
                mpMap_Img[0].SetActive(true);
                mpMap_Img[1].SetActive(false);
                mpMap_Img[2].SetActive(false);
                mpMap_Img[3].SetActive(false);
                mpMap_Img[4].SetActive(false);

                mpMap_Pointer[0].SetActive(true);
                mpMap_Pointer[1].SetActive(false);
                mpMap_Pointer[2].SetActive(false);
                mpMap_Pointer[3].SetActive(false);
                mpMap_Pointer[4].SetActive(false);
            }
        }
        else if (tNum == 1)
        {
            if (mIsSelect[1] == false)
            {
                mpMap_Img[0].SetActive(false);
                mpMap_Img[1].SetActive(true);
                mpMap_Img[2].SetActive(false);
                mpMap_Img[3].SetActive(false);
                mpMap_Img[4].SetActive(false);

                mpMap_Pointer[0].SetActive(false);
                mpMap_Pointer[1].SetActive(true);
                mpMap_Pointer[2].SetActive(false);
                mpMap_Pointer[3].SetActive(false);
                mpMap_Pointer[4].SetActive(false);
            }
        }
        else if (tNum == 2)
        {
            if (mIsSelect[2] == false)
            {
                mpMap_Img[0].SetActive(false);
                mpMap_Img[1].SetActive(false);
                mpMap_Img[2].SetActive(true);
                mpMap_Img[3].SetActive(false);
                mpMap_Img[4].SetActive(false);

                mpMap_Pointer[0].SetActive(false);
                mpMap_Pointer[1].SetActive(false);
                mpMap_Pointer[2].SetActive(true);
                mpMap_Pointer[3].SetActive(false);
                mpMap_Pointer[4].SetActive(false);
            }
        }
        else if (tNum == 3)
        {
            if (mIsSelect[3] == false)
            {
                mpMap_Img[0].SetActive(false);
                mpMap_Img[1].SetActive(false);
                mpMap_Img[2].SetActive(false);
                mpMap_Img[3].SetActive(true);
                mpMap_Img[4].SetActive(false);

                mpMap_Pointer[0].SetActive(false);
                mpMap_Pointer[1].SetActive(false);
                mpMap_Pointer[2].SetActive(false);
                mpMap_Pointer[3].SetActive(true);
                mpMap_Pointer[4].SetActive(false);
            }
        }
        else if (tNum == 4)
        {
            if (mIsSelect[4] == false)
            {
                mpMap_Img[0].SetActive(false);
                mpMap_Img[1].SetActive(false);
                mpMap_Img[2].SetActive(false);
                mpMap_Img[3].SetActive(false);
                mpMap_Img[4].SetActive(true);

                mpMap_Pointer[0].SetActive(false);
                mpMap_Pointer[1].SetActive(false);
                mpMap_Pointer[2].SetActive(false);
                mpMap_Pointer[3].SetActive(false);
                mpMap_Pointer[4].SetActive(true);
            }
        }
    }
}
