package iris.web.fxa.rlis.service;

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
import devonframe.util.NullUtil;

@Service("fxaRlisService")
public class FxaRlisServiceImple implements FxaRlisService{

	static final Logger LOGGER = LogManager.getLogger(FxaRlisServiceImple.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* oracle db connection */
	@Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;
	
	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;

	/**
	 * 자산실사> 실사명 combo리스트 조회
	 * @param input
	 * @return
	 */
	@Override
    public List<Map<String, Object>> retrieveFxaRlisTitlCombo(String string) {
        return commonDao.selectList("fxaInfo.fxaRlis.retrieveFxaRlisTitlCombo",string);
    }

	/**
	 * 자산실사 목록 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaRlisSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaRlis.retrieveFxaRlisSearchList", input);
		return resultList;
	}

	/**
	 *  자산실사 To_do 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaRlisTodoList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaRlis.retrieveFxaRlisTodoList", input);
		return resultList;
	}
	
	/**
	 *  자산실사 To_do 저장
	 * @param input
	 * @return
	 */
	public void saveFxaRlisTodoInfo(List<Map<String, Object>> inputList){
		commonDao.batchUpdate("fxaInfo.fxaRlis.saveFxaRlisTodoInfo", inputList);
	}
	
	/**
	 *  자산실사 To_do 결재저장
	 * @param input
	 * @return
	 */
	public void saveFxaRlisTodoApprInfo(List<Map<String, Object>> inputList, HashMap<String, Object> input) throws Exception{
		//저장안하고 바로 결재 누를경우 to_do 저장
		commonDao.batchUpdate("fxaInfo.fxaRlis.saveFxaRlisTodoInfo", inputList);
		
		HashMap<String, Object> rdcsMap = new HashMap<String, Object>();
		HashMap<String, Object> fxaTodoInfo = new HashMap<String, Object>();
		
		//to_do list 전자결재 template
		List<Map<String,Object>> fxaRlisTodoList = commonDao.selectList("fxaInfo.fxaRlis.retrieveFxaRlisTodoList", input);
		String body = "";
		
		StringBuffer sb = new StringBuffer();
		
		for(Map<String, Object> data : fxaRlisTodoList) {
			sb.append("<tr>")
			  .append("<td>").append(data.get("prjNm")).append("</td>")
			  .append("<td>").append(data.get("fxaNo")).append("</td>")
			  .append("<td>").append(data.get("fxaNm")).append("</td>")
			  .append("<td>").append(data.get("fxaQty")).append("</td>")
			  .append("<td>").append(data.get("fxaUtmNm")).append("</td>")
			  .append("<td>").append(data.get("crgrNm")).append("</td>")
			  .append("<td>").append(NullUtil.nvl(data.get("rlisDt"),"")).append("</td>")
			  .append("<td>").append(data.get("fxaSsisYn")).append("</td>")
			  .append("<td>").append(data.get("fxaRem")).append("</td>")
			  .append("</tr>");
		}
		
		fxaTodoInfo.put("fxaTodoList", sb.toString());
		body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/fxa/rlis/vm/fxaRlisHtml.vm", "UTF-8", fxaTodoInfo);
		
		//전자결재 등록
		rdcsMap.put("guId", "R"+input.get("fxaRlisId"));
		rdcsMap.put("affrCd", input.get("fxaRlisId"));
		rdcsMap.put("approvalUserid", input.get("_userId"));		
		rdcsMap.put("approvalUsername", input.get("_userNm"));		
		rdcsMap.put("approvalJobtitle", input.get("_userJobxName"));  
		rdcsMap.put("approvalDeptname", input.get("_userDeptName"));  
		rdcsMap.put("body", body);
		rdcsMap.put("title", "[자산실사] 자산실사결재요청");
		
		//전자결재 저장
		commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", rdcsMap);
		
    	if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", rdcsMap) == 0) {
    		throw new Exception("결재요청 정보 등록 오류");
    	}
	}
}
