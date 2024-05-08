package iris.web.common.converter;

import java.io.ByteArrayOutputStream;



import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

public class LRuiExcelConverter {
	public static ByteArrayOutputStream convertToExcel(String data) throws Exception {
		byte[] result = null;
		JSONObject joData = new JSONObject(data);
		
//		FileOutputStream bao = null;
		 ByteArrayOutputStream bao = null;
		try {
//			String filename = "c:\\TEMP\\a.xls";
//			bao = new FileOutputStream(filename);
			bao = new ByteArrayOutputStream();
			JSONObject joMetaData = joData.getJSONObject("metaData");
			JSONArray joFields = joMetaData.getJSONArray("fields");
			XSSFWorkbook workBook = new XSSFWorkbook();

			Sheet sheet = workBook.createSheet();

			int row = 0;
			int fieldCount = joFields.length();
			XSSFCellStyle hcs = getTitleStyle(workBook);
			short width = 50;

			String types[] = new String[fieldCount];
			String aligns[] = new String[fieldCount];
			XSSFCellStyle dcs[] = new XSSFCellStyle[fieldCount];

			JSONObject joMultiheaderInfos = null;
			if(joMetaData.has("multiheaderInfos")) {
				joMultiheaderInfos = joMetaData.getJSONObject("multiheaderInfos");
				int rowCount = joMultiheaderInfos.getInt("rowCount");
				int colCount = joMultiheaderInfos.getInt("colCount");
				JSONArray colInfos = joMultiheaderInfos.getJSONArray("colInfos");
				
				int createRow = row;
				int currRow = row;
				int currCol = 0;
				for(int col = 0 ; col < colInfos.length(); col++) {
					JSONObject joField = joFields.getJSONObject(col);
					JSONArray colInfoList = colInfos.getJSONArray(col);
					currRow = 0;
					currCol = col;
					for(int hrow = 0 ; hrow < rowCount; ) {
						JSONObject colInfo = colInfoList.getJSONObject(hrow);
						boolean exist = colInfo.getBoolean("exist");
						int colspan = colInfo.getInt("colspan");
						int rowspan = colInfo.getInt("rowspan");
						Row sheetRow = null;
						if(col == 0) {
							sheetRow = sheet.createRow(currRow);
							sheetRow.setHeight((short) 400); // 칼럼 높이
							createRow = currRow;
						} else {
							sheetRow = sheet.getRow(currRow);
						}
						
						if(sheetRow == null) {
							sheetRow = sheet.createRow(currRow);
							sheetRow.setHeight((short) 400); // 칼럼 높이
						}
						Cell currCell = sheetRow.createCell(currCol);
						currCell.setCellStyle(hcs);

						if(colspan > 0 && rowspan > 0 && exist == true) {
							String label = colInfo.getString("label");

							if(joField.has("width"))
								sheet.setColumnWidth(currCol, joField.getInt("width") * width);
							currCell.setCellValue(label);
							if(colspan > 1 || rowspan > 1) {
								int startRow = currRow;
								int startCol = currCol;
								int endRow = currRow + (rowspan > 1 ? rowspan - 1 : 0);
								int endCol = currCol + (colspan > 1 ? colspan - 1: 0);
								if(endRow > createRow) {
									sheetRow = sheet.createRow(endRow);
									sheetRow.setHeight((short) 400); // 칼럼 높이
									createRow = endRow;
								}
								for(int i = startRow; i <= endRow; i++) {
									Row mSheetRow = sheet.getRow(i);
									if(mSheetRow == null) {
										mSheetRow = sheet.createRow(i);
									}
									Cell mCell = mSheetRow.getCell(currCol);
									if(mCell == null) {
										mCell = mSheetRow.createCell(currCol);
										mCell.setCellStyle(hcs);
									}
								}
								sheet.addMergedRegion(new CellRangeAddress(startRow, endRow, startCol, endCol));
								currRow = endRow + 1;
//								currCol++;
								hrow = currRow;
								continue;
							}
						}
						currRow++;
//						currCol++;
						hrow++;
					}
				}
				row = currRow;
			} else {

				Row sheetRow = sheet.createRow(row++);
				sheetRow.setHeight((short) 400); // 칼럼 높이

				for (int col = 0; col < fieldCount; col++) {
					JSONObject joField = joFields.getJSONObject(col);
					sheet.setColumnWidth(col, joField.getInt("width") * width);
					types[col] = (joField.has("type")) ? joField.getString("type")
							.toLowerCase() : "String";
					String value = joField.getString("label");
					Cell cell = sheetRow.createCell(col);
					cell.setCellValue(new XSSFRichTextString(value));
					cell.setCellStyle(hcs);
					aligns[col] = (joField.has("align")) ? joField.getString("align").toLowerCase() : "left";
				}
			}
			

			for (int col = 0; col < fieldCount; col++) {
				JSONObject joField = joFields.getJSONObject(col);
				aligns[col] = (joField.has("align")) ? joField.getString("align")
						.toLowerCase() : "left";
				dcs[col] = getTextStyle(workBook);
				if("center".equals(aligns[col]))
					dcs[col].setAlignment(XSSFCellStyle.ALIGN_CENTER);
				else if("right".equals(aligns[col]))
					dcs[col].setAlignment(XSSFCellStyle.ALIGN_RIGHT);
				else
					dcs[col].setAlignment(XSSFCellStyle.ALIGN_LEFT);
			}
			JSONArray joRecords = joData.getJSONArray("records");
			int rowCount = joRecords.length();
			
			for (int dataRow = 0; dataRow < rowCount; dataRow++, row++) {
				Row currRow = sheet.createRow(row);
				currRow.setHeight((short) 300); // 칼럼 높이
				JSONArray jaRows = joRecords.getJSONArray(dataRow);
//				System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
//				System.out.println(jaRows);
//				System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
				for (int col = 0; col < fieldCount; col++) {
					Cell cell = currRow.createCell(col);
					String value = jaRows.getString(col);
					cell.setCellValue(new XSSFRichTextString(value));
					cell.setCellStyle(dcs[col]);
				}
			}
//			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//			System.out.println(bao);
//			System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			workBook.write(bao);
			
		//	result = bao.toByteArray();
//			System.out.println("############################################");
//			System.out.write(result, 0, result.length);
//			System.out.println("############################################");
//			System.out.println(filename);
		} finally {
			bao.close();
		}

		return bao;
	}

