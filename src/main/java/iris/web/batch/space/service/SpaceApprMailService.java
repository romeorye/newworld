package iris.web.batch.space.service;

import java.util.HashMap;
import java.util.List;

import iris.web.space.rqpr.vo.SpaceMailInfo;

/*********************************************************************************
 * NAME : SpaceApprMailService.java 
 * DESC : 분석 결재 이메일 배치 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface SpaceApprMailService {

	/* 공간평가의뢰 요청 결재 완료 리스트 조회 */
	public List<SpaceMailInfo> getSpaceRqprApprCompleteList();

	/* 공간평가 결과 결재 완료 리스트 조회 */
	public List<SpaceMailInfo> getSpaceRsltApprCompleteList();
	
	/* 공간평가의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(SpaceMailInfo spaceMailInfo) throws Exception;
	
	/* 공간평가결과 통보 이메일 발송 */
	public boolean sendSpaceRqprResultMail(SpaceMailInfo spaceMailInfo) throws Exception;

	/* 공간평가 Todo 리스트 조회*/
	public List<HashMap<String, Object>> getSpaceRsltApprTodoList();

	/* 공간평가 Todo 정보 생성*/
	public int saveSpaceRqprTodo(HashMap<String, Object> data) throws Exception;

	public void updateSpaceTodoFlag(HashMap<String, Object> data)  throws Exception ;
}