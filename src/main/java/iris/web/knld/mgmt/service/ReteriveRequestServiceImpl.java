package iris.web.knld.mgmt.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : ReteriveRequestServiceImpl.java 
 * DESC : Knowledge > 관리 > 조회요청 관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("knldRtrvRqService")
public class ReteriveRequestServiceImpl implements ReteriveRequestService {
	
	static final Logger LOGGER = LogManager.getLogger(ReteriveRequestServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;
	
	
	/* 조회 요청 리스트 조회 */
	public List<Map<String, Object>> getKnldRtrvRqList(Map<String, Object> input) {
		return commonDao.selectList("knld.rtrv.rq.getKnldRtrvRqList", input);
	}

	/* 조회 요청 상세 정보 조회 */
	public Map<String, Object> getKnldRtrvRqInfo(Map<String, Object> input) {
		return commonDao.select("knld.rtrv.rq.getKnldRtrvRqInfo", input);
	}
	
	/* 조회 요청정보 저장 */
	public boolean insertKnldRtrvRq(Map<String,Object> data) throws Exception {
    	if(commonDao.insert("knld.rtrv.rq.insertKnldRtrvRq", data) == 1) {
    		data.put("rsstDocId", commonDao.select("knld.rtrv.rq.getKnldRtrvRqRsstDocId", data));
    		
    		commonDaoTodo.update("knld.rtrv.rq.saveUpMwTodoReq", data);
    		
        	return true;
    	} else {
    		throw new Exception("조회 요청정보 저장 오류");
    	}
	}
	
	/* 조회 요청 승인/반려 */
	public boolean updateApproval(Map<String, Object> data) throws Exception {
		if(commonDao.update("knld.rtrv.rq.updateApproval", data) == 1) {
			commonDaoTodo.update("knld.rtrv.rq.saveUpMwTodoReq", data);
        	return true;
    	} else {
    		throw new Exception("조회 요청 승인/반려 처리 오류");
    	}
	}
	
	/* 등록자 부서 조회*/
	public HashMap<String, Object> retrieveDeptDetail(HashMap<String, Object> input){
		return commonDao.select("knld.rtrv.rq.retrieveDeptDetail", input);
	}
	
	/* 등록자 pl 정보 조회(승인자용)*/
	public String retrieveApprInfo(HashMap<String, Object> input){
		String apprId = "";
		
		//퇴사자 및 id 유무 체크  체크
		int apprIdCnt =  commonDao.select("knld.rtrv.rq.retrieveApprCnt", input);
			
		if(apprIdCnt > 0 ){	//퇴사자
			input.put("apprId",   commonDao.select("knld.rtrv.rq.retrieveApprId", input)   );
		}else{
			//시스템 인지 확인 
			int apprIdCnt2 =  commonDao.select("knld.rtrv.rq.retrieveApprCnt2", input);
			
			if(apprIdCnt2 > 0 ){ //시스템
				input.put("apprId",   commonDao.select("knld.rtrv.rq.retrieveApprId2", input)   );
			}else{
				input.put("apprId",   commonDao.select("knld.rtrv.rq.retrieveApprId", input)   );
			}
		}
		
		apprId = (String) input.get("apprId");
		
		return apprId;
	}
	
}