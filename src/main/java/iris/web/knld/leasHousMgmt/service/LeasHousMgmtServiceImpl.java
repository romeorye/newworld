package iris.web.knld.leasHousMgmt.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("leasHousMgmtService")
public class LeasHousMgmtServiceImpl implements LeasHousMgmtService {

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	static final Logger LOGGER = LogManager.getLogger(LeasHousMgmtServiceImpl.class);
	
	
	/**
     * 임차주택관리 > 필수첨부파일 리스트 조회
     *
     * @return ModelAndView
     * */
	public Map<String, Object> retrieveAttchFilInfo(HashMap<String, Object> input){
		return commonDao.select("knld.leasHousMgmt.retrieveAttchFilInfo", input); 
	}
	
	/**
     * 임차주택관리 > 필수첨부파일 저장
     *
     * @return ModelAndView
	 * @throws Exception 
     * */
	public void saveAttchFil(Map<String, Object> map) throws Exception {
		commonDao.delete("knld.leasHousMgmt.deleteLeashousAttchFil", map);
		
		if (  commonDao.insert("knld.leasHousMgmt.insertLeashousattchfil", map) > 0){
			
		}else{
			throw new Exception("저장중 오류가 발생했습니다");
		}
		
	}

}