	private static XSSFCellStyle getTitleStyle(XSSFWorkbook workBook) {
		// 제목 폰트
		XSSFFont hf = workBook.createFont();
		hf.setFontHeightInPoints((short) 10);
		hf.setColor((short) HSSFColor.BLACK.index);
		hf.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

		// Header style setting
		XSSFCellStyle hcs = workBook.createCellStyle();
		hcs.setFont(hf);
		hcs.setAlignment(XSSFCellStyle.ALIGN_CENTER);

		// set border style
		hcs.setBorderBottom(XSSFCellStyle.BORDER_THICK);
		hcs.setBorderRight(XSSFCellStyle.BORDER_THIN);
		hcs.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		hcs.setBorderTop(XSSFCellStyle.BORDER_THIN);
		hcs.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		// set color
		// hcs.setFillBackgroundColor((short) HSSFColor.WHITE.index);
		hcs.setFillForegroundColor((short) HSSFColor.GREY_25_PERCENT.index);
		hcs.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		hcs.setLocked(true);
		hcs.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		return hcs;
	}

	private static XSSFCellStyle getTextStyle(XSSFWorkbook workBook) {
		XSSFFont hf = workBook.createFont();
		hf.setFontHeightInPoints((short) 10);
		hf.setColor((short) HSSFColor.BLACK.index);

		XSSFCellStyle hcs = workBook.createCellStyle();
		hcs.setFont(hf);
		hcs.setAlignment(XSSFCellStyle.ALIGN_CENTER);

		// set border style
		hcs.setBorderBottom(XSSFCellStyle.BORDER_THICK);
		hcs.setBorderRight(XSSFCellStyle.BORDER_THIN);
		hcs.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		hcs.setBorderTop(XSSFCellStyle.BORDER_THIN);
		hcs.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		// set color
		hcs.setFillBackgroundColor((short) HSSFColor.WHITE.index);
		hcs.setFillForegroundColor((short) HSSFColor.WHITE.index);
		hcs.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);

		hcs.setLocked(true);
		hcs.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

		return hcs;
	}

	public static void main(String args[]) throws Exception {
		
		
		
		String data = "{\"metaData\":{\"fields\":[{\"id\":\"col2\",\"field\":\"col2\",\"label\":\"4-1\",\"width\":130,\"align\":\"center\",\"type\":\"string\",\"columnType\":\"data\"},{\"id\":\"col3\",\"field\":\"col3\",\"label\":\"5-1\",\"width\":100,\"align\":\"right\",\"type\":\"string\",\"columnType\":\"data\"},{\"id\":\"col4\",\"field\":\"col4\",\"label\":\"5-1-1\",\"width\":100,\"align\":\"right\",\"type\":\"string\",\"columnType\":\"data\"},{\"id\":\"date1\",\"field\":\"date1\",\"label\":\"6-1\",\"width\":100,\"align\":\"center\",\"type\":\"date\",\"columnType\":\"data\"},{\"id\":\"col8\",\"field\":\"col8\",\"label\":\"8-2\",\"width\":100,\"align\":\"right\",\"type\":\"number\",\"columnType\":\"data\"}]},\"records\":[[\"7602111111111\",\"R2\",\"R1\",\"Tue Aug 18 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R2\",\"R2\",\"Wed Aug 19 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R1\",\"Thu Aug 20 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R1\",\"Fri Aug 21 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R2\",\"Sat Aug 22 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R2\",\"R1\",\"Sun Aug 23 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R2\",\"R1\",\"Mon Aug 24 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R1\",\"Tue Aug 25 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111113\",\"R1\",\"R2\",\"Wed Aug 26 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R2\",\"Wed Aug 26 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R2\",\"Wed Aug 26 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"\",\"R2\",\"R1\",\"Tue Aug 18 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R2\",\"R2\",\"Wed Aug 19 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R1\",\"Thu Aug 20 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R1\",\"Fri Aug 21 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R2\",\"Sat Aug 22 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R2\",\"R1\",\"Sun Aug 23 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R2\",\"R1\",\"Mon Aug 24 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R1\",\"Tue Aug 25 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111113\",\"R1\",\"R2\",\"Wed Aug 26 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R2\",\"Wed Aug 26 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"],[\"7602111111111\",\"R1\",\"R2\",\"Wed Aug 26 2009 00:00:00 GMT+0900 (대한민국 표준시)\",\"￦10,000\"]]}";
		LRuiExcelConverter.convertToExcel(data);
	}
}
