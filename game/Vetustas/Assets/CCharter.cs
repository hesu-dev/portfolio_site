using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CCharter : MonoBehaviour {

    public InGame_2_Manager mpManager = null;

    public CKadan_2 mpChar_2;
    public CKadan_3 mpChar_3;

    private void OnMouseDown()
    {
        if (mpChar_2 != null && mpChar_2.gameObject.activeSelf == true)
        {
            mpChar_2.StopMove();
        }
        else
        {
            if (mpChar_3 != null && mpChar_3.gameObject.activeSelf == true)
            {
                mpChar_3.StopMove();
            }
        }
        mpManager.Btn_Char();
        Debug.Log("Good");
    }
}
