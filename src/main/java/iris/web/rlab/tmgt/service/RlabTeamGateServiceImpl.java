package iris.web.rlab.tmgt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("rlabTeamGateService")
public class RlabTeamGateServiceImpl  implements RlabTeamGateService{

	static final Logger LOGGER = LogManager.getLogger(RlabTeamGateServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;


	/* team gate 리스트 조회 */
	public List<Map<String, Object>> rlabTeamGateList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("rlab.tmgt.rlabTeamGateList", input);
	    return resultList;
	}

	/* team gate 상세조회*/
	public HashMap<String, Object> rlabTeamGateDtl(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("rlab.tmgt.rlabTeamGateDtl", input);
		return result;
	}

	/* team gate 결과상세조회*/
	public HashMap<String, Object> rlabTeamGateCmplDtl(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("rlab.tmgt.rlabTeamGateCmplDtl", input);
		return result;
	}

	/* team gate 등록  */
	public void saveRlabTeamGate(HashMap<String, Object> input){
		commonDao.insert("rlab.tmgt.insertRlabTeamGate", input);
	}

	/* team gate 임시저장  */
	public void saveTempRlabTeamGateEv(HashMap<String, Object> input){
		commonDao.update("rlab.tmgt.saveTempRlabTeamGateEv", input);
	}

	/* team gate 평가  */
	public void saveRlabTeamGateEv(HashMap<String, Object> input){
		commonDao.update("rlab.tmgt.saveRlabTeamGateEv", input);
	}

	/* team gate 투표완료  */
	public void saveRlabTeamGateEvCmpl(HashMap<String, Object> input){
		commonDao.update("rlab.tmgt.saveRlabTeamGateEvCmpl", input);
	}

	/* team gate 투표수정  */
	public void saveRlabTeamGateEvReg(HashMap<String, Object> input){
		commonDao.update("rlab.tmgt.saveRlabTeamGateEvReg", input);
	}

	/* team gate 삭제  */
	public void delRlabTeamGateEvReg(HashMap<String, Object> input){
		commonDao.update("rlab.tmgt.delRlabTeamGateEvReg", input);
	}
}
