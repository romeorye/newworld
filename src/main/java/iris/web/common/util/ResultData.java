package iris.web.common.util;

import java.io.InputStream;
import java.io.Reader;
import java.math.BigDecimal;
import java.sql.Array;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.NClob;
import java.sql.Ref;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.RowId;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.net.URL; 

public class ResultData  implements ResultSet, ExtendedResultSet
{
	
	
	
	public void updateClob(int columnIndex,  Clob x)
    {
    }
	
	public void updateClob(String columnName,  Clob x)
    {
    }
	
	public void updateBlob(String columnName, Blob x) 
	{
    }
	
	public void updateBlob(int columnIndex, Blob x) 
	{
    }
	
	public void updateRef(int columnIndex, Ref x) 
	{		
	}
	
	public void updateRef(String columnName, Ref x) 
	{		
	}
		
	
	public URL getURL(int columnIndex)
	{
		return null;
	}
	
	
	public URL getURL(String columnName)
	{
		return null;
	}
	
	public void updateArray(int columnIndex, Array x) 
	{		
	}
	
	public void updateArray(String columnName, Array x) 
	{		
	}
	
	@SuppressWarnings("rawtypes")
	private class TableComparator
        implements Comparator
    {
    	
        @SuppressWarnings("unchecked")
		public int compare(Object o1, Object o2)
        {
            return realComparator.compare(((DataIndex)o1).data, ((DataIndex)o2).data);
        }

        public boolean equals(Object o)
        {
            return realComparator.equals(o);
        }

        private Comparator realComparator;

        public TableComparator(Comparator comp)
        {
            realComparator = comp;
        }
    }

    private class DataIndex
    {

        public int index;
        public Object data;

        public DataIndex(int index, Object data)
        {
            this.index = index;
            this.data = data;
        }
    }

    public static class UnknownColumnIndexException extends RuntimeException
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public UnknownColumnIndexException()
        {
        }

