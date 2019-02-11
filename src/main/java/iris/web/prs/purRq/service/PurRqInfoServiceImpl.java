package iris.web.prs.purRq.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.rlab.rqpr.service.RlabRqprServiceImpl;
import iris.web.sapBatch.service.SapBudgCostService;
import iris.web.system.attach.service.AttachFileService;

@Service("purRqInfoService")
public class PurRqInfoServiceImpl implements PurRqInfoService{
	
	static final Logger LOGGER = LogManager.getLogger(RlabRqprServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;
	
	@Resource(name = "configService")
    private ConfigService configService;
	
	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;
	
	@Resource(name = "sapBudgCostService")
	private SapBudgCostService sapBudgCostService;
	
	static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)
	
	public List<Map<String, Object>> retrievePurRqList(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retrievePurRqList", input );
	}
	
	public int insertPurRqInfo(Map<String, Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> data = input;
		
		int bnfpoPrs = commonDao.select("getBnfpoPrs", data);
			
		data.put("bnfpoPrs", bnfpoPrs);
		data.put("afnam", input.get("_userNm"));
		data.put("bednr", input.get("_userSabun"));
			
		insertList.add(data);
		
		LOGGER.debug("##############################input############################# : " + input);
		LOGGER.debug("##############################data############################# : " + data);
		LOGGER.debug("##############################insertList############################# : " + insertList);
		
		if(commonDao.batchInsert("prs.purRq.insertPurRqInfo", insertList) != insertList.size()) {
			throw new Exception("구매요청 저장 오류");
		}
		
		return bnfpoPrs;
	}

