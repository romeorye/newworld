/**------------------------------------------------------------------------------
 * NAME : ExcelExportBiz.java
 * DESC : 실측관리. Excel Down.
 * VER  : v1.0
 * PROJ : LG CNS TWMS 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2010.03.11  K.B.IM.   Initialize
 * 2016.08.18  김진동 수정
 *------------------------------------------------------------------------------*/

package iris.web.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
//import devon.core.collection.LData;
//import devon.core.collection.LMultiData;
//import devon.core.config.LConfiguration;
//import devon.core.exception.DevonException;
//import devon.core.log.LLog;

import devonframe.configuration.ConfigService;
import java.util.ResourceBundle;
public class ExcelExportBiz {

	public ExcelExportBiz() {

	}
//    @Resource(name = "configService")
//    private ConfigService configService;
    ResourceBundle configService = ResourceBundle.getBundle("config.project");
	/**
	 * Export excel file
	 *
	 * @param LData data
	 * @param String[] dataKey
	 * @param LData sCountData
	 * @param LData mCountData
	 * @param LData rData
	 * @param String templateName
	 * @return
	 * @throws DevonException
	 */
    public File excelExport(Map<String, Object> data, String[] dataKey, String templateName) throws java.text.ParseException{
	    return excelExport(data, dataKey, templateName, "", "", "");
	}

