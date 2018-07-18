package iris.web.stat.code.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("comCodeService")
public class ComCodeServiceImpl  implements ComCodeService{

	static final Logger LOGGER = LogManager.getLogger(ComCodeServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	
	
	/**
	 * 통계 > 공통코드 관리 >공통코드 관리 리스트 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveCcomCodeList(HashMap<String, Object> input){
		return commonDao.selectList("stat.code.retrieveCcomCodeList", input);
	}
	
	/**
	 * 통계 > 공통코드 관리 >공통코드 등록 및 수정
	 * @param input
	 * @return
	 */
	public void saveCodeInfo(List<Map<String, Object>> codeList){
		commonDao.batchUpdate("stat.code.saveCodeInfo", codeList);
	}
	
	
	
}
