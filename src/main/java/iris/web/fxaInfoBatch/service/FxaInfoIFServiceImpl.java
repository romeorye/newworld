package iris.web.fxaInfoBatch.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.sap.conn.jco.AbapException;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoFunction;

import devonframe.dataaccess.CommonDao;

@Service("fxaInfoIFService")
public class FxaInfoIFServiceImpl implements FxaInfoIFService {

	static final Logger LOGGER = LogManager.getLogger(FxaInfoIFServiceImpl.class);
	
	static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)
	
	static String functionName = "ZFI_PMIS_ASSET_CHANGE";
    static String tableName ="IF_ASSETRSLT";
    
    
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	//IF 자산테이블에 저장 
	public void insertFxaInfoIF(List<Map<String, Object>> list){
		
		commonDao.delete("fxaBatch.deleteFxaInfoIF", list);
		commonDao.batchInsert("fxaBatch.insertFxaInfoIF", list);
	
		Map<String,Object> ifMap = new HashMap<String, Object>();

		List<Map<String,Object>> fxaIFList = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> savefxaList = new ArrayList<Map<String,Object>>();
		
		fxaIFList = commonDao.selectList("fxaBatch.retrieveFxaInfoIF", list);
		
		//고정자산 if 정보 추출
		for(int i=0; i < fxaIFList.size(); i++){
			ifMap = fxaIFList.get(i);
			HashMap<String,Object> fxaMap = new HashMap<String, Object>();
			
			fxaMap.put("fxaNo", ifMap.get("fxaNo"));		 
			fxaMap.put("fxaNm", ifMap.get("fxaNm"));		
			fxaMap.put("fxaStCd", ifMap.get("fxaStCd"));
			fxaMap.put("wbsCd", ifMap.get("wbsCd"));
			fxaMap.put("prjCd", ifMap.get("prjCd"));
			fxaMap.put("crgrId", ifMap.get("crgrId"));
			fxaMap.put("fxaClss", ifMap.get("fxaClss"));
			fxaMap.put("fxaQty", ifMap.get("fxaQty"));
			fxaMap.put("fxaUtmNm", ifMap.get("fxaUtmNm"));
			fxaMap.put("obtPce", ifMap.get("obtPce"));
			fxaMap.put("bkpPce", ifMap.get("bkpPce"));
			fxaMap.put("obtDt", ifMap.get("obtDt"));
			fxaMap.put("useUsf", ifMap.get("useUsf"));
			fxaMap.put("dsuDt", ifMap.get("dsuDt"));
			fxaMap.put("deptCd", ifMap.get("deptCd"));
			
			savefxaList.add(fxaMap);
		}
		
		commonDao.batchUpdate("fxaBatch.updateFxaInfoMst", savefxaList);
	}

	
	//IF 자산이관 ERP 연동
	public void insertFxaTrsfIF(List<Map<String, Object>> list) throws Exception{
		Map<String, Object> rtnMap = new HashMap<String, Object>();
        
		//LOGGER.debug("테이블가져오기 실행");
    	JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
    	//연결정보확인.
		JCoFunction function = destination.getRepository().getFunction(functionName); 
		    
	    if(function == null) throw new RuntimeException("SAP_DATA not found in SAP.");

	    HashMap<String, Object> fxaTrsfMap = new HashMap<String, Object>();
	    String msg = "";
	    String returnCd = "";
	    
	    try{
	    	
	    	 List<Map<String, Object>> fxaTrsfList = commonDao.selectList("fxaBatch.retrieveFxaTrsfInfo", list);
	    
	    	for(int i=0; i < fxaTrsfList.size(); i++ ){
	    		fxaTrsfMap = (HashMap<String, Object>) fxaTrsfList.get(i);
	    		
	    		function.getImportParameterList().setValue("ASSET_NO", 	fxaTrsfMap.get("fxaNo")); 
	    		function.getImportParameterList().setValue("PERNRFROM", fxaTrsfMap.get("fromCrgrId")); 
	    		function.getImportParameterList().setValue("PERNRTO",  	fxaTrsfMap.get("toCrgrId")); 
	    		function.getImportParameterList().setValue("WBSFROM",  	fxaTrsfMap.get("fromWbsCd")); 
	    		function.getImportParameterList().setValue("WBSTO",  	fxaTrsfMap.get("toWbsCd")); 
	    		
	    		function.execute(destination);
	    		
	    		// 테이블 호출
	    	    returnCd = function.getExportParameterList().getString("RETURN"); // 
	    	    msg = function.getExportParameterList().getString("MESSAGE"); // 
	    	    //LOGGER.debug("#################################returnStructure#################################################### + " + returnCd);    
	    	    //LOGGER.debug("#################################msg#################################################### + " + msg);    
	            
	    	    if(!returnCd.equals("S")){
	    	    	//LOGGER.debug("##############################fxaNo################################################### + " + fxaTrsfMap.get("fxaNo"));    
	    	    	throw new Exception(msg); 
	            }
	    	}
			
		}catch(AbapException e){
	       	LOGGER.debug("ERROR >> FxaInfoIFBatch : IRIS_SAP_BUDG_S_COST  function.execute Error"+e.toString());	
	        e.printStackTrace();
	    }
	 
	};
	
	//WBS _ prj NM
	public void insertWbsPrjIFInfo(List<Map<String, Object>> list){
		commonDao.batchInsert("fxaBatch.insertWbsPrjIFInfo", list);
	}
		
}
