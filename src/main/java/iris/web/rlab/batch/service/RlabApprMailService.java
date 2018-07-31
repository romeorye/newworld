package iris.web.rlab.batch.service;

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

	/* 분석의뢰 요청 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRqprApprCompleteList();

	/* 분석 결과 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRsltApprCompleteList();
	
	/* 분석의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(RlabMailInfo rlabMailInfo) throws Exception;
	
	/* 분석결과 통보 이메일 발송 */
	public boolean sendRlabRqprResultMail(RlabMailInfo rlabMailInfo) throws Exception;
}