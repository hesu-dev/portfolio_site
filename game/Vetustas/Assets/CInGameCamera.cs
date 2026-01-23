using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CInGameCamera : MonoBehaviour {

    public Transform mpTargetTrans;

    public float mDistance = 7.0f;
    public float mHeight = 5.0f;

    public float mSpeed = 1.5f;
    public bool mIsDoFollow;

    private Transform mCamTrans;

	// Use this for initialization
	void Start () {
        mCamTrans = this.GetComponent<Transform>();	
	}
	
	// Update is called once per frame
	void LateUpdate () {
		
        if (mIsDoFollow == true)
        {
            if (mpTargetTrans != null)
            {
                mCamTrans.position = Vector3.Lerp(mCamTrans.position, mpTargetTrans.position, Time.deltaTime * mSpeed);
                mCamTrans.position = new Vector3(mCamTrans.position.x, mCamTrans.position.y, -10.0f);
            }
        }
	}
}
