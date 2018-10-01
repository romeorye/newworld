package iris.web.prj.grs.service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.util.CommonUtil;
import iris.web.tssbatch.service.TssStCopyService;
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
		String tssScnCd = (String) input.get("tssScnCd");

		//GRS 기본정보 과제 관리 마스터로 복제
		commonDao.insert("prj.grs.moveGrsDefInfo", input);

		// 발의, 연구 기본값 세팅
		input.put("ppslMbdCd", "02"); // 사업부
//		input.put("rsstSphe", "");
		commonDao.insert("prj.grs.updateGrsDefInfo02", input);


		if("N".equals(input.get("grsYn"))){
			//GRS(P1)을 하지 않는 경우
			//WBS 코드 생성 및 등록
			String wbsCd = tssStCopyService.createWbsCd(input);
			input.put("wbsCd", wbsCd);
			commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
		}

		//GRS 기본정보 과제 서머리 마스터로 복제
		commonDao.insert("prj.grs.moveGrsDefSmry", input);

		//GRS 기본정보 삭제
		commonDao.delete("prj.grs.deleteDefInfo", input);

		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int yy = cal.get(Calendar.MONTH) + 1;

		//산출물 등록
		if(tssScnCd.equals("G")){
			//일반
			input.put("goalY",       input.get("tssStrtDd").toString().substring(0,4));
			input.put("yldItmType", "01");
			input.put("arslYymm",  input.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(yy), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);

			String pmisDt = CommonUtil.getMonthSearch_1( CommonUtil.replace(input.get("tssFnhDd").toString(), "-", ""));

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
			input.put("goalY",      year);
			input.put("yldItmType", "01");
			input.put("arslYymm",   year + "-" + yy);

			commonDao.update("prj.tss.com.updateTssYld", input);

		}else if(tssScnCd.equals("N")){
			//국책
			input.put("goalY",      year);
			input.put("yldItmType", "01");
			input.put("arslYymm",   year + "-" + yy);

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
			input.put("arslYymm", input.get("tssStrtDd").toString().substring(0, 4) + "-" + CommonUtil.getZeroAddition(String.valueOf(yy), 2));
			commonDao.update("prj.tss.com.updateTssYld", input);

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

	@Override
	public String isBeforGrs(HashMap<String, Object> input) {
		return commonDao.select("prj.grs.selectIsBeforGrs", input);
	}

}
