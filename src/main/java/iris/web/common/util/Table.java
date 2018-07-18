package iris.web.common.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class Table
{
	
    public static class NonEmptyTableAddedToRepositoryException extends RuntimeException
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public NonEmptyTableAddedToRepositoryException(String msg)
        {
            super(msg);
        }
    }

    public class ColumnAddedToRepositoryTableExcpetion extends RuntimeException
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public ColumnAddedToRepositoryTableExcpetion(String msg)
        {
            super(msg);
        }
    }

    public class ColumnAddedAfterRowInsertionExcpetion extends RuntimeException
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public ColumnAddedAfterRowInsertionExcpetion(String msg)
        {
            super(msg);
        }
    }

    public class NoColumnDefException extends RuntimeException 
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public NoColumnDefException(String msg)
        {
            super(msg);
        }
    }


    @SuppressWarnings("unchecked")
	public static void addStructure(String name, Table table)
    {
        if(table.getNumRows() > 0)
        {
            throw new NonEmptyTableAddedToRepositoryException("Table \"" + table.name + "\" can't be added to repository" + " because it already contains data.");
        } else
        {
            structureRepository.put(name, table);
            return;
        }
    }

    public static Table createFromStructure(String name)
    {
        Table table = (Table)structureRepository.get(name);
        Table newTable = null;
        if(table != null)
        {
            newTable = new Table(table.name);
            newTable.columns = table.columns;
            newTable.columnNames = table.columnNames;
            newTable.numColumns = table.numColumns;
            newTable.fromRepository = true;
        }
        return newTable;
    }

	@SuppressWarnings("rawtypes")
	public Table(String name)
    {
        columns = new ArrayList();
        columnNames = new HashMap();
        numColumns = 0;
        numRows = 0;
        rows = new LinkedList();
        fromRepository = false;
        this.name = name;
    }

    protected String getName()
    {
        return name;
    }

    protected int findColumn(String columnName)
    {
        Integer index = (Integer)columnNames.get(columnName);
        return index != null ? index.intValue() : -1;
    }

    protected TableColumn getColumn(int index)
    {
        return (TableColumn)columns.get(index - 1);
    }

    protected int getNumColumns()
    {
        return numColumns;
    }

    @SuppressWarnings("unchecked")
	public void addColumn(int type, String name)
    {
        if(numRows > 0)
            throw new ColumnAddedAfterRowInsertionExcpetion("You can't add columns after adding rows to the table");
        if(fromRepository)
        {
            throw new ColumnAddedToRepositoryTableExcpetion("You can't add columns to tables from a repository");
        } else
        {
            columns.add(new TableColumn(type, name));
            columnNames.put(name, new Integer(numColumns + 1));
            numColumns++;
            return;
        }
    }

    @SuppressWarnings("unchecked")
	public TableRow insertRow()
    {
        if(numColumns == 0)
        {
            throw new NoColumnDefException("Add columns to table before inserting rows");
        } else
        {
            TableRow row = new TableRow(columns, columnNames);
            rows.add(row);
            numRows++;
            return row;
        }
    }
    
	public void clear()
    {
        if(numColumns == 0)
        {
            throw new NoColumnDefException("Add columns to table before inserting rows");
        } else
        {
            rows.clear();
        }
    }
    
    public int getNumRows()
    {
        return numRows;
    }

    protected TableRow getRow(int index)
    {
        return (TableRow)rows.get(index - 1);
    }

    public String toString()
    {
        StringBuffer bufHeader = new StringBuffer();
        StringBuffer bufData = new StringBuffer();
        StringBuffer bufDelim = new StringBuffer();
        int widths[] = new int[numColumns];
        int widthTotal = 0;
        bufHeader.append("| [No] | ");
        for(int i = 0; i < numColumns; i++)
        {
            TableColumn col = (TableColumn)columns.get(i);
            int widthHeader = col.getName().length();
            int widthData;
            switch(col.getType())
            {
            case -7: 
                widthData = 5;
                break;

            case -2: 
                widthData = 2;
                break;

            case 4: // '\004'
                widthData = 10;
                break;

            case -5: 
                widthData = 10;
                break;

            case 6: // '\006'
                widthData = 8;
                break;

            case 8: // '\b'
                widthData = 10;
                break;

            case 91: // '['
                widthData = 12;
                break;

            case 12: // '\f'
                widthData = 27;
                break;

            default:
                widthData = 15;
                break;
            }
            widths[i] = widthData > widthHeader ? widthData : widthHeader;
            bufHeader.append(col.getName());
            bufHeader.append(repeat(" ", widths[i] - col.getName().length()));
            bufHeader.append(" | ");
            widthTotal += widths[i] + 3;
        }

        bufHeader.append("[TechKey]   | ");
        widthTotal += "TechKey     | ".length();
        widthTotal += 7;
        widthTotal++;
        bufDelim.append(repeat("-", widthTotal));
        bufHeader.insert(0, bufDelim + "\n");
        bufHeader.append("\n");
        bufData.append(bufDelim);
        bufData.append("\n");
        for(int k = 0; k < numRows; k++)
        {
            String num = "" + k;
            bufData.append("| ");
            num = num.substring(0, 4 > num.length() ? num.length() : 4);
            if(4 > num.length())
                bufData.append(repeat(" ", 4 - num.length()));
            bufData.append(num + " | ");
            TableRow row = (TableRow)rows.get(k);
            for(int i = 0; i < numColumns; i++)
            {
                String value = row.getField(i + 1).getString();
                value = value.substring(0, widths[i] > value.length() ? value.length() : widths[i]);
                bufData.append(value);
                if(widths[i] > value.length())
                    bufData.append(repeat(" ", widths[i] - value.length()));
                bufData.append(" | ");
            }

            String rk = row.getRowKey() != null ? row.getRowKey().toString() : "NULL";
            rk = rk.substring(0, 11 > rk.length() ? rk.length() : 11);
            bufData.append(rk);
            if(11 > rk.length())
                bufData.append(repeat(" ", 11 - rk.length()));
            bufData.append(" | ");
            bufData.append("\n");
            bufData.append(bufDelim + "\n");
        }

        StringBuffer bufTotal = new StringBuffer();
        bufTotal.append(bufHeader);
        bufTotal.append(bufData);
        return bufTotal.toString();
    }

    private String repeat(String s, int number)
    {
        StringBuffer buf = new StringBuffer(number * s.length());
        for(int i = 0; i < number; i++)
            buf.append(s);

        return buf.toString();
    }

    public static final int TYPE_OBJ = 1111;
    public static final int TYPE_SHORT = -6;
    public static final int TYPE_BYTE = -2;
    public static final int TYPE_INT = 4;
    public static final int TYPE_LONG = -5;
    public static final int TYPE_STRING = 12;
    public static final int TYPE_DATE = 91;
    public static final int TYPE_FLOAT = 6;
    public static final int TYPE_DOUBLE = 8;
    public static final int TYPE_BOOLEAN = -7;
    @SuppressWarnings("rawtypes")
	private List columns;
    @SuppressWarnings("rawtypes")
	private Map columnNames;
    private int numColumns;
    private int numRows;
    @SuppressWarnings("rawtypes")
	private List rows;
    private String name;
    private boolean fromRepository;
    @SuppressWarnings("rawtypes")
	private static HashMap structureRepository = new HashMap();

}
