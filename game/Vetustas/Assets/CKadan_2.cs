using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class CKadan_2 : MonoBehaviour {

    public float mSpeed = 3.0f;
    public bool mIsMove = false;
    private Vector2 mpVec;

    public int mTargetSide = 0;

    public Transform mLeft_trans;
    public Transform mRight_trans;

    public Quaternion mLeft;
    public Quaternion mRight;

    public bool mIsBack = false;

    public GameObject mpBack_Standing;
    public GameObject mpBack_Run;
    public GameObject mpFront_Standing;
    public GameObject mpFront_Run;

    public GameObject[] mpFlag = new GameObject[2];

    public Text mpCharName_Text;

    public bool mIsPopupWindow = false;

    public CTouchArrow mpTouchArrow;
    public int mTouchArrow_Index = 0;

    public bool mIsStart = false;

    private void Awake()
    {
        if (GameDataManager.mUser_Kingdom == 0)
        {
            mpFlag[0].SetActive(true);
            mpFlag[1].SetActive(false);
        }
        else
        {
            mpFlag[0].SetActive(false);
            mpFlag[1].SetActive(true);
        }

        mpCharName_Text.text = "카단 다카르";

    }

    // Use this for initialization
    void Start()
    {
        mLeft = mLeft_trans.rotation;
        mRight = mRight_trans.rotation;
    }

    public void SpawnTouchArrow(Vector2 tVec)
    {
        /*
        if (mTouchArrow_Index >= 10)
        {
            mTouchArrow_Index = 0;
        }
        */
        mpTouchArrow.transform.localPosition = tVec;
        mpTouchArrow.ResetCo();

        //mTouchArrow_Index++;
    }

    // Update is called once per frame
    void Update()
    {
        if (mIsStart == true)
        { 
            if (mIsPopupWindow == false)
            {
                if (Input.GetMouseButtonDown(0))
                {
                    if (!EventSystem.current.IsPointerOverGameObject())
                    {
                        /*
                        if (EventSystem.current.currentSelectedGameObject.CompareTag("Kamelot"))
                        {
                            Debug.Log("Kamelot");
                        }
                        */
                        mpVec = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                        CheckTargetSide();

                        SpawnTouchArrow(mpVec);

                        if (mIsMove == false)
                        {

                            mIsMove = true;
                        }
                    }
                }
                if (mIsMove == true)
                {
                    transform.position = Vector3.MoveTowards(transform.position, mpVec, mSpeed * Time.deltaTime);

                    if (Vector2.Distance(transform.position, mpVec) <= 0.2f)
                    {
                        mpVec = transform.position;
                        mIsMove = false;

                        if (mIsBack == true)
                        {
                            mpBack_Standing.SetActive(true);
                            mpBack_Run.SetActive(false);
                            mpFront_Standing.SetActive(false);
                            mpFront_Run.SetActive(false);
                        }
                        else
                        {
                            mpBack_Standing.SetActive(false);
                            mpBack_Run.SetActive(false);
                            mpFront_Standing.SetActive(true);
                            mpFront_Run.SetActive(false);
                        }
                    }
                }
                else
                {
                    mpVec = Vector3.MoveTowards(transform.position, transform.position, mSpeed * Time.deltaTime);
                }
            }
        }
    }

    public void StopMove()
    {
        mpVec = Vector3.MoveTowards(transform.position, transform.position, mSpeed * Time.deltaTime);
        mIsMove = false;
        mIsPopupWindow = true;

        if (mIsBack == true)
        {
            mpBack_Standing.SetActive(true);
            mpBack_Run.SetActive(false);
            mpFront_Standing.SetActive(false);
            mpFront_Run.SetActive(false);
        }
        else
        {
            mpBack_Standing.SetActive(false);
            mpBack_Run.SetActive(false);
            mpFront_Standing.SetActive(true);
            mpFront_Run.SetActive(false);
        }
    }

    public void CheckTargetSide()
    {
        if (mpVec.x >= transform.position.x)
        {
            if (mpVec.y >= transform.position.y)
            {
                Debug.Log("Side_우상");
                mIsBack = true;
                transform.rotation = mLeft;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(true);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(false);
            }
            else
            {
                Debug.Log("Side_우하");
                mIsBack = false;
                transform.rotation = mRight;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(false);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(true);
            }
        }
        else
        {
            if (mpVec.y >= transform.position.y)
            {
                Debug.Log("Side_좌상");
                mIsBack = true;
                transform.rotation = mRight;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(true);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(false);
            }
            else
            {
                Debug.Log("Side_좌하");
                mIsBack = false;
                transform.rotation = mLeft;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(false);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(true);
            }
        }
    }
}
