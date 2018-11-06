package iris.web.prj.grs.service;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.tssbatch.service.TssStCopyService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;
import org.springframework.ui.velocity.VelocityEngineUtils;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@Service("grsMngService")
public class GrsMngServiceImpl implements GrsMngService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Resource(name = "configService")
	private ConfigService configService;


	@Resource(name = "jspProperties")
	private Properties jspProperties;

	@Resource(name = "velocityEngine")
	private VelocityEngine velocityEngine;

	@Resource(name = "tssStCopyService")
	private TssStCopyService tssStCopyService;

	@Resource(name = "genTssService")
	private GenTssService genTssService;

	@Resource(name = "grsReqService")
	private GrsReqService grsReqService;


	@Resource(name = "grsMngService")
	private GrsMngService grsMngService;

	@Resource(name = "genTssPlnService")
	private GenTssPlnService genTssPlnService;

	/* 울산 DB Connection */
	@Resource(name="commonDaoQasU")
	private CommonDao commonDaoQasU;

	/* 청주 DB Connection */
	@Resource(name="commonDaoQasC")
	private CommonDao commonDaoQasC;


	static final Logger LOGGER = LogManager.getLogger(GrsMngService.class);


	@Override
	public List<Map<String, Object>> selectListGrsMngList(HashMap<String, Object> input) {
		return commonDao.selectList("prj.grs.retrieveGrsReqList", input);
	}

	@Override
	public Map<String, Object> selectGrsMngInfo(HashMap<String, Object> input) {
		return commonDao.select("prj.grs.selectGrsInfo", input);
	}

	@Override
	public void updateGrsInfo(Map<String, Object> input) {
		commonDao.insert("prj.grs.updateGrsInfo", input);
	}

	@Override
	public Map<String, Object> saveGrsInfo(HashMap<String, Object> input) {
		HashMap<String, Object> result = new HashMap<>();
		if ("".equals(input.get("tssCd"))) {
			result.put("rtnSt", "F");

			//신규
			HashMap<String, Object> getWbs = genTssService.getTssCd(input);
			//SEED WBS_CD 생성
			int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
			String seqMaxS = String.valueOf(seqMax + 1);


//				input.put("nprodSalsPlnY", (Integer)input.get("nprodSalsPlnY") * 100000000);
			input.put("wbsCd", input.get("tssScnCd") + seqMaxS);
			input.put("pkWbsCd", input.get("wbsCd"));
			input.put("userId", input.get("_userId"));
			String grsYn = (String) input.get("grsYn");

			// GRS(P1)을 수행하는 경우 계획 GRS요청  하지 않는 경우 계획 진행중, PG 도 함께 생성
			if (grsYn.equals("Y")) {
				input.put("pgsStepCd", "PL");                                // 과제 진행 단계 코드
				input.put("tssSt","101");
			}else if (grsYn.equals("N")) {
				input.put("pgsStepCd","PL");
				input.put("tssSt","100");
			}

			LOGGER.debug("=============== 과제 기본정보 등록 ===============");
			// mchnCgdgService.saveCgdsMst(input);
			updateGrsInfo(input);                                                        //과제 기본정보 등록
			input.put("tssCd", input.get("newTssCd"));
			result.put("tssCd", (String) input.get("newTssCd"));
			LOGGER.debug("=============== 생성TSS_CD : "+input.get("newTssCd")+" ===============");


			if (grsYn.equals("Y")) {
				LOGGER.debug("=============== GRS=Y 인경우 GRS 요청정보 생성 ===============");
				input.put("grsEvSt", "P1");
				input.put("dlbrCrgr", input.get("_userSabun"));
				updateGrsReqInfo(input);                                            //GRS 정보 등록
			}else if (grsYn.equals("N")) {
				LOGGER.debug("=============== GRS=N 인경우 마스터 이관 ===============");
				String tssCd = (String) input.get("tssCd");

				LOGGER.debug("=============== 과제정보 마스터 이관(PL) ===============");
				input.put("fromTssCd", tssCd); //GRS 기본정보 TSS_CD
				moveDefGrsDefInfo(input);


					/*
					LOGGER.debug("=============== 과제정보 마스터 이관(PG) ===============");
					input.put("tssCd", tssCd.substring( 0,9) + (java.lang.Integer.parseInt(tssCd.substring( 9,10))+1));
					input.put("pgsStepCd","PG");
					input.put("tssSt","100");
					moveDefGrsDefInfo(input);
					*/


				LOGGER.debug("=============== GRG 과제 기본정보 삭제 ===============");
				input.put("tssCd", tssCd);
				deleteDefGrsDefInfo(input);

				//Qgate I/F
				//리더에게 에게 메일 발송
//					genTssPlnService.retrieveSendMail(input); //개발에서 데이터 등록위해 반영위해 주석 1121

			}

			result.put("rtnMsg", "저장되었습니다.");
		} else {
			updateGrsInfo(input);                                                        // 과제 기본정보 수정
			result.put("rtnMsg", "수정되었습니다.");
		}
		result.put("rtnSt", "S");

		return result;
	}

	@Override
	public Map<String, String> evGrs(HashMap<String, Object> input,List<Map<String, Object>>dsLst,HashMap<String, Object>dtlDs) {
			HashMap<String, String> result = new HashMap<String, String>();
			input.put("evTitl", dtlDs.get("evTitl"));
			input.put("commTxt", dtlDs.get("commTxt"));

            input.put("userId", input.get("_userId"));
            input.put("cfrnAtdtCdTxt", input.get("cfrnAtdtCdTxt").toString().replaceAll("%2C", ",")); //참석자
            input = StringUtil.toUtf8Input(input);

            grsReqService.insertGrsEvRsltSave(dsLst, input);

			LOGGER.debug("===GRS 평가 완료후 과제 상태값 변경===");
            input.put("tssSt", "102");
            genTssPlnService.updateGenTssPlnMstTssSt(input);
            grsMngService.updateDefTssSt(input);


            if(grsMngService.isBeforGrs(input).equals("1")){
                LOGGER.debug("===GRS 관리에서 기본정보를 입력한경우===");
                LOGGER.debug("===과제 관리 마스터로 데이터 복제 (과제정보, 개요)===");
                input.put("fromTssCd", input.get("tssCd"));
                input.put("pgsStepCd", "PL");
                grsMngService.moveDefGrsDefInfo(input);
                grsMngService.deleteDefGrsDefInfo(input);
            }

			LOGGER.debug("===해당과제 리더에게 완료 메일 발송===");
            genTssPlnService.retrieveSendMail(input); //개발에서 데이터 등록위해 반영위해 주석 1121


			result.put("rtnMsg", "평가완료되었습니다.");
			result.put("rtnSt", "S");

            return result;
	}

	@Override
	public void deleteGrsInfo(Map<String, Object> input) {
		commonDao.delete("prj.grs.deleteDefInfo", input);
		commonDao.delete("prj.grs.deleteGrsInfo", input);

	}

	@Override
	public void updateGrsReqInfo(Map<String, Object> input) {
		commonDao.update("prj.grs.insertGrsEvRslt", input);
	}

	@Override
	public void updateDefTssSt(HashMap<String, Object> input) {
		commonDao.update("prj.grs.updateDefTssSt", input);
	}

	@Override
	public void moveDefGrsDefInfo(HashMap<String, Object> input) {
		LOGGER.debug("=============== GRS기본정보를 과제 마스터로 등록(마스터, 개요, 산출물) ===============");
		String tssScnCd = (String) input.get("tssScnCd");
		String tssAttrCd = (String) input.get("tssAttrCd");


		if("N".equals(tssScnCd)){
			// 국책인경우 1년차수 입력
			input.put("tssNosSt", "1");
		}

		//GRS 기본정보 과제 관리 마스터로 복제
		commonDao.insert("prj.grs.moveGrsDefInfo", input);


		if(tssScnCd.equals("D")){
			//		창호 01/장식재 03 > 건장재01
			//		자동차 05 > 자동차04
			//		표면소재 06(데코 P11,가전 P12,S&G P13) > 산업용필름02
			//		표면소재 06(그외) > 건장재01
			String bizDptCd = (String) input.get("bizDptCd");
			String prodG = (String) input.get("prodG");

			String rsstSphe = "";
			if("01".equals(bizDptCd) || "03".equals(bizDptCd)){
				rsstSphe = "01";
			}else if("05".equals(bizDptCd)){
				rsstSphe = "04";
			}else if("06".equals(bizDptCd) && ("P11".equals(prodG) || "P12".equals(prodG) || "P13".equals(prodG))){
				rsstSphe = "02";
			}else if("06".equals(bizDptCd)){
				rsstSphe = "01";
			}else{
				rsstSphe = "03";
			}

			// 발의, 연구 기본값 세팅
			if(input.get("tssScnCd").equals("D")){
				input.put("ppslMbdCd", "02"); // 사업부
			}else{
				input.put("ppslMbdCd", ""); // 사업부
			}

			input.put("rsstSphe", rsstSphe);
			commonDao.update("prj.grs.updateGrsDefInfo02", input);
		}


/*

		if("N".equals(input.get("grsYn"))){
			//GRS(P1)을 하지 않는 경우
			//WBS 코드 생성 및 등록
			String wbsCd = tssStCopyService.createWbsCd(input);
			input.put("wbsCd", wbsCd);
			commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
		}
*/

		LOGGER.debug("=============== GRS 기본정보 과제 서머리 마스터로 복제 ===============");
		commonDao.insert("prj.grs.moveGrsDefSmry", input);

		Calendar cal = Calendar.getInstance();
        int mm   = cal.get(Calendar.MONTH) + 1;

		LOGGER.debug("=============== 기본 산출물 등록 ===============");

		input.put("attcFilId", "");	 // 최초 등록시 파일 초기화
		String goalYStart = input.get("tssStrtDd").toString().substring(0, 4);
		String goalYEnd = input.get("tssFnhDd").toString().substring(0, 4);
		String arslYymm01 = input.get("tssFnhDd").toString().substring(0, 7);
		if(tssScnCd.equals("G")){
			//일반
			//과제 제안서
            String pmisDt = CommonUtil.getMonthSearch_1( CommonUtil.replace(input.get("tssFnhDd").toString(), "-", ""));

            input.put("goalY", goalYStart);
            input.put("yldItmType", "01");
            input.put("arslYymm",  goalYStart + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);



            if("00".equals(tssAttrCd)){
            	//과제속성이 제품인 경우에만 Qgate 연동
				//qgate1
				input.put("goalY", goalYStart);
				input.put("yldItmType", "06");
				input.put("arslYymm",  goalYStart + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
				commonDao.update("prj.tss.com.updateTssYld", input);

				//qgate2
				input.put("goalY", goalYEnd);
				input.put("yldItmType", "07");
				input.put("arslYymm", arslYymm01);
				commonDao.update("prj.tss.com.updateTssYld", input);

				//qgate3
				input.put("goalY", goalYEnd);
				input.put("yldItmType", "08");
				input.put("arslYymm", arslYymm01);
				commonDao.update("prj.tss.com.updateTssYld", input);
			}

            //지적재산권
            input.put("goalY", goalYEnd);
            input.put("yldItmType", "05");
            input.put("arslYymm",  CommonUtil.getFormattedDate(pmisDt, "-").substring(0, 7));
			commonDao.update("prj.tss.com.updateTssYld", input);

            //중단 완료 보고서
            input.put("goalY", goalYEnd);
            input.put("yldItmType", "03");
            input.put("arslYymm", arslYymm01);
			commonDao.update("prj.tss.com.updateTssYld", input);


		}else if("O".equals(tssScnCd)){
			//대외
			input.put("goalY", goalYStart);
			input.put("yldItmType", "01");
			input.put("arslYymm",  goalYStart + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);

            //중단 완료 보고서
            input.put("goalY", goalYEnd);
            input.put("yldItmType", "05");
            input.put("arslYymm", arslYymm01);
			commonDao.update("prj.tss.com.updateTssYld", input);

		}else if("N".equals(tssScnCd)){
			//국책
			input.put("goalY", goalYStart);
			input.put("yldItmType", "01");
			input.put("arslYymm",  goalYStart + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);

            //중단 완료 보고서
            input.put("goalY", goalYEnd);
            input.put("yldItmType", "04");
            input.put("arslYymm", arslYymm01);
			commonDao.update("prj.tss.com.updateTssYld", input);
			//개요기관
/*			for(int i = 0; i < inputListLst.size(); i++) {
				inputListLst.get(i).put("tssCd", mstDs.get("tssCd"));
				commonDao.insert("prj.tss.nat.insertNatTssPlnSmryCrroInst", inputListLst.get(i)); //개요기관 신규
			}*/

		}else if("D".equals(tssScnCd)){
			//기술
			//과제 제안서/GRS 심의서
			input.put("goalY", goalYStart);
			input.put("yldItmType", "01");
			input.put("arslYymm", goalYStart + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);


			if("00".equals(tssAttrCd)) {
				//과제속성이 제품인 경우에만 Qgate 연동
				//Qgate 1,2,3
				input.put("goalY", goalYEnd);
				input.put("arslYymm", arslYymm01);

				input.put("yldItmType", "02");
				commonDao.update("prj.tss.com.updateTssYld", input);

				input.put("yldItmType", "03");
				commonDao.update("prj.tss.com.updateTssYld", input);

				input.put("yldItmType", "04");
				commonDao.update("prj.tss.com.updateTssYld", input);
			}

			//중단 완료 보고
			input.put("yldItmType", "05");
			commonDao.update("prj.tss.com.updateTssYld", input);

		}
	}

	@Override
	public void deleteDefGrsDefInfo(HashMap<String, Object> input) {
		//GRS 기본정보 삭제
		commonDao.delete("prj.grs.deleteDefInfo", input);
	}

	@Override
	public String isBeforGrs(HashMap<String, Object> input) {
		return commonDao.select("prj.grs.selectIsBeforGrs", input);
	}
	@Override
	public List<Map<String, Object>> retrieveGrsApproval(HashMap<String, Object> input) {
		return commonDao.selectList("prj.grs.retrieveGrsApproval", input);
	}

	@Override
	public void updateApprGuid(HashMap<String, Object> input) {
		commonDao.update("prj.grs.updateApprGuid", input);
	}

	@Override
	public String getGuid(HashMap<String, Object> input) {
		return commonDao.select("prj.grs.getGuid", input);
	}

	@Override
	public String reqGrsApproval(HashMap<String, Object> input) throws Exception {
		List<Map<String, Object>> grsFileList;
		input.put("cmd", "requestApproval");

		String serverUrl = "http://" + jspProperties.getProperty("defaultUrl") + ":" + jspProperties.getProperty("serverPort") + "/" + jspProperties.getProperty("contextPath");
		StringBuffer sb = new StringBuffer();

		input = StringUtil.toUtf8Input(input);

		String tssCode = (String) input.get("tssCds");

		String[] tssCds = (NullUtil.nvl(input.get("tssCds"),"")).split(",");
		List<String> tssCdList = new ArrayList<String>();
		String commTxt = "";

		String evTitl = "";
		for(String tssCd : tssCds) {
			tssCdList.add(tssCd);
		}

		input.put("tssCdList", tssCdList);

		String guid = grsMngService.getGuid(input);

		Map<String,Object> grsApprInfo  = new HashMap<String, Object>();

		List<Map<String,Object>> grsInfo = grsMngService.retrieveGrsApproval(input);

		grsApprInfo.put("evTitl", grsInfo.get(0).get("evTitl"));
		grsApprInfo.put("cfrnAtdtCdTxtNm", grsInfo.get(0).get("cfrnAtdtCdTxtNm"));

		List<Map<String,Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", input);

		for(int i=0;i<grsInfo.size();i++) {
			sb.append("<tr>")
					.append("<th>").append(grsInfo.get(i).get("grsEvSt")).append("</th>")
					.append("<td>").append(grsInfo.get(i).get("prjNm")).append("</td>")
					.append("<td>").append(grsInfo.get(i).get("tssNm")).append("</td>")
					.append("<td>").append(grsInfo.get(i).get("saSabunName")).append("</td>")
					.append("<td>").append(grsInfo.get(i).get("tssType")).append("</td>")
					.append("<td>").append(grsInfo.get(i).get("evScr")).append("</td>")
					.append("<td>").append("PASS").append("</td>")
					.append("</tr>");
		}

		grsApprInfo.put("grsEvResult", sb.toString());

		sb.delete(0, sb.length());

		for(int i=0;i<grsInfo.size();i++) {
			commTxt = ((String)grsInfo.get(i).get("commTxt")).replaceAll("\n", "<br/>");
			evTitl = ((String)grsInfo.get(i).get("evTitl")).replaceAll("\n", "<br/>");

			sb.append("<li class='analyze_field'>")
					.append("<p class='analyze_s_txt'><b>과제명 : </b>").append(grsInfo.get(i).get("tssNm")).append("</p>")
					/* 일시, 장소 및 참석자를 위로 올림
					.append("<p class='analyze_s_txt'><b>일시, 장소 : </b>").append(grsInfo.get(i).get("evTitl")).append("</p>")
					.append("<p class='analyze_s_txt'><b>참석자 : </b>").append(grsInfo.get(i).get("cfrnAtdtCdTxtNm")).append("</p>")
					*/
					.append("<p class='analyze_s_txt'><b>주요 Comment : </b><p style='padding-left:20px; box-sizing:border-box;line-height:1.4;'>").append(commTxt).append("</p></p>");
				/* 첨부파일 주석처리
				.append("<p class='analyze_s_txt'><b>첨부파일 : </b>");

	    		input.put("attcFilId", grsInfo.get(i).get("attcFilId"));
	    		grsFileList = commonDao.selectList("common.attachFile.getAttachFileList", input);

	    		for(int j=0;j<grsFileList.size();j++) {
	    			sb.append("<a href='").append(serverUrl).append("/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=").append(grsFileList.get(j).get("attcFilId")).append("&seq=").append(grsFileList.get(j).get("seq")).append("'>").append(grsFileList.get(j).get("filNm")).append("</a>");
	    		}
	    		*/

			sb.append("</p></li>");
		}

		grsApprInfo.put("grsInfo", sb.toString());

		sb.delete(0, sb.length());

		String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/prj/grs/vm/grsApproval.vm", "UTF-8", grsApprInfo);

		Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();

		// guid= B : 신뢰성 분석의뢰, D : 신뢰성 분석완료, E : 공간성능 평가의뢰, G : 공간성능 평가완료 + rqprId
		itgRdcsInfo.put("guId", guid);
		itgRdcsInfo.put("approvalUserid", input.get("_userId"));
		itgRdcsInfo.put("approvalUsername", input.get("_userNm"));
		itgRdcsInfo.put("approvalJobtitle", input.get("_userJobxName"));
		itgRdcsInfo.put("approvalDeptname", input.get("_userDeptName"));
		itgRdcsInfo.put("body", body);
		itgRdcsInfo.put("title", "연구/개발과제 GRS 평가결과 보고의 件 ");

		commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", itgRdcsInfo);

		if(commonDao.insert("common.itgRdcs.saveItgRdcsInfo", itgRdcsInfo) == 0) {
			throw new Exception("결재요청 정보 등록 오류");
		}

		input.put("guid", guid);
		updateApprGuid(input);
		return guid;
	}
}
