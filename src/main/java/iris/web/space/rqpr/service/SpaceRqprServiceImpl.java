package iris.web.space.rqpr.service;


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

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.space.rqpr.vo.SpaceMailInfo;
import iris.web.common.converter.RuiConstants;
import iris.web.common.util.FormatHelper;
import iris.web.common.util.StringUtil;

/*********************************************************************************
 * NAME : SpaceRqprServiceImpl.java 
 * DESC : 분석의뢰 - 분석의뢰관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("spaceRqprService")
public class SpaceRqprServiceImpl implements SpaceRqprService {
	
	static final Logger LOGGER = LogManager.getLogger(SpaceRqprServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;

	@Resource(name = "configService")
    private ConfigService configService;

	/* 분석의뢰 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceRqprList", input);
	}

	/* 분석의뢰 담당자 리스트 조회 */
	public List<Map<String, Object>> getSpaceChrgList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceChrgList", input);
	}

	/* 분석의뢰 정보 조회 */
	public Map<String,Object> getSpaceRqprInfo(Map<String, Object> input) {
		return commonDao.select("space.rqpr.getSpaceRqprInfo", input);
	}

	/* 분석의뢰 시료정보 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprSmpoList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceRqprSmpoList", input);
	}

	/* 분석의뢰 관련분석 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprRltdList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceRqprRltdList", input);
	}
	
	/* 분석의뢰 등록 */
	public boolean insertSpaceRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> spaceRqprDataSet = (Map<String, Object>)dataMap.get("spaceRqprDataSet");
		List<Map<String, Object>> spaceRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("spaceRqprSmpoDataSet");
		List<Map<String, Object>> spaceRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("spaceRqprRltdDataSet");
		List<Map<String, Object>> spaceRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		spaceRqprDataSet.put("userId", userId);
		spaceRqprDataSet.put("userDeptCd", input.get("_userDept"));
		spaceRqprDataSet.put("userTeamCd", input.get("_teamDept"));

    	if(commonDao.insert("space.rqpr.insertSpaceRqpr", spaceRqprDataSet) == 1) {
    		Object rqprId = spaceRqprDataSet.get("rqprId");
    		String[] infmPrsnIdArr = ((String)spaceRqprDataSet.get("infmPrsnIds")).split(",");
    		HashMap<String, Object> spaceRqprInfmInfo;
    		
    		for(Map<String, Object> data : spaceRqprSmpoDataSet) {
    			data.put("rqprId", rqprId);
    			data.put("userId", userId);
    		}
    		
    		for(Map<String, Object> data : spaceRqprRltdDataSet) {
    			data.put("rqprId", rqprId);
    			data.put("userId", userId);
    		}
    		
    		for(String infmPrsnId : infmPrsnIdArr) {
    			if(!"".equals(infmPrsnId)) {
        			spaceRqprInfmInfo = new HashMap<String, Object>();
        			
        			spaceRqprInfmInfo.put("rqprId", rqprId);
        			spaceRqprInfmInfo.put("infmPrsnId", infmPrsnId);
        			spaceRqprInfmInfo.put("userId", userId);
        			
        			spaceRqprInfmList.add(spaceRqprInfmInfo);
    			}
    		}
    		
        	if(commonDao.batchInsert("space.rqpr.insertSpaceRqprSmpo", spaceRqprSmpoDataSet) == spaceRqprSmpoDataSet.size()
        			&& commonDao.batchInsert("space.rqpr.insertSpaceRqprRltd", spaceRqprRltdDataSet) == spaceRqprRltdDataSet.size()
        			&& commonDao.batchInsert("space.rqpr.insertSpaceRqprInfm", spaceRqprInfmList) == spaceRqprInfmList.size()) {
        		return true;
        	} else {
        		throw new Exception("분석의뢰 등록 오류");
        	}
    	} else {
    		throw new Exception("분석의뢰 등록 오류");
    	}
	}
	
	/* 분석의뢰 수정 */
	public boolean updateSpaceRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> spaceRqprDataSet = (Map<String, Object>)dataMap.get("spaceRqprDataSet");
		List<Map<String, Object>> spaceRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("spaceRqprSmpoDataSet");
		List<Map<String, Object>> spaceRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("spaceRqprRltdDataSet");
		List<Map<String, Object>> spaceRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		spaceRqprDataSet.put("userId", userId);
		
    	if(commonDao.update("space.rqpr.updateSpaceRqpr", spaceRqprDataSet) == 1) {
    		Object rqprId = spaceRqprDataSet.get("rqprId");
    		String[] infmPrsnIdArr = ((String)spaceRqprDataSet.get("infmPrsnIds")).split(",");
    		HashMap<String, Object> spaceRqprInfmInfo;
    		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
    		
    		for(Map<String, Object> data : spaceRqprSmpoDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("space.rqpr.insertSpaceRqprSmpo", insertList) != insertList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprSmpo", updateList) != updateList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprSmpoDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 수정 오류");
        	}
        	
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
    		for(Map<String, Object> data : spaceRqprRltdDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("space.rqpr.insertSpaceRqprRltd", insertList) != insertList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprRltd", updateList) != updateList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprRltdDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 수정 오류");
        	}
        	
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
    		for(String infmPrsnId : infmPrsnIdArr) {
    			if(!"".equals(infmPrsnId)) {
        			spaceRqprInfmInfo = new HashMap<String, Object>();
        			
        			spaceRqprInfmInfo.put("rqprId", rqprId);
        			spaceRqprInfmInfo.put("infmPrsnId", infmPrsnId);
        			spaceRqprInfmInfo.put("userId", userId);
        			
        			spaceRqprInfmList.add(spaceRqprInfmInfo);
    			}
    		}

    		input.put("rqprId", rqprId);
    		input.put("infmPrsnIdArr", infmPrsnIdArr);
    		
    		commonDao.batchInsert("space.rqpr.insertSpaceRqprInfm", spaceRqprInfmList);
    		commonDao.update("space.rqpr.updateSpaceRqprInfmDelYn", input);
    		
    		// 결재정보 저장
    		if("requestApproval".equals(input.get("cmd"))) {
    			
    			input.put("attcFilId", spaceRqprDataSet.get("rqprAttcFileId"));

        		String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
    			StringBuffer sb = new StringBuffer();
    			Map<String,Object> spaceRqprInfo = commonDao.select("space.rqpr.getSpaceRqprInfo", input);
    			List<Map<String,Object>> spaceRqprSmpoList = commonDao.selectList("space.rqpr.getSpaceRqprSmpoList", input);
    			List<Map<String,Object>> spaceRqprRltdList = commonDao.selectList("space.rqpr.getSpaceRqprRltdList", input);
    			List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", input);
    			
    			spaceRqprInfo.put("spaceRqprInfmView", StringUtil.isNullGetInput((String)spaceRqprInfo.get("spaceRqprInfmView"), ""));
    			spaceRqprInfo.put("spaceSbc", ((String)spaceRqprInfo.get("spaceSbc")).replaceAll("\n", "<br/>"));
    			
    			for(Map<String, Object> data : spaceRqprSmpoList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("smpoNm")).append("</td>")
    				  .append("<td>").append(data.get("mkrNm")).append("</td>")
    				  .append("<td>").append(data.get("mdlNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			spaceRqprInfo.put("spaceRqprSmpoList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : spaceRqprRltdList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("preAcpcNo")).append("</td>")
    				  .append("<td class='txt_layout'>").append(data.get("preSpaceNm")).append("</td>")
    				  .append("<td>").append(data.get("preRgstNm")).append("</td>")
    				  .append("<td>").append(data.get("preSpaceChrgNm")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			spaceRqprInfo.put("spaceRqprRltdList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			int seq = 1;
    			
    			for(Map<String, Object> data : rqprAttachFileList) {
    				sb.append("<tr>")
    				  .append("<td>").append(seq++).append("</td>")
    				  .append("<td class='txt_layout'>").append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(data.get("attcFilId")).append("&seq=").append(data.get("seq")).append("'>").append(data.get("filNm")).append("</a></td>")
    				  .append("</tr>");
    			}
    			  
    			spaceRqprInfo.put("rqprAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/space/rqpr/vm/spaceRqprApproval.vm", "UTF-8", spaceRqprInfo);
    			
    			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();
    			
    			itgRdcsInfo.put("guId", "A" + rqprId);
    			itgRdcsInfo.put("approvalUserid", userId);
    			itgRdcsInfo.put("approvalUsername", input.get("_userNm"));
    			itgRdcsInfo.put("approvalJobtitle", input.get("_userJobxName"));
    			itgRdcsInfo.put("approvalDeptname", input.get("_userDeptName"));
    			itgRdcsInfo.put("body", body);
    			itgRdcsInfo.put("title", "[IRIS/분석의뢰] " + spaceRqprInfo.get("spaceNm"));
    			
    			commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", itgRdcsInfo);
    			
            	if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", itgRdcsInfo) == 0) {
            		throw new Exception("결재요청 정보 등록 오류");
            	}
    		}
    		
        	return true;
        	
    	} else {
    		throw new Exception("분석의뢰 수정 오류");
    	}
	}
	
	/* 분석의뢰 삭제 */
	public boolean deleteSpaceRqpr(Map<String, Object> input) throws Exception {
		
    	if(commonDao.update("space.rqpr.updateSpaceRqprDelYn", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석의뢰 삭제 오류");
    	}
	}

	/* 분석의뢰 의견 리스트 건수 조회 */
	public int getSpaceRqprOpinitionListCnt(Map<String, Object> input) {
		return commonDao.select("space.rqpr.getSpaceRqprOpinitionListCnt", input);
	}

	/* 분석의뢰 의견 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprOpinitionList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceRqprOpinitionList", input);
	}
	
	/* 분석의뢰 의견 저장 */
	public boolean saveSpaceRqprOpinition(Map<String, Object> input) throws Exception {
    	if(commonDao.insert("space.rqpr.saveSpaceRqprOpinition", input) == 1) {
    		String senderNm = input.get("_userNm") + " " + input.get("_userJobxName");
    		SpaceMailInfo spaceMailInfo = commonDao.select("space.rqpr.getSpaceRqprOpinitionEmailInfo", input);
    		
    		spaceMailInfo.setSenderNm(senderNm);
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress((String)input.get("_userEmail"), senderNm);
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + spaceMailInfo.getAnlNm() + "' 분석 건에 새 의견이 게시되었습니다.");
    		mailSender.setHtmlTemplate("spaceRqprOpinition", spaceMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 의견 저장 오류");
    	}
	}
	
	/* 분석의뢰 의견 저장 */
	public boolean deleteSpaceRqprOpinition(Map<String, Object> input) throws Exception {
    	if(commonDao.insert("space.rqpr.updateSpaceRqprOpinitionDelYn", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석의뢰 의견 삭제 오류");
    	}
	}
	
	/* 분석의뢰 저장 */
	public boolean saveSpaceRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> spaceRqprDataSet = (Map<String, Object>)dataMap.get("spaceRqprDataSet");
		List<Map<String, Object>> spaceRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("spaceRqprSmpoDataSet");
		List<Map<String, Object>> spaceRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("spaceRqprRltdDataSet");

		Object userId = input.get("_userId");
		spaceRqprDataSet.put("userId", userId);
		
		
		if(commonDao.update("space.rqpr.updateSpaceRqpr", spaceRqprDataSet) == 1) {
			Object rqprId = spaceRqprDataSet.get("rqprId");
    		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
    		
    		for(Map<String, Object> data : spaceRqprSmpoDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
    		if(commonDao.batchInsert("space.rqpr.insertSpaceRqprSmpo", insertList) != insertList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprSmpo", updateList) != updateList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprSmpoDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 저장 오류");
        	}
    		
    		insertList.clear();
        	updateList.clear();
        	deleteList.clear();
		
		
        	for(Map<String, Object> data : spaceRqprRltdDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("space.rqpr.insertSpaceRqprRltd", insertList) != insertList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprRltd", updateList) != updateList.size()
        			|| commonDao.batchUpdate("space.rqpr.updateSpaceRqprRltdDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 저장 오류");
        	}
		
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
        	return true;
		}else {
    		throw new Exception("분석의뢰 저장 오류");
    	}
	}
	
	/* 분석의뢰 접수 */
	public boolean updateReceiptSpaceRqpr(Map<String,Object> dataMap) throws Exception {
    	if(commonDao.update("space.rqpr.updateSpaceRqpr", dataMap) == 1) {
    		SpaceMailInfo spaceMailInfo = commonDao.select("space.rqpr.getSpaceRqprReceiptEmailInfo", dataMap);
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(spaceMailInfo.getChrgEmail(), spaceMailInfo.getChrgNm());
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + spaceMailInfo.getAnlNm() + "' 분석의뢰 접수 통보");
    		mailSender.setHtmlTemplate("spaceRqprReceipt", spaceMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 접수 오류");
    	}
	}
	
	/* 분석의뢰 반려/분석중단 처리 */
	public boolean updateSpaceRqprEnd(Map<String,Object> dataMap) throws Exception {
    	if(commonDao.update("space.rqpr.updateSpaceRqprAcpcStCd", dataMap) == 1) {
    		StringBuffer subject = new StringBuffer();
    		String templateNm;
    		SpaceMailInfo spaceMailInfo;
    		
    		if("04".equals(dataMap.get("acpcStCd"))) {	// 반려
        		spaceMailInfo = commonDao.select("space.rqpr.getSpaceRqprRejectEmailInfo", dataMap);
        		
        		spaceMailInfo.setAnlGvbRson(spaceMailInfo.getAnlGvbRson().replaceAll("\n", "<br/>"));
        		
        		subject.append("'").append(spaceMailInfo.getAnlNm()).append("' 분석의뢰 반려 통보");
        		templateNm = "spaceRqprReject";
    		} else {									// 중단
        		spaceMailInfo = commonDao.select("space.rqpr.getSpaceRqprStopEmailInfo", dataMap);
        		
        		spaceMailInfo.setAnlDcacRson(spaceMailInfo.getAnlDcacRson().replaceAll("\n", "<br/>"));
        		
        		subject.append("'").append(spaceMailInfo.getAnlNm()).append("' 분석중단 통보");
        		templateNm = "spaceRqprStop";
    		}
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(spaceMailInfo.getChrgEmail(), spaceMailInfo.getChrgNm());
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject(subject.toString());
    		mailSender.setHtmlTemplate(templateNm, spaceMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 반려/분석중단 처리 오류");
    	}
	}

	/* 실험정보 트리 리스트 조회 */
	public List<Map<String, Object>> getSpaceExatTreeList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceExatTreeList", input);
	}

	/* 실험정보 상세 콤보 리스트 조회 */
	public List<Map<String, Object>> getSpaceExprDtlComboList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceExprDtlComboList", input);
	}

	/* 분석결과 실험정보 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprExprList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceRqprExprList", input);
	}

	/* 분석결과 실험정보 조회 */
	public Map<String, Object> getSpaceRqprExprInfo(Map<String, Object> input) {
		return commonDao.select("space.rqpr.getSpaceRqprExprInfo", input);
	}
	
	/* 분석결과 실험정보 저장 */
	public boolean saveSpaceRqprExpr(Map<String, Object> dataMap) throws Exception {
    	if(commonDao.insert("space.rqpr.saveSpaceRqprExpr", dataMap) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석결과 실험정보 저장 오류");
    	}
	}
	
	/* 분석결과 실험정보 삭제 */
	public boolean deleteSpaceRqprExpr(List<Map<String, Object>> list) throws Exception {
    	if(commonDao.batchUpdate("space.rqpr.updateSpaceRqprExprDelYn", list) == list.size()) {
        	return true;
    	} else {
    		throw new Exception("분석결과 실험정보 삭제 오류");
    	}
	}
	
	/* 분석결과 저장 */
	public boolean saveSpaceRqprRslt(Map<String, Object> dataMap) throws Exception {
    	if(commonDao.insert("space.rqpr.saveSpaceRqprRslt", dataMap) == 1) {
    		if("requestRsltApproval".equals(dataMap.get("cmd"))) {

        		String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
    			StringBuffer sb = new StringBuffer();
    			Map<String,Object> spaceRqprInfo = commonDao.select("space.rqpr.getSpaceRqprInfo", dataMap);
    			List<Map<String,Object>> spaceRqprExprList = commonDao.selectList("space.rqpr.getSpaceRqprExprList", dataMap);
    			List<Map<String,Object>> spaceRqprSmpoList = commonDao.selectList("space.rqpr.getSpaceRqprSmpoList", dataMap);
    			List<Map<String,Object>> spaceRqprRltdList = commonDao.selectList("space.rqpr.getSpaceRqprRltdList", dataMap);
    			
    			dataMap.put("attcFilId", dataMap.get("rqprAttcFileId"));
    			
    			List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", dataMap);
    			
    			dataMap.put("attcFilId", dataMap.get("rsltAttcFileId"));
    			
    			List<Map<String,Object>> rsltAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", dataMap);

    			spaceRqprInfo.put("spaceRqprInfmView", StringUtil.isNullGetInput((String)spaceRqprInfo.get("spaceRqprInfmView"), ""));
    			spaceRqprInfo.put("spaceSbc", ((String)spaceRqprInfo.get("spaceSbc")).replaceAll("\n", "<br/>"));
    			spaceRqprInfo.put("spaceRsltSbc", ((String)spaceRqprInfo.get("spaceRsltSbc")).replaceAll("\n", "<br/>"));
    			
    			for(Map<String, Object> data : spaceRqprExprList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("exprNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("<td>").append(data.get("exprTim")).append("</td>")
    				  .append("<td>").append(FormatHelper.strNum(((Integer)data.get("exprExp")).intValue())).append("원</td>")
    				  .append("</tr>");
    			}
    			
    			spaceRqprInfo.put("spaceRqprExprList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			Map<String, Object> rsltAttachFileInfo = null;
    					
    			for(int i=0, size=rsltAttachFileList.size() - 1; i<=size; i++) {
    				rsltAttachFileInfo = rsltAttachFileList.get(i);

    				sb.append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(rsltAttachFileInfo.get("attcFilId")).append("&seq=").append(rsltAttachFileInfo.get("seq")).append("'>").append(rsltAttachFileInfo.get("filNm")).append("</a>");
    				
    				if(i < size) {
    					sb.append("<br/>");
    				}
    			}
    			
    			spaceRqprInfo.put("rsltAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : spaceRqprSmpoList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("smpoNm")).append("</td>")
    				  .append("<td>").append(data.get("mkrNm")).append("</td>")
    				  .append("<td>").append(data.get("mdlNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("</tr>");
    			}
    			
    			spaceRqprInfo.put("spaceRqprSmpoList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : spaceRqprRltdList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("preAcpcNo")).append("</td>")
    				  .append("<td class='txt_layout'>").append(data.get("preSpaceNm")).append("</td>")
    				  .append("<td>").append(data.get("preRgstNm")).append("</td>")
    				  .append("<td>").append(data.get("preSpaceChrgNm")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			spaceRqprInfo.put("spaceRqprRltdList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			int seq = 1;
    			
    			for(Map<String, Object> data : rqprAttachFileList) {
    				sb.append("<tr>")
	  				  .append("<td>").append(seq++).append("</td>")
	  				  .append("<td class='txt_layout'>").append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(data.get("attcFilId")).append("&seq=").append(data.get("seq")).append("'>").append(data.get("filNm")).append("</a></td>")
	  				  .append("</tr>");
    			}
    			  
    			spaceRqprInfo.put("rqprAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/space/rqpr/vm/spaceRqprCompleteApproval.vm", "UTF-8", spaceRqprInfo);
    			
    			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();
    			
    			itgRdcsInfo.put("guId", "C" + dataMap.get("rqprId"));
    			itgRdcsInfo.put("approvalUserid", dataMap.get("userId"));
    			itgRdcsInfo.put("approvalUsername", dataMap.get("userNm"));
    			itgRdcsInfo.put("approvalJobtitle", dataMap.get("userJobxName"));
    			itgRdcsInfo.put("approvalDeptname", dataMap.get("userDeptName"));
    			itgRdcsInfo.put("body", body);
    			itgRdcsInfo.put("title", "[IRIS/분석결과] " + spaceRqprInfo.get("spaceNm"));
    			
    			commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", itgRdcsInfo);
    			
            	if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", itgRdcsInfo) == 0) {
            		throw new Exception("분석결과 결재의뢰 정보 등록 오류");
            	}
    		}
    		
        	return true;
    	} else {
    		throw new Exception("분석결과 저장 오류");
    	}
	}
	
	/* 실험 마스터 정보 저장 */
	public boolean saveSpaceExatMst(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("space.rqpr.saveSpaceExatMst", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("공간평가시험 마스터 정보 저장 오류");
    	}
	}

	/* 실험 상세 정보 리스트 조회 */
	public List<Map<String, Object>> getSpaceExatDtlList(Map<String, Object> input) {
		return commonDao.selectList("space.rqpr.getSpaceExatDtlList", input);
	}
	
	/* 실험 상세 정보 등록 */
	public boolean saveSpaceExatDtl(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("space.rqpr.saveSpaceExatDtl", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("공간평가 시험 상세 정보 등록 오류");
    	}
	}
	
	/* 실험 상세 정보 삭제 */
	public boolean deleteSpaceExatDtl(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("space.rqpr.updateSpaceExatDtlDelYn", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("실험 상세 정보 삭제 오류");
    	}
	}
	
	/* 실험방법 내용 조회*/
	public String getExprWay(HashMap<String, String> input){
		return commonDao.select("space.rqpr.getExprWay", input);
	}
	
	/* 의견 상세 정보 조회*/
	public String retrieveOpiSbc(HashMap<String, String> input){
		return commonDao.select("space.rqpr.retrieveOpiSbc", input);
	}
	
	/* 통보자 추가 저장*/
	public void insertSpaceRqprInfm(Map<String, Object> dataMap){
		Map<String, Object> spaceRqprDataSet = (Map<String, Object>)dataMap.get("spaceRqprDataSet");
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		
		List<Map<String, Object>> spaceRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		
		String[] infmPrsnIdArr = ((String)spaceRqprDataSet.get("infmPrsnIds")).split(",");
		HashMap<String, Object> spaceRqprInfmInfo;
		
		for(String infmPrsnId : infmPrsnIdArr) {
			if(!"".equals(infmPrsnId)) {
    			spaceRqprInfmInfo = new HashMap<String, Object>();
    			
    			spaceRqprInfmInfo.put("rqprId", input.get("rqprId"));
    			spaceRqprInfmInfo.put("infmPrsnId", infmPrsnId);
    			spaceRqprInfmInfo.put("userId", userId);
    			
    			spaceRqprInfmList.add(spaceRqprInfmInfo);
			}
		}
		
		commonDao.batchInsert("space.rqpr.insertSpaceRqprInfm", spaceRqprInfmList);
	}

	@Override
	public List<Map<String, Object>> retrieveMachineList(
			HashMap<String, Object> input) {
		List<Map<String, Object>> resultList = commonDao.selectList("space.rqpr.retrieveMachineList", input);
		return resultList;
	}
	
}