package iris.web.prj.grs.service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.util.CommonUtil;
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


		LOGGER.debug( tssScnCd.equals('N'));
		LOGGER.debug( tssScnCd.equals("N"));
		if(tssScnCd.equals("N")){
			// 국책인경우 1년차수 입력
			input.put("tssNosSt", "1");
		}

		//GRS 기본정보 과제 관리 마스터로 복제
		commonDao.insert("prj.grs.moveGrsDefInfo", input);



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
		input.put("ppslMbdCd", "02"); // 사업부
		input.put("rsstSphe", rsstSphe);
		commonDao.insert("prj.grs.updateGrsDefInfo02", input);


		if("N".equals(input.get("grsYn"))){
			//GRS(P1)을 하지 않는 경우
			//WBS 코드 생성 및 등록
			String wbsCd = tssStCopyService.createWbsCd(input);
			input.put("wbsCd", wbsCd);
			commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
		}

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
