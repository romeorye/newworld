package iris.web.fxa.oscp.service;

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

@Service("fxaOscpService")
public class FxaOscpServiceImpl implements FxaOscpService {

	static final Logger LOGGER = LogManager.getLogger(FxaOscpServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;
	
	
	/**
	 * 사외자산리스트 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaOscpSearchList(HashMap<String, Object> input){
		return commonDao.selectList("fxaInfo.fxaOscp.retrieveFxaOscpSearchList", input);
	}
	
	/**
	 * 사외자산이관 정보 저장
	 * @param oscpList
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	public String insertFxaOscpInfo(List<Map<String, Object>> oscpList, HashMap<String, Object> input) throws Exception{
		
		List<Map<String, Object>> oscpInfoList = new ArrayList<Map<String, Object>>();
		String guid = commonDao.select("fxaInfo.fxaOscp.retrieveOscpGuid", input);
		
		DecimalFormat df = new DecimalFormat("###,###,###,###");
		
		for(Map<String, Object> oscpInfo : oscpList ){
			oscpInfo.put("guid", guid);
			oscpInfo.put("_userId", input.get("_userId"));
			
			oscpInfoList.add(oscpInfo);
		}
		if (commonDao.batchInsert("fxaInfo.fxaOscp.insertFxaOscpInfo", oscpInfoList) > 0 ){
			commonDao.batchUpdate("fxaInfo.fxaOscp.updateFxaLoc", oscpInfoList);
			
			StringBuffer sb = new StringBuffer();
			StringBuffer sbGrid = new StringBuffer();
			HashMap<String, Object> fxaOscpInfo = new HashMap<String, Object>();
			
			sb.append("<tr>");
			sb.append("<th>자산명</th>");
			sb.append("<th>자산번호</th>");
			sb.append("<th>수량</th>");
			sb.append("<th>단위</th>");
			sb.append("<th>장부가</th>");
			sb.append("<th>위치</th>");
			sb.append("</tr>");       
			
			fxaOscpInfo.put("fxaOscpHead", sb);

			for(Map<String ,Object> data : oscpList ){
				sbGrid.append("<tr>");
				sbGrid.append("<td>").append(data.get("fxaNm")).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaNo")).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaQty")).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaUtmNm")).append("</td>");
				sbGrid.append("<td>").append(df.format(Double.parseDouble(data.get("bkpPce").toString()))).append("</td>");
				sbGrid.append("<td>").append(data.get("fxaLoc")).append("</td>");
				sbGrid.append("</tr>");
			}
			
			fxaOscpInfo.put("fxaOscpList", sbGrid);
			
			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/fxa/oscp/vm/fxaOscpHtml.vm", "UTF-8", fxaOscpInfo);
			
			HashMap<String, Object> rdcsMap = new HashMap<String, Object>();
			
			rdcsMap.put("guId", guid);
			rdcsMap.put("affrCd", "");
			rdcsMap.put("approvalUserid", input.get("_userId"));		
			rdcsMap.put("approvalUsername", input.get("_userNm"));		
			rdcsMap.put("approvalJobtitle", input.get("_userJobxName"));  
			rdcsMap.put("approvalDeptname", input.get("_userDeptName"));  
			rdcsMap.put("body", body);
			rdcsMap.put("title", "[사외자산이관] 사외자산이관결재요청");
				
	    	if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", rdcsMap) == 0) {
	    		throw new Exception("결재요청 정보 등록 오류");
	    	}
			
		}else{
			throw new Exception("자산이관(사외) 요청중 오류가 발생하였습니다.");
		}
		
		
		return guid;
	}
	
	/**
	 *  사외자산이관 팝업목록 조회
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaOscpPopList(HashMap<String, Object> input){
		String[] fxaInfoIdArr = ((String)input.get("fxaNos")).split(",");
		input.put("fxaInfoIdArr", fxaInfoIdArr);
		
		return commonDao.selectList("fxaInfo.fxaOscp.retrieveFxaOscpPopList", input);
	}
	
}
