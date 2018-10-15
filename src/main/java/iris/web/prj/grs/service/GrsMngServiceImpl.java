package iris.web.prj.grs.service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.tssbatch.service.TssStCopyService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("grsMngService")
public class GrsMngServiceImpl implements GrsMngService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;

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
	public int updateGrsInfo(Map<String, Object> input) {
		return commonDao.insert("prj.grs.updateGrsInfo", input);
	}

	@Override
	public Map<String, String> saveGrsInfo(HashMap<String, Object> input) {
		HashMap<String, String> result = new HashMap<String, String>();
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

			// mchnCgdgService.saveCgdsMst(input);
			updateGrsInfo(input);                                                        //과제 기본정보 등록
			input.put("tssCd", input.get("newTssCd"));


			if (grsYn.equals("Y")) {
				LOGGER.debug("=============== GRS=Y 인경우 GRS 요청정보 생성 ===============");
				input.put("grsEvSt", "P1");
				input.put("dlbrCrgr", input.get("_userId"));
				updateGrsReqInfo(input);                                            //GRS 정보 등록
			}else if (grsYn.equals("N")) {
				LOGGER.debug("=============== GRS 미수행시 마스터 이관 ===============");
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


		if(tssScnCd.equals("N")){
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
			commonDao.insert("prj.grs.updateGrsDefInfo02", input);
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
		if(tssScnCd.equals("G")){
			//일반
			//과제 제안서
            String pmisDt = CommonUtil.getMonthSearch_1( CommonUtil.replace(input.get("tssFnhDd").toString(), "-", ""));
            
            input.put("goalY",       input.get("tssStrtDd").toString().substring(0,4));
            input.put("yldItmType", "01");
            input.put("arslYymm",  input.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);



            if(tssAttrCd.equals("00")){
            	//과제속성이 제품인 경우에만 Qgate 연동
				//qgate1
				input.put("goalY",       input.get("tssStrtDd").toString().substring(0,4));
				input.put("yldItmType", "06");
				input.put("arslYymm",  input.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
				commonDao.update("prj.tss.com.updateTssYld", input);

				//qgate2
				input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
				input.put("yldItmType", "07");
				input.put("arslYymm",    input.get("tssFnhDd").toString().substring(0,7));
				commonDao.update("prj.tss.com.updateTssYld", input);

				//qgate3
				input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
				input.put("yldItmType", "08");
				input.put("arslYymm",    input.get("tssFnhDd").toString().substring(0,7));
				commonDao.update("prj.tss.com.updateTssYld", input);
			}

            //지적재산권 
            input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
            input.put("yldItmType", "05");
            input.put("arslYymm",  CommonUtil.getFormattedDate(pmisDt, "-").substring(0, 7));
			commonDao.update("prj.tss.com.updateTssYld", input);
            
            //중단 완료 보고서
            input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
            input.put("yldItmType", "03");
            input.put("arslYymm",       input.get("tssFnhDd").toString().substring(0,7));
			commonDao.update("prj.tss.com.updateTssYld", input);


		}else if(tssScnCd.equals("O")){
			//대외
			input.put("goalY",       input.get("tssStrtDd").toString().substring(0,4));
			input.put("yldItmType", "01");
			input.put("arslYymm",  input.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);
            
            //중단 완료 보고서
            input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
            input.put("yldItmType", "05");
            input.put("arslYymm",       input.get("tssFnhDd").toString().substring(0,7));
			commonDao.update("prj.tss.com.updateTssYld", input);

		}else if(tssScnCd.equals("N")){
			//국책
			input.put("goalY",       input.get("tssStrtDd").toString().substring(0,4));
			input.put("yldItmType", "01");
			input.put("arslYymm",  input.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);
            
            //중단 완료 보고서
            input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
            input.put("yldItmType", "04");
            input.put("arslYymm",    input.get("tssFnhDd").toString().substring(0,7));
			commonDao.update("prj.tss.com.updateTssYld", input);
			//개요기관
/*			for(int i = 0; i < inputListLst.size(); i++) {
				inputListLst.get(i).put("tssCd", mstDs.get("tssCd"));
				commonDao.insert("prj.tss.nat.insertNatTssPlnSmryCrroInst", inputListLst.get(i)); //개요기관 신규
			}*/

		}else if(tssScnCd.equals("D")){
			//기술
			//과제 제안서/GRS 심의서
			input.put("goalY", input.get("tssStrtDd").toString().substring(0, 4));
			input.put("yldItmType", "01");
			input.put("arslYymm", input.get("tssStrtDd").toString().substring(0, 4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);


			if(tssAttrCd.equals("00")) {
				//과제속성이 제품인 경우에만 Qgate 연동
				//Qgate 1,2,3
				input.put("goalY", input.get("tssFnhDd").toString().substring(0, 4));
				input.put("arslYymm", input.get("tssFnhDd").toString().substring(0, 7));

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

}
