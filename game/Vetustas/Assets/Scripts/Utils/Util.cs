using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;
using UnityEngine.UI;

public static class Util
{
    private static string GetCalculatiedUnit(double tUnitIndex)
    {
        string tUnit = "";

        switch ((long)tUnitIndex)
        {
            case 1:
                tUnit = "K";
                break;
            case 2:
                tUnit = "M";
                break;
            case 3:
                tUnit = "B";
                break;
            case 4:
                tUnit = "T";
                break;
            default:
                {
                    tUnitIndex -= 5;

                    int tConvertBase = 26;

                    tUnit = ConvertIndexToSymbol((int)tUnitIndex, tConvertBase, tUnit, tUnitIndex >= tConvertBase);
                }
                break;
        }

        return tUnit;
    }

    public static string ConvertIndexToSymbol(int tNumber, int tConvert, string tSolution, bool tIsNumberExcessOverConvertOnFirstCall)
    {
        int tRemainder = tNumber % tConvert;

        tSolution = GetSymbol(tRemainder) + tSolution;
        tNumber = tNumber / tConvert;

        if (tNumber > tConvert)
        {
            tSolution = ConvertIndexToSymbol(tNumber, tConvert, tSolution, tIsNumberExcessOverConvertOnFirstCall);
        }
        else if (tIsNumberExcessOverConvertOnFirstCall)
        {
            tSolution = GetSymbol(tNumber - 1) + tSolution;
        }

        return tSolution;
    }

    private static string GetSymbol(int tRemainNumber)
    {
        return (((char)(tRemainNumber + 97)).ToString());
    }

    public static string ChangeUnit(BigDouble tValue)
    {
        string tChangeUnitString = "";

        if (Math.Ceiling(tValue.mExponent) >= 3)
        {
            tValue = BigDouble.Rebalance(tValue);
            if (tValue.mExponent < 3)
            {
                tChangeUnitString = tValue.ToString("f0");
            }
            else
            {
                double tMod = Math.Ceiling(tValue.mExponent) % 3;
                double tUnitIndex = Math.Ceiling(tValue.mExponent) / 3;
                tChangeUnitString = string.Format("{0:0.##}{1}", tValue.mSignificand * Math.Pow(10, tMod), GetCalculatiedUnit(tUnitIndex));
            }
        }
        else
        {
            tChangeUnitString = tValue.ToString("f0");
        }

        return tChangeUnitString;
    }

    public static MemoryStream SerializeToStream<T>(T tO)
    {
        MemoryStream tStream = new MemoryStream();
        IFormatter tFormatter = new BinaryFormatter();
        tFormatter.Serialize(tStream, tO);
        return tStream;
    }

    public static object DeSerializeFromStream(MemoryStream tStream)
    {
        IFormatter tFormatter = new BinaryFormatter();
        tStream.Seek(0, SeekOrigin.Begin);
        object tO = tFormatter.Deserialize(tStream);
        return tO;
    }

    public static T ToEnum<T>(this string tStrEnumValue, T tDefaultValue)
    {
        T tRet = default(T);

        if (Enum.IsDefined(typeof(T), tStrEnumValue) == false)
        {
            tRet = tDefaultValue;
        }
        else
        {
            tRet = (T)Enum.Parse(typeof(T), tStrEnumValue);
        }

        return tRet;
    }

    public static void WaitFrame(int tFrame, Action tEndAction)
    {
        GameManager.Instance.StartCoroutine(WaitUpdate(tFrame, tEndAction));
    }

    private static IEnumerator WaitUpdate(int tFrame, Action tEndAction)
    {
        for (int i = 0; i < tFrame; i++)
        {
            yield return null;
        }

        if (tEndAction != null)
        {
            tEndAction();
        }
    }

    public static void WaitForSeconds(float tTime, Action tEndAction)
    {
        GameManager.Instance.StartCoroutine(WaitForSecondsUpdate(tTime, tEndAction));
    }

