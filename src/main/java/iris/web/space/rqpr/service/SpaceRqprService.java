package iris.web.space.rqpr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : SpaceRqprService.java
 * DESC : 분석의뢰관리 - 분석의뢰관리 Service
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.21  정현웅	최초생성
 *********************************************************************************/

public interface SpaceRqprService {

	/* 분석의뢰 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprList(Map<String, Object> input);

	/* 분석의뢰 담당자 리스트 조회 */
	public List<Map<String, Object>> getSpaceChrgList(Map<String, Object> input);

	/* 분석의뢰 정보 조회 */
	public Map<String,Object> getSpaceRqprInfo(Map<String, Object> input);

	/* 분석의뢰 시료정보 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprSmpoList(Map<String, Object> input);

	/* 분석의뢰 관련분석 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprRltdList(Map<String, Object> input);

	/* 분석의뢰 등록 */
	public boolean insertSpaceRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 수정 */
	public boolean updateSpaceRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 삭제 */
	public boolean deleteSpaceRqpr(Map<String, Object> input) throws Exception;

	/* 분석의뢰 의견 리스트 건수 조회 */
	public int getSpaceRqprOpinitionListCnt(Map<String, Object> input);

	/* 분석의뢰 의견 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprOpinitionList(Map<String, Object> input);

	/* 분석의뢰 의견 저장 */
	public boolean saveSpaceRqprOpinition(Map<String, Object> input) throws Exception;

	/* 분석의뢰 의견 삭제 */
	public boolean deleteSpaceRqprOpinition(Map<String, Object> input) throws Exception;

	/* 분석의뢰 저장 */
	public boolean saveSpaceRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 접수 */
	public boolean updateReceiptSpaceRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 반려/분석중단 처리 */
	public boolean updateSpaceRqprEnd(Map<String,Object> dataMap) throws Exception;

	/* 실험정보 트리 리스트 조회 */
	public List<Map<String, Object>> getSpaceExatTreeList(Map<String, Object> input);

	/* 실험정보 상세 콤보 리스트 조회 */
	public List<Map<String, Object>> getSpaceExprDtlComboList(Map<String, Object> input);

	/* 분석결과 실험정보 리스트 조회 */
	public List<Map<String, Object>> getSpaceRqprExprList(Map<String, Object> input);

	/* 분석결과 실험정보 조회 */
	public Map<String, Object> getSpaceRqprExprInfo(Map<String, Object> input);

	/* 분석결과 실험정보 저장 */
	public boolean saveSpaceRqprExpr(Map<String, Object> dataMap) throws Exception;

	/* 분석결과 실험정보 삭제 */
	public boolean deleteSpaceRqprExpr(List<Map<String, Object>> list) throws Exception;

	/* 분석결과 저장 */
	public boolean saveSpaceRqprRslt(Map<String, Object> dataMap) throws Exception;

	/* 공간평가시험 마스터 정보 저장 */
	public boolean saveSpaceExatMst(List<Map<String,Object>> list) throws Exception;

	/* 실험 상세 정보 리스트 조회 */
	public List<Map<String, Object>> getSpaceExatDtlList(Map<String, Object> input);

	/* 공간평가시험 상세 정보 등록 */
	public boolean saveSpaceExatDtl(List<Map<String,Object>> list) throws Exception;

	/* 공간평가시험 상세 정보 삭제 */
	public boolean deleteSpaceExatDtl(List<Map<String,Object>> list) throws Exception;

	/* 실험방법 내용 조회*/
	public String getExprWay(HashMap<String, String> input);

	/* 의견 상세 정보 조회*/
	public String retrieveOpiSbc(HashMap<String, String> input);

	/* 통보자 추가 저장*/
	public void insertSpaceRqprInfm(Map<String, Object> dataMap);

	/* 공간평가시험 장비 팝업 목록조회 */
	List<Map<String, Object>> retrieveMachineList(HashMap<String, Object> input);
}