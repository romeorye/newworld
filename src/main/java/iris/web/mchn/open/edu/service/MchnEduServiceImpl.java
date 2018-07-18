package iris.web.mchn.open.edu.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mchnEduService")
public class MchnEduServiceImpl implements MchnEduService{

	@Resource(name="commonDao")
	private CommonDao commonDao;
	static final Logger LOGGER = LogManager.getLogger(MchnEduServiceImpl.class);


	/**
	 *  open기기 > 기기교육 > 기기교육목록조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveMchnEduSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("open.mchnEdu.retrieveMchnEduSearchList", input);
		return resultList;
	}

	/**
	 * open기기 > 기기교육 > 기기교육상세화면
	 * @param input
	 * @return
	 */
	public Map<String, Object> retrieveEduInfo(HashMap<String, Object> input){
		HashMap<String, Object> rtnMap = commonDao.select("open.mchnEdu.retrieveEduInfo", input);

		input.put("mchnInfoId", rtnMap.get("mchnInfoId"));
		input.put("rgstId", input.get("_userSabun"));
		
		HashMap<String, Object> eduMap = new HashMap<String, Object>();
		eduMap = commonDao.select("open.mchnInfo.retrieveMchnEduInfo", input); 
		

		if( eduMap != null  ){
			rtnMap.put("ccsDt", eduMap.get("ccsDt"));
			rtnMap.put("eduStNm", eduMap.get("eduStNm"));
			rtnMap.put("eduStCd", eduMap.get("eduStCd"));
		}
	    return rtnMap;
	}

	/**
	 *open기기 > 기기교육 > 기기교육신청 등록 
	 * @param input
	 * @return
	 */
	public void insertEduInfoDetail(HashMap<String, Object> input){
		commonDao.insert("open.mchnEdu.insertEduInfoDetail", input);
	}

	/* open기기 > 기기교육 > 기기교육 신청 건수 체크*/
	public int retrieveEduInfoCnt(HashMap<String, Object> input){
		return commonDao.select("open.mchnEdu.retrieveEduInfoCnt", input);
	}
	
	/**
	 *open기기 > 기기교육 > 기기교육신청 취소 
	 * @param input
	 * @return
	 */
	public void updateEduCancel(HashMap<String, Object> input){
		commonDao.update("open.mchnEdu.updateEduCancel", input);
	}
}
