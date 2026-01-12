using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public partial class ObjectPool : Singleton<ObjectPool>
{
    private void createPool<T>(GameObject baseObject, int poolCount, bool isDynamicPool = false) where T : Object
    {
        string objectName = baseObject.name;

        Transform recycleTargetParent = null;

        if (m_basePrefabDictionary.ContainsKey(objectName) == false)
        {
            m_basePrefabDictionary.Add(objectName, baseObject);
        }

        if (isDynamicPool)
        {
            recycleTargetParent = cachedObjectRecycleTargetTransformForDynamicCreatedObject;
            m_totalDynamicCreatedPoolNameList.Add(objectName);
        }
        else
        {
            recycleTargetParent = cachedObjectRecycleTargetTransform;
        }

        if (m_totalObjectPoolDictionary.ContainsKey(objectName) == false)
        {
            m_totalObjectPoolDictionary.Add(objectName, new List<PoolObject>());
            m_currentNotUsingPoolDictionary.Add(objectName, new List<PoolObject>());
            m_currentUsingPoolDictionary.Add(objectName, new List<PoolObject>());
        }

        List<PoolObject> poolObjectList = m_totalObjectPoolDictionary[objectName];
        List<PoolObject> currentNotUsingpoolObject = m_currentNotUsingPoolDictionary[objectName];

        for (int i = 0; i < poolCount; i++)
        {
            PoolObject createdObject = Object.Instantiate<GameObject>(baseObject).AddComponent<PoolObject>();

            if (typeof(T) == createdObject.CachedGameObject.GetType())
                createdObject.cachedObject = createdObject.CachedGameObject;
            else
                createdObject.cachedObject = createdObject.GetComponent<T>();

            createdObject.name = objectName;
            createdObject.isDynamicPoolObject = isDynamicPool;
            createdObject.CachedTransform.SetParent(recycleTargetParent);
            poolObjectList.Add(createdObject);
            currentNotUsingpoolObject.Add(createdObject);
        }
    }

    private T spawn<T>(string poolName, Vector3 localPosition, Vector3 localRotation, Vector3 localScale, Transform parent) where T : Object
    {
        PoolObject poolObject = null;

        if (m_totalObjectPoolDictionary.ContainsKey(poolName))
        {
            List<PoolObject> poolList = m_currentNotUsingPoolDictionary[poolName];

            if (poolList.Count > 0)
            {
                poolObject = poolList[0];
                poolList.Remove(poolObject);
            }
            else
            {
                PoolObject createdPoolObject = Object.Instantiate(m_basePrefabDictionary[poolName]).AddComponent<PoolObject>();

                if (typeof(T) == createdPoolObject.CachedGameObject.GetType())
                    createdPoolObject.cachedObject = createdPoolObject.CachedGameObject;
                else
                    createdPoolObject.cachedObject = createdPoolObject.GetComponent<T>();

                createdPoolObject.name = poolName;
                poolObject = createdPoolObject;
#if UNITY_EDITOR
                //Debug.LogWarning("This object is created from 'Spawn()'.\nPool name : " + poolName);
#endif
            }

            Transform objectAsTransform = poolObject.CachedTransform;
            GameObject objectAsGameObject = poolObject.CachedGameObject;

            objectAsTransform.SetParent(parent);
            objectAsTransform.localPosition = localPosition;
            objectAsTransform.localEulerAngles = localRotation;
            objectAsTransform.localScale = localScale;

            if (objectAsGameObject.activeSelf == false)
                objectAsGameObject.SetActive(true);

            m_currentUsingPoolDictionary[poolName].Add(poolObject);
        }
        else
        {
#if UNITY_EDITOR
            //Debug.LogError("This object isn't created. You need to call 'CreatePool()' method.\nPool name : " + poolName);
#endif
        }
        return poolObject != null ? poolObject.cachedObject as T : null;
    }

    private void recycle(Object targetObject)
    {
        string poolName = targetObject.name;

        List<PoolObject> currentUsingPoolList = m_currentUsingPoolDictionary[poolName];

        PoolObject targetRecycleObject = null;

        for (int i = 0; i < currentUsingPoolList.Count; i++)
        {
            if (currentUsingPoolList[i].cachedObject == targetObject ||
                currentUsingPoolList[i].CachedGameObject == targetObject)
            {
                targetRecycleObject = currentUsingPoolList[i];
            }
        }

        if (targetRecycleObject != null)
        {
            Transform recycleTargetParent = null;

            if (targetRecycleObject.isDynamicPoolObject)
                recycleTargetParent = cachedObjectRecycleTargetTransformForDynamicCreatedObject;
            else
                recycleTargetParent = cachedObjectRecycleTargetTransform;

            targetRecycleObject.CachedTransform.SetParent(recycleTargetParent);
            targetRecycleObject.CachedTransform.position = Vector2.one * 1000;
            currentUsingPoolList.Remove(targetRecycleObject);
            m_currentNotUsingPoolDictionary[poolName].Add(targetRecycleObject);
        }
    }

    private void clear(params string[] ignoreObjectPoolNames)
    {
        List<PoolObject> totalTargetClearPoolObjectList = new List<PoolObject>();
        foreach (KeyValuePair<string, List<PoolObject>> item in m_currentUsingPoolDictionary)
        {
            bool isCanClear = true;

            for (int i = 0; i < ignoreObjectPoolNames.Length; i++)
            {
                if (ignoreObjectPoolNames[i].Equals(item.Key))
                {
                    isCanClear = false;
                    break;
                }
            }

            if (isCanClear)
            {
                List<PoolObject> currentPoolObjects = item.Value;

                for (int i = 0; i < currentPoolObjects.Count; i++)
                {
                    totalTargetClearPoolObjectList.Add(currentPoolObjects[i]);
                }
            }
        }

        for (int i = 0; i < totalTargetClearPoolObjectList.Count; i++)
        {
            string currentName = totalTargetClearPoolObjectList[i].name;
            if (m_currentUsingPoolDictionary.ContainsKey(currentName))
            {
                recycle(totalTargetClearPoolObjectList[i].cachedObject);
            }
        }
    }

    private void clearTargetPools(params string[] targetObjectPoolNames)
    {
        List<PoolObject> totalTargetClearPoolObjectList = new List<PoolObject>();
        foreach (KeyValuePair<string, List<PoolObject>> item in m_currentUsingPoolDictionary)
        {
            bool isCanClear = false;

            for (int i = 0; i < targetObjectPoolNames.Length; i++)
            {
                if (targetObjectPoolNames[i].Equals(item.Key))
                {
                    isCanClear = true;
                    break;
                }
            }

            if (isCanClear)
            {
                List<PoolObject> currentPoolObjects = item.Value;

                for (int i = 0; i < currentPoolObjects.Count; i++)
                {
                    totalTargetClearPoolObjectList.Add(currentPoolObjects[i]);
                }
            }
        }

        for (int i = 0; i < totalTargetClearPoolObjectList.Count; i++)
        {
            string currentName = totalTargetClearPoolObjectList[i].name;
            if (m_currentUsingPoolDictionary.ContainsKey(currentName))
            {
                recycle(totalTargetClearPoolObjectList[i].cachedObject);
            }
        }
    }

    private void destroyDynamicPools()
    {
        for (int i = 0; i < m_totalDynamicCreatedPoolNameList.Count; i++)
        {
            List<PoolObject> totalPoolList = m_totalObjectPoolDictionary[m_totalDynamicCreatedPoolNameList[i]];

            for (int j = 0; j < totalPoolList.Count; j++)
            {
                DestroyImmediate(totalPoolList[i]);
            }

            List<PoolObject> currentUsingPoolList = m_currentUsingPoolDictionary[m_totalDynamicCreatedPoolNameList[i]];

            for (int j = 0; j < currentUsingPoolList.Count; j++)
            {
                DestroyImmediate(totalPoolList[i]);
            }

            List<PoolObject> currentNotUsingPoolList = m_currentNotUsingPoolDictionary[m_totalDynamicCreatedPoolNameList[i]];

            for (int j = 0; j < currentNotUsingPoolList.Count; j++)
            {
                DestroyImmediate(totalPoolList[i]);
            }

            m_totalObjectPoolDictionary.Remove(m_totalDynamicCreatedPoolNameList[i]);
            m_currentUsingPoolDictionary.Remove(m_totalDynamicCreatedPoolNameList[i]);
            m_currentNotUsingPoolDictionary.Remove(m_totalDynamicCreatedPoolNameList[i]);
        }
        m_totalDynamicCreatedPoolNameList.Clear();
    }
}
