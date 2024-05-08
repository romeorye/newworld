package iris.web.rlab.batch.service;

import java.util.HashMap;
import java.util.List;

import iris.web.rlab.rqpr.vo.RlabMailInfo;

/*********************************************************************************
 * NAME : RlabApprMailService.java 
 * DESC : 분석 결재 이메일 배치 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2018.07.30  정현웅	최초생성                 
 *********************************************************************************/

public interface RlabApprMailService {

	/* 신뢰성 시험의뢰 요청 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRqprApprCompleteList();

	/* 신뢰성 시험 결과 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRsltApprCompleteList();
	
	/* 신뢰성 시험의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(RlabMailInfo rlabMailInfo) throws Exception;
	
	/* 신뢰성 시험결과 통보 이메일 발송 */
	public boolean sendRlabRqprResultMail(RlabMailInfo rlabMailInfo) throws Exception;

	/* 신뢰성 시험결과 Todo 리스트 조회*/
	public List<HashMap<String, Object>> getRlabRqprApprTodoList();

	/* 신뢰성 시험결과 Todo 전송*/
	public int saveRlabRqprTodo(HashMap<String, Object> data) throws Exception;

	public void updateRlabTodoFlag(HashMap<String, Object> data) throws Exception;
	
}