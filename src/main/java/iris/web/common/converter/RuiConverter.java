/*
 * @(#) LDefaultJsonConverter.java
 *
 * Copyright ⓒ LG CNS, Inc. All rights reserved.
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * DevOn Framework의 클래스를 실제 프로젝트에 사용하는 경우 DevOn 개발담당자에게
 * 프로젝트 정식명칭, 담당자 연락처(Email)등을 mail로 알려야 한다.
 *
 * 소스를 변경하여 사용하는 경우 DevOn Framework 개발담당자에게
 * 변경된 소스 전체와 변경된 사항을 알려야 한다.
 * 저작자는 제공된 소스가 유용하다고 판단되는 경우 해당 사항을 반영할 수 있다.
 * 중요한 Idea를 제공하였다고 판단되는 경우 협의하에 저자 List에 반영할 수 있다.
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
package iris.web.common.converter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * <pre>
 * Request에 담겨 있는 Rui용 LDataSet의 데이터와 Dataset간의 상호변환을 위한 Utility class이다.
 *     
 * </pre>
 * 
 * @author DevOn Framework, LG CNS,Inc., devon@lgcns.com
 */
public class RuiConverter  {
	
	public static Map<String, Object> createDataset(String datasetName, Map<String, Object> result) {
		if(result == null) {
			result = new HashMap<String,Object>();
		}
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list.add(result);
		
		return createDataset(datasetName, list);
	}
	
	public static Map<String, Object> createDataset(String datasetName, List<Map<String, Object>> result) {
		Map<String,Object> dataset = new HashMap<String,Object>();
		
		dataset.put("metaData", createMetaData(datasetName, result));
		dataset.put("records", result);
		
		return dataset;
	}
   
    /**
     * Dataset을 기준으로 metaData를 생성한다.
     * 
     * @param lMultiData List
     * @return LData 변환 결과
     */
    private static Map<String, Object> createMetaData(String datasetName, List<Map<String, Object>> result) {
    	/*if(result == null || result.size() == 0) {
    		return new HashMap<String,Object>();
    	}*/
    	Map<String,Object> metadata = new HashMap<String,Object>();
		List<Map<String,Object>> fields = new ArrayList<Map<String,Object>>();
		datasetName = datasetName != null ? datasetName : RuiConstants.METADATA_DATASET_DEFAULT_NAME;
		metadata.put( "idColumn", RuiConstants.METADATA_RECORD_ID );
		metadata.put( "stateColumn", RuiConstants.METADATA_RECORD_STATE );
		metadata.put( "dataSetId", datasetName );
		
		int totalCount = 0;
		if(result != null && result.size() > 0) {
			Set<String> keyset = result.get(0).keySet();
			String[] keysets = new String[keyset.size()];
			keyset.toArray(keysets);
			for(int inx = 0 ; inx < keyset.size() ; inx++) {
				Map<String,Object> field = new HashMap<String,Object>();
				field.put("name", keysets[inx]);
				fields.add(field);
			}
			metadata.put("fields", fields);
        
			totalCount = result.size();
		}
        
        metadata.put( "totalCount", new Integer(totalCount));

        return metadata;
    }
    
    /**
     * ServletRequest에서 Rui의 데이터를 추출하여 JSONArray객체로 리턴한다.
     * 
     * @param req ServletRequest
     * @return JSONArray 변환 결과
     * @exception JSONException
     */
    private static JSONArray getJSONArray(ServletRequest req) throws JSONException {
        String dataSetData = req.getParameter(RuiConstants.KEY_DATASETDATA);
        if(dataSetData == null || "".equals(dataSetData)) return null;

        return new JSONArray(dataSetData);
    }

    /**
     * ServletRequest에서 Rui의 데이터를 추출하여 JSONArray객체로 리턴한다.
     * 
     * @param jSONArray JSONArray
     * @param id String
     * @return JSONObject 변환 결과
     * @exception Exception
     */
    private static JSONObject getJSONObject(JSONArray jSONArray, String id) throws Exception {
        JSONObject jSONObject = null;
        for(int i = 0 ; i < jSONArray.length(); i++) {
            jSONObject = jSONArray.getJSONObject(i);
            String dataSetId = null;
            try {
                dataSetId = (String) ((JSONObject) jSONObject.get(RuiConstants.KEY_METADATA)).get(RuiConstants.METADATA_DATASET_ID);
            } catch (Exception e) {
                dataSetId = (String) jSONObject.get(RuiConstants.METADATA_DATASET_ID);
            }
            if(id.equalsIgnoreCase(dataSetId))
                return jSONObject;
        }
        return null;
    }
    
