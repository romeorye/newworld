package iris.web.fxa.trsf.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;
import org.springframework.ui.velocity.VelocityEngineUtils;

import devonframe.dataaccess.CommonDao;

@Service("fxaTrsfService")
public class FxaTrsfServiceImpl implements FxaTrsfService {

	static final Logger LOGGER = LogManager.getLogger(FxaTrsfServiceImpl.class);
	/*
	static String functionName = "ZFI_PMIS_ASSET_CHANGE";
    static String tableName ="IF_ASSETRSLT";
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)
   */ 
	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;
	
	
	/**
	 * 자산이관 목록 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaTrsfSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaTrsf.retrieveFxaTrsfSearchList", input);
		return resultList;
	}

	/**
	 * 자산관리 > 이관 정보 저장
	 * @param input
	 */
	@Override
	public void insertFxaTrsfInfo(HashMap<String, Object> input) throws Exception{
		
		LOGGER.debug("input===================================="+input);
		int chk = commonDao.insert("fxaInfo.fxaTrsf.insertFxaTrsfInfo", input);
		String rtnFxaTrsfId ="";
		
		if(chk > 0 ){
			rtnFxaTrsfId = input.get("fxaTrsfId").toString();
		}else{
			throw new Exception("자산이관 요청중 오류가 발생하였습니다.");
		}
		//LOGGER.debug("rtnFxaTrsfId===================================="+rtnFxaTrsfId);
		
		HashMap<String, Object> rdcsMap = new HashMap<String, Object>();
		HashMap<String, Object> fxaTrsfInfo = new HashMap<String, Object>();
		
		fxaTrsfInfo.put("fxaNo",input.get("fxaNo"));
		fxaTrsfInfo.put("fxaNm",input.get("fxaNm"));
		fxaTrsfInfo.put("fromPrjNm",input.get("fromPrjNm"));
		fxaTrsfInfo.put("crgrNm",input.get("crgrNm"));
		fxaTrsfInfo.put("prjNm",input.get("prjNm"));
		fxaTrsfInfo.put("toCrgrNm",input.get("toCrgrNm"));
		fxaTrsfInfo.put("trsfRson",input.get("trsfRson"));
		
		String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/fxa/trsf/vm/fxaTrsfHtml.vm", "UTF-8", fxaTrsfInfo);
		
		rdcsMap.put("guId", "F"+rtnFxaTrsfId);
		rdcsMap.put("affrCd", rtnFxaTrsfId);
		rdcsMap.put("approvalUserid", input.get("_userId"));		
		rdcsMap.put("approvalUsername", input.get("_userNm"));		
		rdcsMap.put("approvalJobtitle", input.get("_userJobxName"));  
		rdcsMap.put("approvalDeptname", input.get("_userDeptName"));  
		rdcsMap.put("body", body);
		rdcsMap.put("title", "[자산이관] 자산이관결재요청");
		
		//전자결재 저장
		commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", rdcsMap);
		
    	if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", rdcsMap) == 0) {
    		throw new Exception("결재요청 정보 등록 오류");
    	}
		
	}

	
	/**
	 * 자산관리 > 이관 정보 저장 정보 -> ERP 전달
	 * @param input
	
	 @Override
	public Map fxaInfoTrsfErpIF(HashMap<String, Object> input) throws JCoException{
		 Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
        
    	//연결정보확인.
		JCoFunction function = destination.getRepository().getFunction(functionName); 
		    
	    if(function == null) throw new RuntimeException("SAP_DATA not found in SAP.");
	        
	    try{ 
			function.getImportParameterList().setValue("ASSET_NO", 	input.get("fxaNo")); 
			function.getImportParameterList().setValue("PERNRFROM", input.get("fromCrgrId")); 
			function.getImportParameterList().setValue("PERNRTO",  	input.get("toCrgrId")); 
			function.getImportParameterList().setValue("WBSFROM",  	input.get("fromWbsCd")); 
			function.getImportParameterList().setValue("WBSTO",  	input.get("toWbsCd")); 
	       
			function.execute(destination);
			
		}catch(AbapException e){
	       	LOGGER.debug("ERROR >> FxaInfoIFBatch : IRIS_SAP_BUDG_S_COST  function.execute Error"+e.toString());	
	        e.printStackTrace();
	    }
    
		// 테이블 호출
	    String returnCd = function.getExportParameterList().getString("RETURN"); // .getStructure("RETURN").getByte();
	    String msg = function.getExportParameterList().getString("MESSAGE"); // .getStructure("RETURN").getByte();
	    LOGGER.debug("#################################returnStructure#################################################### + " + returnCd);    
	    LOGGER.debug("#################################msg#################################################### + " + msg);    
        
	    if(returnCd.equals("S")){
        	try{
        		commonDao.insert("fxaInfo.fxaTrsf.insertFxaTrsfInfo", input);
        	}catch(Exception e){
        		e.printStackTrace();
        		//이관 ERP는 성공  이관테이블 오류발생시..SM으로 강제 등록해야함
        		msg = "이관 등록중 오류가 발생하였습니다.";
        		returnCd = "F";
        	}
        }
        
	    rtnMap.put("rtnSt", returnCd);
	    rtnMap.put("msg", msg);
	    
		return rtnMap;
	}
	 */
}