        public UnknownColumnIndexException(String msg)
        {
            super(msg);
        }
    }

    public static class UnknownColumnNameException extends RuntimeException
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public UnknownColumnNameException()
        {
        }

        public UnknownColumnNameException(String msg)
        {
            super(msg);
        }
    }

    public static class CursorPositionInvalidException extends RuntimeException
    {
    	static final long serialVersionUID = -8183895086397161746L;
        public CursorPositionInvalidException()
        {
        }

        public CursorPositionInvalidException(String msg)
        {
            super(msg);
        }
    }


    public ResultData(Table table)
    {
        currentRow = 0;
        numRows = 0;
        row = null;
        fetchDirection = 1000;
        sorted = false;
        sortedRows = null;
        this.table = table;
        numRows = table.getNumRows();
    }

    private TableRow getRow(int index)
    {
        if(sorted)
            return table.getRow(((DataIndex)sortedRows.get(index - 1)).index);
        else
            return table.getRow(index);
    }

    public int getNumRows()
    {
        return numRows;
    }

    public RowKey getRowKey()
    {
        if(row == null)
            throw new CursorPositionInvalidException("Cursor is positioned before first or after last row and access to this row is is not possible");
        else
            return row.getRowKey();
    }

	@SuppressWarnings("rawtypes")
	public void sort(String columnName, Comparator comp)
    {
        sort(table.findColumn(columnName), comp);
    }

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void sort(int columnIndex, Comparator comp)
    {
        sorted = true;
        sortedRows = new ArrayList(numRows);
        for(int i = 1; i <= table.getNumRows(); i++)
            sortedRows.add(new DataIndex(i, table.getRow(i).getField(columnIndex).getObject()));

        Collections.sort(sortedRows, new TableComparator(comp));
    }

    public boolean next()
    {
        if(fetchDirection == 1000)
            currentRow++;
        else
            currentRow--;
        boolean validPosition;
        if(validPosition = alignCursor())
            row = getRow(currentRow);
        return validPosition;
    }

    public void close()
    {
        currentRow = 0;
        numRows = 0;
        row = null;
        table = null;
    }

    public boolean first()
    {
        if(numRows > 0)
        {
            currentRow = 1;
            row = getRow(currentRow);
            return true;
        } else
        {
            return false;
        }
    }



    public boolean last()
    {
        if(numRows > 0)
        {
            currentRow = numRows;
            row = getRow(currentRow);
            return true;
        } else
        {
            return false;
        }
    }

    public int getRow()
    {
        return currentRow;
    }
    
    
    
    public String getString(int columnIndex)
    {
        return getField(columnIndex).getString();
    }

    public boolean getBoolean(int columnIndex)
    {
        return getField(columnIndex).getBoolean();
    }

    public byte getByte(int columnIndex)
    {
        return getField(columnIndex).getByte();
    }

    public short getShort(int columnIndex)
    {
        return getField(columnIndex).getShort();
    }

    public int getInt(int columnIndex)
    {
        return getField(columnIndex).getInt();
    }

    public long getLong(int columnIndex)
    {
        return getField(columnIndex).getLong();
    }

    public float getFloat(int columnIndex)
    {
        return getField(columnIndex).getFloat();
    }

    public double getDouble(int columnIndex)
    {
        return getField(columnIndex).getDouble();
    }

    public java.sql.Date getDate(int columnIndex)
    {
        return getField(columnIndex).getDate();
    }

    private TableField getField(String columnName)
    {
        if(row == null)
            throw new CursorPositionInvalidException("Cursor is positioned before first or after last row and access to this row is is not possible");
        TableField field = row.getField(columnName);
        if(field == null)
            throw new UnknownColumnNameException("Column named \"" + columnName + "\" not found!");
        else
            return field;
    }

    private TableField getField(int columnIndex)
    {
        if(row == null)
            throw new CursorPositionInvalidException("Cursor is positioned before first or after last row and access to this row is is not possible");
        TableField field = row.getField(columnIndex);
        if(field == null)
            throw new UnknownColumnIndexException("Column with index [" + columnIndex + "] not found!");
        else
            return field;
    }

    public String getString(String columnName)
    {
        return getField(columnName).getString();
    }

    public boolean getBoolean(String columnName)
    {
        return getField(columnName).getBoolean();
    }

    public byte getByte(String columnName)
    {
        return getField(columnName).getByte();
    }

    public short getShort(String columnName)
    {
        return getField(columnName).getShort();
    }

    public int getInt(String columnName)
    {
        return getField(columnName).getInt();
    }

    public long getLong(String columnName)
    {
        return getField(columnName).getLong();
    }

    public float getFloat(String columnName)
    {
        return getField(columnName).getFloat();
    }

    public double getDouble(String columnName)
    {
        return getField(columnName).getDouble();
    }

    public java.sql.Date getDate(String columnName)
    {
        return getField(columnName).getDate();
    }

    public Object getObject(int columnIndex)
    {
        return getField(columnIndex).getObject();
    }

    public Object getObject(String columnName)
    {
        return getField(columnName).getObject();
    }

    public int findColumn(String columnName)
    {
        return table.findColumn(columnName);
    }

    public boolean isBeforeFirst()
    {
        return currentRow <= 0;
    }

    public boolean isAfterLast()
    {
        return currentRow > numRows;
    }

    public boolean isFirst()
    {
        return currentRow == 1;
    }

    public boolean isLast()
    {
        return currentRow == numRows;
    }

    public void beforeFirst()
    {
        currentRow = 0;
    }

    public void afterLast()
    {
        currentRow = numRows + 1;
    }

    private boolean alignCursor()
    {
        boolean retVal = true;
        if(currentRow <= 0)
        {
            currentRow = 0;
            retVal = false;
        } else
        if(currentRow > numRows)
        {
            currentRow = numRows + 1;
            retVal = false;
        }
        return retVal;
    }

    public boolean absolute(int row)
    {
        currentRow = row >= 0 ? row : numRows + row;
        if(alignCursor())
        {
            this.row = getRow(currentRow);
            return true;
        } else
        {
            return false;
        }
    }

    public boolean relative(int rows)
    {
        currentRow += rows;
        if(alignCursor())
        {
            row = getRow(currentRow);
            return true;
        } else
        {
            return false;
        }
    }

    public boolean previous()
    {
        if(fetchDirection == 1001)
            currentRow++;
        else
            currentRow--;
        boolean validPosition;
        if(validPosition = alignCursor())
            row = getRow(currentRow);
        return validPosition;
    }

    public void setFetchDirection(int direction)
    {
        fetchDirection = direction;
    }

    public int getFetchDirection()
    {
        return fetchDirection;
    }

    public ResultSetMetaData getMetaData()
    {
        return new ResultMetaData(table);
    }

    public boolean searchRowByColumn(int columnIndex, String value)
    {
        return searchRowByColumn(columnIndex, value, -1, -1);
    }

    public boolean searchRowByColumn(int columnIndex, long value)
    {
        return searchRowByColumn(columnIndex, value, -1, -1);
    }

    public boolean searchRowByColumn(int columnIndex, double value)
    {
        return searchRowByColumn(columnIndex, value, -1, -1);
    }

    public boolean searchRowByColumn(int columnIndex, java.sql.Date value)
    {
        return searchRowByColumn(columnIndex, value, -1, -1);
    }

    public boolean searchRowByColumn(String columnName, String value)
    {
        return searchRowByColumn(columnName, value, -1, -1);
    }

    public boolean searchRowByColumn(String columnName, long value)
    {
        return searchRowByColumn(columnName, value, -1, -1);
    }

    public boolean searchRowByColumn(String columnName, double value)
    {
        return searchRowByColumn(columnName, value, -1, -1);
    }

    public boolean searchRowByColumn(String columnName, java.sql.Date value)
    {
        return searchRowByColumn(columnName, value, -1, -1);
    }

	@SuppressWarnings("rawtypes")
	public boolean seek(Map valueFieldMap)
    {
        return seek(valueFieldMap, -1, -1);
    }

    public boolean searchRowByColumn(int columnIndex, String value, int start, int end)
    {
        if(columnIndex <= 0 || table.getNumColumns() < columnIndex)
            return false;
        if(table.getColumn(columnIndex).getType() != 12)
            return false;
        start = start > 0 ? start : currentRow;
        end = end > 0 ? end : numRows;
        int increment = fetchDirection != 1000 ? -1 : 1;
        for(int i = start; i <= end; i += increment)
        {
            row = getRow(i);
            if(row.getField(columnIndex).getString().equals(value))
            {
                currentRow = i;
                return true;
            }
        }

        row = getRow(currentRow);
        return false;
    }

    public boolean searchRowByColumn(int columnIndex, long value, int start, int end)
    {
        if(columnIndex <= 0 || table.getNumColumns() < columnIndex)
            return false;
        int type = table.getColumn(columnIndex).getType();
        if(type != -2 && type != -6 && type != 4 && type != -5)
            return false;
        start = start > 0 ? start : currentRow;
        end = end > 0 ? end : numRows;
        int increment = fetchDirection != 1000 ? -1 : 1;
        for(int i = start; i <= end; i += increment)
        {
            row = getRow(i);
            if(row.getField(columnIndex).getLong() == value)
            {
                currentRow = i;
                return true;
            }
        }

        row = getRow(currentRow);
        return false;
    }

    public boolean searchRowByColumn(int columnIndex, double value, int start, int end)
    {
        if(columnIndex <= 0 || table.getNumColumns() < columnIndex)
            return false;
        int type = table.getColumn(columnIndex).getType();
        if(type != 8 && type != 6)
            return false;
        start = start > 0 ? start : currentRow;
        end = end > 0 ? end : numRows;
        int increment = fetchDirection != 1000 ? -1 : 1;
        for(int i = start; i <= end; i += increment)
        {
            row = getRow(i);
            if(row.getField(columnIndex).getDouble() == value)
            {
                currentRow = i;
                return true;
            }
        }

        row = getRow(currentRow);
        return false;
    }

    public boolean searchRowByColumn(int columnIndex, java.sql.Date value, int start, int end)
    {
        if(columnIndex <= 0 || table.getNumColumns() < columnIndex)
            return false;
        if(table.getColumn(columnIndex).getType() != 91)
            return false;
        start = start > 0 ? start : currentRow;
        end = end > 0 ? end : numRows;
        int increment = fetchDirection != 1000 ? -1 : 1;
        for(int i = start; i <= end; i += increment)
        {
            row = getRow(i);
            if(row.getField(columnIndex).getDate().equals(value))
            {
                currentRow = i;
                return true;
            }
        }

        row = getRow(currentRow);
        return false;
    }

    public boolean searchRowByColumn(String columnName, String value, int start, int end)
    {
        return searchRowByColumn(table.findColumn(columnName), value, start, end);
    }

    public boolean searchRowByColumn(String columnName, long value, int start, int end)
    {
        return searchRowByColumn(table.findColumn(columnName), value, start, end);
    }

    public boolean searchRowByColumn(String columnName, double value, int start, int end)
    {
        return searchRowByColumn(table.findColumn(columnName), value, start, end);
    }

    public boolean searchRowByColumn(String columnName, java.sql.Date value, int start, int end)
    {
        return searchRowByColumn(table.findColumn(columnName), value, start, end);
    }

	@SuppressWarnings("rawtypes")
	public boolean seek(Map valueFieldMap, int start, int end)
    {
        throw new RuntimeException("Method not implemented, try again later ;-)");
    }

    public String toString()
    {
        return table.toString() + "\n" + "Current row    : " + currentRow + "\n" + "Number of rows : " + numRows + "\n" + "Sorted         : " + sorted + "\n";
    }

    public boolean wasNull()
    {
        return false;
    }

    public void updateNull(int i)
    {
    }

    public void updateBoolean(int i, boolean flag)
    {
    }

    public void updateByte(int i, byte byte0)
    {
    }

    public void updateShort(int i, short word0)
    {
    }

    public void updateInt(int i, int j)
    {
    }

    public void updateLong(int i, long l)
    {
    }

    public void updateFloat(int i, float f)
    {
    }

    public void updateDouble(int i, double d)
    {
    }

    public void updateString(int i, String s)
    {
    }

    public void updateDate(int i, java.sql.Date date)
    {
    }

    public void updateNull(String s)
    {
    }

    public void updateBoolean(String s, boolean flag)
    {
    }

    public void updateByte(String s, byte byte0)
    {
    }

    public void updateShort(String s, short word0)
    {
    }

    public void updateInt(String s, int i)
    {
    }

    public void updateLong(String s, long l)
    {
    }

    public void updateFloat(String s, float f)
    {
    }

    public void updateDouble(String s, double d)
    {
    }

    public void updateString(String s, String s1)
    {
    }

    public void updateDate(String s, java.sql.Date date)
    {
    }

    public void insertRow()
    {
    }

    public void updateRow()
    {
    }

    public void deleteRow()
    {
    }

    public void refreshRow()
    {
    }

    public void moveToInsertRow()
    {
    }

    public void moveToCurrentRow()
    {
    }

    public BigDecimal getBigDecimal(int columnIndex, int scale)
    {
        return null;
    }

    public byte[] getBytes(int columnIndex)
    {
        return null;
    }

    public Time getTime(int columnIndex)
    {
        return null;
    }

    public Timestamp getTimestamp(int columnIndex)
    {
        return null;
    }

    public InputStream getAsciiStream(int columnIndex)
    {
        return null;
    }

    public InputStream getUnicodeStream(int columnIndex)
    {
        return null;
    }

    public InputStream getBinaryStream(int columnIndex)
    {
        return null;
    }

    public BigDecimal getBigDecimal(String columnName, int scale)
    {
        return null;
    }

    public byte[] getBytes(String columnName)
    {
        return null;
    }

    public Time getTime(String columnName)
    {
        return null;
    }

    public Timestamp getTimestamp(String columnName)
    {
        return null;
    }

    public InputStream getAsciiStream(String columnName)
    {
        return null;
    }

    public InputStream getUnicodeStream(String columnName)
    {
        return null;
    }

    public InputStream getBinaryStream(String columnName)
    {
        return null;
    }

    public SQLWarning getWarnings()
    {
        return null;
    }

    public void clearWarnings()
    {
    }

    public String getCursorName()
    {
        return null;
    }

    public Reader getCharacterStream(int columnIndex)
    {
        return null;
    }

    public Reader getCharacterStream(String columnName)
    {
        return null;
    }

    public BigDecimal getBigDecimal(int columnIndex)
    {
        return null;
    }

    public BigDecimal getBigDecimal(String columnName)
    {
        return null;
    }

    public void setFetchSize(int i)
    {
    }

    public int getFetchSize()
    {
        return 1;
    }

    public int getType()
    {
        return 1004;
    }

    public int getConcurrency()
    {
        return 1008;
    }

    public boolean rowUpdated()
    {
        return true;
    }

    public boolean rowInserted()
    {
        return true;
    }

    public boolean rowDeleted()
    {
        return true;
    }

    public void updateBigDecimal(int i, BigDecimal bigdecimal)
    {
    }

    public void updateBytes(int i, byte abyte0[])
    {
    }

    public void updateTime(int i, Time time)
    {
    }

    public void updateTimestamp(int i, Timestamp timestamp)
    {
    }

    public void updateAsciiStream(int i, InputStream inputstream, int j)
    {
    }

    public void updateBinaryStream(int i, InputStream inputstream, int j)
    {
    }

    public void updateCharacterStream(int i, Reader reader, int j)
    {
    }

    public void updateObject(int i, Object obj, int j)
    {
    }

    public void updateObject(int i, Object obj)
    {
    }

    public void updateBigDecimal(String s, BigDecimal bigdecimal)
    {
    }

    public void updateBytes(String s, byte abyte0[])
    {
    }

    public void updateTime(String s, Time time)
    {
    }

    public void updateTimestamp(String s, Timestamp timestamp)
    {
    }

    public void updateAsciiStream(String s, InputStream inputstream, int i)
    {
    }

    public void updateBinaryStream(String s, InputStream inputstream, int i)
    {
    }

    public void updateCharacterStream(String s, Reader reader1, int i)
    {
    }

    public void updateObject(String s, Object obj, int i)
    {
    }

    public void updateObject(String s, Object obj)
    {
    }

    public void cancelRowUpdates()
    {
    }

    public Statement getStatement()
    {
        return null;
    }

	@SuppressWarnings("rawtypes")
	public Object getObject(int i, Map map)
    {
        return null;
    }

    public Ref getRef(int i)
    {
        return null;
    }

    public Blob getBlob(int i)
    {
        return null;
    }

    public Clob getClob(int i)
    {
        return null;
    }

    public Array getArray(int i)
    {
        return null;
    }

	@SuppressWarnings("rawtypes")
	public Object getObject(String colName, Map map)
    {
        return null;
    }

    public Ref getRef(String colName)
    {
        return null;
    }

    public Blob getBlob(String colName)
    {
        return null;
    }

    public Clob getClob(String colName)
    {
        return null;
    }

    public Array getArray(String colName)
    {
        return null;
    }

    public java.sql.Date getDate(int columnIndex, Calendar cal)
    {
        return null;
    }

    public java.sql.Date getDate(String columnName, Calendar cal)
    {
        return null;
    }

    public Time getTime(int columnIndex, Calendar cal)
    {
        return null;
    }

    public Time getTime(String columnName, Calendar cal)
    {
        return null;
    }

    public Timestamp getTimestamp(int columnIndex, Calendar cal)
    {
        return null;
    }

    public Timestamp getTimestamp(String columnName, Calendar cal)
    {
        return null;
    }

    private int currentRow;
    private int numRows;
    private Table table;
    private TableRow row;
    private int fetchDirection;
    private boolean sorted;
	@SuppressWarnings("rawtypes")
	private List sortedRows;
	public int getHoldability() throws SQLException {
		return 0;
	}

	public Reader getNCharacterStream(int arg0) throws SQLException {
		return null;
	}

	public Reader getNCharacterStream(String arg0) throws SQLException {
		return null;
	}

	
	public String getNString(int arg0) throws SQLException {
		return null;
	}

	public String getNString(String arg0) throws SQLException {
		return null;
	}

	
	public boolean isClosed() throws SQLException {
		return false;
	}

	public void updateAsciiStream(int arg0, InputStream arg1) throws SQLException {
		
	}

	public void updateAsciiStream(String arg0, InputStream arg1) throws SQLException {
		
	}

	public void updateAsciiStream(int arg0, InputStream arg1, long arg2) throws SQLException {
		
	}

	public void updateAsciiStream(String arg0, InputStream arg1, long arg2) throws SQLException {
		
	}

	public void updateBinaryStream(int arg0, InputStream arg1) throws SQLException {
		
	}

	public void updateBinaryStream(String arg0, InputStream arg1) throws SQLException {
		
	}

	public void updateBinaryStream(int arg0, InputStream arg1, long arg2) throws SQLException {
		
	}

	public void updateBinaryStream(String arg0, InputStream arg1, long arg2) throws SQLException {
		
	}

	public void updateBlob(int arg0, InputStream arg1) throws SQLException {
		
	}

	public void updateBlob(String arg0, InputStream arg1) throws SQLException {
		
	}

	public void updateBlob(int arg0, InputStream arg1, long arg2) throws SQLException {
		
	}

	public void updateBlob(String arg0, InputStream arg1, long arg2) throws SQLException {
		
	}

	public void updateCharacterStream(int arg0, Reader arg1) throws SQLException {
		
	}

	public void updateCharacterStream(String arg0, Reader arg1) throws SQLException {
		
	}

	public void updateCharacterStream(int arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateCharacterStream(String arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateClob(int arg0, Reader arg1) throws SQLException {
		
	}

	public void updateClob(String arg0, Reader arg1) throws SQLException {
		
	}

	public void updateClob(int arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateClob(String arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateNCharacterStream(int arg0, Reader arg1) throws SQLException {
		
	}

	public void updateNCharacterStream(String arg0, Reader arg1) throws SQLException {
		
	}

	public void updateNCharacterStream(int arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateNCharacterStream(String arg0, Reader arg1, long arg2) throws SQLException {
		
	}


	public void updateNClob(int arg0, Reader arg1) throws SQLException {
		
	}

	public void updateNClob(String arg0, Reader arg1) throws SQLException {
		
	}

	public void updateNClob(int arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateNClob(String arg0, Reader arg1, long arg2) throws SQLException {
		
	}

	public void updateNString(int arg0, String arg1) throws SQLException {
		
	}

	public void updateNString(String arg0, String arg1) throws SQLException {
		
	}

	
	@SuppressWarnings("rawtypes")
	public boolean isWrapperFor(Class arg0) throws SQLException {
		return false;
	}
	@SuppressWarnings("rawtypes")
	public Object unwrap(Class arg0) throws SQLException {
		return null;
	}

	@Override
	public NClob getNClob(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public NClob getNClob(String columnLabel) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <T> T getObject(int columnIndex, Class<T> type) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <T> T getObject(String columnLabel, Class<T> type) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public RowId getRowId(int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public RowId getRowId(String columnLabel) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SQLXML getSQLXML(int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SQLXML getSQLXML(String columnLabel) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateNClob(int columnIndex, NClob nClob) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateNClob(String columnLabel, NClob nClob) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateRowId(int columnIndex, RowId x) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateRowId(String columnLabel, RowId x) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateSQLXML(int columnIndex, SQLXML xmlObject) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateSQLXML(String columnLabel, SQLXML xmlObject) throws SQLException {
		// TODO Auto-generated method stub
		
	}
}
