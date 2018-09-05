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


	@Override
	public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input) {
		TestConsole.showMap(input);
		return commonDao.selectList("prj.tss.tctm.selectList", input);
	}

	@Override
	public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input) {
		return commonDao.select("prj.tss.tctm.selectInfo", input);
	}

	@Override
	public Map<String, Object> selectTctmTssInfoSmry(HashMap<String, String> input) {
		return commonDao.select("prj.tss.tctm.selectInfoSmry", input);
	}

	@Override
	public Map<String, Object> selectTctmTssInfoAltrI(HashMap<String, String> input) {
		return null;
	}

	@Override
	public Map<String, Object> selectTctmTssInfoCmpl(HashMap<String, String> input) {
		return null;
	}

	@Override
	public List<Map<String, Object>> selectTctmTssInfoGoal(HashMap<String, String> input) {
		return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
	}

	@Override
	public Map<String, Object> selectTctmTssInfoAltrHis(HashMap<String, String> input) {
		return null;
	}


	@Override
	public void updateTctmTssInfo(HashMap<String, Object> input) {
		TestConsole.showMap(input);
		commonDao.insert("prj.tss.tctm.updateInfo", input);
	}

	@Override
	public void updateTctmTssSmryInfo(HashMap<String, Object> input) {
		TestConsole.showMap(input);
		commonDao.insert("prj.tss.tctm.updateSmryInfo", input);
	}

	@Override
	public void updateTctmTssAltrInfo(HashMap<String, Object> input) {

	}




	@Override
	public void updateTctmTssYld(HashMap<String, Object> input) {
		//과제 제안서
		Calendar cal = Calendar.getInstance();
		int yy   = cal.get(Calendar.MONTH) + 1;

		input.put("goalY",       input.get("tssStrtDd").toString().substring(0,4));
		input.put("yldItmType", "01");
		input.put("arslYymm",  input.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(yy), 2));
		commonDao.update("prj.tss.com.updateTssYld", input);

//		String pmisDt = CommonUtil.getMonthSearch_1( CommonUtil.replace(input.get("tssFnhDd").toString(), "-", ""));

//		//지적재산권
//		input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
//		input.put("yldItmType", "05");
//		input.put("arslYymm",  CommonUtil.getFormattedDate(pmisDt, "-").substring(0, 7));
//		commonDao.update("prj.tss.com.updateTssYld", input);


		//중단 완료 보고서
		input.put("goalY",       input.get("tssFnhDd").toString().substring(0,4));
		input.put("yldItmType", "03");
		input.put("arslYymm",       input.get("tssFnhDd").toString().substring(0,7));
		commonDao.update("prj.tss.com.updateTssYld", input);
	}


	@Override
	public void deleteTctmTssInfo(HashMap<String, Object> input) {
		commonDao.delete("prj.tss.tctm.deleteInfo", input);
	}

	@Override
	public void deleteTctmTssSmryInfo(HashMap<String, Object> input) {
		commonDao.delete("prj.tss.tctm.deleteSmryInfo", input);
	}


	@Override
	public void deleteTctmTssAltrIInfo(HashMap<String, Object> input) {
		commonDao.delete("prj.tss.tctm.deleteAltrInfo", input);
	}


	@Override
	public void deleteTctmTssGoalInfo(HashMap<String, Object> input) {
		commonDao.delete("prj.tss.tctm.deleteGoalInfo", input);
	}

	@Override
	public void deleteTctmTssEv(HashMap<String, Object> input) {
		commonDao.delete("prj.tss.tctm.deleteEv", input);
	}

	@Override
	public void deleteTctmTssEvResult(HashMap<String, Object> input) {
		commonDao.delete("prj.tss.tctm.deleteEvResult", input);
	}


	@Override
	public String selectNewTssCdt(HashMap<String, Object> input) {
		return commonDao.select("prj.tss.tctm.selectNewTssCd", input);
	}

	@Override
	public List<Map<String, Object>> selectTssPlnTssYyt(HashMap<String, String> input) {
		return commonDao.selectList("prj.tss.com.retrieveTssTssYy", input);
	}

	@Override
	public Map<String, Object> selectTssCsus(Map<String, Object> input) {
		return commonDao.select("prj.tss.com.retrieveTssCsus", input);
	}


}
