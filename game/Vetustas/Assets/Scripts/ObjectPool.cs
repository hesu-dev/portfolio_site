using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public partial class ObjectPool : Singleton<ObjectPool>
{
    public class PoolObject : ObjectBase
    {
        public Object cachedObject;
        public bool isDynamicPoolObject;
    }

    public Transform cachedObjectRecycleTargetTransform
    {
        get
        {
            if (m_cachedObjectRecycleTargetTransform == null)
            {
                Transform parnetObject = new GameObject("PoolParent").GetComponent<Transform>();
                m_cachedObjectRecycleTargetTransform = parnetObject;
                parnetObject.SetParent(transform);
                parnetObject.gameObject.SetActive(false);
            }

            return m_cachedObjectRecycleTargetTransform;
        }
    }
    private Transform m_cachedObjectRecycleTargetTransform;

    public Transform cachedObjectRecycleTargetTransformForDynamicCreatedObject
    {
        get
        {
            if (m_cachedObjectRecycleTargetTransformForDynamicCreatedObject == null)
            {
                Transform parnetObject = new GameObject("PoolParentForDynamicCreatedObject").GetComponent<Transform>();
                m_cachedObjectRecycleTargetTransformForDynamicCreatedObject = parnetObject;
                parnetObject.SetParent(transform);
                parnetObject.gameObject.SetActive(false);
            }

            return m_cachedObjectRecycleTargetTransformForDynamicCreatedObject;
        }
    }
    private Transform m_cachedObjectRecycleTargetTransformForDynamicCreatedObject;

    private Dictionary<string, GameObject> m_basePrefabDictionary = new Dictionary<string, GameObject>();

    private Dictionary<string, List<PoolObject>> m_totalObjectPoolDictionary = new Dictionary<string, List<PoolObject>>();
    private Dictionary<string, List<PoolObject>> m_currentNotUsingPoolDictionary = new Dictionary<string, List<PoolObject>>();
    private Dictionary<string, List<PoolObject>> m_currentUsingPoolDictionary = new Dictionary<string, List<PoolObject>>();

    private List<string> m_totalDynamicCreatedPoolNameList = new List<string>();

    public static void CreatePool<T>(GameObject baseObject, int poolCount, bool isDynamicPool = false) where T : Object
    {
        Instance.createPool<T>(baseObject, poolCount, isDynamicPool);
    }

    public static T Spawn<T>(string poolName) where T : Object
    {
        return Instance.spawn<T>(poolName, Vector3.zero, Vector3.zero, Vector3.one, null);
    }

    public static T Spawn<T>(string poolName, Vector3 localPosition) where T : Object
    {
        return Instance.spawn<T>(poolName, localPosition, Vector3.zero, Vector3.one, null);
    }

    public static T Spawn<T>(string poolName, Vector3 localPosition, Transform parent) where T : Object
    {
        return Instance.spawn<T>(poolName, localPosition, Vector3.zero, Vector3.one, parent);
    }

    public static T Spawn<T>(string poolName, Vector3 localPosition, Vector3 localRotation) where T : Object
    {
        return Instance.spawn<T>(poolName, localPosition, localRotation, Vector3.one, null);
    }

    public static T Spawn<T>(string poolName, Vector3 localPosition, Vector3 localRotation, Vector3 localScale) where T : Object
    {
        return Instance.spawn<T>(poolName, localPosition, localRotation, localScale, null);
    }

    public static T Spawn<T>(string poolName, Vector3 localPosition, Vector3 localRotation, Vector3 localScale, Transform parent) where T : Object
    {
        return Instance.spawn<T>(poolName, localPosition, localRotation, localScale, parent);
    }

    public static void Recycle(Object targetObject)
    {
        Instance.recycle(targetObject);
    }

    public static void Clear(params string[] ignoreObjectPoolNames)
    {
        Instance.clear(ignoreObjectPoolNames);
    }

    public static void ClearTargetPools(params string[] targetObjectPoolNames)
    {
        Instance.clearTargetPools(targetObjectPoolNames);
    }

    public static void DestroyDynamicPools()
    {
        Instance.destroyDynamicPools();
    }
}