    private static IEnumerator WaitForSecondsUpdate(float tTime, Action tEndAction)
    {
        yield return new WaitForSeconds(tTime);

        if (tEndAction != null)
        {
            tEndAction();
        }
    }

    private static Dictionary<UnityEngine.Object, Transform> m_CachedTransformDictionary = new Dictionary<UnityEngine.Object, Transform>();

    public static Transform CachedTransform(this UnityEngine.Object tTarget)
    {
        if (m_CachedTransformDictionary.ContainsKey(tTarget) == false)
        {
            m_CachedTransformDictionary.Add(tTarget, (tTarget as Component).GetComponent<Transform>());
        }
        else
        {
            m_CachedTransformDictionary.Add(tTarget, (tTarget as GameObject).GetComponent<Transform>());
        }

        return m_CachedTransformDictionary[tTarget];
    }

    private static Dictionary<UnityEngine.Object, RectTransform> m_CachedRectTransformDictionary = new Dictionary<UnityEngine.Object, RectTransform>();

    public static RectTransform CachedRectTransform(this UnityEngine.Object tTarget)
    {
        if (m_CachedRectTransformDictionary.ContainsKey(tTarget) == false)
        {
            if ((tTarget as GameObject) == null)
            {
                m_CachedRectTransformDictionary.Add(tTarget, (tTarget as Component).GetComponent<RectTransform>());
            }
            else
            {
                m_CachedRectTransformDictionary.Add(tTarget, (tTarget as GameObject).GetComponent<RectTransform>());
            }
        }

        return m_CachedRectTransformDictionary[tTarget];
    }

    private static Dictionary<UnityEngine.Object, GameObject> m_CachedGameObjectDictionary = new Dictionary<UnityEngine.Object, GameObject>();

    public static GameObject CachedGameObject(this UnityEngine.Object tTarget)
    {
        if (m_CachedGameObjectDictionary.ContainsKey(tTarget) == false)
        {
            if ((tTarget as GameObject) == null)
            {
                m_CachedGameObjectDictionary.Add(tTarget, (tTarget as Component).gameObject);
            }
            else
            {
                m_CachedGameObjectDictionary.Add(tTarget, (tTarget as GameObject));
            }
        }

        return m_CachedGameObjectDictionary[tTarget];
    }

    private static Dictionary<UnityEngine.Object, Animation> m_CachedAnimationDictionary = new Dictionary<UnityEngine.Object, Animation>();

    public static Animation CachedAnimation(this UnityEngine.Object tTarget)
    {
        if (m_CachedAnimationDictionary.ContainsKey(tTarget) == false)
        {
            if ((tTarget as GameObject) == null)
            {
                m_CachedAnimationDictionary.Add(tTarget, (tTarget as Component).GetComponent<Animation>());
            }
            else
            {
                m_CachedAnimationDictionary.Add(tTarget, (tTarget as GameObject).GetComponent<Animation>());
            }
        }

        return m_CachedAnimationDictionary[tTarget];
    }

    public static string ConvertTimeSpanToString(TimeSpan tTimeSpan)
    {
        string tTimeString = "";

        if ((int)tTimeSpan.TotalDays >= 1)
        {
            tTimeString = string.Format("{0:00}:{1:00}:{2:00}:{3:00}", (int)tTimeSpan.TotalDays, tTimeSpan.Hours, tTimeSpan.Minutes, tTimeSpan.Seconds);
        }
        else if ((int)tTimeSpan.TotalHours >= 1)
        {
            tTimeString = string.Format("{0:00}:{1:00}:{2:00}", (int)tTimeSpan.TotalHours, tTimeSpan.Minutes, tTimeSpan.Seconds);
        }
        else if ((int)tTimeSpan.TotalMinutes >= 1)
        {
            tTimeString = string.Format("{0:00}:{1:00}", (int)tTimeSpan.TotalMinutes, tTimeSpan.Seconds);
        }
        else
        {
            tTimeString = string.Format("00:{0:00}", (int)tTimeSpan.TotalSeconds);
        }

        return tTimeString;
    }
}
