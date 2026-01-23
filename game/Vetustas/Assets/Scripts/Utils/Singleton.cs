using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//@Bump
//싱글톤 간편화

public class Singleton<T> : ObjectBase where T : Singleton<T>
{
    private static T mInstance;

    public static T Instance
    {
        get
        {
            if (mInstance == null)
            {
                T t = (T)FindObjectOfType(typeof(T));

                if (t == null)
                    Debug.LogError("Singleton null error");
                else
                    mInstance = t;
            }

            return mInstance;
        }
    }
}
