package iris.web.common.util;

import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class ResultMetaData implements ResultSetMetaData {

	protected ResultMetaData(Table table) {
		this.table = table;
	}

	public int getColumnCount() {
		return table.getNumColumns();
	}

	public boolean isCaseSensitive(int column) {
		return true;
	}

	public String getColumnLabel(int column) {
		return table.getColumn(column).getName();
	}

	public String getColumnName(int column) {
		return table.getColumn(column).getName();
	}

	public String getTableName(int column) {
		return table.getName();
	}

	public String getCatalogName(int column) {
		return table.getName();
	}

	public int getColumnType(int column) {
		return table.getColumn(column).getType();
	}

	public String getColumnTypeName(int column) {
		String type;
		switch (getColumnType(column)) {
		case -7:
			type = "boolean";
			break;

		case -2:
			type = "byte";
			break;

		case 91: // '['
			type = "java.sql.Date";
			break;

		case 8: // '\b'
			type = "double";
			break;

		case 6: // '\006'
			type = "float";
			break;

		case 4: // '\004'
			type = "int";
			break;

		case -5:
			type = "long";
			break;

		case 1111:
			type = "java.lang.Object";
			break;

		case -6:
			type = "short";
			break;

		case 12: // '\f'
			type = "java.lang.String";
			break;

		default:
			type = "unknown";
			break;
		}
		return type;
	}

	public boolean isReadOnly(int column) {
		return false;
	}

	public boolean isWritable(int column) {
		return false;
	}

	public boolean isDefinitelyWritable(int column) {
		return false;
	}

	public String getColumnClassName(int column) {
		return null;
	}

	public boolean isAutoIncrement(int column) {
		return false;
	}

	public boolean isSearchable(int column) {
		return false;
	}

	public boolean isCurrency(int column) {
		return false;
	}

	public int isNullable(int column) {
		return 0;
	}

	public boolean isSigned(int column) {
		return true;
	}

	public int getColumnDisplaySize(int column) {
		return 0;
	}

	public String getSchemaName(int column) {
		return "";
	}

	public int getPrecision(int column) {
		return 0;
	}

	public int getScale(int column) {
		return 0;
	}

	private Table table;

	@SuppressWarnings("rawtypes")
	public boolean isWrapperFor(Class arg0) throws SQLException {
		return false;
	}

	@SuppressWarnings("rawtypes")
	public Object unwrap(Class arg0) throws SQLException {
		return null;
	}
}
