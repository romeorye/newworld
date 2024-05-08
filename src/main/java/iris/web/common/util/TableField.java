package iris.web.common.util;

import java.sql.Date;

public class TableField
{

    protected TableField(int type)
    {
        valObj = null;
        valLong = 0L;
        valDouble = 0.0D;
        this.type = type;
    }

    protected int getType()
    {
        return type;
    }

    public void setValue(boolean x)
    {
        if(type != -7)
        {
            throw new RuntimeException("Value type boolean does not match column type");
        } else
        {
            valLong = x ? -1L : 0L;
            return;
        }
    }

    public void setValue(Object o)
    {
        if(type != 1111 && type != 91 && type != 12)
        {
            throw new RuntimeException("Value type java.lang.Object does not match column type");
        } else
        {
            valObj = o;
            return;
        }
    }

    public void setValue(short x)
    {
        if(type != 4 && type != -5 && type != -6)
        {
            throw new RuntimeException("Value type short does not match column type");
        } else
        {
            valLong = x;
            return;
        }
    }

    public void setValue(int x)
    {
        if(type != 4 && type != -5)
        {
            throw new RuntimeException("Value type int does not match column type");
        } else
        {
            valLong = x;
            return;
        }
    }

    public void setValue(long x)
    {
        if(type != -5)
        {
            throw new RuntimeException("Value type long does not match column type");
        } else
        {
            valLong = x;
            return;
        }
    }

    public void setValue(double x)
    {
        if(type != 8)
        {
            throw new RuntimeException("Value type double does not match column type");
        } else
        {
            valDouble = x;
            return;
        }
    }

    public void setValue(float x)
    {
        if(type != 8 && type != 6)
        {
            throw new RuntimeException("Value type int does not match column type");
        } else
        {
            valDouble = x;
            return;
        }
    }

    public void setValue(Date x)
    {
        if(type != 91)
        {
            throw new RuntimeException("Value type java.sql.Date does not match column type");
        } else
        {
            valObj = x;
            return;
        }
    }

    public void setValue(String x)
    {
        if(type != 1111 && type != 91 && type != 12)
        {
            throw new RuntimeException("Value type java.lang.String does not match column type");
        } else
        {
            valObj = x;
            return;
        }
    }

    protected boolean getBoolean()
    {
        return valLong != 0L;
    }

    protected byte getByte()
    {
        return (byte)(int)valLong;
    }

    protected Object getObject()
    {
        Object returnVal = null;
        switch(type)
        {
        case 8: // '\b'
            returnVal = new Double(valDouble);
            break;

        case 6: // '\006'
            returnVal = new Float(valDouble);
            break;

        case -7:
            returnVal = new Boolean(valLong == -1L);
            break;

        case 91: // '['
            returnVal = valObj;
            break;

        case 1111:
            returnVal = valObj;
            break;

        case 12: // '\f'
            returnVal = valObj;
            break;

        case 4: // '\004'
            returnVal = new Integer((int)valLong);
            break;

        case -5:
            returnVal = new Long(valLong);
            break;

        case -6:
            returnVal = new Short((short)(int)valLong);
            break;

        case -2:
            returnVal = new Byte((byte)(int)valLong);
            break;
        }
        return returnVal;
    }

    protected short getShort()
    {
        return (short)(int)valLong;
    }

    protected int getInt()
    {
        return (int)valLong;
    }

    protected long getLong()
    {
        return valLong;
    }

    protected double getDouble()
    {
        return valDouble;
    }

    protected float getFloat()
    {
        return (float)valDouble;
    }

    protected Date getDate()
    {
        return (Date)valObj;
    }

    protected String getString()
    {
        if(type == 8 || type == 6)
            return "" + valDouble;
        if(type == -7)
            return valLong != -1L ? "false" : "true";
        if(type == 91 || type == 1111 || type == 12)
        {	if(valObj != null)
        		return valObj.toString();
        	else
        		return "null";
        }
        else
            return "" + valLong;
    }

    private Object valObj;
    private long valLong;
    private double valDouble;
    private int type;
}
