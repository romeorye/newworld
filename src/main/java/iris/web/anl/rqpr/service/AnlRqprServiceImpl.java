package iris.web.anl.rqpr.service;


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
import iris.web.anl.rqpr.vo.AnlMailInfo;
import iris.web.common.converter.RuiConstants;
import iris.web.common.util.FormatHelper;
import iris.web.common.util.StringUtil;

/*********************************************************************************
 * NAME : AnlRqprServiceImpl.java 
 * DESC : 분석의뢰 - 분석의뢰관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("anlRqprService")
public class AnlRqprServiceImpl implements AnlRqprService {
	
	static final Logger LOGGER = LogManager.getLogger(AnlRqprServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;

	@Resource(name = "configService")
    private ConfigService configService;

	/* 분석의뢰 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlRqprList", input);
	}

	/* 분석의뢰 담당자 리스트 조회 */
	public List<Map<String, Object>> getAnlChrgList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlChrgList", input);
	}

	/* 분석의뢰 정보 조회 */
	public Map<String,Object> getAnlRqprInfo(Map<String, Object> input) {
		return commonDao.select("anl.rqpr.getAnlRqprInfo", input);
	}

	/* 분석의뢰 시료정보 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprSmpoList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlRqprSmpoList", input);
	}

	/* 분석의뢰 관련분석 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprRltdList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlRqprRltdList", input);
	}
	
	/* 분석의뢰 등록 */
	public boolean insertAnlRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> anlRqprDataSet = (Map<String, Object>)dataMap.get("anlRqprDataSet");
		List<Map<String, Object>> anlRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("anlRqprSmpoDataSet");
		List<Map<String, Object>> anlRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("anlRqprRltdDataSet");
		List<Map<String, Object>> anlRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		anlRqprDataSet.put("userId", userId);
		anlRqprDataSet.put("userDeptCd", input.get("_userDept"));
		anlRqprDataSet.put("userTeamCd", input.get("_teamDept"));

    	if(commonDao.insert("anl.rqpr.insertAnlRqpr", anlRqprDataSet) == 1) {
    		Object rqprId = anlRqprDataSet.get("rqprId");
    		String[] infmPrsnIdArr = ((String)anlRqprDataSet.get("infmPrsnIds")).split(",");
    		HashMap<String, Object> anlRqprInfmInfo;
    		
    		for(Map<String, Object> data : anlRqprSmpoDataSet) {
    			data.put("rqprId", rqprId);
    			data.put("userId", userId);
    		}
    		
    		for(Map<String, Object> data : anlRqprRltdDataSet) {
    			data.put("rqprId", rqprId);
    			data.put("userId", userId);
    		}
    		
    		for(String infmPrsnId : infmPrsnIdArr) {
    			if(!"".equals(infmPrsnId)) {
        			anlRqprInfmInfo = new HashMap<String, Object>();
        			
        			anlRqprInfmInfo.put("rqprId", rqprId);
        			anlRqprInfmInfo.put("infmPrsnId", infmPrsnId);
        			anlRqprInfmInfo.put("userId", userId);
        			
        			anlRqprInfmList.add(anlRqprInfmInfo);
    			}
    		}
    		
        	if(commonDao.batchInsert("anl.rqpr.insertAnlRqprSmpo", anlRqprSmpoDataSet) == anlRqprSmpoDataSet.size()
        			&& commonDao.batchInsert("anl.rqpr.insertAnlRqprRltd", anlRqprRltdDataSet) == anlRqprRltdDataSet.size()
        			&& commonDao.batchInsert("anl.rqpr.insertAnlRqprInfm", anlRqprInfmList) == anlRqprInfmList.size()) {
        		return true;
        	} else {
        		throw new Exception("분석의뢰 등록 오류");
        	}
    	} else {
    		throw new Exception("분석의뢰 등록 오류");
    	}
	}
	
	/* 분석의뢰 수정 */
	public boolean updateAnlRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> anlRqprDataSet = (Map<String, Object>)dataMap.get("anlRqprDataSet");
		List<Map<String, Object>> anlRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("anlRqprSmpoDataSet");
		List<Map<String, Object>> anlRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("anlRqprRltdDataSet");
		List<Map<String, Object>> anlRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		anlRqprDataSet.put("userId", userId);
		
    	if(commonDao.update("anl.rqpr.updateAnlRqpr", anlRqprDataSet) == 1) {
    		Object rqprId = anlRqprDataSet.get("rqprId");
    		String[] infmPrsnIdArr = ((String)anlRqprDataSet.get("infmPrsnIds")).split(",");
    		HashMap<String, Object> anlRqprInfmInfo;
    		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
    		
    		for(Map<String, Object> data : anlRqprSmpoDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("anl.rqpr.insertAnlRqprSmpo", insertList) != insertList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprSmpo", updateList) != updateList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprSmpoDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 수정 오류");
        	}
        	
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
    		for(Map<String, Object> data : anlRqprRltdDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("anl.rqpr.insertAnlRqprRltd", insertList) != insertList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprRltd", updateList) != updateList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprRltdDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 수정 오류");
        	}
        	
        	insertList.clear();
        	updateList.clear();
        	deleteList.clear();
    		
    		for(String infmPrsnId : infmPrsnIdArr) {
    			if(!"".equals(infmPrsnId)) {
        			anlRqprInfmInfo = new HashMap<String, Object>();
        			
        			anlRqprInfmInfo.put("rqprId", rqprId);
        			anlRqprInfmInfo.put("infmPrsnId", infmPrsnId);
        			anlRqprInfmInfo.put("userId", userId);
        			
        			anlRqprInfmList.add(anlRqprInfmInfo);
    			}
    		}

    		input.put("rqprId", rqprId);
    		input.put("infmPrsnIdArr", infmPrsnIdArr);
    		
    		commonDao.batchInsert("anl.rqpr.insertAnlRqprInfm", anlRqprInfmList);
    		commonDao.update("anl.rqpr.updateAnlRqprInfmDelYn", input);
    		
    		// 결재정보 저장
    		if("requestApproval".equals(input.get("cmd"))) {
    			
    			input.put("attcFilId", anlRqprDataSet.get("rqprAttcFileId"));

        		String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
    			StringBuffer sb = new StringBuffer();
    			Map<String,Object> anlRqprInfo = commonDao.select("anl.rqpr.getAnlRqprInfo", input);
    			List<Map<String,Object>> anlRqprSmpoList = commonDao.selectList("anl.rqpr.getAnlRqprSmpoList", input);
    			List<Map<String,Object>> anlRqprRltdList = commonDao.selectList("anl.rqpr.getAnlRqprRltdList", input);
    			List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", input);
    			
    			anlRqprInfo.put("anlRqprInfmView", StringUtil.isNullGetInput((String)anlRqprInfo.get("anlRqprInfmView"), ""));
    			anlRqprInfo.put("anlSbc", ((String)anlRqprInfo.get("anlSbc")).replaceAll("\n", "<br/>"));
    			
    			for(Map<String, Object> data : anlRqprSmpoList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("smpoNm")).append("</td>")
    				  .append("<td>").append(data.get("mkrNm")).append("</td>")
    				  .append("<td>").append(data.get("mdlNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			anlRqprInfo.put("anlRqprSmpoList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : anlRqprRltdList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("preAcpcNo")).append("</td>")
    				  .append("<td class='txt_layout'>").append(data.get("preAnlNm")).append("</td>")
    				  .append("<td>").append(data.get("preRgstNm")).append("</td>")
    				  .append("<td>").append(data.get("preAnlChrgNm")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			anlRqprInfo.put("anlRqprRltdList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			int seq = 1;
    			
    			for(Map<String, Object> data : rqprAttachFileList) {
    				sb.append("<tr>")
    				  .append("<td>").append(seq++).append("</td>")
    				  .append("<td class='txt_layout'>").append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(data.get("attcFilId")).append("&seq=").append(data.get("seq")).append("'>").append(data.get("filNm")).append("</a></td>")
    				  .append("</tr>");
    			}
    			  
    			anlRqprInfo.put("rqprAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());

    			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/anl/rqpr/vm/anlRqprApproval.vm", "UTF-8", anlRqprInfo);
    			
    			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();
    			
    			itgRdcsInfo.put("guId", "A" + rqprId);
    			itgRdcsInfo.put("approvalUserid", userId);
    			itgRdcsInfo.put("approvalUsername", input.get("_userNm"));
    			itgRdcsInfo.put("approvalJobtitle", input.get("_userJobxName"));
    			itgRdcsInfo.put("approvalDeptname", input.get("_userDeptName"));
    			itgRdcsInfo.put("body", body);
    			itgRdcsInfo.put("title", "[IRIS/분석의뢰] " + anlRqprInfo.get("anlNm"));
    			
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
	public boolean deleteAnlRqpr(Map<String, Object> input) throws Exception {
		
    	if(commonDao.update("anl.rqpr.updateAnlRqprDelYn", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석의뢰 삭제 오류");
    	}
	}

	/* 분석의뢰 의견 리스트 건수 조회 */
	public int getAnlRqprOpinitionListCnt(Map<String, Object> input) {
		return commonDao.select("anl.rqpr.getAnlRqprOpinitionListCnt", input);
	}

	/* 분석의뢰 의견 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprOpinitionList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlRqprOpinitionList", input);
	}
	
	/* 분석의뢰 의견 저장 */
	public boolean saveAnlRqprOpinition(Map<String, Object> input) throws Exception {
    	if(commonDao.insert("anl.rqpr.saveAnlRqprOpinition", input) == 1) {
    		String senderNm = input.get("_userNm") + " " + input.get("_userJobxName");
    		AnlMailInfo anlMailInfo = commonDao.select("anl.rqpr.getAnlRqprOpinitionEmailInfo", input);
    		
    		anlMailInfo.setSenderNm(senderNm);
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress((String)input.get("_userEmail"), senderNm);
    		mailSender.setToMailAddress(anlMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + anlMailInfo.getAnlNm() + "' 분석 건에 새 의견이 게시되었습니다.");
    		mailSender.setHtmlTemplate("anlRqprOpinition", anlMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 의견 저장 오류");
    	}
	}
	
	/* 분석의뢰 의견 저장 */
	public boolean deleteAnlRqprOpinition(Map<String, Object> input) throws Exception {
    	if(commonDao.insert("anl.rqpr.updateAnlRqprOpinitionDelYn", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석의뢰 의견 삭제 오류");
    	}
	}
	
	/* 분석의뢰 저장 */
	public boolean saveAnlRqpr(Map<String,Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> anlRqprDataSet = (Map<String, Object>)dataMap.get("anlRqprDataSet");
		List<Map<String, Object>> anlRqprSmpoDataSet = (List<Map<String, Object>>)dataMap.get("anlRqprSmpoDataSet");
		List<Map<String, Object>> anlRqprRltdDataSet = (List<Map<String, Object>>)dataMap.get("anlRqprRltdDataSet");

		Object userId = input.get("_userId");
		anlRqprDataSet.put("userId", userId);
		
		
		if(commonDao.update("anl.rqpr.updateAnlRqpr", anlRqprDataSet) == 1) {
			Object rqprId = anlRqprDataSet.get("rqprId");
    		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
    		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
    		
    		for(Map<String, Object> data : anlRqprSmpoDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
    		if(commonDao.batchInsert("anl.rqpr.insertAnlRqprSmpo", insertList) != insertList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprSmpo", updateList) != updateList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprSmpoDelYn", deleteList) != deleteList.size()) {
        		throw new Exception("분석의뢰 저장 오류");
        	}
    		
    		insertList.clear();
        	updateList.clear();
        	deleteList.clear();
		
		
        	for(Map<String, Object> data : anlRqprRltdDataSet) {
    			data.put("userId", userId);
    			
    			if(RuiConstants.ROW_STATE_INSERT.equals(data.get("duistate"))) {
    				insertList.add(data);
    			} else if(RuiConstants.ROW_STATE_UPDATE.equals(data.get("duistate"))) {
    				updateList.add(data);
    			} else if(RuiConstants.ROW_STATE_DELETE.equals(data.get("duistate"))) {
    				deleteList.add(data);
    			}
    		}
    		
        	if(commonDao.batchInsert("anl.rqpr.insertAnlRqprRltd", insertList) != insertList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprRltd", updateList) != updateList.size()
        			|| commonDao.batchUpdate("anl.rqpr.updateAnlRqprRltdDelYn", deleteList) != deleteList.size()) {
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
	public boolean updateReceiptAnlRqpr(Map<String,Object> dataMap) throws Exception {
    	if(commonDao.update("anl.rqpr.updateAnlRqpr", dataMap) == 1) {
    		AnlMailInfo anlMailInfo = commonDao.select("anl.rqpr.getAnlRqprReceiptEmailInfo", dataMap);
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(anlMailInfo.getChrgEmail(), anlMailInfo.getChrgNm());
    		mailSender.setToMailAddress(anlMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + anlMailInfo.getAnlNm() + "' 분석의뢰 접수 통보");
    		mailSender.setHtmlTemplate("anlRqprReceipt", anlMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 접수 오류");
    	}
	}
	
	/* 분석의뢰 반려/분석중단 처리 */
	public boolean updateAnlRqprEnd(Map<String,Object> dataMap) throws Exception {
    	if(commonDao.update("anl.rqpr.updateAnlRqprAcpcStCd", dataMap) == 1) {
    		StringBuffer subject = new StringBuffer();
    		String templateNm;
    		AnlMailInfo anlMailInfo;
    		
    		if("04".equals(dataMap.get("acpcStCd"))) {	// 반려
        		anlMailInfo = commonDao.select("anl.rqpr.getAnlRqprRejectEmailInfo", dataMap);
        		
        		anlMailInfo.setAnlGvbRson(anlMailInfo.getAnlGvbRson().replaceAll("\n", "<br/>"));
        		
        		subject.append("'").append(anlMailInfo.getAnlNm()).append("' 분석의뢰 반려 통보");
        		templateNm = "anlRqprReject";
    		} else {									// 중단
        		anlMailInfo = commonDao.select("anl.rqpr.getAnlRqprStopEmailInfo", dataMap);
        		
        		anlMailInfo.setAnlDcacRson(anlMailInfo.getAnlDcacRson().replaceAll("\n", "<br/>"));
        		
        		subject.append("'").append(anlMailInfo.getAnlNm()).append("' 분석중단 통보");
        		templateNm = "anlRqprStop";
    		}
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(anlMailInfo.getChrgEmail(), anlMailInfo.getChrgNm());
    		mailSender.setToMailAddress(anlMailInfo.getReceivers().split(","));
    		mailSender.setSubject(subject.toString());
    		mailSender.setHtmlTemplate(templateNm, anlMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 반려/분석중단 처리 오류");
    	}
	}

	/* 실험정보 트리 리스트 조회 */
	public List<Map<String, Object>> getAnlExprTreeList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlExprTreeList", input);
	}

	/* 실험정보 상세 콤보 리스트 조회 */
	public List<Map<String, Object>> getAnlExprDtlComboList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlExprDtlComboList", input);
	}

	/* 분석결과 실험정보 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprExprList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlRqprExprList", input);
	}

	/* 분석결과 실험정보 조회 */
	public Map<String, Object> getAnlRqprExprInfo(Map<String, Object> input) {
		return commonDao.select("anl.rqpr.getAnlRqprExprInfo", input);
	}
	
	/* 분석결과 실험정보 저장 */
	public boolean saveAnlRqprExpr(Map<String, Object> dataMap) throws Exception {
    	if(commonDao.insert("anl.rqpr.saveAnlRqprExpr", dataMap) == 1) {
        	return true;
    	} else {
    		throw new Exception("분석결과 실험정보 저장 오류");
    	}
	}
	
	/* 분석결과 실험정보 삭제 */
	public boolean deleteAnlRqprExpr(List<Map<String, Object>> list) throws Exception {
    	if(commonDao.batchUpdate("anl.rqpr.updateAnlRqprExprDelYn", list) == list.size()) {
        	return true;
    	} else {
    		throw new Exception("분석결과 실험정보 삭제 오류");
    	}
	}
	
	/* 분석결과 저장 */
	public boolean saveAnlRqprRslt(Map<String, Object> dataMap) throws Exception {
    	if(commonDao.insert("anl.rqpr.saveAnlRqprRslt", dataMap) == 1) {
    		if("requestRsltApproval".equals(dataMap.get("cmd"))) {

        		String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
    			StringBuffer sb = new StringBuffer();
    			Map<String,Object> anlRqprInfo = commonDao.select("anl.rqpr.getAnlRqprInfo", dataMap);
    			List<Map<String,Object>> anlRqprExprList = commonDao.selectList("anl.rqpr.getAnlRqprExprList", dataMap);
    			List<Map<String,Object>> anlRqprSmpoList = commonDao.selectList("anl.rqpr.getAnlRqprSmpoList", dataMap);
    			List<Map<String,Object>> anlRqprRltdList = commonDao.selectList("anl.rqpr.getAnlRqprRltdList", dataMap);
    			
    			dataMap.put("attcFilId", dataMap.get("rqprAttcFileId"));
    			
    			List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", dataMap);
    			
    			dataMap.put("attcFilId", dataMap.get("rsltAttcFileId"));
    			
    			List<Map<String,Object>> rsltAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", dataMap);

    			anlRqprInfo.put("anlRqprInfmView", StringUtil.isNullGetInput((String)anlRqprInfo.get("anlRqprInfmView"), ""));
    			anlRqprInfo.put("anlSbc", ((String)anlRqprInfo.get("anlSbc")).replaceAll("\n", "<br/>"));
    			anlRqprInfo.put("anlRsltSbc", ((String)anlRqprInfo.get("anlRsltSbc")).replaceAll("\n", "<br/>"));
    			
    			for(Map<String, Object> data : anlRqprExprList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("exprNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("<td>").append(data.get("exprTim")).append("</td>")
    				  .append("<td>").append(FormatHelper.strNum(((Integer)data.get("exprExp")).intValue())).append("원</td>")
    				  .append("</tr>");
    			}
    			
    			anlRqprInfo.put("anlRqprExprList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			Map<String, Object> rsltAttachFileInfo = null;
    					
    			for(int i=0, size=rsltAttachFileList.size() - 1; i<=size; i++) {
    				rsltAttachFileInfo = rsltAttachFileList.get(i);

    				sb.append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(rsltAttachFileInfo.get("attcFilId")).append("&seq=").append(rsltAttachFileInfo.get("seq")).append("'>").append(rsltAttachFileInfo.get("filNm")).append("</a>");
    				
    				if(i < size) {
    					sb.append("<br/>");
    				}
    			}
    			
    			anlRqprInfo.put("rsltAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : anlRqprSmpoList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("smpoNm")).append("</td>")
    				  .append("<td>").append(data.get("mkrNm")).append("</td>")
    				  .append("<td>").append(data.get("mdlNm")).append("</td>")
    				  .append("<td>").append(data.get("smpoQty")).append("</td>")
    				  .append("</tr>");
    			}
    			
    			anlRqprInfo.put("anlRqprSmpoList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			for(Map<String, Object> data : anlRqprRltdList) {
    				sb.append("<tr>")
    				  .append("<td>").append(data.get("preAcpcNo")).append("</td>")
    				  .append("<td class='txt_layout'>").append(data.get("preAnlNm")).append("</td>")
    				  .append("<td>").append(data.get("preRgstNm")).append("</td>")
    				  .append("<td>").append(data.get("preAnlChrgNm")).append("</td>")
    				  .append("</tr>");
    			}
    			  
    			anlRqprInfo.put("anlRqprRltdList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			int seq = 1;
    			
    			for(Map<String, Object> data : rqprAttachFileList) {
    				sb.append("<tr>")
	  				  .append("<td>").append(seq++).append("</td>")
	  				  .append("<td class='txt_layout'>").append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(data.get("attcFilId")).append("&seq=").append(data.get("seq")).append("'>").append(data.get("filNm")).append("</a></td>")
	  				  .append("</tr>");
    			}
    			  
    			anlRqprInfo.put("rqprAttachFileList", sb.toString());
    			
    			sb.delete(0, sb.length());
    			
    			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/anl/rqpr/vm/anlRqprCompleteApproval.vm", "UTF-8", anlRqprInfo);
    			
    			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();
    			
    			itgRdcsInfo.put("guId", "C" + dataMap.get("rqprId"));
    			itgRdcsInfo.put("approvalUserid", dataMap.get("userId"));
    			itgRdcsInfo.put("approvalUsername", dataMap.get("userNm"));
    			itgRdcsInfo.put("approvalJobtitle", dataMap.get("userJobxName"));
    			itgRdcsInfo.put("approvalDeptname", dataMap.get("userDeptName"));
    			itgRdcsInfo.put("body", body);
    			itgRdcsInfo.put("title", "[IRIS/분석결과] " + anlRqprInfo.get("anlNm"));
    			
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
	public boolean saveAnlExprMst(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("anl.rqpr.saveAnlExprMst", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("실험 마스터 정보 저장 오류");
    	}
	}

	/* 실험 상세 정보 리스트 조회 */
	public List<Map<String, Object>> getAnlExprDtlList(Map<String, Object> input) {
		return commonDao.selectList("anl.rqpr.getAnlExprDtlList", input);
	}
	
	/* 실험 상세 정보 등록 */
	public boolean saveAnlExprDtl(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("anl.rqpr.saveAnlExprDtl", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("실험 상세 정보 등록 오류");
    	}
	}
	
	/* 실험 상세 정보 삭제 */
	public boolean deleteAnlExprDtl(List<Map<String,Object>> list) throws Exception {
    	if(commonDao.batchInsert("anl.rqpr.updateAnlExprDtlDelYn", list) == list.size()) {
            return true;
    	}
    	else {
    		throw new Exception("실험 상세 정보 삭제 오류");
    	}
	}
	
	/* 실험방법 내용 조회*/
	public String getExprWay(HashMap<String, String> input){
		return commonDao.select("anl.rqpr.getExprWay", input);
	}
	
	/* 의견 상세 정보 조회*/
	public String retrieveOpiSbc(HashMap<String, String> input){
		return commonDao.select("anl.rqpr.retrieveOpiSbc", input);
	}
	
	/* 통보자 추가 저장*/
	public void insertAnlRqprInfm(Map<String, Object> dataMap){
		Map<String, Object> anlRqprDataSet = (Map<String, Object>)dataMap.get("anlRqprDataSet");
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		
		List<Map<String, Object>> anlRqprInfmList = new ArrayList<Map<String, Object>>();

		Object userId = input.get("_userId");
		
		String[] infmPrsnIdArr = ((String)anlRqprDataSet.get("infmPrsnIds")).split(",");
		HashMap<String, Object> anlRqprInfmInfo;
		
		for(String infmPrsnId : infmPrsnIdArr) {
			if(!"".equals(infmPrsnId)) {
    			anlRqprInfmInfo = new HashMap<String, Object>();
    			
    			anlRqprInfmInfo.put("rqprId", input.get("rqprId"));
    			anlRqprInfmInfo.put("infmPrsnId", infmPrsnId);
    			anlRqprInfmInfo.put("userId", userId);
    			
    			anlRqprInfmList.add(anlRqprInfmInfo);
			}
		}
		
		commonDao.batchInsert("anl.rqpr.insertAnlRqprInfm", anlRqprInfmList);
	}
	
}