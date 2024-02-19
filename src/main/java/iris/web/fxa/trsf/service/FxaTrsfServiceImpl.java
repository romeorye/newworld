package iris.web.fxa.trsf.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
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
	public String insertFxaTrsfInfo(List<Map<String, Object>> trsfList, HashMap<String, Object> input)  throws Exception{
		
		List<Map<String, Object>> trsfInfoList = new ArrayList<Map<String, Object>>();
		String guid = commonDao.select("fxaInfo.fxaTrsf.retrieveGuid", input);
		
		DecimalFormat df = new DecimalFormat("###,###,###,###");
		
		for(Map<String, Object> trsfInfo :trsfList ){
			trsfInfo.put("guid", guid);
			trsfInfo.put("_userId", input.get("_userId"));
			
			trsfInfoList.add(trsfInfo);
		}

		if (commonDao.batchInsert("fxaInfo.fxaTrsf.insertFxaTrsfInfo", trsfInfoList) > 0 ){
			StringBuffer sb = new StringBuffer();
			StringBuffer sbGrid = new StringBuffer();
			HashMap<String, Object> fxaTrsfInfo = new HashMap<String, Object>();
			
			sb.append("<tr>");
			sb.append("<th rowspan='2'>자산명</th>");
			sb.append("<th rowspan='2'>자산번호</th>");
			sb.append("<th rowspan='2'>수량</th>");
			sb.append("<th rowspan='2'>단위</th>");
			sb.append("<th rowspan='2'>장부가</th>");
			sb.append("<th colspan='2'>이관 前</th>");
			sb.append("<th colspan='2'>이관 後</th>");
			sb.append("</tr>");       
			sb.append("<tr>");
			sb.append("<th>PJT코드</th>");
			sb.append("<th>담당자</th>");
			sb.append("<th>PJT코드</th>");
			sb.append("<th>담당자</th>");
			sb.append("</tr>  ");
			
			fxaTrsfInfo.put("fxaTrsfHead", sb);

			for(Map<String ,Object> data : trsfList ){
				sbGrid.append("<tr>");
				sbGrid.append("<td>").append(data.get("fxaNm")).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaNo")).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaQty")).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaUtmNm")).append("</td>");
				//sbGrid.append("<td>").append(df.format(Double.parseDouble(data.get("obtPce").toString()))).append("</td>");
				sbGrid.append("<td>").append(df.format(Double.parseDouble(data.get("bkpPce").toString()))).append("</td>");
				sbGrid.append("<td>").append(data.get("wbsCd")).append("</td>");
				sbGrid.append("<td>").append(data.get("crgrNm")).append("</td>");
				sbGrid.append("<td>").append(data.get("toWbsCd")).append("</td>");
				sbGrid.append("<td>").append(data.get("toCrgrNm")).append("</td>");
				sbGrid.append("</tr>");
			}
			
			fxaTrsfInfo.put("fxaTrsfList", sbGrid);
			
			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/fxa/trsf/vm/fxaTrsfHtml.vm", "UTF-8", fxaTrsfInfo);
			
			HashMap<String, Object> rdcsMap = new HashMap<String, Object>();
			
			rdcsMap.put("guId", guid);
			rdcsMap.put("affrCd", "");
			rdcsMap.put("approvalUserid", input.get("_userId"));		
			rdcsMap.put("approvalUsername", input.get("_userNm"));		
			rdcsMap.put("approvalJobtitle", input.get("_userJobxName"));  
			rdcsMap.put("approvalDeptname", input.get("_userDeptName"));  
			rdcsMap.put("body", body);
			rdcsMap.put("title", "[자산이관] 자산이관결재요청");
				
	    	if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", rdcsMap) == 0) {
	    		throw new Exception("결재요청 정보 등록 오류");
	    	}
			
		}else{
			throw new Exception("자산이관 요청중 오류가 발생하였습니다.");
		}
		
		return guid;
	}

	/**
	 * 자산관리 > 자산이관 목록 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaTrsfPopList(HashMap<String, Object> input){
		String[] fxaInfoIdArr = ((String)input.get("fxaNos")).split(",");
		input.put("fxaInfoIdArr", fxaInfoIdArr);
		
		return commonDao.selectList("fxaInfo.fxaTrsf.retrieveFxaTrsfPopList", input);
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
