using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class ChracterSceneManager : MonoBehaviour {

    public CanvasGroup mChracterSceneCanvasGroup;
    public CanvasScaler mChracterSceneCanvasScaler;

    public GameObject mFlag_Kamelot;
    public GameObject mFlag_Camlan;

    public Text mCharName_Text;
    public Text mCharInfo_Text;
    public Image mCharImg;

    public List<Sprite> mCharImage_List;
    public List<string> mCharName_List;
    public List<string> mCharInfo_List;

    public bool mIsFadeComplete = false;

    private void Awake()
    {    
        CanvasManager.Instance.SetCanvasScreen(mChracterSceneCanvasScaler);

        SetCharData();

        if (GameDataManager.mUser_Kingdom == 0)
        {
            mFlag_Kamelot.SetActive(true);
            mFlag_Camlan.SetActive(false);
            GameDataManager.mUser_Char_Num = 0;
            Change_CharInfo(GameDataManager.mUser_Char_Num);
        }
        else
        {
            mFlag_Kamelot.SetActive(false);
            mFlag_Camlan.SetActive(true);
            GameDataManager.mUser_Char_Num = 15;
            Change_CharInfo(GameDataManager.mUser_Char_Num);
        }        
    }

    private void Start()
    {
        FadeManager.Instance.FadeIn_Canvas(1.0f, delegate { mIsFadeComplete = true; }, mChracterSceneCanvasGroup);
    }

    public void SetCharData()
    {
        mCharName_List.Clear();
        //카멜롯
        mCharName_List.Add("아라운 막 아르투르");
        mCharName_List.Add("디안 케트");
        mCharName_List.Add("칼 비스탄");
        mCharName_List.Add("이그레인");
        mCharName_List.Add("슈크람 아이베르크");
        mCharName_List.Add("이루사");
        mCharName_List.Add("로스린다");
        mCharName_List.Add("루 메리골드");
        mCharName_List.Add("브리지트 플라타");
        mCharName_List.Add("새일 그란아이네헤");
        mCharName_List.Add("레이겐 슈라이어");
        mCharName_List.Add("라비엔 로렌조");
        mCharName_List.Add("세드릭 반스");
        mCharName_List.Add("팔라라크 필파");
        mCharName_List.Add("아드나 할리할");

        //캄란
        mCharName_List.Add("카단 다카르");
        mCharName_List.Add("틸데");
        mCharName_List.Add("이삭 프로이트");
        mCharName_List.Add("녹턴");
        mCharName_List.Add("아이렘");
        mCharName_List.Add("고르곤");
        mCharName_List.Add("베스타르");
        mCharName_List.Add("새틴 레이니어");
        mCharName_List.Add("하운드");
        mCharName_List.Add("바칼");
        mCharName_List.Add("글렌디스 오 두바하인");
        mCharName_List.Add("헬레네 앙겔");
        mCharName_List.Add("타타");
        mCharName_List.Add("올리비아 캐리건");
        //mCharName_List.Add("다이어 눅토");


        mCharInfo_List.Clear();
        //카멜롯
        mCharInfo_List.Add("현왕\n아르투르의 적법한 후계자\n카멜롯의 국왕");                                                       //01.아라운
        mCharInfo_List.Add("몇 세기를 불멸로 살아온\n카멜롯의 요정왕\n약초학의 대가");                                             //02.디안 케트
        mCharInfo_List.Add("카멜롯의 대공\n아라운의 심부름꾼\n비스탄 가문의 유일한 후계자");                                       //03.칼 비스탄
        mCharInfo_List.Add("포모르와 디나시의 혼혈. \n토리섬의 사절이자, 발로르레르의 대표\n푸른 피의 용.");                       //04.이그레인
        mCharInfo_List.Add("아이베르크 가문의\n가주이자, 후작\n천문학파 마법사");                                                  //05.슈크람 아이베르크
        mCharInfo_List.Add("인간처럼 키워진\n아이베르크 가문의 요정\n카멜롯의 기사");                                              //06.이루사
        mCharInfo_List.Add("카멜롯의 요정기사로\n물과 얼음을 다루는\n자연계 마법사.");                                             //07.로스린다
        mCharInfo_List.Add("나르시스트이자\n이루사의 약혼자이자 연인\n허니 레몬향을 지닌 디나시");                                //08.도나하 놀란                             
        mCharInfo_List.Add("카멜롯의 기사\n빛을 잃은 환상술사.\n그리고 해묵은 저주의 주인");                                       //09.브리지트 플라타
        mCharInfo_List.Add("천공도시 출신의 요정\n약초학파의 마법사\n본체는 커다란 나무");                                         //10.새일 그란아이네헤
        mCharInfo_List.Add("과거 극단가희 출신으로\n아이리스 변경백의 피후원자\n카멜롯의 천문학파 마법사");                        //11.레이겐 슈라이어
        mCharInfo_List.Add("라비엔 남작가의 삼남\n 카멜롯의 기사.\n베스타르의 스승.");                                             //12.라비엔 로렌조
        mCharInfo_List.Add("코노트 출신으로\n칼킨 소속의 기사\n신체강화학파");                                                     //13.세드릭 반스
        mCharInfo_List.Add("카멜롯의 소속 마법사이자\n 공간이동학파의 마법을 구사하는\n가능성의 기사");                            //14.팔라라크 필파
        mCharInfo_List.Add("신체 강화학파의 카멜롯 기사\n 의수의족을 차고 있다.\n이삭의 전 약혼자");                               //15.아드나 할리할
        //캄란
        mCharInfo_List.Add("리어팔의 선택을 받은 반왕\n마법과 기사의 왕\n검은 산맥의 주인");                                       //01.카단 다카르
        mCharInfo_List.Add("전대 요정왕 마나난의\n일곱번째 아들이자\n캄란의 현요정왕");                                            //02.틸데
        mCharInfo_List.Add("전카멜롯 출신의 기사\n프로이트 가문의 차남\n소환학을 다루는 마법기사");                                //03.이삭 프로이트
        mCharInfo_List.Add("그레이뉴 가문의 장자로 귀족 출신\n반왕군을 지지함으로 의절당했다고 한다\n불속성의 마법기사");          //04.녹턴
        mCharInfo_List.Add("아르드바흐의 차남으로\n가문과는 연을 끊고\n운명에 따라 반왕군이 되었다\n환상마법을 쓰는 마법기사");    //05.아이렘
        mCharInfo_List.Add("졸라 가문의 장자로\n투박한 검술기법을 사용한다\n신체강화학파이자 인성파탄자");                         //06.고르곤
        mCharInfo_List.Add("비텔가문 출신의 외동으로,\n 바람마법을 구사한다.\n로렌조의 제자");                                     //07.베스타르
        mCharInfo_List.Add("멸족한 레이니어 가문의 출신.\n 백발백중의 명사수.\n캄란의 궁수부대 소속.");                            //08.새틴 레이니어
        mCharInfo_List.Add("얼스터 출신의 귀족 자제로,\n사냥과 추적에 능하다.\n신체강화학파");                                     //09.하운드
        mCharInfo_List.Add("평민 출신의 용병기사\n주 무기는 여러종류의 나이프며,\n저돌적으로 신체강화를 사용한다");                //10.바칼
        mCharInfo_List.Add("두바하인의 가주이자\n아르드와하의 영주\n신체강화학파인 캄란의 기사");                                  //11.글렌디스 오 두바하인
        mCharInfo_List.Add("천민 출신 귀족으로\n현 앙겔가의 가주\n근접전을 선호하는 사령학파");                                    //12.헬레네 앙겔
        mCharInfo_List.Add("전 카멜롯 견습 기사로\n새일의 손에 자랐다\n캄란의 약초학파");                                          //13.타타
        mCharInfo_List.Add("얼스터 출신, 케리건 가문의 장녀\n무기는 그레이트 엑스를 사용한다\n애주가, 술급기사");                  //14.올리비아 케리건
        //mCharInfo_List.Add("");                                                                                                    //15.다이어 눅토
    }
    public void Change_CharInfo(int tCharNum)
    {
        mCharImg.sprite = mCharImage_List[tCharNum];
        mCharName_Text.text = mCharName_List[tCharNum];
        mCharInfo_Text.text = mCharInfo_List[tCharNum];
    }

    public void Btn_Select()
    {
        if (mIsFadeComplete != false)
        {
            SoundManager.Effect_Play(1);
            FadeManager.Instance.FadeOut_Canvas(1.0f, delegate
            {
                SceneManager.LoadScene("PlayScene");
            }, mChracterSceneCanvasGroup);
        }
    }

    public void Btn_LeftArrow()
    {
        SoundManager.Effect_Play(2);

        if (GameDataManager.mUser_Kingdom == 0)
        {
            if (GameDataManager.mUser_Char_Num == 0)
            {
                GameDataManager.mUser_Char_Num = 14;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }
            else
            {
                GameDataManager.mUser_Char_Num -= 1;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }

        }
        else
        {
            if (GameDataManager.mUser_Char_Num == 15)
            {
                GameDataManager.mUser_Char_Num = 28;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }
            else
            {
                GameDataManager.mUser_Char_Num -= 1;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }
        }
    }

    public void Btn_RightArrow()
    {
        SoundManager.Effect_Play(2);

        if (GameDataManager.mUser_Kingdom == 0)
        {
            if (GameDataManager.mUser_Char_Num == 14)
            {
                GameDataManager.mUser_Char_Num = 0;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }
            else
            {
                GameDataManager.mUser_Char_Num += 1;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }

        }
        else
        {
            if (GameDataManager.mUser_Char_Num == 28)
            {
                GameDataManager.mUser_Char_Num = 15;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }
            else
            {
                GameDataManager.mUser_Char_Num += 1;
                Change_CharInfo(GameDataManager.mUser_Char_Num);
            }
        }
    }

    public void Btn_Back()
    {
        FadeManager.Instance.FadeOut_Canvas(1.0f, delegate { SceneManager.LoadScene("SelectScene"); }, mChracterSceneCanvasGroup);
    }
}
