using Spine.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class CKadan_3 : MonoBehaviour {

    public float mSpeed = 3.0f;
    public bool mIsMove = false;
    private Vector2 mpVec;

    public int mTargetSide = 0;

    public Transform mLeft_trans;
    public Transform mRight_trans;

    public Quaternion mLeft;
    public Quaternion mRight;

    public bool mIsBack = false;

    public CChar[] mpCamlan_Char = new CChar[14];
    public CChar[] mpKamelot_Char = new CChar[15];
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

        for (int tN = 0; tN < 14; tN++)
        {
            mpCamlan_Char[tN].gameObject.SetActive(false);
            mpKamelot_Char[tN].gameObject.SetActive(false);
        }
        mpKamelot_Char[14].gameObject.SetActive(false);

        switch (GameDataManager.mUser_Char_Num)
        {
            case 0:
                {
                    mpBack_Standing = mpKamelot_Char[0].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[0].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[0].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[0].mpCharObject[3];

                    mpCharName_Text.text = "아라운 막 아르투르";

                    mpKamelot_Char[0].gameObject.SetActive(true);
                }
                break;
            case 1:
                {
                    mpBack_Standing = mpKamelot_Char[1].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[1].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[1].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[1].mpCharObject[3];

                    mpCharName_Text.text = "디안 케트";

                    mpKamelot_Char[1].gameObject.SetActive(true);
                }
                break;
            case 2:
                {
                    mpBack_Standing = mpKamelot_Char[2].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[2].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[2].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[2].mpCharObject[3];

                    mpCharName_Text.text = "칼 비스탄";

                    mpKamelot_Char[2].gameObject.SetActive(true);
                }
                break;
            case 3:
                {
                    mpBack_Standing = mpKamelot_Char[3].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[3].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[3].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[3].mpCharObject[3];

                    mpCharName_Text.text = "이그레인";

                    mpKamelot_Char[3].gameObject.SetActive(true);
                }
                break;
            case 4:
                {
                    mpBack_Standing = mpKamelot_Char[4].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[4].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[4].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[4].mpCharObject[3];

                    mpCharName_Text.text = "슈크람 아이베르크";

                    mpKamelot_Char[4].gameObject.SetActive(true);
                }
                break;
            case 5:
                {
                    mpBack_Standing = mpKamelot_Char[5].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[5].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[5].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[5].mpCharObject[3];

                    mpCharName_Text.text = "이루사";

                    mpKamelot_Char[5].gameObject.SetActive(true);
                }
                break;
            case 6:
                {
                    mpBack_Standing = mpKamelot_Char[6].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[6].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[6].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[6].mpCharObject[3];

                    mpCharName_Text.text = "로스린다";

                    mpKamelot_Char[6].gameObject.SetActive(true);
                }
                break;
            case 7:
                {
                    mpBack_Standing = mpKamelot_Char[7].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[7].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[7].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[7].mpCharObject[3];

                    mpCharName_Text.text = "루 메리골드";

                    mpKamelot_Char[7].gameObject.SetActive(true);
                }
                break;
            case 8:
                {
                    mpBack_Standing = mpKamelot_Char[8].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[8].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[8].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[8].mpCharObject[3];

                    mpCharName_Text.text = "브리지트 플라타";

                    mpKamelot_Char[8].gameObject.SetActive(true);
                }
                break;
            case 9:
                {
                    mpBack_Standing = mpKamelot_Char[9].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[9].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[9].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[9].mpCharObject[3];

                    mpCharName_Text.text = "새일 그란아이네헤";

                    mpKamelot_Char[9].gameObject.SetActive(true);
                }
                break;
            case 10:
                {
                    mpBack_Standing = mpKamelot_Char[10].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[10].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[10].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[10].mpCharObject[3];

                    mpCharName_Text.text = "레이겐 슈라이어";

                    mpKamelot_Char[10].gameObject.SetActive(true);
                }
                break;
            case 11:
                {
                    mpBack_Standing = mpKamelot_Char[11].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[11].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[11].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[11].mpCharObject[3];

                    mpCharName_Text.text = "라비엔 로렌조";

                    mpKamelot_Char[11].gameObject.SetActive(true);
                }
                break;
            case 12:
                {
                    mpBack_Standing = mpKamelot_Char[12].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[12].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[12].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[12].mpCharObject[3];

                    mpCharName_Text.text = "세드릭 반스";

                    mpKamelot_Char[12].gameObject.SetActive(true);
                }
                break;
            case 13:
                {
                    mpBack_Standing = mpKamelot_Char[13].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[13].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[13].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[13].mpCharObject[3];

                    mpCharName_Text.text = "팔라라크 필파";

                    mpKamelot_Char[13].gameObject.SetActive(true);
                }
                break;
            case 14:
                {
                    mpBack_Standing = mpKamelot_Char[14].mpCharObject[0];
                    mpBack_Run = mpKamelot_Char[14].mpCharObject[1];
                    mpFront_Standing = mpKamelot_Char[14].mpCharObject[2];
                    mpFront_Run = mpKamelot_Char[14].mpCharObject[3];

                    mpCharName_Text.text = "아드나 할리할";

                    mpKamelot_Char[14].gameObject.SetActive(true);
                }
                break;
            case 15:
                {
                    mpBack_Standing = mpCamlan_Char[0].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[0].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[0].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[0].mpCharObject[3];

                    mpCharName_Text.text = "카단 다카르";

                    mpCamlan_Char[0].gameObject.SetActive(true);
                }
                break;
            case 16:
                {
                    mpBack_Standing = mpCamlan_Char[1].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[1].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[1].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[1].mpCharObject[3];

                    mpCharName_Text.text = "틸데";

                    mpCamlan_Char[1].gameObject.SetActive(true);
                }
                break;
            case 17:
                {
                    mpBack_Standing = mpCamlan_Char[2].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[2].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[2].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[2].mpCharObject[3];

                    mpCharName_Text.text = "이삭 프로이트";

                    mpCamlan_Char[2].gameObject.SetActive(true);
                }
                break;
            case 18:
                {
                    mpBack_Standing = mpCamlan_Char[3].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[3].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[3].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[3].mpCharObject[3];

                    mpCharName_Text.text = "녹턴";

                    mpCamlan_Char[3].gameObject.SetActive(true);
                }
                break;
            case 19:
                {
                    mpBack_Standing = mpCamlan_Char[4].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[4].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[4].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[4].mpCharObject[3];

                    mpCharName_Text.text = "아이렘";

                    mpCamlan_Char[4].gameObject.SetActive(true);
                }
                break;
            case 20:
                {
                    mpBack_Standing = mpCamlan_Char[5].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[5].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[5].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[5].mpCharObject[3];

                    mpCharName_Text.text = "고르곤";

                    mpCamlan_Char[5].gameObject.SetActive(true);
                }
                break;
            case 21:
                {
                    mpBack_Standing = mpCamlan_Char[6].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[6].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[6].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[6].mpCharObject[3];

                    mpCharName_Text.text = "베스타르";

                    mpCamlan_Char[6].gameObject.SetActive(true);
                }
                break;
            case 22:
                {
                    mpBack_Standing = mpCamlan_Char[7].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[7].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[7].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[7].mpCharObject[3];

                    mpCharName_Text.text = "새틴 레이니어";

                    mpCamlan_Char[7].gameObject.SetActive(true);
                }
                break;
            case 23:
                {
                    mpBack_Standing = mpCamlan_Char[8].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[8].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[8].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[8].mpCharObject[3];

                    mpCharName_Text.text = "하운드";

                    mpCamlan_Char[8].gameObject.SetActive(true);
                }
                break;
            case 24:
                {
                    mpBack_Standing = mpCamlan_Char[9].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[9].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[9].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[9].mpCharObject[3];

                    mpCharName_Text.text = "바칼";

                    mpCamlan_Char[9].gameObject.SetActive(true);
                }
                break;
            case 25:
                {
                    mpBack_Standing = mpCamlan_Char[10].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[10].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[10].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[10].mpCharObject[3];

                    mpCharName_Text.text = "글렌디스 오 두바하인";

                    mpCamlan_Char[10].gameObject.SetActive(true);
                }
                break;
            case 26:
                {
                    mpBack_Standing = mpCamlan_Char[11].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[11].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[11].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[11].mpCharObject[3];

                    mpCharName_Text.text = "헬레네 앙겔";

                    mpCamlan_Char[11].gameObject.SetActive(true);
                }
                break;
            case 27:
                {
                    mpBack_Standing = mpCamlan_Char[12].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[12].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[12].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[12].mpCharObject[3];

                    mpCharName_Text.text = "타타";

                    mpCamlan_Char[12].gameObject.SetActive(true);
                }
                break;
            case 28:
                {
                    mpBack_Standing = mpCamlan_Char[13].mpCharObject[0];
                    mpBack_Run = mpCamlan_Char[13].mpCharObject[1];
                    mpFront_Standing = mpCamlan_Char[13].mpCharObject[2];
                    mpFront_Run = mpCamlan_Char[13].mpCharObject[3];

                    mpCharName_Text.text = "올리비아 캐리건";

                    mpCamlan_Char[13].gameObject.SetActive(true);
                }
                break;
        }
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

    public void SetDirection()
    {
        transform.rotation = mLeft;
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
                transform.rotation = mRight;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(true);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(false);
            }
            else
            {
                Debug.Log("Side_우하");
                mIsBack = false;
                transform.rotation = mLeft;
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
                transform.rotation = mLeft;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(true);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(false);
            }
            else
            {
                Debug.Log("Side_좌하");
                mIsBack = false;
                transform.rotation = mRight;
                mpBack_Standing.SetActive(false);
                mpBack_Run.SetActive(false);
                mpFront_Standing.SetActive(false);
                mpFront_Run.SetActive(true);
            }
        }
    }
}
