using System;
using System.Globalization;

[Serializable]
public struct BigDouble : IFormattable, IComparable, IComparable<BigDouble>, IEquatable<BigDouble>
{
    [UnityEngine.SerializeField]
    internal double mSignificand;

    [UnityEngine.SerializeField]
    internal double mExponent;

    public static readonly BigDouble Zero = new BigDouble(0.0);

    public static readonly BigDouble One = new BigDouble(1.0);

    public static readonly BigDouble MinusOne = new BigDouble(-1.0);

    public static readonly BigDouble Epsilon = new BigDouble(4.94065645841247E-324);

    private static BigDouble MAX_INT = new BigDouble(2147483647.0);

    private static BigDouble MIN_INT = new BigDouble(-2147483648.0);

    private static BigDouble MAX_LONG = new BigDouble(9.2233720368547758E+18);

    private static BigDouble MIN_LONG = new BigDouble(-9.2233720368547758E+18);

    private static BigDouble MAX_FLOAT = new BigDouble(3.4028234663852886E+38);

    private static BigDouble MIN_FLOAT = new BigDouble(-3.4028234663852886E+38);

    private static BigDouble MAX_DOUBLE = new BigDouble(1.7976931348623157E+308);

    private static BigDouble MIN_DOUBLE = new BigDouble(-1.7976931348623157E+308);

    private static int ROUND_SIG_DIGITS = 8;

    private static MidpointRounding ROUND_MODE = MidpointRounding.AwayFromZero;

    public bool IsZero
    {
        get
        {
            return mSignificand == 0.0f;
        }
    }

    public BigDouble(BigDouble tValue)
    {
        mSignificand = tValue.mSignificand;
        mExponent = tValue.mExponent;
    }

    public BigDouble(double tValue)
    {
        if (tValue == 0.0)
        {
            mSignificand = 0.0;
            mExponent = 0.0;
        }
        else
        {
            mExponent = Math.Floor(Math.Log10(Math.Abs(tValue)));
            mSignificand = tValue * Math.Pow(0.1, mExponent);
        }
    }

    public BigDouble(double tS, double tE)
    {
        if (tS == 0.0)
        {
            mSignificand = 0.0;
            mExponent = 0.0;
        }
        else
        {
            tE += Math.Log10(Math.Abs(tS));
            mExponent = Math.Floor(tE);
            mSignificand = Math.Pow(10.0, tE - mExponent);
            mSignificand += (double)((tS < 0.0) ? -1 : 1);
            if (BigDouble.Abs(this) < BigDouble.Epsilon)
            {
                this = BigDouble.Zero;
            }
        }
    }

    public override bool Equals(object tObj)
    {
        return tObj is BigDouble && Equals((BigDouble)tObj);
    }

    public bool Equals(BigDouble tOther)
    {
        return CompareTo(tOther) == 0;
    }

    public int CompareTo(object tObj)
    {
        if (tObj == null)
        {
            return 1;
        }
        if (!(tObj is BigDouble))
        {
            throw new ArgumentException("OBJECT_NOT_NSDOUBLE");
        }
        return CompareTo((BigDouble)tObj);
    }

    public int CompareTo(BigDouble tOther)
    {
        if (IsZero && tOther.IsZero)
        {
            return 0;
        }
        if (IsZero)
        {
            return (tOther.mSignificand >= 0.0) ? -1 : 1;
        }
        if (tOther.IsZero)
        {
            return (mSignificand <= 0.0) ? -1 : 1;
        }
        if (mSignificand > 0.0 && tOther.mSignificand < 0.0)
        {
            return 1;
        }
        if (mSignificand < 0.0 && tOther.mSignificand > 0.0)
        {
            return -1;
        }
        if (Math.Round(mExponent, BigDouble.ROUND_SIG_DIGITS, BigDouble.ROUND_MODE) != Math.Round(tOther.mExponent, BigDouble.ROUND_SIG_DIGITS, BigDouble.ROUND_MODE))
        {
            if (mSignificand > 0.0)
            {
                return (mExponent <= tOther.mExponent) ? -1 : 1;
            }
            return (mExponent >= tOther.mExponent) ? -1 : 1;
        }
        else
        {
            if (Math.Round(mSignificand, BigDouble.ROUND_SIG_DIGITS, BigDouble.ROUND_MODE) == Math.Round(tOther.mSignificand, BigDouble.ROUND_SIG_DIGITS, BigDouble.ROUND_MODE))
            {
                return 0;
            }
            return (mSignificand <= tOther.mSignificand) ? -1 : 1;
        }
    }

