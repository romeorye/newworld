package iris.web.knld.mgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ReteriveRequestService.java 
 * DESC : Knowledge > 관리 > 조회요청 관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface ReteriveRequestService {

	/* 조회 요청 리스트 조회 */
	public List<Map<String, Object>> getKnldRtrvRqList(Map<String, Object> input);

	/* 조회 요청 상세 정보 조회 */
	public Map<String, Object> getKnldRtrvRqInfo(Map<String, Object> input);
	
	/* 조회 요청정보 저장 */
	public boolean insertKnldRtrvRq(Map<String,Object> data) throws Exception;
	
	/* 조회 요청 승인/반려 */
	public boolean updateApproval(Map<String, Object> data) throws Exception;

	/* 등록자 부서 조회*/
	public HashMap<String, Object> retrieveDeptDetail(HashMap<String, Object> input);

	/* 등록자 pl 정보 조회(승인자용)*/
	public String retrieveApprInfo(HashMap<String, Object> input);
}