	/**
	 *
	 * @param data
	 * @param dataKey
	 * @param templateName
	 * @param subpath
	 * @return
	 * @throws DevonException
	 */
    public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, String subpath) throws java.text.ParseException{
        return excelExport(data, dataKey, templateName, "", "", subpath);
    }

    /**
     *
     * @param data
     * @param dataKey
     * @param templateName
     * @param downFileName
     * @param downSheetName
     * @return
     * @throws DevonException
     */
    public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, String downFileName, String downSheetName) throws java.text.ParseException{
        return excelExport(data, dataKey, templateName, downFileName, downSheetName, "");
    }


    public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, int limitRowCnt) throws java.text.ParseException{
        return excelExport(data, dataKey, templateName, "", "", "", limitRowCnt);
    }

    /**
     *
     * @param data
     * @param dataKey
     * @param templateName
     * @param subpath
     * @param limitRowCnt
     * @return
     * @throws DevonException
     */
    public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, String subpath, int limitRowCnt) throws java.text.ParseException{
        return excelExport(data, dataKey, templateName, "", "", subpath, limitRowCnt);
    }

    /**
     *
     * @param data
     * @param dataKey
     * @param templateName
     * @param downFileName
     * @param downSheetName
     * @param limitRowCnt
     * @return
     * @throws DevonException
     */
    public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, String downFileName, String downSheetName, int limitRowCnt) throws java.text.ParseException{
        return excelExport(data, dataKey, templateName, downFileName, downSheetName, "", limitRowCnt);
    }












	public File excelExportFile(Map<String, Object> data,String[] dataKey,Map<String, String> sCountData,Map<String, String> mCountData,Map<String, String> rData,String templateName) throws java.text.ParseException {

		FileInputStream is = null;
		File file = null;
//        LConfiguration config = LConfiguration.getInstance();
//        String basePath = config.get("/devon/framework/front/upload/policy<default>/target-directory");
//        String downloadPath = basePath+ "/esti/"+templateName;
//        String basePath = configService.getString("template.root_path"); //config.get("/devon/framework/front/upload/policy<default>/target-directory");
//        String basePath  ="C:/IRIS_DevonFrame/workspace/iris/src/main/webapp/resource/fileupload/template";
		String basePath  =configService.getString("KeyStore.EXCEL_BASE");
        String downloadPath = basePath + "/" + templateName;
        System.out.println("downloadPath="+downloadPath);
        file = new File(downloadPath);
        System.out.println("getPath() -"+file.getPath());

		try {
			is = new FileInputStream(downloadPath);
		} catch (FileNotFoundException e) {

			e.printStackTrace();
		}
		try {

			HSSFWorkbook workbook = new HSSFWorkbook(is);
			HSSFSheet sheet = workbook.getSheetAt(0);

			//------------------------------------------ 사용 CellType START
			HSSFSheet sheet2           = workbook.getSheetAt(1);
            HSSFRow row2               = sheet2.getRow(0);
            HSSFCell cell2             = row2.getCell( 0);
            HSSFCell cellDatType2      = null;
            HSSFCellStyle[] cellStyle2 = new HSSFCellStyle[1];

            HSSFRow dataRowTemp2     = sheet2.getRow(0);
            HSSFRow dataRowTempType2 = sheet2.getRow(0);

            cell2           = dataRowTemp2.getCell( 0);
            cellDatType2    = dataRowTempType2.getCell( 0);
            cellStyle2[0]   = cellDatType2.getCellStyle();
            //------------------------------------------ 사용 CellType END

			int temRows = sheet.getPhysicalNumberOfRows();
			int startRow = -1;
			int dataTempRow = -1;

			for (int i = 0; i < temRows; i++) {

				HSSFRow row = sheet.getRow(i);
				HSSFCell cell = row.getCell( 0);

				if ("dataStart".equals(cell.getStringCellValue())) {
					startRow    = i;
					dataTempRow = i + 1;
					break;
				}

			}

            HSSFRow dataRowTemp     = sheet.getRow(dataTempRow);
            HSSFRow dataRowTempType = sheet.getRow(dataTempRow + 1);

            int lastCellNum             = dataRowTemp.getLastCellNum();
            HSSFCellStyle cellStyle[]   = new HSSFCellStyle[lastCellNum];
            HSSFCell cell               = null;
            HSSFCell cellDatType        = null;
            int cellType[]              = new int[lastCellNum];
            String cellTempValue[]      = new String[lastCellNum];

            //------------------------------------------ 사용 CellType START
            HSSFCellStyle cellStyle3[]  = new HSSFCellStyle[lastCellNum];
            HSSFCell cell3              = null;
            HSSFCell cellDatType3       = null;
            //------------------------------------------ 사용 CellType END

            for (int i = 0; i < lastCellNum; i++) {
                cell                = dataRowTemp.getCell( i);
                cellDatType         = dataRowTempType.getCell( i);
                cellStyle[i]        = cellDatType.getCellStyle();
                cellType[i]         = cellDatType.getCellType();
                cellTempValue[i]    = cell.getStringCellValue();

                if(templateName.equals("ordIqListSys.xls")) {
                    cell3               = dataRowTemp2.getCell( i);
                    cellDatType3        = dataRowTempType2.getCell( i);
                    cellStyle3[i]       = cellDatType3.getCellStyle();
                }
            }

            sheet.removeRow(sheet.getRow(startRow));
            sheet.removeRow(sheet.getRow(dataTempRow));
            sheet.removeRow(sheet.getRow(dataTempRow+1));

//            int mCount = ((LMultiData) data.get(dataKey[0])).getDataCount();

            int mCount = ((List <Map<String, Object>>) data.get(dataKey[0])).size();
            int sCount = 0;

            String cellValue = "";

//            System.out.println("mCount="+mCount);

			int startData = startRow;
			HSSFRow rowline = null;

            if(templateName.equals("estIMfrTmCost.xls")) {                    // 가공비내역서
                for (int i = 0; i < mCount; i++) {
                    int tempMergeNum = startData;
                    tempMergeNum = tempMergeNum + i;

                    rowline     = sheet.createRow(tempMergeNum);
                    for (int j = 0; j < cellTempValue.length; j++) {
                        cell        = rowline.createCell( j);

                        if( j >= 31 && j <= 36) {
                            if(getLMDataValue(data, cellTempValue[j-6], i) != null) {

                                cellValue = getLMDataValue(data, cellTempValue[j-6], i).toString()+"EE";

                                // 이동공정여부 -> 이동공정시간
                                // 절단공정여부 -> 절단공정시간
                                // 용접공정여부 -> 용접공정시간
                                // 사상공정여부 -> 사상공정시간
                                // 가공공정여부 -> 가공공정시간
                                // 부착공정여부 -> 부착공정시간
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else if( j >= 37 && j <= 42) {
                            if(getLMDataValue(data, cellTempValue[j], i) != null) {

                                int intValue = Integer.parseInt(getLMDataValue(data, cellTempValue[j], i).toString());

                                if(0 < intValue) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else {
                            cell.setCellStyle(cellStyle[j]);
                        }

                        cell.setCellType(cellType[j]);
                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
                    }
                }

            } else if(templateName.equals("ordIqListSys.xls")) {                    // 견적별 산출결과 조회

            	Map<String, Object> ldata = new HashMap<String, Object>();
                int strRowNo = 0;

                for (int i = 0; i < mCount; i++) {

                    int tempMergeNum = startData;
                    tempMergeNum = tempMergeNum + i;

                    HSSFCellStyle strCellStyle = null;

                    ldata.put("rn2", getLMDataValue(data, cellTempValue[24], i).toString());

                    if((Integer.parseInt(ldata.get("rn2")+"") % 2) == 0)  strRowNo = 1;
                    else                                strRowNo = 2;

                    rowline     = sheet.createRow(tempMergeNum);
                    for (int j = 0; j < cellTempValue.length; j++) {
                        cell        = rowline.createCell( j);

                        if(strRowNo == 1)   strCellStyle = cellStyle[j];
                        else                strCellStyle = cellStyle3[j];

                        cell = rowline.createCell( j);
                        cell.setCellStyle(strCellStyle);
                        cell.setCellType(cellType[j]);

                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
                    }
                }

            } else if(templateName.equals("moldMtrlclList.xls")) {                    // 가공비내역서
                for (int i = 0; i < mCount; i++) {

                    int tempMergeNum = startData;
                    tempMergeNum = tempMergeNum + i;
                    rowline     = sheet.createRow(tempMergeNum);
                    for (int j = 0; j < cellTempValue.length; j++) {
                        cell        = rowline.createCell( j);

                        if( j == 9) {
                            if(getLMDataValue(data, cellTempValue[27], i) != null) {
                                cellValue = getLMDataValue(data, cellTempValue[27], i).toString();
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else if( j == 12) {
                            if(getLMDataValue(data, cellTempValue[28], i) != null) {
                                cellValue = getLMDataValue(data, cellTempValue[28], i).toString();
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else if( j == 15) {
                            if(getLMDataValue(data, cellTempValue[29], i) != null) {
                                cellValue = getLMDataValue(data, cellTempValue[29], i).toString();
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else if( j == 18) {
                            if(getLMDataValue(data, cellTempValue[30], i) != null) {
                                cellValue = getLMDataValue(data, cellTempValue[30], i).toString();
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else if( j == 21) {
                            if(getLMDataValue(data, cellTempValue[31], i) != null) {
                                cellValue = getLMDataValue(data, cellTempValue[31], i).toString();
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else if( j == 24) {
                            if(getLMDataValue(data, cellTempValue[32], i) != null) {
                                cellValue = getLMDataValue(data, cellTempValue[32], i).toString();
                                if(cellValue.equals("Y")) cell.setCellStyle(cellStyle2[0]); else cell.setCellStyle(cellStyle[j]);
                            }
                        } else {
                            cell.setCellStyle(cellStyle[j]);
                        }



                        cell.setCellType(cellType[j]);
                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
                    }
                }

            } else {
                for (int i = 0; i < mCount; i++) {

                    int tempMergeNum = startData;
                    tempMergeNum = tempMergeNum + i;

                    rowline = sheet.createRow(tempMergeNum);
                    for (int j = 0; j < cellTempValue.length; j++) {

                        cell = rowline.createCell( j);
                        cell.setCellStyle(cellStyle[j]);
                        cell.setCellType(cellType[j]);

                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
                    }
                }
            }

			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
			String tempfileName = "esti_" + sdf.format(new Date()).toString();
//			String basePath  ="C:/IRIS_DevonFrame/workspace/iris/src/main/webapp/resource/fileupload/template";
//			String downloadPath = basePath + "/" + templateName;
//			System.out.println("downloadPath="+downloadPath);
			basePath  =configService.getString("KeyStore.UPLOAD_BASE");
			file = new File(basePath + "/esti/" + tempfileName + ".xls");
			FileOutputStream fos = new FileOutputStream(file);
			workbook.write(fos);
			fos.close();

		} catch (IOException e) {
			e.printStackTrace();
		}
		return file;
	}


    /**
     * Export excel file
     *
     * @param LData data
     * @param String[] dataKey
     * @param String templateName
     * @return
     * @throws DevonException
     */

    public File excelAutoExportFile(Map<String, Object> data, Map<String, Object> dSet, String[] dataKey,Map<String, Object> sCountData,Map<String, Object> mCountData,Map<String, Object> rData,String templateName) throws java.text.ParseException{

        FileInputStream is = null;
        File file = null;
//        LConfiguration config = LConfiguration.getInstance();
//        String basePath = config.get("/devon/framework/front/upload/policy<default>/target-directory");
//        String downloadPath = basePath+ "/esti/"+templateName;
//        String basePath = configService.getString("template.root_path"); //config.get("/devon/framework/front/upload/policy<default>/target-directory");
        String basePath = configService.getString("KeyStore.EXCEL_BASE"); //config.get("/devon/framework/front/upload/policy<default>/target-directory");
        String downloadPath = basePath + "/" + templateName;
        System.out.println("downloadPath="+downloadPath);

        try {
            is = new FileInputStream(downloadPath);
        } catch (FileNotFoundException e) {

            e.printStackTrace();
        }
        try {

            HSSFWorkbook workbook = new HSSFWorkbook(is);
            HSSFSheet sheet = workbook.getSheetAt(0);

            int temRows = sheet.getPhysicalNumberOfRows();
            int startRow = -1;
            int dataTempRow = -1;
            String cellStr = "";
            String cellValue = "";
            int idx = 0;

            for (int i = 0; i < temRows; i++) {
                HSSFRow row = sheet.getRow(i);
                HSSFCell cell = null;

                if( dSet != null ) {
                    idx = 0;
                    while( true ) {
                        cell = row.getCell( idx++);
                        if( cell == null ) break;
                        cellStr = cell.getStringCellValue() == null ? "" : cell.getStringCellValue();
                        cellValue = dSet.get(cellStr) == null ? "nu" : dSet.get(cellStr)+"";

//                        cell.setEncoding(HSSFCell.ENCODING_UTF_16); //최신소스에서는 필요없
                        if( !cellValue.equals("nu") ) {
                            cell.setCellValue(cellValue);
                        }

                        if( cellStr.equals("end") ) {
                            cell.setCellValue("");
                            break;
                        } else if( cellStr.equals("stop") ) {
                            cell.setCellValue("");
                            dSet = null;
                            break;
                        }
                    }
                }

                cell = row.getCell( 0);

                if ("dataStart".equals(cell.getStringCellValue())) {
                    startRow = i;
                    dataTempRow = i + 1;
                    break;
                }
            }

            HSSFRow dataRowTemp = sheet.getRow(dataTempRow);
            HSSFRow dataRowTempType = sheet.getRow(dataTempRow + 1);

            int lastCellNum = dataRowTemp.getLastCellNum();

            HSSFCellStyle cellStyle[] = new HSSFCellStyle[lastCellNum];
            HSSFCell cell = null;
            HSSFCell cellDatType = null;

            int cellType[] = new int[lastCellNum];

            String cellTempValue[] = new String[lastCellNum];

            for (int i = 0; i < lastCellNum; i++) {
                cell = dataRowTemp.getCell( i);
                cellDatType = dataRowTempType.getCell( i);
                if(cellDatType != null) {
                    cellStyle[i] = cellDatType.getCellStyle();
                    cellType[i] = cellDatType.getCellType();
                    cellTempValue[i] = cell.getStringCellValue();
                }
            }

            sheet.removeRow(sheet.getRow(startRow));
            sheet.removeRow(sheet.getRow(dataTempRow));
            sheet.removeRow(sheet.getRow(dataTempRow+1));

            int mCount = ((List <Map<String, Object>>) data.get(dataKey[0])).size();

            int startData = startRow;
            HSSFRow rowline = null;

            for (int i = 0; i < mCount; i++) {

                int tempMergeNum = startData;
                tempMergeNum = tempMergeNum + i;

                rowline = sheet.createRow(tempMergeNum);
                for (int j = 0; j < cellTempValue.length; j++) {


                    cell = rowline.createCell( j);
                    if(cellStyle[j] != null) {
                        cell.setCellStyle(cellStyle[j]);
                        cell.setCellType(cellType[j]);
                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
                    }
                }
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
            String tempfileName = "esti_" + sdf.format(new Date()).toString();
            basePath  =configService.getString("KeyStore.UPLOAD_BASE");
            file = new File(basePath + "/esti/" + tempfileName + ".xls");
            FileOutputStream fos = new FileOutputStream(file);
            workbook.write(fos);
            fos.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return file;
    }

    @SuppressWarnings("unchecked")
	public File excelAutoExportFile2(Map<String, Object> data, List<Map<String, String>> dSet, String[] dataKey,Map<String, Object> sCountData,Map<String, Object> mCountData,Map<String, Object> rData,String templateName) throws java.text.ParseException{

    	FileInputStream is = null;
    	File file = null;
//        LConfiguration config = LConfiguration.getInstance();
//        String basePath = config.get("/devon/framework/front/upload/policy<default>/target-directory");
//        String downloadPath = basePath+ "/esti/"+templateName;
//    	String basePath = configService.getString("template.root_path"); //config.get("/devon/framework/front/upload/policy<default>/target-directory");
    	String basePath  =configService.getString("KeyStore.EXCEL_BASE");; //config.get("/devon/framework/front/upload/policy<default>/target-directory");
    	String downloadPath = basePath + "/" + templateName;
//    	String downloadPath = basePath+ "/cnstw/"+templateName; //경로이동 20160825김진동
    	System.out.println("downloadPath="+downloadPath);

    	try {
    		is = new FileInputStream(downloadPath);
    	} catch (FileNotFoundException e) {

    		e.printStackTrace();
    	}
    	try {

    		 HSSFWorkbook workbook = new HSSFWorkbook(is);
             HSSFSheet sheet;
             Map<String, String> tempDSet = null;

             for(int k = 0; k < dataKey.length; k++) {
                 sheet = workbook.getSheetAt(k);
                 int temRows = sheet.getPhysicalNumberOfRows();
                 int startRow = -1;
                 int dataTempRow = -1;
                 String cellStr = "";
                 String cellValue = "";
                 int idx = 0;

                 if(dSet.size() > k) {
                     tempDSet = dSet.get(k);
                 } else {
                     tempDSet = null;
                 }

                 for (int i = 0; i < temRows; i++) {
                     HSSFRow row = sheet.getRow(i);
                     HSSFCell cell = null;

                     if( tempDSet != null ) {
                         idx = 0;
                         while( true ) {
                             cell = row.getCell(idx++);
                             if( cell == null ) break;
                             cellStr = cell.getStringCellValue() == null ? "" : cell.getStringCellValue();
                             cellValue = tempDSet.get(cellStr) == null ? "" : tempDSet.get(cellStr);

//                             cell.setEncoding(HSSFCell.ENCODING_UTF_16);
                             if( !cellValue.equals("") ) {
                                 cell.setCellValue(cellValue);
                             } else {
                                 if( tempDSet.containsKey(cellStr) )
                                     cell.setCellValue("");
                             }

                             if( cellStr.equals("end") ) {
                                 cell.setCellValue("");
                                 break;
                             } else if( cellStr.equals("stop") ) {
                                 cell.setCellValue("");
                                 tempDSet = null;
                                 break;
                             }
                         }
                     }

                     cell = row.getCell( 0);
                     if ("dataStart".equals(cell.getStringCellValue())) {
                         startRow = i;
                         dataTempRow = i + 1;
                         break;
                     }
                 }

                 HSSFRow dataRowTemp = sheet.getRow(dataTempRow);
                 HSSFRow dataRowTempType = sheet.getRow(dataTempRow + 1);

                 int lastCellNum = dataRowTemp.getLastCellNum();

                 HSSFCellStyle cellStyle[] = new HSSFCellStyle[lastCellNum];
                 HSSFCell cell = null;
                 HSSFCell cellDatType = null;

                 int cellType[] = new int[lastCellNum];

                 String cellTempValue[] = new String[lastCellNum];

                 for (int i = 0; i < lastCellNum; i++) {
                     cell = dataRowTemp.getCell( i);
                     cellDatType = dataRowTempType.getCell( i);
                     cellStyle[i] = cellDatType.getCellStyle();
                     cellType[i] = cellDatType.getCellType();
                     cellTempValue[i] = cell.getStringCellValue();
                 }

                 sheet.removeRow(sheet.getRow(startRow));
                 sheet.removeRow(sheet.getRow(dataTempRow));
                 sheet.removeRow(sheet.getRow(dataTempRow+1));

                 int mCount = ((List<Map<String, String>>) data.get(dataKey[k])).size();

                 int startData = startRow;
                 HSSFRow rowline = null;

                 for (int i = 0; i < mCount; i++) {

                     int tempMergeNum = startData;
                     tempMergeNum = tempMergeNum + i;

                     rowline = sheet.createRow(tempMergeNum);
                     for (int j = 0; j < cellTempValue.length; j++) {

                         cell = rowline.createCell( j);
                         cell.setCellStyle(cellStyle[j]);
                         cell.setCellType(cellType[j]);
                         setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
                     }
                 }
             }

             SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
             String tempfileName = "cnstw_" + sdf.format(new Date()).toString();
//             file = new File(basePath + "/cnstw/" + tempfileName + ".xls"); //경로이동 20160825김진동
             basePath  =configService.getString("KeyStore.UPLOAD_BASE");
             file = new File(basePath + "/" + tempfileName + ".xls");
             FileOutputStream fos = new FileOutputStream(file);
             workbook.write(fos);
             fos.close();

         } catch (IOException e) {
             e.printStackTrace();
         }
         return file;
    }

	/**
	 * Set cell type
	 *
	 * @param HSSFCell cell
	 * @param int cType
	 * @param Object obj
	 */
	public void setCellForType(HSSFCell cell, int cType, Object obj) {
		if (obj == null){
//			System.out.println("int cType="+cType);
			return;
		}
//		cell.setEncoding(HSSFCell.ENCODING_UTF_16);
		try {
			switch (cType) {
			case HSSFCell.CELL_TYPE_BOOLEAN:
				cell.setCellValue((Boolean) obj);
				break;
			case HSSFCell.CELL_TYPE_NUMERIC:
				cell.setCellValue(Double.parseDouble(obj.toString()));
				break;
			case HSSFCell.CELL_TYPE_STRING:
				cell.setCellValue(obj.toString());
				break;
			default:
				cell.setCellValue(obj.toString());
			}
//				cell.setCellValue(obj.toString());
		} catch (Exception e) {
			cell.setCellValue(obj.toString());
		}

	}

	/**
	 * Get LMData value
	 *
	 * @param LData data
	 * @param String key
	 * @param int inx
	 * @return
	 */
	public Object getLMDataValue(Map<String, Object> data, String key, int inx) {
        if (key != null && key.startsWith("${") && key.endsWith("}")) {
			String keyStr = key.replace("${", "").replace("}", "");
			String dataKey = keyStr.split("\\.")[0].trim();
			String mDataKey = keyStr.split("\\.")[1].trim();
//			return ((List<Map<String, Object>>) data.get(dataKey)).get(mDataKey, inx);
//			System.out.println("keyStr="+keyStr);
//			System.out.println("dataKey="+keyStr);
//			System.out.println("mDataKey="+keyStr);

			return ((List <Map<String, Object>>) data.get(dataKey)).get(inx).get(mDataKey);

		}
//        System.out.println("key="+key);
		return key;
	}

    /**
     * Get LMData key
     *
     * @param String key
     * @return
     */
	public String getLMDataKey(String key) {
		if (key != null && key.startsWith("${") && key.endsWith("}")) {
			String keyStr = key.replace("${", "").replace("}", "");
			String dataKey = keyStr.split("\\.")[0].trim();
			return dataKey;
		}
		return "";
	}

	/**
	 * Equal condition for MS
	 *
	 * @param LData data
	 * @param LData rData
	 * @param String[] dataKey
	 * @param int i
	 * @param int k
	 * @return
	 */
	public boolean eqCondiForMS(Map<String,Object> data, Map<String,Object> rData, String [] dataKey, int i, int k){
		String mColCondi = rData.get(dataKey[0])+"";
		String sColCondi = rData.get(dataKey[1])+"";
		boolean flag=true;
		if(mColCondi.indexOf(',')>0){
			String [] mColCondis= mColCondi.split(",");
			String [] sColCondis= sColCondi.split(",");
//			return ((List <Map<String, Object>>) data.get(dataKey)).get(inx).get(mDataKey);
			for(int inx=0; inx < mColCondis.length; inx++){
//			if(!((LMultiData) data.get(dataKey[0])).getString(mColCondis[inx], i)
				if(!((List<Map<String,Object>>) data.get(dataKey[0])).get(i).get(mColCondis[inx])
						.equals(
								((List<Map<String,Object>>) data.get(dataKey[1]))
										.get(k).get(sColCondis[inx]))){
					flag = false;
					break;
				}
			}

		}else{
//			if(!((LMultiData) data.get(dataKey[0])).getString(mColCondi, i)
			if(!((List<Map<String,Object>>) data.get(dataKey[0])).get(i).get(mColCondi)
					.equals(
							((List<Map<String,Object>>) data.get(dataKey[1]))
									.get(k).get(sColCondi))){
				flag = false;
			}
		}
		return flag;
	}

	 public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, String downFileName, String downSheetName, String subpath, int limitRowCnt) throws java.text.ParseException{

	        FileInputStream is = null;
	        File file = null;
	        String basePath  =configService.getString("KeyStore.EXCEL_BASE");
	        System.out.println("getPath() -"+file.getPath());
	        String tmpPath = "";
	        if(subpath.equals("")){
	            tmpPath = basePath + "/";
	        }else{
	            tmpPath = basePath + "/" + subpath + "/";
	        }
	        String downloadPath = tmpPath + templateName;
	        System.out.println("downloadPath="+downloadPath);

	        try {
	            is = new FileInputStream(downloadPath);
	        } catch (FileNotFoundException e) {

	            e.printStackTrace();
	        }
	        try {

	            HSSFWorkbook workbook = new HSSFWorkbook(is);
	            HSSFSheet sheet = workbook.getSheetAt(0);

	            int temRows = sheet.getPhysicalNumberOfRows();
	            int startRow = -1;
	            int dataTempRow = -1;
	            int headSize = 1;

	            for (int i = 0; i < temRows; i++) {

	                HSSFRow row = sheet.getRow(i);
	                HSSFCell cell = row.getCell( 0);

	                if ("dataStart".equals(cell.getStringCellValue())) {
	                    startRow = i;
	                    dataTempRow = i + 1;
	                    if(startRow>1){
	                        headSize = startRow;
	                    }
	                    break;
	                }

	            }

	            int headLine[] = new int[headSize];

	            HSSFRow dataRowTemp = sheet.getRow(dataTempRow);
	            HSSFRow dataRowTempType = sheet.getRow(dataTempRow + 1);

	            int lastCellNum = dataRowTemp.getLastCellNum();

	            HSSFCellStyle cellStyle[] = new HSSFCellStyle[lastCellNum];
	            HSSFCell cell = null;
	            HSSFCell cellDatType = null;

	            int cellType[] = new int[lastCellNum];

	            String cellTempValue[] = new String[lastCellNum];

	            for (int i = 0; i < lastCellNum; i++) {
	                cell = dataRowTemp.getCell( i);
	                cellDatType = dataRowTempType.getCell( i);
	                cellStyle[i] = cellDatType.getCellStyle();
	                cellType[i] = cellDatType.getCellType();
	                cellTempValue[i] = cell.getStringCellValue();
	            }

	            sheet.removeRow(sheet.getRow(startRow));
	            sheet.removeRow(sheet.getRow(dataTempRow));
	            sheet.removeRow(sheet.getRow(dataTempRow+1));

	            HSSFRow headline = null;
	            //엑셀 sheet의 헤드라인 정보
	            HSSFSheet sheet_head = workbook.getSheetAt(0);
	            HSSFCell cell_head = null;

	            HSSFCellStyle cellStyle_head[][] = new HSSFCellStyle[headSize][lastCellNum];
	            int cellType_head[][] = new int[headSize][lastCellNum];
	            String cellTempValue_head[][] = new String[headSize][lastCellNum];

	            HSSFRow headRow[] = new HSSFRow[headSize];
	            for (int k = 0; k < headLine.length; k++) {
	                headRow[k] = sheet_head.getRow(k);
	                for (int i = 0; i < lastCellNum; i++) {
	                    cell_head = headRow[k].getCell( i);
	                    cellStyle_head[k][i] = cell_head.getCellStyle();
	                    cellType_head[k][i] = cell_head.getCellType();
	                    cellTempValue_head[k][i] = cell_head.getStringCellValue();
	                }
	            }

	            int mCount = ((List <Map<String, Object>>) data.get(dataKey[0])).size();
	            int sCount = 0;

//	            LLog.debug.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> mCount="+mCount);

	            int startData = startRow;
	            HSSFRow rowline = null;

	            int sheetCnt = 0; //excel sheet 번호

	            if(downSheetName.equals("")){
	                downSheetName = "Sheet";
	            }
	            String tmpSheetName = downSheetName; //자동생성될 sheet 명

	            int tmpStCnt = 0;
	            int tmpEdCnt = limitRowCnt;

	            if(mCount>tmpEdCnt){    // 데이터 전체 수량이 제한 수량보다 많은 경우
	                while(mCount>tmpEdCnt){ //sheet 출력 범위 마지막 행번호가 전체수량보다 적은 경우만 반복
	                    if(sheetCnt==0){   //첫번째 sheet인 경우
//	                        workbook.setSheetName(sheetCnt, tmpSheetName, HSSFWorkbook.ENCODING_UTF_16);
	                        workbook.setSheetName(sheetCnt, tmpSheetName);
	                    }else if(sheetCnt>0){
	                        workbook.createSheet();
	                        sheet = workbook.getSheetAt(sheetCnt);

	                        tmpSheetName = downSheetName + Integer.toString(sheetCnt);
//	                        workbook.setSheetName(sheetCnt, tmpSheetName, HSSFWorkbook.ENCODING_UTF_16);
	                        workbook.setSheetName(sheetCnt, tmpSheetName);
	                        tmpStCnt = limitRowCnt * sheetCnt;
	                        tmpEdCnt = limitRowCnt * (sheetCnt+1);

	                        if(tmpEdCnt>mCount){ //해당 sheet의 마지막 행번호가 전체행번호보다 크면 안됨
	                            tmpEdCnt=mCount;
	                        }
//	                      LLog.debug.println("########################### 저장할 HEADER LINE 수 : "+headLine.length);
//	                      LLog.debug.println("########################### 저장할 값의 수 : "+cellTempValue_head[0].length);

	                        for (int k = 0; k < headLine.length; k++) {
	                            headline = sheet.createRow(k);
	                            for (int j = 0; j < cellTempValue_head[k].length; j++) {
	                                cell_head = headline.createCell( j);
	                                cell_head.setCellStyle(cellStyle_head[k][j]);
	                                cell_head.setCellType(cellType_head[k][j]);
	                                setCellForType(cell_head, cellType_head[k][j],getLMDataValue(data, cellTempValue_head[k][j],k));
//	                              LLog.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HEADER 값 cellStyle["+k+"]["+j+"] : "+cell_head.getCellStyle());
//	                              LLog.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HEADER 값 cellType["+k+"]["+j+"] : "+cell_head.getCellType());
//	                              LLog.debug.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ HEADER 값 cellTempValue["+k+"]["+j+"] : "+cell_head.getStringCellValue());
	                            }
	                        }
	                    }

	                    for (int i = 0; i < tmpEdCnt-tmpStCnt; i++) {
	                        int tempMergeNum = startData;
	                        tempMergeNum = tempMergeNum + i;
	                        rowline = sheet.createRow(tempMergeNum);
	                        for (int j = 0; j < cellTempValue.length; j++) {

	                            cell = rowline.createCell( j);
	                            cell.setCellStyle(cellStyle[j]);
	                            cell.setCellType(cellType[j]);
	                            setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i+tmpStCnt));
	                        }
	                    }

	                    sheetCnt++;
	                }

	            }else{   // 첫번째 sheet에 전부 작성하는 경우
//	                workbook.setSheetName(sheetCnt, tmpSheetName, HSSFWorkbook.ENCODING_UTF_16);
	                workbook.setSheetName(sheetCnt, tmpSheetName);
	                for (int i = 0; i < mCount; i++) {

	                    int tempMergeNum = startData;
	                    tempMergeNum = tempMergeNum + i;

	                    rowline = sheet.createRow(tempMergeNum);
	                    for (int j = 0; j < cellTempValue.length; j++) {

	                        cell = rowline.createCell( j);
	                        cell.setCellStyle(cellStyle[j]);
	                        cell.setCellType(cellType[j]);
	                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
	                    }
	                }
	            }

	            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");

	            String tempfileName = "";

	            if(downFileName.equals("")){
	                if(subpath.equals("")){
	                    tempfileName = sdf.format(new Date()).toString();
	                }else{
	                    tempfileName = subpath + "_" + sdf.format(new Date()).toString();
	                }
	            }else{
	                tempfileName = downFileName + "_" + sdf.format(new Date()).toString();
	            }

	            file = new File(tmpPath + tempfileName + ".xls");
	            FileOutputStream fos = new FileOutputStream(file);
	            workbook.write(fos);
	            fos.close();

	        } catch (IOException e) {
	            // TODO Auto-generated catch block
	            e.printStackTrace();
	        }
	        return file;
	    }


	    /**
	     * 하나의 Sheet에 모든 데이터를 담는 경우
	     * @param data
	     * @param dataKey
	     * @param templateName
	     * @param downFileName
	     * @param downSheetName
	     * @param subpath
	     * @return
	     * @throws DevonException
	     */
	 	public File excelExport(Map<String, Object> data, String[] dataKey, String templateName, String downFileName, String downSheetName, String subpath) throws java.text.ParseException{
	        FileInputStream is = null;
	        File file = null;
//	        LConfiguration config = LConfiguration.getInstance();
	        String basePath  =configService.getString("KeyStore.EXCEL_BASE");

	        String tmpPath = "";
	        if(subpath.equals("")){ //서브패스 일단 안씀.
	            tmpPath = basePath + "/";
	        }else{
	            tmpPath = basePath + "/" + subpath + "/";
	        }
	        tmpPath = basePath + "/";
	        String downloadPath = tmpPath + templateName;

	        System.out.println("downloadPath="+downloadPath);

	        try {
	            is = new FileInputStream(downloadPath);
	        } catch (FileNotFoundException e) {

	            e.printStackTrace();
	        }
	        try {

	            HSSFWorkbook workbook = new HSSFWorkbook(is);

	            if(!downSheetName.equals(""))
	                workbook.setSheetName(0, downSheetName);

	            HSSFSheet sheet = workbook.getSheetAt(0);

	            int temRows = sheet.getPhysicalNumberOfRows();
	            int startRow = -1;
	            int dataTempRow = -1;

	            for (int i = 0; i < temRows; i++) {

	                HSSFRow row = sheet.getRow(i);
	                HSSFCell cell = row.getCell( 0);

	                if ("dataStart".equals(cell.getStringCellValue())) {
	                    startRow = i;
	                    dataTempRow = i + 1;
	                    break;
	                }

	            }

	            HSSFRow dataRowTemp = sheet.getRow(dataTempRow);
	            HSSFRow dataRowTempType = sheet.getRow(dataTempRow + 1);

	            int lastCellNum = dataRowTemp.getLastCellNum();

	            HSSFCellStyle cellStyle[] = new HSSFCellStyle[lastCellNum];
	            HSSFCell cell = null;
	            HSSFCell cellDatType = null;

	            int cellType[] = new int[lastCellNum];

	            String cellTempValue[] = new String[lastCellNum];

	            for (int i = 0; i < lastCellNum; i++) {
	                cell = dataRowTemp.getCell( i);
	                cellDatType = dataRowTempType.getCell( i);
	                if(cellDatType != null){
	                    cellStyle[i] = cellDatType.getCellStyle() == null ? null : cellDatType.getCellStyle();
	                    cellType[i] = cellDatType.getCellType();
	                    cellTempValue[i] = cell.getStringCellValue() == null ? "" : cell.getStringCellValue();
	                }
	            }

	            sheet.removeRow(sheet.getRow(startRow));
	            sheet.removeRow(sheet.getRow(dataTempRow));
	            sheet.removeRow(sheet.getRow(dataTempRow+1));

	            int mCount = ((List <Map<String, Object>>) data.get(dataKey[0])).size();
	            int sCount = 0;

	            System.out.println("mCount="+mCount);

	            int startData = startRow;
	            HSSFRow rowline = null;

	            for (int i = 0; i < mCount; i++) {

	                int tempMergeNum = startData;
	                tempMergeNum = tempMergeNum + i;

	                rowline = sheet.createRow(tempMergeNum);
	                for (int j = 0; j < cellTempValue.length; j++) {


	                    cell = rowline.createCell( j);

	                    if(cellStyle[j] != null) {
	                        cell.setCellStyle(cellStyle[j]);
	                        cell.setCellType(cellType[j]);
	                        setCellForType(cell, cellType[j],getLMDataValue(data, cellTempValue[j],i));
	                    }
	                }
	            }

	            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");

	            String tempfileName = "";

	            if(downFileName.equals("")){
	                if(subpath.equals("")){
	                    tempfileName = sdf.format(new Date()).toString();
	                }else{
	                    tempfileName = subpath + "_" + sdf.format(new Date()).toString();
	                }
	            }else{
	                tempfileName = downFileName + "_" + sdf.format(new Date()).toString();
	            }

	            file = new File(tmpPath + tempfileName + ".xls");
	            FileOutputStream fos = new FileOutputStream(file);
	            workbook.write(fos);
	            fos.close();

	        } catch (IOException e) {
	            // TODO Auto-generated catch block
	            e.printStackTrace();
	        }
	        return file;

		}

}
