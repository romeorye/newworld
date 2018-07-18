package iris.web.system.main.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;
import iris.web.common.util.CommonUtil;

/********************************************************************************
 * NAME : MainServiceImpl.java
 * DESC : PROJECT 메인 service implement
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.19  IRIS04	최초생성
 *********************************************************************************/

@Service("mainService")
public class MainServiceImpl implements  MainService{

	static final Logger LOGGER = LogManager.getLogger(MainServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 프로젝트메인 공지사항 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjMainNoticeList() {

		List<Map<String, Object>> noticeList = commonDao.selectList("main.retrievePrjMainNoticeList");

    	for(Map<String, Object> data : noticeList) {
    		data.put("bbsSbc" , CommonUtil.stripHTML(NullUtil.nvl(data.get("bbsSbc"), "")));
    	}

    	return noticeList;
	}

	/* 프로젝트메인 QnA 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjMainQnaList() {
		return commonDao.selectList("main.retrievePrjMainQnaList");
	}

	/* 프로젝트메인 연구소 금주,차주일정 조회 */
	@Override
	public List<Map<String, Object>> retrievePrjMainScheduleList() {
		return commonDao.selectList("main.retrievePrjMainScheduleList");
	}

	/* 분석메인  승인요청, 접수대기, 완료, 새의견 건수 조회 */
	@Override
	public Map<String,Object> getAnlCntInfo1(Map<String, Object> input) {
		return commonDao.select("main.getAnlCntInfo1", input);
	}

	/* 분석메인  (전월 미완료, 이번달 접수, 이번달 진행, 이번달 완료) 건수, 분석완료율  조회 */
	@Override
	public Map<String,Object> getAnlCntInfo2(Map<String, Object> input) {
		return commonDao.select("main.getAnlCntInfo2", input);
	}

	/* 분석메인 일반사용자 분석의뢰 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlRqprList(Map<String, Object> input) {
		return commonDao.selectList("main.getAnlRqprList", input);
	}

	/* 분석메인 일반사용자 분석기기 교육신청 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlMchnEduReqList(Map<String, Object> input) {
		return commonDao.selectList("main.getAnlMchnEduReqList", input);
	}

	/* 분석메인 일반사용자 기기신청 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlMchnReqList(Map<String, Object> input) {
		return commonDao.selectList("main.getAnlMchnReqList", input);
	}

	/* 분석메인 공지사항 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlNoticeList() {

		List<Map<String, Object>> anlNoticeList = commonDao.selectList("main.getAnlNoticeList");

	/*
    	for(Map<String, Object> data : anlNoticeList) {
    		data.put("bbsSbc" , CommonUtil.stripHTML(NullUtil.nvl(data.get("bbsSbc"), "")));
    	}
*/
    	return anlNoticeList;
	}

	/* 분석메인 설정된 분석기기 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlMchnSettingList() {
		return commonDao.selectList("main.getAnlMchnSettingList");
	}

	/* 분석메인 분석기기 예약현황 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlMchnReservList(Map<String, Object> input) {
		return commonDao.selectList("main.getAnlMchnReservList", input);
	}

	/* 분석메인 교육 신청 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlEduReqList() {
		return commonDao.selectList("main.getAnlEduReqList");
	}

	/* 분석메인 주요 분석 자료 리스트  조회 */
	@Override
	public List<Map<String,Object>> getAnlMainDataList() {
		return commonDao.selectList("main.getAnlMainDataList");
	}

	/* 프로젝트 메인 GRS요청개수, 품의요청개수 조회 */
	@Override
	public Map<String,Object> retrieveUserTssReqCntInfo(Map<String, Object> input) {
		return commonDao.select("main.retrieveUserTssReqCntInfo", input);
	}

}