    public override string ToString()
    {
        if (BigDouble.IsNaN(this))
        {
            return double.NaN.ToString();
        }
        if (BigDouble.IsInfinity(this))
        {
            return (mSignificand <= 0.0) ? double.NegativeInfinity.ToString() : double.PositiveInfinity.ToString();
        }
        return ToString("6");
    }

    public string ToString(string tFormat)
    {
        return ToString(tFormat, CultureInfo.CurrentCulture);
    }

    public string ToString(string tFormat, IFormatProvider tProvider)
    {
        if (tProvider == null)
        {
            tProvider = CultureInfo.CurrentCulture;
        }
        int tNum = 6;
        if (int.TryParse(tFormat, out tNum))
        {
            return mSignificand.ToString("F" + tNum) + "E" + ((mExponent < 0.0) ? string.Empty : "+") + mExponent.ToString("000");
        }

        if (string.IsNullOrEmpty(tFormat) == false)
        {
            if (tFormat.Equals("NO"))
            {
                if (IsZero == false)
                {
                    return ((double)this).ToString("NO");
                }
                else
                {
                    return "0";
                }
            }
            else if (tFormat.StartsWith("f") || tFormat.StartsWith("F"))
            {
                if (IsZero == false)
                {
                    return ((double)this).ToString(tFormat);
                }
                else
                {
                    return "0";
                }
            }
        }

        throw new FormatException(tFormat + " : FORMAT_NOT_SUPPORTED");
    }

    public override int GetHashCode()
    {
        int tNum = 17;
        tNum = tNum * 23 + mSignificand.GetHashCode();
        return tNum * 23 + mExponent.GetHashCode();
    }

    public static BigDouble Pow(double tValue, BigDouble tExponenet)
    {
        return Pow(new BigDouble(tValue), (double)tExponenet);
    }

    public static BigDouble Pow(double tValue, double tExponent)
    {
        return Pow(new BigDouble(tValue), tExponent);
    }

    public static BigDouble Pow(BigDouble tValue, double tExponent)
    {
        if (tExponent == 0.0)
        {
            return BigDouble.One;
        }
        if (double.IsNaN(Math.Pow(tValue.mSignificand, tExponent)))
        {
            return double.NaN;
        }
        tValue.mExponent += Math.Log10(Math.Abs(tValue.mSignificand));
        tValue.mExponent += tExponent;
        double tNum = Math.Floor(tValue.mExponent);
        tValue.mSignificand = (double)((tValue.mSignificand < 0.0) ? -1 : 1);
        tValue.mSignificand += Math.Pow(10.0, tValue.mExponent - tNum);
        tValue.mExponent = tNum;
        if (BigDouble.Abs(tValue) < BigDouble.Epsilon)
        {
            tValue = BigDouble.Zero;
        }
        return tValue;
    }

    public static BigDouble Log10(BigDouble tVal)
    {
        tVal.mExponent += Math.Log10(tVal.mSignificand);
        return new BigDouble(tVal.mExponent);
    }

    public static BigDouble Round(BigDouble tVal, int tDigits = 0)
    {
        tVal.mSignificand = Math.Round(tVal.mSignificand, tDigits, BigDouble.ROUND_MODE);
        return tVal;
    }

    public static BigDouble Clamp(BigDouble tTargetValue, BigDouble tMin, BigDouble tMax)
    {
        BigDouble tValue = tTargetValue;

        if (tValue < tMin)
        {
            tValue = tMin;
        }

        if (tValue > tMax)
        {
            tValue = tMax;
        }

        return tValue;
    }