    /**
     * ServletRequest에서 Rui의 데이터를 추출하여 dataSetId에 해당되는 Dataset을 리턴한다. 
     * LData의 key는 rui field가 된다.
     * 
     * @param req ServletRequest
     * @param dataSetId String
     * @return LMultiData 변환 결과
     * @exception Exception
     */
    public static List<Map<String, Object>> convertToDataSet(ServletRequest req, String dataSetId) throws Exception {
    	List<Map<String, Object>> dataset = new ArrayList<Map<String, Object>>();
        try {
            JSONArray jSONArray = getJSONArray(req);
            JSONObject jSONObject = getJSONObject(jSONArray, dataSetId);
            
            if(jSONObject == null) return null;
            
            JSONArray recordsJSONArray = jSONObject.getJSONArray(RuiConstants.KEY_RECORDS);
            
            for(int i = 0 ; i < recordsJSONArray.length() ; i++) {
                JSONObject rowDataJSONObject = recordsJSONArray.getJSONObject(i);
                
                Map rowData = new LinkedHashMap();

                Iterator keys = rowDataJSONObject.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next();
                    String value = rowDataJSONObject.getString(key);
                    rowData.put(key, value);
                }
                
                dataset.add(rowData);
            }
            
        } catch (Exception e) {
        	//e.printStackTrace();
            /*throwException("FRM_RUI_002", RuiConverter.class,
                    "convertToLMultiData(ServletRequest req, String dataSetId)", e);*/
        }
        return dataset;
    }
    
    /**
     * ServletRequest에서 Rui의 데이터를 추출하여 dataSetId에 해당되는 Dataset을 리턴한다. 
     * LData의 key는 rui field가 된다.
     * 
     * @param req ServletRequest
     * @param dataSetId String
     * @return List<HashMap<String, Object>> 변환 결과
     * @exception Exception
     */
    public static List<HashMap<String, String>> convertToDataSetHashMap(ServletRequest req, String dataSetId) throws Exception {
    	List<HashMap<String, String>> dataset = new ArrayList<HashMap<String, String>>();
        try {
            JSONArray jSONArray = getJSONArray(req);
            JSONObject jSONObject = getJSONObject(jSONArray, dataSetId);
            
            if(jSONObject == null) return null;
            
            JSONArray recordsJSONArray = jSONObject.getJSONArray(RuiConstants.KEY_RECORDS);
            
            for(int i = 0 ; i < recordsJSONArray.length() ; i++) {
                JSONObject rowDataJSONObject = recordsJSONArray.getJSONObject(i);
                
                HashMap rowData = new LinkedHashMap();

                Iterator keys = rowDataJSONObject.keys();
                while (keys.hasNext()) {
                    String key = (String) keys.next();
                    String value = rowDataJSONObject.getString(key);
                    rowData.put(key, value);
                }
                
                dataset.add(rowData);
            }
            
        } catch (Exception e) {
        	//e.printStackTrace();
            /*throwException("FRM_RUI_002", RuiConverter.class,
                    "convertToLMultiData(ServletRequest req, String dataSetId)", e);*/
        }
        return dataset;
    }
  
    private static void throwException(String s, Class cls, String msg, Exception t) throws Exception{
    	throw t;
    }
/*    
    private static String jsonConvertToMessage(List dataSetList) throws Exception {
    	JSONArray response = new JSONArray();
    	for(int i = 0 ; i < dataSetList.size(); i++) {
    		DataSet dataSet = (DataSet) dataSetList.get(i);
    		JSONObject dataSetObject = new JSONObject();
    		dataSetObject.put("metaData", dataSet.getMetaData());
    		dataSetObject.put("records", dataSet.getList());
    		response.put(dataSetObject);
    	}
    	return response.toString(1);
    }
    
    public static void main(String args[]) {
    	try {
    		retrieveRow();
    		retrieveList();
    		retrieveMultiList();
    		cudDataSet();
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    public static void retrieveRow() {
    	Map rowData1 = new HashMap();
    	rowData1.put("col1", "11");
    	rowData1.put("col2", "12");
    	
    	DataSet dataSet1 = new DataSet("dataSet1", rowData1);
    	
    	try {
    		System.out.println(RuiConverter.convertToMessage(dataSet1));
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    public static void retrieveList() {
    	List lMultiDataList = new ArrayList();
    	Map rowData1 = new HashMap();
    	rowData1.put("col1", "11");
    	rowData1.put("col2", "12");
    	Map rowData2 = new HashMap();
    	rowData2.put("col1", "21");
    	rowData2.put("col2", "22");
    	lMultiDataList.add(rowData1);
    	lMultiDataList.add(rowData2);
    	
    	DataSet dataSet1 = new DataSet("dataSet1", lMultiDataList);
    	
    	try {
    		System.out.println(RuiConverter.convertToMessage(dataSet1));
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    public static void retrieveMultiList() {
    	List lMultiDataList = new ArrayList();
    	Map rowData1 = new HashMap();
    	rowData1.put("col1", "11");
    	rowData1.put("col2", "12");
    	Map rowData2 = new HashMap();
    	rowData2.put("col1", "21");
    	rowData2.put("col2", "22");
    	lMultiDataList.add(rowData1);
    	lMultiDataList.add(rowData2);
    	
    	DataSet dataSet1 = new DataSet("dataSet1", lMultiDataList);
    	dataSet1.setTotalCount(1000);
    	DataSet dataSet2 = new DataSet("dataSet2", lMultiDataList);
    	
    	List dataSetList = new ArrayList();
    	
    	dataSetList.add(dataSet1);
    	dataSetList.add(dataSet2);
    	
    	try {
    		System.out.println(RuiConverter.convertToMessage(dataSetList));
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    
    public static void cudDataSet() {
    	try {
    		String jsonString = "[ {  \"metaData\": {   \"dataSetId\": \"dataSet1\",   \"idColumn\": \"id\",   \"stateColumn\": \"duistate\",   \"totalCount\": 2  },  \"records\": [   {    \"col1\": \"11\",    \"col2\": \"12\"   },   {    \"col1\": \"21\",    \"col2\": \"22\"   }  ] }, {  \"metaData\": {   \"dataSetId\": \"dataSet2\",   \"idColumn\": \"id\",   \"stateColumn\": \"duistate\",   \"totalCount\": 2  },  \"records\": [   {    \"col1\": \"11\",    \"col2\": \"12\"   },   {    \"col1\": \"21\",    \"col2\": \"22\"   }  ] }]";
    		DataSet dataSet = DataSetFactory.getInstance().getJsonDataSet(jsonString, "dataSet1");
    		System.out.println(dataSet.getId());
		} catch (Exception e) {
			e.printStackTrace();
		}
    }*/
}
