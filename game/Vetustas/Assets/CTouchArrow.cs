using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CTouchArrow : MonoBehaviour {

    public SkeletonAnimation tAni;

    Coroutine mpCo;

    private void Awake()
    {
        StartCoroutine(FirstSet());
    }
    /*
    private void OnEnable()
    {
        tAni.state.SetAnimation(0, "animation", false);
        mpCo = StartCoroutine(DestroyCo());
    }
    */
    public void ResetCo()
    {
        tAni.state.SetAnimation(0, "animation", false);

        if (mpCo != null)
        { 
            StopCoroutine(mpCo);
            mpCo = null;
        }

        if (this.gameObject.activeSelf == false)
        { 
            this.gameObject.SetActive(true);
        }
        mpCo = StartCoroutine(DestroyCo());
    }

    IEnumerator DestroyCo()
    {
        yield return new WaitForSeconds(1.0f);

        this.gameObject.SetActive(false);
    }

    IEnumerator FirstSet()
    {
        yield return new WaitForSeconds(0.01f);
        this.gameObject.SetActive(false);
    }
}