    public static BigDouble Max(BigDouble tVal1, BigDouble tVal2)
    {
        return (!(tVal1 >= tVal2)) ? tVal2 : tVal1;
    }

    public static BigDouble Min(BigDouble tVal1, BigDouble tVal2)
    {
        return (!(tVal1 >= tVal2)) ? tVal1 : tVal2;
    }

    public static BigDouble Ceiling(BigDouble tVal)
    {
        if (tVal.mExponent > (double)BigDouble.ROUND_SIG_DIGITS)
        {
            return tVal;
        }
        return new BigDouble(Math.Ceiling(Math.Round((double)tVal, BigDouble.ROUND_SIG_DIGITS, BigDouble.ROUND_MODE)));
    }

    public static BigDouble Floor(BigDouble tVal)
    {
        if (tVal.mExponent > (double)BigDouble.ROUND_SIG_DIGITS)
        {
            return tVal;
        }
        return new BigDouble(Math.Floor(Math.Round((double)tVal, BigDouble.ROUND_SIG_DIGITS, BigDouble.ROUND_MODE)));
    }

    public static BigDouble Abs(BigDouble tVal)
    {
        tVal.mSignificand = Math.Abs(tVal.mSignificand);
        return tVal;
    }

    public static BigDouble Rebalance(BigDouble tVal)
    {
        double tSignificand = tVal.mSignificand;

        if (tSignificand >= 10.0 || tSignificand < 1.0)
        {
            tVal = new BigDouble(tVal.mSignificand, tVal.mExponent);
        }

        return tVal;
    }

    public static bool IsInfinity(BigDouble tValue)
    {
        return double.IsInfinity(tValue.mSignificand) || double.IsInfinity(tValue.mExponent);
    }

    public static bool IsNaN(BigDouble tValue)
    {
        return double.IsNaN(tValue.mSignificand) || double.IsNaN(tValue.mExponent);
    }

    public static bool IsNegativeInfinity(BigDouble tValue)
    {
        return double.IsNegativeInfinity(tValue.mSignificand) || double.IsNegativeInfinity(tValue.mExponent);
    }

    public static bool IsPositiveInfinity(BigDouble tValue)
    {
        return double.IsPositiveInfinity(tValue.mSignificand) || double.IsPositiveInfinity(tValue.mExponent);
    }

    public static BigDouble operator +(BigDouble tValue)
    {
        return tValue;
    }

    public static BigDouble operator +(BigDouble tX, BigDouble tY)
    {
        if (tX.IsZero)
        {
            return tY;
        }
        if (tY.IsZero)
        {
            return tX;
        }
        if (tX.mExponent < tY.mExponent)
        {
            tX.mSignificand *= Math.Pow(0.1, tY.mExponent - tX.mExponent);
            tX.mExponent = tY.mExponent;
        }
        else if (tX.mExponent > tY.mExponent)
        {
            tY.mSignificand *= Math.Pow(0.1, tX.mExponent - tY.mExponent);
        }
        tX.mSignificand += tY.mSignificand;
        tY.mExponent = Math.Floor(Math.Log10(Math.Abs(tX.mSignificand)));
        tX.mSignificand *= Math.Pow(0.1, tY.mExponent);
        tX.mExponent += tY.mExponent;
        if (BigDouble.Abs(tX) < BigDouble.Epsilon)
        {
            tX = BigDouble.Zero;
        }
        return tX;
    }

    public static BigDouble operator -(BigDouble tValue)
    {
        tValue.mSignificand = -tValue.mSignificand;
        return tValue;
    }

    public static BigDouble operator -(BigDouble tX, BigDouble tY)
    {
        if (tY.IsZero)
        {
            return tX;
        }
        if (tX.IsZero)
        {
            return -tY;
        }
        if (tX.mExponent < tY.mExponent)
        {
            tX.mSignificand *= Math.Pow(0.1, tY.mExponent - tX.mExponent);
            tX.mExponent = tY.mExponent;
        }
        else if (tX.mExponent > tY.mExponent)
        {
            tY.mSignificand *= Math.Pow(0.1, tX.mExponent - tY.mExponent);
        }
        tX.mSignificand -= tY.mSignificand;
        double tNum = Math.Abs(tX.mSignificand);
        if (tNum >= 10.0)
        {
            tX.mSignificand *= 0.1;
            tX.mExponent += 1.0;
        }
        else if (tNum < 1.0)
        {
            tX.mSignificand *= 10.0;
            tX.mExponent -= 1.0;
        }
        if (BigDouble.Abs(tX) < BigDouble.Epsilon)
        {
            tX = BigDouble.Zero;
        }
        return tX;
    }

