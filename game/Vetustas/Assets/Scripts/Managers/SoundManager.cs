using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using AndroidAudioBypass;

[RequireComponent(typeof(AudioSource))]
public class SoundManager : Singleton<SoundManager>
{
    public static float EffectVolume
    {
        get
        {
            return PlayerPrefs.GetFloat("EffectVolume", 1);
        }
        set
        {
            PlayerPrefs.SetFloat("EffectVolume", value);
        }
    }

    public static float BGMVolume
    {
        get
        {
            return PlayerPrefs.GetFloat("BGMVolume", 1);
        }
        set
        {
            PlayerPrefs.SetFloat("BGMVolume", value);
        }
    }


    public List<BypassAudioSource> mBGMAudioList;
    public GameObject mBGM_Title;
    public GameObject mBGM_Game;
    public List<BypassAudioSource> mEffectList;

    public string mEffectSoundFolderPath = "Assets/Sounds/Effect";
    public string mBGMSoundFolderPath = "Assets/Sounds/BGM";

    public List<AudioClip> mEffectAudioClipList;
    private Dictionary<string, AudioClip> m_EffectTotalAudioClipData;

    public List<AudioClip> mBGMAudioClipList;
    private Dictionary<string, AudioClip> m_BGMTotalAudioClipData;

    public AudioSource BGMAudioSource
    {
        get
        {
            if (m_BGMAudioSource == null)
            {
                m_BGMAudioSource = GetComponent<AudioSource>();
            }

            return m_BGMAudioSource;
        }
    }
    private AudioSource m_BGMAudioSource;

    public AudioSource m_EffectAudioSource;

#if UNITY_EDITOR
    [ContextMenu("Register all sounds")]
    public void RegisterAllSounds()
    {
        mEffectAudioClipList = new List<AudioClip>();

        string[] tEffectGUIDs = UnityEditor.AssetDatabase.FindAssets("", new string[] { mEffectSoundFolderPath });

        for (int i = 0; i < tEffectGUIDs.Length; i++)
        {
            AudioClip tTargetClip = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(UnityEditor.AssetDatabase.GUIDToAssetPath(tEffectGUIDs[i]));
            mEffectAudioClipList.Add(tTargetClip);
        }

        mBGMAudioClipList = new List<AudioClip>();

        string[] tBGMGUIDs = UnityEditor.AssetDatabase.FindAssets("", new string[] { mBGMSoundFolderPath });

        for (int i = 0; i < tBGMGUIDs.Length; i++)
        {
            AudioClip tTargetClip = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(UnityEditor.AssetDatabase.GUIDToAssetPath(tBGMGUIDs[i]));
            mBGMAudioClipList.Add(tTargetClip);
        }
    }
#endif

