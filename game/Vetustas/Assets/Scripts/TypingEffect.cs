using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TypingEffect : Singleton<TypingEffect> {

    public Text mTypingText;
    private string mTyping_String;

    public bool mIsTyping = false;

    Coroutine mTypingCoroutine;

    public void DoTypingText(Text TargetText, string tString, int tSize, float FirstDelay, float TypingDelay)
    {
        mTypingText = TargetText;
        mTyping_String = tString;
        mTypingCoroutine = StartCoroutine(DoTyping(FirstDelay, TypingDelay));
    }

    IEnumerator DoTyping(float FirstDelay = 0.0f, float TypingDelay = 0.05f)
    {
        mIsTyping = true;
        yield return new WaitForSeconds(FirstDelay);
        if (TypingDelay == 0.0f)
        {
            mTypingText.text = mTyping_String;
        }
        else
        {
            for (int i = 0; i <= mTyping_String.Length; i++)
            {
                mTypingText.text = mTyping_String.Substring(0, i);

                yield return new WaitForSeconds(TypingDelay);
            }
        }
        mIsTyping = false;
    }

    public void SkipTyping()
    {
        if (mIsTyping == true)
        {
            if (mTypingCoroutine != null)
            {
                StopCoroutine(mTypingCoroutine);
                mTypingCoroutine = null;
                mTypingText.text = mTyping_String;
                mIsTyping = false;
            }
        }
    }
}
