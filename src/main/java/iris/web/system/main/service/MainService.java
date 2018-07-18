package iris.web.system.main.service;

import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : MainService.java
 * DESC : PROJECT 메인 service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.19  IRIS04	최초생성
 *********************************************************************************/

public interface MainService {
	
	/* 프로젝트메인 공지사항 조회 */
	public List<Map<String, Object>> retrievePrjMainNoticeList();
	
	/* 프로젝트메인 QnA 조회 */
	public List<Map<String, Object>> retrievePrjMainQnaList();
	
	/* 프로젝트메인 연구소 금주,차주일정 조회 */
	public List<Map<String, Object>> retrievePrjMainScheduleList();
	
	/* 분석메인  승인요청, 접수대기, 완료, 새의견 건수 조회 */
	public Map<String,Object> getAnlCntInfo1(Map<String, Object> input);
	
	/* 분석메인  (전월 미완료, 이번달 접수, 이번달 진행, 이번달 완료) 건수, 분석완료율  조회 */
	public Map<String,Object> getAnlCntInfo2(Map<String, Object> input);
	
	/* 분석메인 일반사용자 분석의뢰 리스트  조회 */
	public List<Map<String,Object>> getAnlRqprList(Map<String, Object> input);
	
	/* 분석메인 일반사용자 분석기기 교육신청 리스트  조회 */
	public List<Map<String,Object>> getAnlMchnEduReqList(Map<String, Object> input);
	
	/* 분석메인 일반사용자 기기신청 리스트  조회 */
	public List<Map<String,Object>> getAnlMchnReqList(Map<String, Object> input);
	
	/* 분석메인 공지사항 리스트  조회 */
	public List<Map<String,Object>> getAnlNoticeList();
	
	/* 분석메인 설정된 분석기기 리스트  조회 */
	public List<Map<String,Object>> getAnlMchnSettingList();
	
	/* 분석메인 분석기기 예약현황 리스트  조회 */
	public List<Map<String,Object>> getAnlMchnReservList(Map<String, Object> input);
	
	/* 분석메인 교육 신청 리스트  조회 */
	public List<Map<String,Object>> getAnlEduReqList();
	
	/* 분석메인 주요 분석 자료 리스트  조회 */
	public List<Map<String,Object>> getAnlMainDataList();
	
	/* 프로젝트 메인 GRS요청개수, 품의요청개수 조회 */
	public Map<String,Object> retrieveUserTssReqCntInfo(Map<String, Object> input);

}
