package iris.web.rlab.rqpr.service;


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
import iris.web.rlab.rqpr.vo.RlabMailInfo;
import iris.web.common.converter.RuiConstants;
import iris.web.common.util.FormatHelper;
import iris.web.common.util.StringUtil;

/*********************************************************************************
 * NAME : RlabRqprServiceImpl.java 
 * DESC : 분석의뢰 - 분석의뢰관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("rlabRqprService")
public class RlabRqprServiceImpl implements RlabRqprService {
	
	static final Logger LOGGER = LogManager.getLogger(RlabRqprServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;

	@Resource(name = "configService")
    private ConfigService configService;

	/* 분석의뢰 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabRqprList", input);
	}

	/* 분석의뢰 담당자 리스트 조회 */
	public List<Map<String, Object>> getRlabChrgList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabChrgList", input);
	}

	/* 분석의뢰 정보 조회 */
	public Map<String,Object> getRlabRqprInfo(Map<String, Object> input) {
		return commonDao.select("rlab.rqpr.getRlabRqprInfo", input);
	}

	/* 분석의뢰 시료정보 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprSmpoList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabRqprSmpoList", input);
	}

	/* 분석의뢰 관련분석 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprRltdList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabRqprRltdList", input);
	}
	
	/* 분석의뢰 등록 */
	public boolean insertRlabRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> rlabRqprDataSet = (Map<String, Object>)dataMap.get("rlabRqprDataSet");	//의뢰정보
		List<Map<String, Object>> rlabRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("rlabRqprSmpoDataSet");	//시료정보
		List<Map<String, Object>> rlabRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("rlabRqprRltdDataSet");	//관련분석
		List<Map<String, Object>> rlabRqprInfmList = new ArrayList<Map<String, Object>>();	//통보자 리스트

		Object userId = input.get("_userId");
		rlabRqprDataSet.put("userId", userId);
		rlabRqprDataSet.put("userDeptCd", input.get("_userDept"));
		rlabRqprDataSet.put("userTeamCd", input.get("_teamDept"));

    	if(commonDao.insert("rlab.rqpr.insertRlabRqpr", rlabRqprDataSet) == 1) { //의뢰정보 저장
    		Object rqprId = rlabRqprDataSet.get("rqprId");
    		String[] infmPrsnIdArr = ((String)rlabRqprDataSet.get("infmPrsnIds")).split(",");
    		HashMap<String, Object> rlabRqprInfmInfo;
    		
    		for(Map<String, Object> data : rlabRqprSmpoDataSet) {
    			data.put("rqprId", rqprId);
    			data.put("userId", userId);
    		}
    		
    		for(Map<String, Object> data : rlabRqprRltdDataSet) {
    			data.put("rqprId", rqprId);
    			data.put("userId", userId);
    		}
    		
    		for(String infmPrsnId : infmPrsnIdArr) {
    			if(!"".equals(infmPrsnId)) {
        			rlabRqprInfmInfo = new HashMap<String, Object>();
        			
        			rlabRqprInfmInfo.put("rqprId", rqprId);
        			rlabRqprInfmInfo.put("infmPrsnId", infmPrsnId);
        			rlabRqprInfmInfo.put("userId", userId);
        			
        			rlabRqprInfmList.add(rlabRqprInfmInfo);
    			}
    		}
    		
        	if(commonDao.batchInsert("rlab.rqpr.insertRlabRqprSmpo", rlabRqprSmpoDataSet) == rlabRqprSmpoDataSet.size()
        			&& commonDao.batchInsert("rlab.rqpr.insertRlabRqprRltd", rlabRqprRltdDataSet) == rlabRqprRltdDataSet.size()
        			&& commonDao.batchInsert("rlab.rqpr.insertRlabRqprInfm", rlabRqprInfmList) == rlabRqprInfmList.size()) {
        		//시료정보 && 관련분석 &&
        		return true;
        	} else {
        		throw new Exception("분석의뢰 등록 오류");
        	}
    	} else {
    		throw new Exception("분석의뢰 등록 오류");
    	}
	}
	
	/* 분석의뢰 수정 */
	public boolean updateRlabRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> rlabRqprDataSet = (Map<String, Object>)dataMap.get("rlabRqprDataSet");
		List<Map<String, Object>> rlabRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("rlabRqprSmpoDataSet");
		List<Map<String, Object>> rlabRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("rlabRqprRltdDataSet");
		List<Map<String, Object>> rlabRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		rlabRqprDataSet.put("userId", userId);
		
    	if(commonDao.update("rlab.rqpr.updateRlabRqpr", rlabRqprDataSet) == 1) {
    		Object rqprId = rlabRqprDataSet.get("rqprId");
    		String[] infmPrsnIdArr = ((String)rlabRqprDataSet.get("infmPrsnIds")).split(",");
    		HashMap<String, Object> rlabRqprInfmInfo;
    		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
    		
    		for(Map<String, Object> data : rlabRqprSmpoDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("rlab.rqpr.insertRlabRqprSmpo", insertList) != insertList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprSmpo", updateList) != updateList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprSmpoDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 수정 오류");
        	}
        	
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
    		for(Map<String, Object> data : rlabRqprRltdDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("rlab.rqpr.insertRlabRqprRltd", insertList) != insertList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprRltd", updateList) != updateList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprRltdDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 수정 오류");
        	}
        	
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
    		for(String infmPrsnId : infmPrsnIdArr) {
    			if(!"".equals(infmPrsnId)) {
        			rlabRqprInfmInfo = new HashMap<String, Object>();
        			
        			rlabRqprInfmInfo.put("rqprId", rqprId);
        			rlabRqprInfmInfo.put("infmPrsnId", infmPrsnId);
        			rlabRqprInfmInfo.put("userId", userId);
        			
        			rlabRqprInfmList.add(rlabRqprInfmInfo);
    			}
    		}

    		input.put("rqprId", rqprId);
    		input.put("infmPrsnIdArr", infmPrsnIdArr);
    		
    		commonDao.batchInsert("rlab.rqpr.insertRlabRqprInfm", rlabRqprInfmList);
    		commonDao.update("rlab.rqpr.updateRlabRqprInfmDelYn", input);
    		
    		// 결재정보 저장
    		if("requestApproval".equals(input.get("cmd"))) {
    			
    			input.put("attcFilId", rlabRqprDataSet.get("rqprAttcFileId"));

        		String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
    			StringBuffer sb = new StringBuffer();
    			Map<String,Object> rlabRqprInfo = commonDao.select("rlab.rqpr.getRlabRqprInfo", input);
    			List<Map<String,Object>> rlabRqprSmpoList = commonDao.selectList("rlab.rqpr.getRlabRqprSmpoList", input);
    			List<Map<String,Object>> rlabRqprRltdList = commonDao.selectList("rlab.rqpr.getRlabRqprRltdList", input);
    			List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", input);
    			
    			rlabRqprInfo.put("rlabRqprInfmView", StringUtil.isNullGetInput((String)rlabRqprInfo.get("rlabRqprInfmView"), ""));
    			rlabRqprInfo.put("rlabSbc", ((String)rlabRqprInfo.get("rlabSbc")).replaceAll("\n", "<br/>"));
    			
    			for(Map<String, Object> data : rlabRqprSmpoList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("smpoNm")).append("</td>")
    				  .append("<td>").append(data.get("mkrNm")).append("</td>")
    				  .append("<td>").append(data.get("mdlNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			rlabRqprInfo.put("rlabRqprSmpoList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : rlabRqprRltdList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("preAcpcNo")).append("</td>")
    				  .append("<td class='txt_layout'>").append(data.get("preRlabNm")).append("</td>")
    				  .append("<td>").append(data.get("preRgstNm")).append("</td>")
    				  .append("<td>").append(data.get("preRlabChrgNm")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			rlabRqprInfo.put("rlabRqprRltdList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			int seq = 1;
    			
    			for(Map<String, Object> data : rqprAttachFileList) {
    				sb.append("<tr>")
    				  .append("<td>").append(seq++).append("</td>")
    				  .append("<td class='txt_layout'>").append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(data.get("attcFilId")).append("&seq=").append(data.get("seq")).append("'>").append(data.get("filNm")).append("</a></td>")
    				  .append("</tr>");
    			}
    			  
    			rlabRqprInfo.put("rqprAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/rlab/rqpr/vm/rlabRqprApproval.vm", "UTF-8", rlabRqprInfo);
    			
    			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();
    			
    			itgRdcsInfo.put("guId", "A" + rqprId);
    			itgRdcsInfo.put("approvalUserid", userId);
    			itgRdcsInfo.put("approvalUsername", input.get("_userNm"));
    			itgRdcsInfo.put("approvalJobtitle", input.get("_userJobxName"));
    			itgRdcsInfo.put("approvalDeptname", input.get("_userDeptName"));
    			itgRdcsInfo.put("body", body);
    			itgRdcsInfo.put("title", "[IRIS/분석의뢰] " + rlabRqprInfo.get("rlabNm"));
    			
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
	public boolean deleteRlabRqpr(Map<String, Object> input) throws Exception {
		
    	if(commonDao.update("rlab.rqpr.updateRlabRqprDelYn", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석의뢰 삭제 오류");
    	}
	}

	/* 분석의뢰 의견 리스트 건수 조회 */
	public int getRlabRqprOpinitionListCnt(Map<String, Object> input) {
		return commonDao.select("rlab.rqpr.getRlabRqprOpinitionListCnt", input);
	}

	/* 분석의뢰 의견 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprOpinitionList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabRqprOpinitionList", input);
	}
	
	/* 분석의뢰 의견 저장 */
	public boolean saveRlabRqprOpinition(Map<String, Object> input) throws Exception {
    	if(commonDao.insert("rlab.rqpr.saveRlabRqprOpinition", input) == 1) {
    		String senderNm = input.get("_userNm") + " " + input.get("_userJobxName");
    		RlabMailInfo rlabMailInfo = commonDao.select("rlab.rqpr.getRlabRqprOpinitionEmailInfo", input);
    		
    		rlabMailInfo.setSenderNm(senderNm);
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress((String)input.get("_userEmail"), senderNm);
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + rlabMailInfo.getAnlNm() + "' 분석 건에 새 의견이 게시되었습니다.");
    		mailSender.setHtmlTemplate("rlabRqprOpinition", rlabMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 의견 저장 오류");
    	}
	}
	
	/* 분석의뢰 의견 저장 */
	public boolean deleteRlabRqprOpinition(Map<String, Object> input) throws Exception {
    	if(commonDao.insert("rlab.rqpr.updateRlabRqprOpinitionDelYn", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석의뢰 의견 삭제 오류");
    	}
	}
	
	/* 분석의뢰 저장 */
	public boolean saveRlabRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> rlabRqprDataSet = (Map<String, Object>)dataMap.get("rlabRqprDataSet");
		List<Map<String, Object>> rlabRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("rlabRqprSmpoDataSet");
		List<Map<String, Object>> rlabRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("rlabRqprRltdDataSet");

		Object userId = input.get("_userId");
		rlabRqprDataSet.put("userId", userId);
		
		
		if(commonDao.update("rlab.rqpr.updateRlabRqpr", rlabRqprDataSet) == 1) {
			Object rqprId = rlabRqprDataSet.get("rqprId");
    		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
    		
    		for(Map<String, Object> data : rlabRqprSmpoDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
    		if(commonDao.batchInsert("rlab.rqpr.insertRlabRqprSmpo", insertList) != insertList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprSmpo", updateList) != updateList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprSmpoDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 저장 오류");
        	}
    		
    		insertList.clear();
        	updateList.clear();
        	deleteList.clear();
		
		
        	for(Map<String, Object> data : rlabRqprRltdDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("rlab.rqpr.insertRlabRqprRltd", insertList) != insertList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprRltd", updateList) != updateList.size()
        			|| commonDao.batchUpdate("rlab.rqpr.updateRlabRqprRltdDelYn", deleteList) != deleteList.size()) {
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
	public boolean updateReceiptRlabRqpr(Map<String,Object> dataMap) throws Exception {
    	if(commonDao.update("rlab.rqpr.updateRlabRqpr", dataMap) == 1) {
    		RlabMailInfo rlabMailInfo = commonDao.select("rlab.rqpr.getRlabRqprReceiptEmailInfo", dataMap);
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(rlabMailInfo.getChrgEmail(), rlabMailInfo.getChrgNm());
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + rlabMailInfo.getRlabNm() + "' 시험의뢰 접수 통보");
    		mailSender.setHtmlTemplate("anlRqprReceipt", rlabMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 접수 오류");
    	}
	}
	
	/* 분석의뢰 반려/분석중단 처리 */
	public boolean updateRlabRqprEnd(Map<String,Object> dataMap) throws Exception {
    	if(commonDao.update("rlab.rqpr.updateRlabRqprAcpcStCd", dataMap) == 1) {
    		StringBuffer subject = new StringBuffer();
    		String templateNm;
    		RlabMailInfo rlabMailInfo;
    		
    		if("04".equals(dataMap.get("acpcStCd"))) {	// 반려
        		rlabMailInfo = commonDao.select("rlab.rqpr.getRlabRqprRejectEmailInfo", dataMap);
        		
        		rlabMailInfo.setAnlGvbRson(rlabMailInfo.getAnlGvbRson().replaceAll("\n", "<br/>"));
        		
        		subject.append("'").append(rlabMailInfo.getAnlNm()).append("' 분석의뢰 반려 통보");
        		templateNm = "rlabRqprReject";
    		} else {									// 중단
        		rlabMailInfo = commonDao.select("rlab.rqpr.getRlabRqprStopEmailInfo", dataMap);
        		
        		rlabMailInfo.setAnlDcacRson(rlabMailInfo.getAnlDcacRson().replaceAll("\n", "<br/>"));
        		
        		subject.append("'").append(rlabMailInfo.getAnlNm()).append("' 분석중단 통보");
        		templateNm = "rlabRqprStop";
    		}
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(rlabMailInfo.getChrgEmail(), rlabMailInfo.getChrgNm());
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject(subject.toString());
    		mailSender.setHtmlTemplate(templateNm, rlabMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 반려/분석중단 처리 오류");
    	}
	}

	/* 신뢰성 시험정보 트리 리스트 조회 */
	public List<Map<String, Object>> getRlabExatTreeList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabExatTreeList", input);
	}

	/* 실험정보 상세 콤보 리스트 조회 */
	public List<Map<String, Object>> getRlabExprDtlComboList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabExprDtlComboList", input);
	}

	/* 분석결과 실험정보 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprExprList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabRqprExprList", input);
	}

	/* 분석결과 실험정보 조회 */
	public Map<String, Object> getRlabRqprExprInfo(Map<String, Object> input) {
		return commonDao.select("rlab.rqpr.getRlabRqprExprInfo", input);
	}
	
	/* 분석결과 실험정보 저장 */
	public boolean saveRlabRqprExpr(Map<String, Object> dataMap) throws Exception {
    	if(commonDao.insert("rlab.rqpr.saveRlabRqprExpr", dataMap) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석결과 실험정보 저장 오류");
    	}
	}
	
	/* 분석결과 실험정보 삭제 */
	public boolean deleteRlabRqprExpr(List<Map<String, Object>> list) throws Exception {
    	if(commonDao.batchUpdate("rlab.rqpr.updateRlabRqprExprDelYn", list) == list.size()) {
        	return true;
    	} else {
    		throw new Exception("분석결과 실험정보 삭제 오류");
    	}
	}
	
	/* 분석결과 저장 */
	public boolean saveRlabRqprRslt(Map<String, Object> dataMap) throws Exception {
    	if(commonDao.insert("rlab.rqpr.saveRlabRqprRslt", dataMap) == 1) {
    		if("requestRsltApproval".equals(dataMap.get("cmd"))) {

        		String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
    			StringBuffer sb = new StringBuffer();
    			Map<String,Object> rlabRqprInfo = commonDao.select("rlab.rqpr.getRlabRqprInfo", dataMap);
    			List<Map<String,Object>> rlabRqprExprList = commonDao.selectList("rlab.rqpr.getRlabRqprExprList", dataMap);
    			List<Map<String,Object>> rlabRqprSmpoList = commonDao.selectList("rlab.rqpr.getRlabRqprSmpoList", dataMap);
    			List<Map<String,Object>> rlabRqprRltdList = commonDao.selectList("rlab.rqpr.getRlabRqprRltdList", dataMap);
    			
    			dataMap.put("attcFilId", dataMap.get("rqprAttcFileId"));
    			
    			List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", dataMap);
    			
    			dataMap.put("attcFilId", dataMap.get("rsltAttcFileId"));
    			
    			List<Map<String,Object>> rsltAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", dataMap);

    			rlabRqprInfo.put("rlabRqprInfmView", StringUtil.isNullGetInput((String)rlabRqprInfo.get("rlabRqprInfmView"), ""));
    			rlabRqprInfo.put("rlabSbc", ((String)rlabRqprInfo.get("rlabSbc")).replaceAll("\n", "<br/>"));
    			rlabRqprInfo.put("rlabRsltSbc", ((String)rlabRqprInfo.get("rlabRsltSbc")).replaceAll("\n", "<br/>"));
    			
    			for(Map<String, Object> data : rlabRqprExprList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("exprNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("<td>").append(data.get("exprTim")).append("</td>")
    				  .append("<td>").append(FormatHelper.strNum(((Integer)data.get("exprExp")).intValue())).append("원</td>")
    				  .append("</tr>");
    			}
    			
    			rlabRqprInfo.put("rlabRqprExprList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			Map<String, Object> rsltAttachFileInfo = null;
    					
    			for(int i=0, size=rsltAttachFileList.size() - 1; i<=size; i++) {
    				rsltAttachFileInfo = rsltAttachFileList.get(i);

    				sb.append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(rsltAttachFileInfo.get("attcFilId")).append("&seq=").append(rsltAttachFileInfo.get("seq")).append("'>").append(rsltAttachFileInfo.get("filNm")).append("</a>");
    				
    				if(i < size) {
    					sb.append("<br/>");
    				}
    			}
    			
    			rlabRqprInfo.put("rsltAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : rlabRqprSmpoList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("smpoNm")).append("</td>")
    				  .append("<td>").append(data.get("mkrNm")).append("</td>")
    				  .append("<td>").append(data.get("mdlNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("</tr>");
    			}
    			
    			rlabRqprInfo.put("rlabRqprSmpoList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : rlabRqprRltdList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("preAcpcNo")).append("</td>")
    				  .append("<td class='txt_layout'>").append(data.get("preRlabNm")).append("</td>")
    				  .append("<td>").append(data.get("preRgstNm")).append("</td>")
    				  .append("<td>").append(data.get("preRlabChrgNm")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			rlabRqprInfo.put("rlabRqprRltdList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			int seq = 1;
    			
    			for(Map<String, Object> data : rqprAttachFileList) {
    				sb.append("<tr>")
	  				  .append("<td>").append(seq++).append("</td>")
	  				  .append("<td class='txt_layout'>").append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(data.get("attcFilId")).append("&seq=").append(data.get("seq")).append("'>").append(data.get("filNm")).append("</a></td>")
	  				  .append("</tr>");
    			}
    			  
    			rlabRqprInfo.put("rqprAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/rlab/rqpr/vm/rlabRqprCompleteApproval.vm", "UTF-8", rlabRqprInfo);
    			
    			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();
    			
    			itgRdcsInfo.put("guId", "C" + dataMap.get("rqprId"));
    			itgRdcsInfo.put("approvalUserid", dataMap.get("userId"));
    			itgRdcsInfo.put("approvalUsername", dataMap.get("userNm"));
    			itgRdcsInfo.put("approvalJobtitle", dataMap.get("userJobxName"));
    			itgRdcsInfo.put("approvalDeptname", dataMap.get("userDeptName"));
    			itgRdcsInfo.put("body", body);
    			itgRdcsInfo.put("title", "[IRIS/분석결과] " + rlabRqprInfo.get("rlabNm"));
    			
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
	
	/* 신뢰성 시험 마스터 정보 저장 */
	public boolean saveRlabExatMst(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("rlab.rqpr.saveRlabExatMst", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("실험 마스터 정보 저장 오류");
    	}
	}

	/* 실험 상세 정보 리스트 조회 */
	public List<Map<String, Object>> getRlabExatDtlList(Map<String, Object> input) {
		return commonDao.selectList("rlab.rqpr.getRlabExatDtlList", input);
	}
	
	/* 신뢰성시험 상세 정보 등록 */
	public boolean saveRlabExatDtl(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("rlab.rqpr.saveRlabExatDtl", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("신뢰성시험 상세 정보 등록 오류");
    	}
	}
	
	/* 신뢰성시험 상세 정보 삭제 */
	public boolean deleteRlabExatDtl(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("rlab.rqpr.updateRlabExatDtlDelYn", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("신뢰성시험 상세 정보 삭제 오류");
    	}
	}
	
	/* 실험방법 내용 조회*/
	public String getExprWay(HashMap<String, String> input){
		return commonDao.select("rlab.rqpr.getExprWay", input);
	}
	
	/* 의견 상세 정보 조회*/
	public String retrieveOpiSbc(HashMap<String, String> input){
		return commonDao.select("rlab.rqpr.retrieveOpiSbc", input);
	}
	
	/* 통보자 추가 저장*/
	public void insertRlabRqprInfm(Map<String, Object> dataMap){
		Map<String, Object> rlabRqprDataSet = (Map<String, Object>)dataMap.get("rlabRqprDataSet");
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		
		List<Map<String, Object>> rlabRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		
		String[] infmPrsnIdArr = ((String)rlabRqprDataSet.get("infmPrsnIds")).split(",");
		HashMap<String, Object> rlabRqprInfmInfo;
		
		for(String infmPrsnId : infmPrsnIdArr) {
			if(!"".equals(infmPrsnId)) {
    			rlabRqprInfmInfo = new HashMap<String, Object>();
    			
    			rlabRqprInfmInfo.put("rqprId", input.get("rqprId"));
    			rlabRqprInfmInfo.put("infmPrsnId", infmPrsnId);
    			rlabRqprInfmInfo.put("userId", userId);
    			
    			rlabRqprInfmList.add(rlabRqprInfmInfo);
			}
		}
		
		commonDao.batchInsert("rlab.rqpr.insertRlabRqprInfm", rlabRqprInfmList);
	}

	@Override
	public List<Map<String, Object>> retrieveMachineList(
			HashMap<String, Object> input) {
		List<Map<String, Object>> resultList = commonDao.selectList("rlab.rqpr.retrieveMachineList", input);
		return resultList;
	}


	
}