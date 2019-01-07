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
import com.sap.conn.jco.JCoTable;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSenderFactory;
import iris.web.rlab.rqpr.service.RlabRqprServiceImpl;
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
	
	public HashMap<String, Object> retrievePurRqInfo(HashMap<String, Object> input){
		return commonDao.select("prs.purRq.retrievePurRqInfo", input);
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
	public String sendSapExpensePr(Map<String, Object> dataMap) throws JCoException{
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		String resultVal = "";
		
		input.put("usedCode", "S");
		input.put("prsFlag", "0");
		
		List<Map<String, Object>> result = retrieveERPPrInfo(input);
		
		String functionName = "Z_RFC_PRS01";			// PRS 구매요청 생성/수정
		String zmm0109s ="IT_INPUT";					// [PRS] Import parameter - PRS 구매요청 생성/수정
		String zmm0110s ="IT_POTXT";					// [PRS] Import parameter - PRS PO 특기사항
		String zmm0111s ="IT_APPR";						// [PRS] Import parameter - PRS 결제의뢰 내역
		String zmm0112s ="IT_DISP";						// [PRS] PRS 구매요청 생성 결과 리스트
		String zmm0159s ="IT_FILE";						// [PRS] Import Parameter - PR 첨부화일
		
	    JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
	    //연결정보확인.
	    System.out.println(destination.getApplicationServerHost());
	    
		JCoFunction function = destination.getRepository().getFunction(functionName); 
		    
        if(function == null) throw new RuntimeException("SAP_DATA not found in SAP.");
           
        JCoTable expenseInput = function.getTableParameterList().getTable(zmm0109s);
        JCoTable itemTextInput = function.getTableParameterList().getTable(zmm0110s);
        JCoTable expenseAppInput = function.getTableParameterList().getTable(zmm0111s);
        JCoTable fileInput = function.getTableParameterList().getTable(zmm0159s);
        JCoTable resultTable = function.getTableParameterList().getTable(zmm0112s);
        
        expenseInput = makeExpenseInputData(expenseInput, result);
        itemTextInput = makeItemTextInputData(itemTextInput, result, input);
        fileInput = makeFileInputData(fileInput, result);
        expenseAppInput = makeExpenseAppInputData(expenseAppInput, result, input);
        
        try{
            	
        	//System.out.println(expenseInput);
        	//System.out.println(itemTextInput);
        	//System.out.println(fileInput);
        	//System.out.println(expenseAppInput);
        	
        	function.execute(destination);
        	
        	//System.out.println(resultTable);
        	
        	resultVal = erpApprovalResultSave(resultTable);
    	        
        }catch(Exception e){
           	
        }finally{
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
					jcoTable.setValue("G_LINE", i + 1);
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
			jcoTable.setValue("RECE_PERNR", data.get("bednr").toString());
    		jcoTable.setValue("APR1_PERNR", data.get("apr1Pernr").toString());
    		jcoTable.setValue("APR2_PERNR", data.get("apr2Pernr").toString());
    		jcoTable.setValue("APR3_PERNR", data.get("apr3Pernr").toString());
    		jcoTable.setValue("APR4_PERNR", data.get("apr4Pernr").toString());
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
//    			expensePrAppList = selectApprovalPr(temp_banfn_prs);
//    			for (int i = 0; i < expensePrAppList.size(); i++) {
//    				appVo = (ApprovalVO) expensePrAppList.get(i);
//    				apr1_pernr = appVo.getApprovalEntity().getApr1_pernr();
//    				apr2_pernr = appVo.getApprovalEntity().getApr2_pernr();
//    				apr3_pernr = appVo.getApprovalEntity().getApr3_pernr();
//    				apr4_pernr = appVo.getApprovalEntity().getApr4_pernr();
//    				wbs_pernr = appVo.getApprovalEntity().getWbs_pernr();
//    				g_check = appVo.getApprovalEntity().getG_check();
//    				g_check2 = appVo.getApprovalEntity().getG_check2();
//    				expenseAppInput.appendRow();
//    				expenseAppInput.setRow(jj++);
//    				// sap function값을 셋팅한다.
//    				expenseAppInput.setValue(str.nullChange(banfn_prs), "BANFN_PRS");
//    				expenseAppInput.setValue("", "BANFN");
//    				expenseAppInput.setValue(str.nullChange(bednr), "RECE_PERNR");
//    				expenseAppInput.setValue(str.nullChange(apr1_pernr), "APR1_PERNR");
//    				expenseAppInput.setValue(str.nullChange(apr2_pernr), "APR2_PERNR");
//    				expenseAppInput.setValue(str.nullChange(apr3_pernr), "APR3_PERNR");
//    				expenseAppInput.setValue(str.nullChange(apr4_pernr), "APR4_PERNR");
//    				expenseAppInput.setValue(str.nullChange(wbs_pernr), "WBS_PERNR");
//
//    				String gCheckFlag = "";
//    				String gCheck2Flag = "";
//    				if (StringUtil.getNullToEmpty(g_check).equals("Y")) {
//    					gCheckFlag = "X";
//    				}
//    				if (StringUtil.getNullToEmpty(g_check2).equals("Y")) {
//    					gCheck2Flag = "X";
//    				}
//
//    				expenseAppInput.setValue(gCheckFlag, "G_CHECK");
//    				expenseAppInput.setValue(gCheck2Flag, "G_CHECK2");
//
//    				opin_doc = appVo.getApprovalEntity().getOpin_doc();
//    				if (str.nullCheck(opin_doc)) {
//    					opin_doc = StringUtil.replace(opin_doc, "\n", " ");
//    					opin_doc = StringUtil.replace(opin_doc, "\r", "");
//
//    					appList = StringUtil.getStringByteLengthList(opin_doc, ApprovalOpinLength);   // int ApprovalOpinLength = 65;
//
//    					if (null != appList && appList.size() > 0) {
//    						for (int yy = 0; yy < appList.size(); yy++) {
//
//    							String tempOpin_doc = "OPIN_DOC" + yy;
//    							String submitStringValue = (String) appList.get(yy);
//
//    							if (yy < 8) {
//    								// 의견등록 SAP function에 입력
//    								expenseAppInput.setValue((String) appList.get(yy), tempOpin_doc);
//    							}
//    						}
//    					}
//    				}
//   			}
//    		}
		return jcoTable;
	};

	private String erpApprovalResultSave(JCoTable jcoTable) {
		String resultVal = "";
		int rowCnt = jcoTable.getNumRows();
		
		if (rowCnt > 0) {
			for (int i = 0; i < rowCnt; i++) {
				jcoTable.setRow(i);

				String appBanfn = jcoTable.getString("BANFN");
				String appBnfpo = jcoTable.getString("BNFPO");

//				if ("E".equals(jcoTable.getString("STATUS").trim())) {
//					// SAP 전송 에러일 경우 해당 요청자에게 처리 결과를 메일로 보낸다.
//					String pernr = bednr;
//
//					PrsEmployeeVO empVo = new PrsEmployeeVO();
//					empVo.getPrsEmployeeEntity().setPernr(pernr);
//
//					empVo = employee.retrievePrsEmployeeInfo(empVo);
//
//					String mailServer = "subspam.lghausys.com";
//					String fromAddress = "admin@lghausys.com";
//					String toAddress = empVo.getPrsEmployeeEntity().getSamail();
//					String subject = "구매요청 SAP 전송 실패";
//					String message = "<b>* 구매요청 내역</b><br>";
//					message += "&nbsp;&nbsp;&nbsp;" + txz01 + "<br>";
//					message += "<br><br>";
//					message += "<b>* SAP 처리 결과</b><br>";
//					message += "&nbsp;&nbsp;&nbsp;"	+ resultTable.getString("MESSAGE").trim();
//
//					SmtpClient.send(mailServer, fromAddress, SmtpClient.tokenToAddress(toAddress), subject, message);
//				}

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
		        map.put("prsFlag", jcoTable.getString("STATUS")); 
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
}
