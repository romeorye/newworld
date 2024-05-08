package iris.web.knld.nrm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.knld.pub.service.ConferenceServiceImpl;

@Service("nrmInfoService")
public class NrmInfoServiceImpl implements NrmInfoService{

	static final Logger LOGGER = LogManager.getLogger(ConferenceServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	
	/**
	 *  규격 리스트 조회
	 */
	public List<Map<String, Object>> retrieveNrmSearchList(HashMap<String, Object> input){
		// TODO Auto-generated method stub
		return commonDao.selectList("knld.nrm.retrieveNrmSearchList", input);
	}
	
	
	/**
	 * 규격 상세정보 조회
	 */
	public Map<String, Object> retrieveNrmInfo(HashMap<String, Object> input){
		
		return commonDao.select("knld.nrm.retrieveNrmInfo", input);
	}
	
	
	public void saveNrmInfo(Map<String, Object> nrmInfo) throws Exception {
	
		if(commonDao.update("knld.nrm.saveNrmInfo", nrmInfo) > 0 ){
			
		}else{
			throw new Exception("저장중 오류가 발생했습니다.");
		}
	
	
	}
}
