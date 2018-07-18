package iris.web.prj.tss.opnInno.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("opnInnovationService")
public class OpnInnovationServiceImpl implements OpnInnovationService {

	static final Logger LOGGER = LogManager.getLogger(OpnInnovationServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	/**
	 *  open innovation 협력과제 관리 리스트조회
	 */
	public List<Map<String, Object>> retrieveOpnInnoSearchList(HashMap<String, Object> input){
		return commonDao.selectList("prj.tss.opnInno.retrieveOpnInnoSearchList" ,  input);
	}
	
	/**
	 *  open innovation 협력과제 정보 등록(수정) 정보 조회
	 */
	public Map<String, Object> retrieveOpnInnoInfo(HashMap<String, Object> input){
		return commonDao.select("prj.tss.opnInno.retrieveOpnInnoInfo" ,  input);
	}
	
	/**
	 *  open innovation 협력과제 정보 저장
	 */
	public void saveOpnInnoInfo(Map<String, Object> saveDataSet){
		commonDao.update("prj.tss.opnInno.saveOpnInnoInfo" ,  saveDataSet);
	}
	
	/**
	 *  open innovation 협력과제 정보 삭제
	 */
	public void deleteOpnInnoInfo(HashMap<String, Object> input){
		commonDao.update("prj.tss.opnInno.deleteOpnInnoInfo" ,  input);
	}
}
