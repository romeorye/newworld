package iris.web.common.util;

import java.sql.Date;
import java.sql.ResultSet;
import java.util.Comparator;
import java.util.Map;

public interface ExtendedResultSet
    extends ResultSet
{

    public abstract boolean searchRowByColumn(int i, String s);

    public abstract boolean searchRowByColumn(int i, long l);

    public abstract boolean searchRowByColumn(int i, double d);

    public abstract boolean searchRowByColumn(int i, Date date);

    public abstract boolean searchRowByColumn(String s, String s1);

    public abstract boolean searchRowByColumn(String s, long l);

    public abstract boolean searchRowByColumn(String s, double d);

    public abstract boolean searchRowByColumn(String s, Date date);

    public abstract boolean seek(Map<String, Object> map);

    public abstract boolean searchRowByColumn(int i, String s, int j, int k);

    public abstract boolean searchRowByColumn(int i, long l, int j, int k);

    public abstract boolean searchRowByColumn(int i, double d, int j, int k);

    public abstract boolean searchRowByColumn(int i, Date date, int j, int k);

    public abstract boolean searchRowByColumn(String s, String s1, int i, int j);

    public abstract boolean searchRowByColumn(String s, long l, int i, int j);

    public abstract boolean searchRowByColumn(String s, double d, int i, int j);

    public abstract boolean searchRowByColumn(String s, Date date, int i, int j);

    public abstract boolean seek(Map<String, Object> map, int i, int j);

    public abstract void sort(int i, Comparator<Integer> comparator);

    public abstract void sort(String s, Comparator<String> comparator);

    public abstract RowKey getRowKey();

    public abstract int getNumRows();
}
