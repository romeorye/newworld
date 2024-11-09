package iris.web.batch.anl.service;

import java.util.List;

import iris.web.anl.rqpr.vo.AnlMailInfo;

/*********************************************************************************
 * NAME : AnlApprMailService.java 
 * DESC : 분석 결재 이메일 배치 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface AnlApprMailService {

	/* 분석의뢰 요청 결재 완료 리스트 조회 */
	public List<AnlMailInfo> getAnlRqprApprCompleteList();

	/* 분석 결과 결재 완료 리스트 조회 */
	public List<AnlMailInfo> getAnlRsltApprCompleteList();
	
	/* 분석의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(AnlMailInfo anlMailInfo) throws Exception;
	
	/* 분석결과 통보 이메일 발송 */
	public boolean sendAnlRqprResultMail(AnlMailInfo anlMailInfo) throws Exception;
}