    private void Awake()
    {
        if (SoundManager.Instance != null && SoundManager.Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        DontDestroyOnLoad(this);

        m_EffectTotalAudioClipData = new Dictionary<string, AudioClip>();
        m_BGMTotalAudioClipData = new Dictionary<string, AudioClip>();

        for (int i = 0; i < mEffectAudioClipList.Count; i++)
        {
            m_EffectTotalAudioClipData.Add(mEffectAudioClipList[i].name, mEffectAudioClipList[i]);
        }

        for (int i = 0; i < mBGMAudioClipList.Count; i++)
        {
            m_BGMTotalAudioClipData.Add(mBGMAudioClipList[i].name, mBGMAudioClipList[i]);
        }
    }

    public static void PlayBGMSound(string tBGMName, bool tLoop)
    {
        if (Instance.m_BGMTotalAudioClipData.ContainsKey(tBGMName) == false)
        {
            Debug.LogError("BGM key name " + tBGMName + " is not found");
            return;
        }

        AudioClip tClip = Instance.m_BGMTotalAudioClipData[tBGMName];

        Instance.BGMAudioSource.Stop();
        Instance.BGMAudioSource.clip = tClip;
        Instance.BGMAudioSource.loop = tLoop;
        Instance.BGMAudioSource.Play();
    }

    public static void StopBGMSound()
    {
        Instance.BGMAudioSource.Stop();
    }

    public static void PlayEffectSound(string tEffectName)
    {
        if (Instance.m_EffectTotalAudioClipData.ContainsKey(tEffectName) == false)
        {
            Debug.LogError("Effect key name " + tEffectName + " is not found");
            return;
        }

        AudioClip tClip = Instance.m_EffectTotalAudioClipData[tEffectName];

        AudioSource tAudioSource = Instance.m_EffectAudioSource;//ObjectPool.Spawn<AudioSource>("@AudioObject");

        tAudioSource.clip = tClip;
        tAudioSource.volume = EffectVolume;
        tAudioSource.Play();

        float tTotalLength = tClip.length * ((Time.timeScale * GameManager.mGameTimeScale >= 0.01f) ? Time.timeScale * GameManager.mGameTimeScale : 0.01f);
        /*
        Util.WaitForSeconds(tTotalLength, delegate
        {
            ObjectPool.Recycle(tAudioSource);
        });
        */
    }

    /// <summary>
    ///  0 : 00. lobby_bg
    ///  1 : 02. Arawn
    ///  2 : 03. kamelot castle1
    ///  3 : 04. kamelot castle2
    ///  4 : 04. op_bg_bgm 현왕 아라운
    ///  5 : 05. Liafail
    ///  6 : 06. escape or chase
    ///  9 : 09. kadan
    ///  10: 10. timerine_bgm
    /// </summary>
    /// <param name="tNum"></param>
    public static void BGM_Play(int tNum)
    {
        switch(tNum)
        {
            case 0:
                {
                    PlayBGMSound("00. lobby_bg", true);
                }
                break;
            case 1:
                {
                    PlayBGMSound("02. Arawn", true);
                }
                break;
            case 2:
                {
                    PlayBGMSound("03. kamelot castle1", true);
                }
                break;
            case 3:
                {
                    PlayBGMSound("04. kamelot castle2", true);
                }
                break;
            case 4:
                {
                    PlayBGMSound("04. op_bg_bgm 현왕 아라운", true);
                }
                break;
            case 5:
                {
                    PlayBGMSound("05. Liafail", true);
                }
                break;
            case 6:
                {
                    PlayBGMSound("06. escape or chase", true);
                }
                break;
            case 9:
                {
                    PlayBGMSound("09. kadan", true);
                }
                break;
            case 10:
                {
                    PlayBGMSound("10. timerine_bgm", true);
                }
                break;
        }
    }

    public static void BGM_Title()
    {
        /*
        if (mBGMAudioList.Count != 0 && mBGMAudioList[0] != null)
        {
            mBGM_Title.SetActive(true);
            mBGM_Game.SetActive(false);

            mBGMAudioList[0].Play();
        }
        */

        PlayBGMSound("title", true);
    }

    public static void BGM_Game()
    {
        /*
        if (mBGMAudioList.Count != 0 && mBGMAudioList[1] != null)
        {
            mBGM_Title.SetActive(false);
            mBGM_Game.SetActive(true);

            mBGMAudioList[1].Play();
        }
        */

        PlayBGMSound("game", true);
    }

    /// <summary>
    /// 0 : pen_writing
    /// 1 : chain
    /// 2 : page bgm
    /// 3 : stab effect
    /// 4 : walk
    /// 5 : map_horse_01
    /// 6 : button click
    /// </summary>
    /// <param name="tNum"></param>
    public static void Effect_Play(int tNum)
    {
        /*
        if (mEffectList.Count != 0 && mEffectList[tNum] != null)
        {
            mEffectList[tNum].Play();
        }
        */
        switch (tNum)
        {
            case 0:
                {
                    PlayEffectSound("01. pen-writing");
                }
                break;
            case 1:
                {
                    PlayEffectSound("02. chain");
                }
                break;
            case 2:
                {
                    PlayEffectSound("03. page bgm");
                }
                break;
            case 3:
                {
                    PlayEffectSound("05. stab effect");
                }
                break;
            case 4:
                {
                    PlayEffectSound("06. walk");
                }
                break;
            case 5:
                {
                    PlayEffectSound("08. map_horse_01");
                }
                break;
            case 6:
                {
                    PlayEffectSound("09. button click");
                }
                break;
        }
    }
    /*
    public void Effect_Machin()
    {
        if (mEffectList.Count != 0 && mEffectList[1] != null)
        {
            mEffectList[1].Play();
        }
    }

    public void Effect_Attack()
    {
        if (mEffectList.Count != 0 && mEffectList[2] != null)
        {
            mEffectList[2].Play();
        }
    }

    public void Effect_Skill_UP()
    {
        if (mEffectList.Count != 0 && mEffectList[3] != null)
        {
            mEffectList[3].Play();
        }
    }

    public void Effect_Coin_Buy()
    {
        if (mEffectList.Count != 0 && mEffectList[4] != null)
        {
            mEffectList[4].Play();
        }
    }

    public void Effect_Destroy_EnemyFlight()
    {
        if (mEffectList.Count != 0 && mEffectList[5] != null)
        {
            mEffectList[5].Play();
        }
    }

    public void Effect_Flight_UnLock()
    {
        if (mEffectList.Count != 0 && mEffectList[6] != null)
        {
            mEffectList[6].Play();
        }
    }

    public void Effect_MenuWindow_Pop()
    {
        if (mEffectList.Count != 0 && mEffectList[7] != null)
        {
            mEffectList[7].Play();
        }
    }

    public void Effect_Skill_HPHeal()
    {
        if (mEffectList.Count != 0 && mEffectList[8] != null)
        {
            mEffectList[8].Play();
        }
    }

    public void Effect_Skill_Laser()
    {
        if (mEffectList.Count != 0 && mEffectList[9] != null)
        {
            mEffectList[9].Play();
        }
    }

    public void Effect_Skill_Summon()
    {
        if (mEffectList.Count != 0 && mEffectList[10] != null)
        {
            mEffectList[10].Play();
        }
    }

    public void Effect_Skill_Shield()
    {
        if (mEffectList.Count != 0 && mEffectList[11] != null)
        {
            mEffectList[11].Play();
        }
    }

    public void Effect_Skill_Dash()
    {
        if (mEffectList.Count != 0 && mEffectList[12] != null)
        {
            mEffectList[12].Play();
        }
    }

    public void Effect_Skill_Bomb()
    {
        if (mEffectList.Count != 0 && mEffectList[13] != null)
        {
            mEffectList[13].Play();
        }
    }

    public void Effect_Coin_Get()
    {
        if (mEffectList.Count != 0 && mEffectList[14] != null)
        {
            mEffectList[14].Play();
        }
    }
    */
}
