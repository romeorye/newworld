package iris.web.common.itgRdcs.service;

import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.fxa.anl.service.FxaAnlServiceImpl;

@Service("itgRdcsService")
public class ItgRdcsServiceImpl implements ItgRdcsService {

	static final Logger LOGGER = LogManager.getLogger(FxaAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	/**
	 * 전자결재 정보 저장
	 * @param input
	 */
	public boolean saveItgRdcsInfo(HashMap<String, Object> input) throws Exception{
    	if(commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", input) == 1 &&
    			commonDao.update("common.itgRdcs.saveItgRdcsInfo", input) == 1) {
    		
            return true;
    	}
    	else {
    		throw new Exception("실험 상세 정보 등록 오류");
    	}
	}

	/**
	 * 전자결재 정보 삭제
	 * @param input
	 */
	public void deleteItgRdcsInfo(HashMap<String, Object> input){
		commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", input);
	}
	
	
	
	
}