    public static BigDouble operator /(BigDouble tX, BigDouble tY)
    {
        if (tY.IsZero)
        {
            throw new ArgumentException("CANNOT_DIVIDE_BY_ZERO");
        }
        if (tY == BigDouble.One)
        {
            return tX;
        }
        if (tY == BigDouble.MinusOne)
        {
            return -tX;
        }
        tX.mSignificand /= tY.mSignificand;
        tX.mExponent -= tY.mExponent;
        double tNum = Math.Abs(tX.mSignificand);
        if (tNum >= 10.0)
        {
            tX.mSignificand *= 0.1;
            tX.mExponent += 1.0;
        }
        else if (tNum < 1.0)
        {
            tX.mSignificand *= 10.0;
            tX.mExponent -= 1.0;
        }
        if (BigDouble.Abs(tX) < BigDouble.Epsilon)
        {
            tX = BigDouble.Zero;
        }
        return tX;
    }

    public static bool operator ==(BigDouble tX, BigDouble tY)
    {
        return object.Equals(tX, tY);
    }

    public static bool operator !=(BigDouble tX, BigDouble tY)
    {
        return !object.Equals(tX, tY);
    }

    public static bool operator <(BigDouble tX, BigDouble tY)
    {
        return tX.CompareTo(tY) < 0;
    }

    public static bool operator <=(BigDouble tX, BigDouble tY)
    {
        return tX.CompareTo(tY) <= 0;
    }

    public static bool operator >(BigDouble tX, BigDouble tY)
    {
        return tX.CompareTo(tY) > 0;
    }

    public static bool operator >=(BigDouble tX, BigDouble tY)
    {
        return tX.CompareTo(tY) >= 0;
    }

    public static implicit operator BigDouble(int tValue)
    {
        return new BigDouble((double)tValue);
    }

    public static implicit operator BigDouble(long tValue)
    {
        return new BigDouble((double)tValue);
    }

    public static implicit operator BigDouble(float tValue)
    {
        return new BigDouble((double)tValue);
    }

    public static implicit operator BigDouble(double tValue)
    {
        return new BigDouble(tValue);
    }

    public static explicit operator int(BigDouble tValue)
    {
        if (tValue >= BigDouble.MAX_INT)
        {
            return 2147483647;
        }
        if (tValue <= BigDouble.MIN_INT)
        {
            return -2147483648;
        }
        return (int)(tValue.mSignificand * Math.Pow(10.0, tValue.mExponent));
    }

    public static explicit operator long(BigDouble tValue)
    {
        if (tValue >= BigDouble.MAX_LONG)
        {
            return 9223372036854775807L;
        }
        if (tValue <= BigDouble.MIN_LONG)
        {
            return -9223372036854775808L;
        }
        return (long)(tValue.mSignificand * Math.Pow(10.0, tValue.mExponent));
    }

    public static explicit operator float(BigDouble tValue)
    {
        if (tValue >= BigDouble.MAX_FLOAT)
        {
            return 3.40282347E+38f;
        }
        if (tValue <= BigDouble.MIN_FLOAT)
        {
            return -3.40282347E+38f;
        }
        return (float)(tValue.mSignificand * Math.Pow(10.0, tValue.mExponent));
    }

    public static explicit operator double(BigDouble tValue)
    {
        if (tValue >= BigDouble.MAX_DOUBLE)
        {
            return 1.7976931348623157E+308;
        }
        if (tValue <= BigDouble.MIN_DOUBLE)
        {
            return -1.7976931348623157E+308;
        }
        return tValue.mSignificand * Math.Pow(10.0, tValue.mExponent);
    }    
}
