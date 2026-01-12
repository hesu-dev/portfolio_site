using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CAlaphaAni : MonoBehaviour {

    public Text mText;
    Color mColor = new Color(255, 255, 255, 0);
    int mNum = 0;
    float mA = 1.0f;

    // Update is called once per frame
    
    void Update () {

        if (mNum >= 100 && mNum < 200)
        {
            mA += 0.008f;
        }
        else if (mNum >= 200)
        {
            mA = 1.0f;
            mNum = 0;
        }
        else
        {
            mA -= 0.008f;
        }

        mNum++;
        mColor.a = mA;
        mText.color = mColor; 
	}
    
}
