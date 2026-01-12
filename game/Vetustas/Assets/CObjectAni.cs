using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CObjectAni : MonoBehaviour {

    public InGame_2_Manager mpInGameManager;

    public Animator mpAnimator;

    public CInGameCamera mpCamera;

    public GameObject mpChar_0 = null;
    public GameObject mpChar_1 = null;
    public GameObject mpChar_2 = null;

    private void Awake()
    {
        if (GameDataManager.mUser_Char_Num == 15)
        {
            mpChar_0.SetActive(true);
            mpChar_1.SetActive(false);
            mpChar_2.SetActive(false);
        }
        else
        {
            mpChar_0.SetActive(true);
            mpChar_1.SetActive(false);
            mpChar_2.SetActive(true);
        }
    }

    public void Start_CharMoveAni()
    {
        if (GameDataManager.mUser_Char_Num == 15)
        {
            mpChar_0.SetActive(false);
            mpChar_1.SetActive(true);

            mpCamera.mpTargetTrans = mpChar_1.transform;
        }
        else
        {
            mpCamera.mpTargetTrans = mpChar_2.transform;
        }

        mpAnimator.SetTrigger("MoveAni_Trig");

        mpCamera.mIsDoFollow = true;
    }

    public void EndMoveAni()
    {
        mpInGameManager.MoveCharacter_Dialog_5_End();
    }
}
