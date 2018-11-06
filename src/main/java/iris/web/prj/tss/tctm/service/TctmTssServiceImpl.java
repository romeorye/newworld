package iris.web.prj.tss.tctm.service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.TestConsole;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("tctmTssService")
public class TctmTssServiceImpl implements TctmTssService {

	static final Logger LOGGER = LogManager.getLogger(TctmTssServiceImpl.class);

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	private final String tctmPack = "prj.tss.tctm";

	/*과제*/
	@Override
	public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input) {
		TestConsole.showMap(input);
		return commonDao.selectList(tctmPack + ".selectList", input);
	}

	@Override
	public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input) {
		return commonDao.select(tctmPack + ".selectInfo", input);
	}

	@Override
	public void updateTctmTssInfo(HashMap<String, Object> input) {
		TestConsole.showMap(input);
		commonDao.insert(tctmPack + ".updateInfo", input);
	}

	@Override
	public void deleteTctmTssInfo(HashMap<String, String> input) {
		commonDao.delete(tctmPack + ".deleteInfo", input);
		commonDao.delete(tctmPack + ".deleteEv", input);
		commonDao.delete(tctmPack + ".deleteEvResult", input);
		deleteTctmTssSmryInfo(input);
		deleteTctmTssGoalInfo(input);
	}

	@Override
	public void duplicateTctmTssInfo(HashMap<String, Object> input) {
		commonDao.insert(tctmPack + ".duplicateInfo", input);
	}

	@Override
	public void updateTctmTssInfoCmpl(HashMap<String, Object> input) {
		commonDao.update(tctmPack + ".updateInfoCmpl", input);
	}

	@Override
	public void updateTctmTssInfoDcac(HashMap<String, Object> input) {
		commonDao.update(tctmPack + ".updateInfoDcac", input);
	}


	/*개요*/
	@Override
	public Map<String, Object> selectTctmTssInfoSmry(HashMap<String, String> input) {
		return commonDao.select(tctmPack + ".selectInfoSmry", input);
	}

	@Override
	public void updateTctmTssSmryInfo(HashMap<String, Object> input) {
		commonDao.insert(tctmPack + ".updateSmryInfo", input);
	}

	@Override
	public void deleteTctmTssSmryInfo(HashMap<String, String> input) {
		commonDao.delete(tctmPack + ".deleteSmryInfo", input);
	}

	@Override
	public void duplicateTctmTssSmryInfo(HashMap<String, Object> input) {
		commonDao.insert(tctmPack + ".duplicateSmryInfo", input);
	}

	@Override
	public void updateTctmTssSmryInfoCmpl(HashMap<String, Object> input) {
		commonDao.update(tctmPack + ".updateSmryInfoCmpl", input);
	}

	@Override
	public void updateTctmTssSmryInfoDcac(HashMap<String, Object> input) {
		commonDao.update(tctmPack + ".updateSmryInfoDcac", input);
	}


	/*산출물*/
	@Override
	public void updateTctmTssYld(HashMap<String, Object> input) {
		String tssAttrCd = (String) input.get("tssAttrCd");
		Calendar cal = Calendar.getInstance();
		int yy = cal.get(Calendar.MONTH) + 1;

		//과제 제안서/GRS 심의서

		input.put("goalY", input.get("tssStrtDd").toString().substring(0, 4));
		input.put("yldItmType", "01");
		input.put("arslYymm", input.get("tssStrtDd").toString().substring(0, 4) + "-" + CommonUtil.getZeroAddition(String.valueOf(yy), 2));
		commonDao.update("prj.tss.com.updateTssYld", input);


		if(tssAttrCd.equals("00")) {
			//과제속성이 제품인 경우에만 Qgate 연동
			//Qgate 1,2,3
			input.put("goalY", input.get("tssFnhDd").toString().substring(0, 4));
			input.put("yldItmType", "02");
			input.put("arslYymm", input.get("tssFnhDd").toString().substring(0, 7));
			commonDao.update("prj.tss.com.updateTssYld", input);
			input.put("goalY", input.get("tssFnhDd").toString().substring(0, 4));
			input.put("yldItmType", "03");
			input.put("arslYymm", input.get("tssFnhDd").toString().substring(0, 7));
			commonDao.update("prj.tss.com.updateTssYld", input);
			input.put("goalY", input.get("tssFnhDd").toString().substring(0, 4));
			input.put("yldItmType", "04");
			input.put("arslYymm", input.get("tssFnhDd").toString().substring(0, 7));
			commonDao.update("prj.tss.com.updateTssYld", input);
		}
		input.put("yldItmType", "05");
		input.put("arslYymm", input.get("tssFnhDd").toString().substring(0, 7));
		commonDao.update("prj.tss.com.updateTssYld", input);


	}

	@Override
	public void updateYldFile(HashMap<String, Object> input) {
		commonDao.update(tctmPack + ".updateYldFile", input);
	}

	@Override
	public void deleteTctmTssGoalInfo(HashMap<String, String> input) {
		commonDao.delete(tctmPack + ".deleteGoalInfo", input);
	}


	/*변경개요*/
	@Override
	public List<Map<String, Object>> selectTctmTssInfoAltrList(HashMap<String, String> input) {
		return commonDao.selectList(tctmPack + ".selectAltrList", input);
	}

	@Override
	public void updateTctmTssInfoAltrSmry(HashMap<String, Object> input, HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs) {
//		commonDao.update(tctmPack + ".updateAltrSmrySmry", input);

		String pgsStepCd = (String) mstDs.get("pgsStepCd");

		if ("PG".equals(pgsStepCd)) {
			//변경 신규
			mstDs.put("createMod", "Altr");
			mstDs.put("pgsStepCd", "AL");

			int mstCnt = commonDao.insert("prj.tss.com.insertTssMst", mstDs);	// 마스터 복제 (변경)

			if (mstCnt > 0) {
				String tssCd = String.valueOf(mstDs.get("tssCd"));

				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("tssCd", mstDs.get("pgTssCd"));
				map.put("userId", mstDs.get("userId"));

				if ("100".equals(String.valueOf(mstDs.get("pgTssSt")))) {
					map.put("tssSt", "201"); //진행화면 -> 변경요청
				} else {
					map.put("tssSt", "202"); //GRS완료후 변경생성
				}

				commonDao.update("prj.tss.com.updateTssMstTssSt", map); // 진행과제 상태코드 변경
				mstDs.put("pgTssSt", map.get("tssSt"));

				for (int i = 0; i < altrDs.size(); i++) {
					altrDs.get(i).put("tssCd", tssCd);
				}
				commonDao.batchUpdate("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs); //변경목록 저장


				//개요 첨부파일ID 신규생성
				HashMap<String, Object> attachFile = commonDao.select(tctmPack +".selectSmryFileId", mstDs);
				if (attachFile!=null && !attachFile.isEmpty()) {
					attachFile.put("userId", mstDs.get("userId"));
					commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
					smryDs.put("attcFilId", attachFile.get("newAttcFilId"));
				}

				smryDs.put("newTssCd", tssCd);
				smryDs.put("tssCd", mstDs.get("pgTssCd"));
				commonDao.insert(tctmPack + ".duplicateSmryInfo", smryDs);  			//변경 개요  복제

				smryDs.put("tssCd", tssCd);
				smryDs.put("pgTssCd", mstDs.get("pgTssCd"));
				commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", smryDs);    //산출물 복제

				//산출물 첨부파일ID 신규생성
				HashMap<String, Object> yldMap = new HashMap<String, Object>();
				yldMap.put("tssCd", smryDs.get("tssCd"));
				yldMap.put("newAttcFilId", smryDs.get("attcFilId"));
				yldMap.put("gbn", "Y");
				yldMap.put("userId", smryDs.get("userId"));
				commonDao.select("prj.tss.com.insertTssAttcFilIdCreate", yldMap);
			}
		} else if ("AL".equals(pgsStepCd)) {
			//변경 수정
			commonDao.update("prj.tss.com.updateTssMst", mstDs);    				// 마스터 수정
			commonDao.update(tctmPack + ".updateSmryInfoAltrRson", smryDs); //변경 사유 반영

			for (int i = 0; i < altrDs.size(); i++) {
				//삭제
				if ("3".equals(altrDs.get(i).get("duistate"))) {
					commonDao.delete("prj.tss.gen.altr.deleteGenTssAltrSmryList", altrDs.get(i));
				}
				//신규,수정
				else {
					commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs.get(i));
				}
			}
		}
	}

	@Override
	public void cancelTctmTssInfoAltrSmry(HashMap<String, String> input) {
		HashMap<String,String> stTssCd = commonDao.select(tctmPack + ".selectStTssCd", input);

		input.put("tssCd", stTssCd.get("alTssCd"));
		//변경 마스터 삭제
		commonDao.delete(tctmPack +".deleteInfo",input);
		//변경서머리 삭제
		commonDao.delete(tctmPack +".deleteSmryInfo",input);
		//변경 산출물 삭제
		commonDao.delete(tctmPack +".deleteGoalInfo",input);
		//변경개요 목록 삭제
		commonDao.delete(tctmPack +".deleteAltrInfo",input);
		//GRS 평가표 삭제
		commonDao.delete(tctmPack +".deleteEv",input);
		//GRS 평가내역 삭제
		commonDao.delete(tctmPack +".deleteEvResult",input);


		input.put("tssCd", stTssCd.get("pgTssCd"));
		input.put("tssSt", "100");
		//진행 마스터 TssSt 100으로 변경
		commonDao.update("prj.tss.com.updateTssMstTssSt", input);

	}


	/*변경이력*/
	@Override
	public List<Map<String, Object>> selectInfoAltrHisListAll(HashMap<String, String> input) {
		return commonDao.selectList(tctmPack + ".selectInfoAltrHisListAll", input);
	}

	@Override
	public List<Map<String, Object>> selectInfoAltrHisList(HashMap<String, Object> input) {
		return commonDao.selectList(tctmPack + ".selectInfoAltrHisList", input);
	}

	@Override
	public Map<String, Object> selectInfoAltrHisInfo(HashMap<String, Object> input) {
		return commonDao.select(tctmPack + ".selectInfoAltrHisInfo", input);
	}


	@Override
	public Map<String, Object> selectTctmTssInfoCmpl(HashMap<String, String> input) {
		return null;
	}

	@Override
	public List<Map<String, Object>> selectTctmTssInfoGoal(HashMap<String, String> input) {
		return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
	}


	/*GRS*/
	@Override
	public void deleteTctmTssEv(HashMap<String, Object> input) {
		commonDao.delete(tctmPack + ".deleteEv", input);
	}

	@Override
	public void deleteTctmTssEvResult(HashMap<String, Object> input) {
		commonDao.delete(tctmPack + ".deleteEvResult", input);
	}


	@Override
	public String selectNewTssCdt(HashMap<String, Object> input) {
		return commonDao.select(tctmPack + ".selectNewTssCd", input);
	}

	@Override
	public List<Map<String, Object>> selectTssPlnTssYyt(HashMap<String, String> input) {
		return commonDao.selectList("prj.tss.com.retrieveTssTssYy", input);
	}

	@Override
	public Map<String, Object> selectTssCsus(Map<String, Object> input) {
		return commonDao.select("prj.tss.com.retrieveTssCsus", input);
	}

	@Override
	public List<Map<String, Object>> selectAttachFileList(HashMap<String, String> input) {
		return commonDao.selectList("common.attachFile.getAttachFileList", input);
	}

	@Override
	public Map<String, Object> selectCsus(Map<String, Object> input) {
		return commonDao.select("prj.tss.com.retrieveTssCsus", input);
	}

}
