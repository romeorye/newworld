package iris.web.common.util;

import java.util.Date;
import java.util.List;
import java.util.Map;

public class TableRow
{

	@SuppressWarnings("rawtypes")
	protected TableRow(List columns, Map columnNames)
    {
        fields = new TableField[columns.size()];
        for(int i = 0; i < columns.size(); i++)
            fields[i] = new TableField(((TableColumn)columns.get(i)).getType());

        this.columnNames = columnNames;
    }

    public TableField getField(int index)
    {
        return fields[index - 1];
    }

    public TableField getField(String columnName)
    {
        Integer index = (Integer)columnNames.get(columnName);
        if(index != null)
            return getField(index.intValue());
        else
            return null;
    }

    public void setRowKey(RowKey key)
    {
        this.key = key;
    }

    protected RowKey getRowKey()
    {
        return key;
    }

    public void setValue(int index, Object o)
    {
        getField(index).setValue(o);
    }

    public void setValue(int index, boolean x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, short x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, int x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, long x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, double x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, float x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, Date x)
    {
        getField(index).setValue(x);
    }

    public void setValue(int index, String x)
    {
        getField(index).setValue(x);
    }

    public void setValue(String columnName, boolean x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, Object o)
    {
        getField(columnName).setValue(o);
    }

    public void setValue(String columnName, short x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, int x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, long x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, double x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, float x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, Date x)
    {
        getField(columnName).setValue(x);
    }

    public void setValue(String columnName, String x)
    {
        getField(columnName).setValue(x);
    }

    public void setStringValues(String data[])
    {
        int minColumns = fields.length > data.length ? data.length : fields.length;
         for(int i = 0; i < minColumns; i++)
        {

           if ( data[i] != null)
           {
           	 fields[i].setValue(data[i]);
           }
           else
           {
           	fields[i].setValue("");
           }

        }

        for(int i = minColumns + 1; i < fields.length; i++)
            fields[i].setValue("");

    }

    private TableField fields[];
	@SuppressWarnings("rawtypes")
	private Map columnNames;
    private RowKey key;
}
