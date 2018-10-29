package iris.web.fxa.rlisAnl.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("fxaRlisAnlService")
public class FxaRlisAnlServiceImpl implements FxaRlisAnlService{


	static final Logger LOGGER = LogManager.getLogger(FxaRlisAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;

	/**
	 * 자산실기간관리 목록 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaRlisAnlSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaRlisAnl.retrieveFxaRlisAnlSearchList", input);
		return resultList;
	}

	/**
	 * 자산실기간관리 신규등록
	 * @param input
	 */
	public void saveFxaRlisAnlInfo(HashMap<String, Object> input)throws Exception{
		
		List<Map<String,Object>> rfpList = new ArrayList<Map<String,Object>>();
		String fxaClassArry[] = String.valueOf(input.get("rlisFxaClss")).split(","); 
		Map<String,Object> fxaRlisMap = new HashMap<String, Object>();
		List<Map<String, Object>> rlisCrgrList = new ArrayList<Map<String,Object>>();
				
		if(commonDao.insert("fxaInfo.fxaRlisAnl.saveFxaRlisAnlInfo", input) > 0){
			//자산 담당자 정보 조회
			rlisCrgrList = commonDao.selectList("fxaInfo.fxaRlisAnl.retrieveFxaRlisCrgrList", input);
			
			for(int i=0; i < rlisCrgrList.size(); i++){
				fxaRlisMap = rlisCrgrList.get(i);
				
				input.put("deptCd", fxaRlisMap.get("deptCd"));
				input.put("wbsCd", fxaRlisMap.get("wbsCd"));
				input.put("fxaClass", fxaClassArry);
				input.put("crgrId", fxaRlisMap.get("crgrId"));
				input.put("curRlisTrmId", fxaRlisMap.get("curRlisTrmId"));
				input.put("curFxaRlisId", "");
				int fxaCnt =  commonDao.select("fxaInfo.fxaRlisAnl.retrieveFxaCnt", input); 
				
				if( fxaCnt > 0 ){
					//실사정보 저장
					int chkCount = commonDao.insert("fxaInfo.fxaRlisAnl.insertFxaRlisList", input);

					if ( chkCount > 0 ){
						 input.put("curFxaRlisId", input.get("curFxaRlisId"));
						 //LOGGER.debug("#################################curFxaRlisId#################################################### + " + input.get("curFxaRlisId"));
						 //LOGGER.debug("#################################crgrId#################################################### + " + input.get("crgrId"));
						 //to_do
						 commonDaoTodo.insert("fxaInfo.fxaRlisAnl.insertFxaRlisTodo", input);
						//실사기간과 자산매핑
						commonDao.insert("fxaInfo.fxaRlisAnl.insertFxaRlisMapp", input);
					}else{
						throw new Exception("실사정보 등록중 오류가 발생하였습니다.");
					}
					
					
					//메일발송
					
				}
			}
		}else{
			throw new Exception("실사정보 등록중 오류가 발생하였습니다.");
		}
		
		
		
	}

	/**
	 * 자산 담당자 정보 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveFxaRlisCrgrList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("fxaInfo.fxaRlisAnl.retrieveFxaRlisCrgrList", input);
		return resultList;
	}
	
	/**
	 * 실사할 자신건수 있는지 체크
	 * @param input
	 * @return
	 */
	public int retrieveFxaCnt(HashMap<String, Object> input){
		int chkCnt = commonDao.select("fxaInfo.fxaRlisAnl.retrieveFxaCnt", input); 
		return chkCnt;
	}
	
	/**
	 * 실사정보 저장
	 * @param input
	 */
	public void insertFxaRlisList(HashMap<String, Object> input){
		commonDao.insert("fxaInfo.fxaRlisAnl.insertFxaRlisList", input);
	}
	
	/**
	 * 실사기간과 자산매핑
	 * @param input
	 */
	public void insertFxaRlisMapp(HashMap<String, Object> input){
		commonDao.insert("fxaInfo.fxaRlisAnl.insertFxaRlisMapp", input);
	}

	/**
	 * to_do 정보
	 * @param input
	 */
	public void insertFxaRlisTodo(HashMap<String, Object> input){
		
	}
	
	/**
	 * 실사건이 없을 경우 삭제
	 * @param input
	 */
	public void deleteFxaRlisTrmInfo(HashMap<String, Object> input){
		commonDao.insert("fxaInfo.fxaRlisAnl.deleteFxaRlisTrmInfo", input);
	}
	
	/**
	 * 실사기간 관리 팝업 정보조회
	 * @param input
	 */
	public HashMap<String, Object> retrieveFxaRlisAnlInfo(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("fxaInfo.fxaRlisAnl.retrieveFxaRlisAnlInfo", input);
		return result;
	}
}