	public boolean deletePurRqInfo(Map<String, Object> input) throws Exception {
    	if(commonDao.update("prs.purRq.deletePurRqInfo", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("구매요청 삭제 오류");
    	}
	}

	public boolean updatePurRqInfo(Map<String, Object> input) throws Exception {
    	if(commonDao.update("prs.purRq.updatePurRqInfo", input) == 1) {
        	return true;
    	} else {
    		throw new Exception("구매요청 수정 오류");
    	}
	}
	
	public List<Map<String, Object>> retrievePurRqInfo(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retrievePurRqInfo", input);
	}
	
	public int getBanfnPrsNumber() {
		return commonDao.select("prs.purRq.getBanfnPrs");
	}
	
	public List<Map<String, Object>> retrieveMyPurRqList(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retrieveMyPurRqList", input );
	}
	
	public int insertPurApprovalInfo(Map<String, Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		
		Map<String, Object> data = input;
		
		insertList.add(data);
		
		LOGGER.debug("##############################input############################# : " + input);
		LOGGER.debug("##############################data############################# : " + data);
		LOGGER.debug("##############################insertList############################# : " + insertList);
		
		if(commonDao.batchInsert("prs.purRq.insertPurApprovalInfo", insertList) != insertList.size()) {
			throw new Exception("결재의뢰 저장 오류");
		} else {
			return input.size();
		}
	}
	
	@Override
	public HashMap<String, Object> sendSapExpensePr(Map<String, Object> dataMap){
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		HashMap<String, Object> resultVal = new HashMap<String, Object>();
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoServiceImpl - sendSapExpensePr [결재의뢰 ERP 전송: Z_RFC_PRS01]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input.put("usedCode", "S");
		input.put("prsFlag", "0");
		
		List<Map<String, Object>> result = retrieveERPPrInfo(input);
		
		String functionName = "Z_RFC_PRS01";			// PRS 구매요청 생성/수정
		String zmm0109s ="IT_INPUT";					// [PRS] Import parameter - PRS 구매요청 생성/수정
		String zmm0110s ="IT_POTXT";					// [PRS] Import parameter - PRS PO 특기사항
		String zmm0111s ="IT_APPR";						// [PRS] Import parameter - PRS 결제의뢰 내역
		String zmm0112s ="IT_DISP";						// [PRS] PRS 구매요청 생성 결과 리스트
		String zmm0159s ="IT_FILE";						// [PRS] Import Parameter - PR 첨부화일
		
	    JCoDestination destination;
		try {
			destination = JCoDestinationManager.getDestination(ABAP_AS);
		    LOGGER.debug("destination => " + destination);
		    
	    	JCoFunction function = destination.getRepository().getFunction(functionName); 
	    	LOGGER.debug("function => " + function);

	    	JCoTable expenseInput = function.getTableParameterList().getTable(zmm0109s);
	    	JCoTable itemTextInput = function.getTableParameterList().getTable(zmm0110s);
	    	JCoTable expenseAppInput = function.getTableParameterList().getTable(zmm0111s);
	    	JCoTable fileInput = function.getTableParameterList().getTable(zmm0159s);
	    	JCoTable resultTable = function.getTableParameterList().getTable(zmm0112s);
	        
	    	expenseInput = makeExpenseInputData(expenseInput, result);
	    	itemTextInput = makeItemTextInputData(itemTextInput, result, input);
	    	fileInput = makeFileInputData(fileInput, result);
	    	expenseAppInput = makeExpenseAppInputData(expenseAppInput, result, input);
	    	
	    	LOGGER.debug("expenseInput => ");
	    	LOGGER.debug(expenseInput);
	    	LOGGER.debug("itemTextInput => ");
	    	LOGGER.debug(itemTextInput);
	    	LOGGER.debug("fileInput => ");
	    	LOGGER.debug(fileInput);
	    	LOGGER.debug("expenseAppInput => ");
	    	LOGGER.debug(expenseAppInput);
		    	
	       	function.execute(destination);
	        	
	       	LOGGER.debug("resultTable => ");
	       	LOGGER.debug(resultTable);
	       	
	       	resultVal.put("retCode", erpApprovalResultSave(resultTable));;
		} catch (JCoException e) {
			resultVal.put("retCode", "F");
			resultVal.put("retMsg", e.getMessage());
		} finally {
	        return resultVal;
		}
	}
	
	private JCoTable makeExpenseInputData(JCoTable jcoTable, List<Map<String, Object>> result) {
    	for(Map<String, Object> data : result) {
    		jcoTable.appendRow();
    		
    		jcoTable.setValue("BANFN_PRS", data.get("banfnPrs").toString());
    		jcoTable.setValue("BNFPO_PRS", data.get("bnfpoPrs").toString());  
    		jcoTable.setValue("BANFN", data.get("banfn").toString());  
    		
			if ("0".equals(data.get("bnfpo"))) {
				jcoTable.setValue("BNFPO", "");
			} else {
				jcoTable.setValue("BNFPO", data.get("bnfpo").toString());
			}
			
			jcoTable.setValue("KNTTP", data.get("knttp"));
			jcoTable.setValue("PSTYP", data.get("pstyp"));
			jcoTable.setValue("MATNR", data.get("matnr"));
			jcoTable.setValue("TXZ01", data.get("txz01"));
			jcoTable.setValue("MENGE", data.get("menge"));
			jcoTable.setValue("MEINS", data.get("meins"));
			jcoTable.setValue("EEIND", data.get("eeind"));
			jcoTable.setValue("AFNAM", data.get("afnam"));
			jcoTable.setValue("MATKL", data.get("matkl"));
			jcoTable.setValue("WERKS", data.get("werks"));
			jcoTable.setValue("EKGRP", data.get("ekgrp"));
			jcoTable.setValue("BEDNR", data.get("bednr"));
			jcoTable.setValue("PREIS", data.get("preis"));
			jcoTable.setValue("WAERS", data.get("waers"));
			jcoTable.setValue("PEINH", data.get("peinh"));
			jcoTable.setValue("SAKTO", data.get("sakto"));
			jcoTable.setValue("ANLN1_CR", data.get("anln1Cr"));
			jcoTable.setValue("ANLN1", data.get("anln1"));
			jcoTable.setValue("ANLKL", data.get("anlkl"));
			jcoTable.setValue("TXT50", data.get("txt50"));
			jcoTable.setValue("KOSTL", data.get("kostl"));
			jcoTable.setValue("ORD44", data.get("ord44"));
			jcoTable.setValue("GDLGRP", data.get("gdlgrp"));
			jcoTable.setValue("POSID", "TST001");				// 운영에 반영시 반드시 삭제/주석 처리해야함. ERP DEV에 있는 프로젝트 코드로 Hard coding
			//jcoTable.setValue("POSID", data.get("posid"));	// 운영에 반영시 반드시 주석 풀어야 함
			jcoTable.setValue("POST1", data.get("post1"));
			jcoTable.setValue("FKSTL", data.get("fkstl"));
			jcoTable.setValue("IMPRF", data.get("imprf"));
			jcoTable.setValue("IZWEK", data.get("izwek"));
			jcoTable.setValue("G_FLAG", "");  
			
    	}

		return jcoTable;
	};
	
	private JCoTable makeItemTextInputData(JCoTable jcoTable, List<Map<String, Object>> result, HashMap<String, Object> input) {
		Vector tdLineList = new Vector();
		int itemtxtLength = 66;
		
    	for(Map<String, Object> data : result) {
			if (("P".equals(data.get("knttp")) && "D".equals(data.get("pstyp"))) || ("K".equals(data.get("knttp")) && "D".equals(data.get("pstyp")))) { // 서비스인 경우
				//tdLineList.addElement("HP NO:" + handphone);					// 개인정보
				tdLineList.addElement("HP NO:");
				tdLineList.addElement("Room NO:" + data.get("position"));
				tdLineList.addElement("소속:" + input.get("_userDeptName"));
				tdLineList.addElement("거래처 전화번호:" + data.get("lifnr_phone"));
			} else { // 투자, 비용인 경우
				tdLineList.addElement("Maker:" + data.get("maker"));
				tdLineList.addElement("Vendor:" + data.get("vendor"));
				tdLineList.addElement("Catalog NO:" + data.get("catalogno"));
				tdLineList.addElement("Room NO:" + data.get("position"));
				tdLineList.addElement("소속:" + input.get("_userDeptName"));
				//tdLineList.addElement("HP NO:" + handphone);					// 개인정보
				tdLineList.addElement("HP NO:");
			}

			if (Integer.parseInt(data.get("fileCnt").toString()) > 0) {
				tdLineList.addElement("첨부문서 있음");
			}
			
			// 보안성 검토 대상 유무 
			if ("Y".equals(data.get("itAnln1"))) {
				tdLineList.addElement("특기사항 : [보안성 품목 대상임]");
				// 보안성검토 의견
				if (!"".equals(data.get("refuseReason"))) {
					tdLineList.addElement("검토 의견:" + data.get("refuseReason"));
				}
			} else {
				tdLineList.addElement("특기사항 : [보안성 품목 비대상임]");
			}			
			
			if (!"".equals(data.get("itemTxt"))) {
				String itemLines[] = data.get("itemTxt").toString().split("\n");

				for(int i = 0; i < itemLines.length; i++) {
					if(itemLines[i].length() > itemtxtLength) {
						int fromIndex = 0;
						int toIndex = 0;
						for(int j = 0; j <= itemLines[i].length() / itemtxtLength; j++) {
							fromIndex = j * itemtxtLength;
							toIndex = (j * itemtxtLength) + itemtxtLength;
							
							if (toIndex > itemLines[i].length()) {
								toIndex = itemLines[i].length();
							}
							
							tdLineList.addElement(itemLines[i].substring(fromIndex, toIndex));
						}
					} else {
						tdLineList.addElement(itemLines[i]);
					}
				}
			}
			
			if (tdLineList != null) {
				for(int i = 0; i < tdLineList.size(); i++) {
					jcoTable.appendRow();
				
					// Po특기사항 SAP function에 입력
					jcoTable.setValue("BANFN_PRS", data.get("banfnPrs").toString());
					jcoTable.setValue("BNFPO_PRS", data.get("bnfpoPrs").toString());
					jcoTable.setValue("G_LINE", String.format("%02d", i + 1));
					jcoTable.setValue("BANFN", data.get("banfn"));  
	    		
					if ("0".equals(data.get("bnfpo"))) {
						jcoTable.setValue("BNFPO", "");
					} else {
						jcoTable.setValue("BNFPO", data.get("bnfpo").toString());
					}
				
					jcoTable.setValue("TDLINE", (String) tdLineList.elementAt(i));

					// 재무/인사 김은경D 요청 (2006.09.12)
					if (i == 0) {
						jcoTable.setValue("MAKER", data.get("maker"));
						jcoTable.setValue("LIFNR", data.get("vendor"));
					}
				}
			}
			
			tdLineList.removeAllElements();
    	}

		return jcoTable;
	};

	private JCoTable makeFileInputData(JCoTable jcoTable, List<Map<String, Object>> result) {
    	for(Map<String, Object> data : result) {
    		if(Integer.parseInt(data.get("fileCnt").toString()) > 0) {
    			List<Map<String, Object>> retreiveAttachFileInfoList = attachFileService.getAttachFileInfoList(data);
    			
    			for(Map<String, Object> attachFileInfo : retreiveAttachFileInfoList) {
    				jcoTable.appendRow();
    
    				jcoTable.setValue("BANFN_PRS", data.get("banfnPrs").toString());
    				jcoTable.setValue("BNFPO_PRS", data.get("bnfpoPrs").toString());
    				jcoTable.setValue("BANFN","");
    				jcoTable.setValue("BNFPO","");
    				jcoTable.setValue("PATH", attachFileInfo.get("attcFilId").toString() + "-" + attachFileInfo.get("seq").toString());
    				jcoTable.setValue("FILE", attachFileInfo.get("filNm").toString());    				
    			}

    			
//				fileList = file.fileList(seqNum, "01");
//				for (int ll = 0; ll < fileList.size(); ll++) {
//					fileVo = (FileVO) fileList.get(ll);
//					canonicalpath = fileVo.getFileEntity().getCanonicalpath();
//					org_filename = fileVo.getFileEntity().getOrg_filename();
//					fileInput.appendRow();
//					fileInput.setRow(kk++);
//
//					fileInput.setValue(str.nullChange(banfn_prs), "BANFN_PRS");
//					fileInput.setValue(bnfpo_prs, "BNFPO_PRS");
//					fileInput.setValue("", "BANFN");
//					fileInput.setValue("", "BNFPO");
//					fileInput.setValue(seqNum + "-01", "PATH");
//					fileInput.setValue(str.nullChange(org_filename), "FILE");
//				}    			
    		}
    	}

		return jcoTable;
	};

	private JCoTable makeExpenseAppInputData(JCoTable jcoTable, List<Map<String, Object>> result, HashMap<String, Object> input) {
		List<Map<String, Object>> approvalList = retreivePurApprovalInfo(input);
		int approvalOpinLength = 65; 
		int approvalOpinMaxLine = 8; // 8줄까지만 가능
		
    	for(Map<String, Object> data : approvalList) {
    		jcoTable.appendRow();
    		
    		jcoTable.setValue("BANFN_PRS", data.get("banfnPrs").toString());
    		jcoTable.setValue("BANFN", "");  
			//jcoTable.setValue("RECE_PERNR", data.get("bednr").toString());    // 운영반영시 주석 풀고 아랫줄 주석 처리할 것
			jcoTable.setValue("RECE_PERNR", "00206645");   // 정현철 책임으로 테스트 진행. 운영반영시 주석처리하고 윗줄 주석 풀것
    		jcoTable.setValue("APR1_PERNR", data.get("apr1Pernr").toString());
    		jcoTable.setValue("APR2_PERNR", data.get("apr2Pernr").toString());
    		jcoTable.setValue("APR3_PERNR", data.get("apr3Pernr").toString());
    		//jcoTable.setValue("APR4_PERNR", data.get("apr4Pernr").toString());	// 운영반영시 주석 풀고 아랫줄 주석 처리할 것
    		jcoTable.setValue("APR4_PERNR", "00060954");	// 장재용 책임으로 테스트 진행. 운영반영시 주석처리하고 윗줄 주석 풀것
    		jcoTable.setValue("WBS_PERNR", data.get("wbsPernr").toString());
			
			String gCheckFlag = "";
			String gCheck2Flag = "";
			if ( data.get("gCheck").toString().equals("Y")) {
				gCheckFlag = "X";
			}
			if ( data.get("gCheck2").toString().equals("Y")) {
				gCheck2Flag = "X";
			}
			
			jcoTable.setValue("G_CHECK", gCheckFlag);
			jcoTable.setValue("G_CHECK2", gCheck2Flag);			

			if (!"".equals(data.get("opinDoc").toString())) {
				String itemLines[] = data.get("opinDoc").toString().split("\n");
				String tempOpin_doc = "";
				int lineIndex = 0;
				
				for(int i = 0; i < itemLines.length && lineIndex < approvalOpinMaxLine; i++) {
					if(itemLines[i].length() > approvalOpinLength) {
						int fromIndex = 0;
						int toIndex = 0;
						
						for(int j = 0;(j <= itemLines[i].length() / approvalOpinLength) && lineIndex < approvalOpinMaxLine; j++) {
							fromIndex = j * approvalOpinLength;
							toIndex = (j * approvalOpinLength) + approvalOpinLength;
							
							if (toIndex > itemLines[i].length()) {
								toIndex = itemLines[i].length();
							}
							
							tempOpin_doc = "OPIN_DOC" + lineIndex;
							jcoTable.setValue(tempOpin_doc, itemLines[i].toString().substring(fromIndex, toIndex));
							lineIndex++;
						}
					} else {
						tempOpin_doc = "OPIN_DOC" + lineIndex;
						jcoTable.setValue(tempOpin_doc, itemLines[i].toString());
						lineIndex++;
					}
				}
			}
    	}
		return jcoTable;
	};

	private String erpApprovalResultSave(JCoTable jcoTable) {
		String resultVal = "";
		int rowCnt = jcoTable.getNumRows();
		MailSender mailSender = null;
		String message = "";
		
		LOGGER.debug("##############################input############################# : " + jcoTable);
		
		if (rowCnt > 0) {
			for (int i = 0; i < rowCnt; i++) {
				jcoTable.setRow(i);

				String appBanfn = jcoTable.getString("BANFN");
				String appBnfpo = jcoTable.getString("BNFPO");

				if ("S".equals(jcoTable.getString("STATUS").trim()) && i == 0) {		// to-do: "S" -> "E"로 변경하여 운영 반영
					// SAP 전송 에러일 경우 해당 요청자에게 처리 결과를 메일로 보낸다.
					mailSender = mailSenderFactory.createMailSender();
	
					mailSender.setFromMailAddress("iris@lghausys.com");
					mailSender.setToMailAddress("sehonga@lghausys.com");    // to-do: 개발시에만 하드코딩, 운영은 처음 작성한 담당자에게 보내야 한다.
					mailSender.setSubject("구매요청 SAP 전송 실패");
					
					message = "<b>* 구매요청 내역</b><br>";
					message += "&nbsp;&nbsp;&nbsp;" + jcoTable.getString("BANFN_PRS") + "<br>";
					message += "<br><br>";
					message += "<b>* SAP 처리 결과</b><br>";
					message += "&nbsp;&nbsp;&nbsp;"	+ jcoTable.getString("MESSAGE").trim();					
					
					mailSender.setText(message);
					
					mailSender.send();
				}

				/*
				 * 구매요청 단계 플래그 D:삭제 , E:SAP전송에러 S:SAP로 데이터 전송, 0: 임시저장 
				 * 1:구매요청, 2:구매반려(PRS반려), 3:결재의뢰, 4:결재반려(SAP반려), 5:결재완료,
				 * 6:구매발주, 7:입고완료 8:삭제된 결재반려건
				 */
				resultVal = jcoTable.getString("STATUS").trim();

				Map<String, Object> map = new HashMap<String, Object>();
		        map.put("banfn", jcoTable.getString("BANFN"));		// PR번호
		        map.put("bnfpo", jcoTable.getString("BNFPO"));		// PR품목번호
		        map.put("banfnPrs", Integer.parseInt(jcoTable.getString("BANFN_PRS")));
		        map.put("bnfpoPrs", Integer.parseInt(jcoTable.getString("BNFPO_PRS")));
		        map.put("anln1", jcoTable.getString("ANLN1"));
		        map.put("posid", jcoTable.getString("POSID"));
		        if(!"E".equals(resultVal) && !"".equals(jcoTable.getString("BANFN"))) {
		        	map.put("prsFlag", "3");
		        	resultVal = "S";
		        } else if("E".equals(resultVal) && !"".equals(jcoTable.getString("BANFN"))) {
		        	map.put("prsFlag", "1");
		        	resultVal = "S";
		        } else {
		        	map.put("prsFlag", resultVal);
		        }
		        map.put("message", jcoTable.getString("MESSAGE")); 
	            
				updateAppExpensePr(map);
			}
		}
		
		return resultVal;
	}
	
	public List<Map<String, Object>> retrieveERPPrInfo(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retrievePurRqInfo", input);
	}
	
	public List<Map<String, Object>> retreivePurApprovalInfo(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retreivePurApprovalInfo", input);
	}
	
	public int updateAppExpensePr(Map<String, Object> input){
		return commonDao.update("prs.purRq.updateAppExpensePr", input);
	}
	
	public List<Map<String, Object>> retrieveAttachFileList(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retrieveMyPurRqListAttachFiles", input);
	}
	
	@Override
	public List<Map<String, Object>> getPrRequestSAPStatus(List<Map<String,Object>> dataList){
		List<Map<String, Object>> resultVal = new ArrayList<Map<String, Object>>();
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoServiceImpl - getPrRequestSAPStatus ");
		LOGGER.debug("dataList = > " + dataList);
		LOGGER.debug("###########################################################");
		
		resultVal = callZ_RFC_PRS04_05(dataList);

		return resultVal;
	}
	
	private JCoTable makePrData(JCoTable jcoTable, List<Map<String, Object>> list) {
		int i = 0;
		for(Map<String, Object> data : list) {
    		if(!"".equals(data.get("banfn"))) {
    			jcoTable.appendRow();
    
    			jcoTable.setValue("BANFN", data.get("banfn").toString());
    			jcoTable.setValue("BNFPO", data.get("bnfpo").toString());
    			jcoTable.setValue("BANFN_PRS", i);
    		}
    		i++;
    	}

		return jcoTable;
	};
	
	private JCoTable makePrList(JCoTable jcoTable, List<Map<String, Object>> list) {
		int i = 0;
		for(Map<String, Object> data : list) {
    		if(!"".equals(data.get("banfn"))) {
    			jcoTable.appendRow();
    
    			jcoTable.setValue("BANFN", data.get("banfn").toString());
    			jcoTable.setValue("BNFPO", data.get("bnfpo").toString());
    		}
    		i++;
    	}

		return jcoTable;
	};

	private List<Map<String, Object>> makeGetPrRequestSAPReturn(JCoTable jcoTable) {
		List<Map<String, Object>> resultVal = new ArrayList<Map<String, Object>>();
		String erpIndex = "";
		
		for(int i = 0; i < jcoTable.getNumRows(); i++, jcoTable.nextRow()) {
			HashMap<String, Object> record = new HashMap<String, Object>();
			
			record.put("banfn", jcoTable.getValue("BANFN"));
			record.put("bnfpo", jcoTable.getValue("BNFPO"));
			erpIndex = jcoTable.getValue("INDEX").toString();
			
			record.put("index", erpIndex);
			record.put("idx", jcoTable.getValue("BANFN_PRS"));
			LOGGER.debug(jcoTable.getValue("BANFN_PRS"));
			switch (erpIndex) {
				case "1":
					record.put("status", "구매요청");
					break;
				case "2":
					record.put("status", "구매반려(PRS)");
					break;
				case "3":
					record.put("status", "결재의뢰");
					break;
				case "4":
					record.put("status", "결재반려(SAP)");
					break;
				case "5":
					record.put("status", "결재완료");
					break;
				case "6":
					record.put("status", "구매발주");
					break;
				case "7":
					record.put("status", "입고완료");
					break;
				case "8":
					record.put("status", "삭제(결재반려)");
					break;
				default:
					record.put("status", "");
					break;
			}
		
			resultVal.add(i, record);
    	}

		LOGGER.debug(resultVal);
		return resultVal;
	};

	private List<Map<String, Object>> callZ_RFC_PRS04(List<Map<String,Object>> dataList){
		List<Map<String, Object>> resultVal = new ArrayList<Map<String, Object>>();
		
		//LOGGER.debug("###########################################################");
		//LOGGER.debug("PurRqInfoServiceImpl - callZ_RFC_PRS04 [구매요청현황: Z_RFC_PRS04]");
		//LOGGER.debug("###########################################################");
		
		String functionName = "Z_RFC_PRS04";			// 구매요청현황
		String gubun ="I_GUBUN";						// 작업구분 (1:my구매내역,2:구매요청)
		String zmm0126s ="I_PAGE";						// [PRS] import_page info
		String zmm0128s ="I_SORT";						// [PRS] [PRS] Import parameter - 구매요청현황 (정렬 및 구매단계)
		String zmm0115s ="E_OUTPUT";					// [PRS] RFC_EXPORT
		String zmm0118s ="IT_INPUT";					// [PRS] Import parameter - 구매요청현황
		String zmm0119s ="IT_LIST";						// [PRS] 구매요청현황 리스트
		
	    JCoDestination destination;
		try {
			destination = JCoDestinationManager.getDestination(ABAP_AS);
	    	JCoFunction function = destination.getRepository().getFunction(functionName); 

	    	JCoParameterList importList = function.getImportParameterList();
	    	JCoParameterList exportList = function.getExportParameterList();
	    	JCoTable requestTable = function.getTableParameterList().getTable(zmm0118s);
	    	JCoTable resultTable  = function.getTableParameterList().getTable(zmm0119s);
	        
	    	requestTable = makePrData(requestTable, dataList);
	    	LOGGER.debug("requestTable");
	    	LOGGER.debug(requestTable);
	    	importList.setValue(gubun, "1");
	       	function.execute(destination);
	    	LOGGER.debug("resultTable");
	    	LOGGER.debug(resultTable);
	       	
	       	resultVal = makeGetPrRequestSAPReturn(resultTable);
		} catch (JCoException e) {
			
		} finally {
	        return resultVal;
		}
	}

	private List<Map<String, Object>> callZ_RFC_PRS05(List<Map<String,Object>> dataList){
		List<Map<String, Object>> resultVal = new ArrayList<Map<String, Object>>();
		
		//LOGGER.debug("###########################################################");
		//LOGGER.debug("PurRqInfoServiceImpl - callZ_RFC_PRS05 [구매진척현황: Z_RFC_PRS05]");
		//LOGGER.debug("###########################################################");
		
		String functionName = "Z_RFC_PRS05";			// 구매요청현황
		String zmm0126s ="I_PAGE";						// [PRS] import_page info
		String zmm0115s ="E_OUTPUT";					// [PRS] RFC_EXPORT
		String zmm0120s ="IT_INPUT";					// [PRS] Import parameter - 구매진척현황
		String zmm0121s ="IT_LIST";						// [PRS] 구매진척현황 리스트
		
	    JCoDestination destination;
		try {
			destination = JCoDestinationManager.getDestination(ABAP_AS);
	    	JCoFunction function = destination.getRepository().getFunction(functionName); 

	    	JCoParameterList importList = function.getImportParameterList();
	    	JCoParameterList exportList = function.getExportParameterList();
	    	JCoTable requestTable = function.getTableParameterList().getTable(zmm0120s);
	    	JCoTable resultTable  = function.getTableParameterList().getTable(zmm0121s);
	        
	    	requestTable = makePrList(requestTable, dataList);
	       	function.execute(destination);
	       	resultVal = makeGetPrProcessSAPReturn(resultTable);
	       	
		} catch (JCoException e) {
			
		} finally {
	        return resultVal;
		}
	}
	
	private List<Map<String, Object>> callZ_RFC_PRS04_05(List<Map<String,Object>> dataList){
		List<Map<String, Object>> resultVal04 = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultVal05 = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultVal = new ArrayList<Map<String, Object>>();
		
		//LOGGER.debug("###########################################################");
		//LOGGER.debug("PurRqInfoServiceImpl - callZ_RFC_PRS04_05");
		//LOGGER.debug("###########################################################");
		
		resultVal04 = callZ_RFC_PRS04(dataList);
		resultVal05 = callZ_RFC_PRS05(dataList);
		
		int i = 0;
		for(Map item : resultVal04) {
			Map<String, Object> record = new HashMap<String, Object>();

			record.put("banfn", 	item.get("banfn"));
			record.put("bnfpo", 	item.get("bnfpo"));
			record.put("index", 	item.get("index"));
			record.put("idx", 		item.get("idx"));
			record.put("status", 	item.get("status"));
			record.put("badat", 	resultVal05.get(i).get("badat"));		
			record.put("apr4Date", 	resultVal05.get(i).get("apr4Date"));		
			record.put("rejeDate", 	resultVal05.get(i).get("rejeDate"));		
			record.put("ebeln", 	resultVal05.get(i).get("ebeln"));			
			record.put("ebelp", 	resultVal05.get(i).get("ebelp"));			
			record.put("bedat", 	resultVal05.get(i).get("bedat"));			
			record.put("poMenge", 	resultVal05.get(i).get("poMenge"));		
			record.put("poMeins", 	resultVal05.get(i).get("poMeins"));		
			record.put("netwr", 	resultVal05.get(i).get("netwr"));			
			record.put("waers", 	resultVal05.get(i).get("waers"));			
			record.put("name1", 	resultVal05.get(i).get("name1"));			
			record.put("grBudat", 	resultVal05.get(i).get("grBudat"));		
			record.put("grMenge", 	resultVal05.get(i).get("grMenge"));		
			record.put("piBudat", 	resultVal05.get(i).get("piBudat"));		
			
			resultVal.add(i, record);
			
			i++;
		}
		
		LOGGER.debug(resultVal);
		return resultVal;
	}
	
	private List<Map<String, Object>> makeGetPrProcessSAPReturn(JCoTable jcoTable) {
		List<Map<String, Object>> resultVal = new ArrayList<Map<String, Object>>();
		for(int i = 0; i < jcoTable.getNumRows(); i++, jcoTable.nextRow()) {
			HashMap<String, Object> record = new HashMap<String, Object>();

			record.put("banfn", jcoTable.getValue("BANFN"));
			record.put("bnfpo", jcoTable.getValue("BNFPO"));
			record.put("badat", jcoTable.getValue("BADAT"));			// PR 생성일
			record.put("apr4Date", jcoTable.getValue("APR4_DATE"));		// PR 결제일
			record.put("rejeDate", jcoTable.getValue("REJE_DATE"));		// PR 결제기각일
			record.put("ebeln", jcoTable.getValue("EBELN"));			// PO 번호
			record.put("ebelp", jcoTable.getValue("EBELP").toString().replace("00000",""));			// PO 품번
			record.put("bedat", jcoTable.getValue("BEDAT"));			// PO 생성일
			record.put("poMenge", jcoTable.getValue("PO_MENGE"));		// PO 수량
			record.put("poMeins", jcoTable.getValue("PO_MEINS"));		// PO 단위
			record.put("netwr", jcoTable.getValue("NETWR"));			// PO 금액
			record.put("waers", jcoTable.getValue("WAERS"));			// PO 통화
			record.put("name1", jcoTable.getValue("NAME1"));			// Vendor
			record.put("grBudat", jcoTable.getValue("GR_BUDAT"));		// 입고일
			record.put("grMenge", jcoTable.getValue("GR_MENGE").toString().replace("","0"));		// 입고수량
			record.put("piBudat", jcoTable.getValue("PI_BUDAT"));		// 송장일
		
			resultVal.add(i, record);
    	}

		return resultVal;
	};
	
}
