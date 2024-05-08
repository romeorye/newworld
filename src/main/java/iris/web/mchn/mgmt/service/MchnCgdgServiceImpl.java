package iris.web.mchn.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mchnCgdgService")
public class MchnCgdgServiceImpl implements MchnCgdgService{
	static final Logger LOGGER = LogManager.getLogger(MchnCgdgServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	

	/**
	 * 분석기기 > 관리 > 소모품 관리 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveCdgsList(HashMap<String, Object> input){
		 List<Map<String, Object>> resultList = commonDao.selectList("mgmt.mchnCgds.retrieveCdgsList", input);
		 return resultList;
	}
	
	/**
	 * 소모품 신규 및 상세 조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveCdgsMst(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.mchnCgds.retrieveCdgsMst", input);
		return result;
	}

	/**
	 * 소모품 정보 저장 및 수정
	 * @param input
	 * @return
	 */
	public void saveCgdsMst(HashMap<String, Object> input){
		commonDao.update("mgmt.mchnCgds.saveCgdsMst", input);
	}
	
	/**
	 *  소모품 정보 삭제
	 * @param input
	 * @return
	 */
	public void updateCgdsMst(HashMap<String, Object> input){
		commonDao.update("mgmt.mchnCgds.updateCgdsMst", input);
	}
	
	/**
	 * 소모품입출력정보 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveCdgsMgmt(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("mgmt.mchnCgds.retrieveCdgsMgmt", input);
		 return resultList;
	}

	/**
	 * 소모품 입출력 정보 조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveCgdsMgmtPopInfo(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.mchnCgds.retrieveCgdsMgmtPopInfo", input);
		return result;
	}
	
	/**
	 * 현재고 가지고 오기
	 * @param input
	 * @return
	 */
	public int retrieveTotQty(HashMap<String, Object> input){
		return commonDao.select("mgmt.mchnCgds.retrieveTotQty", input);
	}

	/**
	 * 분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 > 팝업창 정보 저장 및 수정
	 * @param input
	 * @return
	 */
	public void saveCgdsMgmtPopInfo(HashMap<String, Object> input){
		if(input.get("whioClCd").equals("WHSN")  ){
			//입고
			commonDao.select("mgmt.mchnCgds.saveCgdsMgmtWhsn", input);
		}else{
			//출고 및 폐기
			commonDao.select("mgmt.mchnCgds.saveCgdsMgmtWhot", input);
		}
		
		//마스터 테이블 업데이트	
		commonDao.select("mgmt.mchnCgds.updateCgdsQtyMst", input);
	}
}
