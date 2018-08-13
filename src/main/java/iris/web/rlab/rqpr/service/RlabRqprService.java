package iris.web.rlab.rqpr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : RlabRqprService.java 
 * DESC : 분석의뢰관리 - 분석의뢰관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface RlabRqprService {

	/* 분석의뢰 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprList(Map<String, Object> input);

	/* 분석의뢰 담당자 리스트 조회 */
	public List<Map<String, Object>> getRlabChrgList(Map<String, Object> input);

	/* 분석의뢰 정보 조회 */
	public Map<String,Object> getRlabRqprInfo(Map<String, Object> input);

	/* 분석의뢰 시료정보 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprSmpoList(Map<String, Object> input);

	/* 분석의뢰 관련분석 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprRltdList(Map<String, Object> input);
	
	/* 분석의뢰 등록 */
	public boolean insertRlabRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 수정 */
	public boolean updateRlabRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 삭제 */
	public boolean deleteRlabRqpr(Map<String, Object> input) throws Exception;

	/* 분석의뢰 의견 리스트 건수 조회 */
	public int getRlabRqprOpinitionListCnt(Map<String, Object> input);

	/* 분석의뢰 의견 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprOpinitionList(Map<String, Object> input);
	
	/* 분석의뢰 의견 저장 */
	public boolean saveRlabRqprOpinition(Map<String, Object> input) throws Exception;
	
	/* 분석의뢰 의견 삭제 */
	public boolean deleteRlabRqprOpinition(Map<String, Object> input) throws Exception;
	
	/* 분석의뢰 저장 */
	public boolean saveRlabRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 접수 */
	public boolean updateReceiptRlabRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 반려/분석중단 처리 */
	public boolean updateRlabRqprEnd(Map<String,Object> dataMap) throws Exception;

	/* 신뢰성 시험정보 트리 리스트 조회 */
	public List<Map<String, Object>> getRlabExatTreeList(Map<String, Object> input);

	/* 실험정보 상세 콤보 리스트 조회 */
	public List<Map<String, Object>> getRlabExprDtlComboList(Map<String, Object> input);

	/* 분석결과 실험정보 리스트 조회 */
	public List<Map<String, Object>> getRlabRqprExprList(Map<String, Object> input);

	/* 분석결과 실험정보 조회 */
	public Map<String, Object> getRlabRqprExprInfo(Map<String, Object> input);
	
	/* 분석결과 실험정보 저장 */
	public boolean saveRlabRqprExpr(Map<String, Object> dataMap) throws Exception;
	
	/* 분석결과 실험정보 삭제 */
	public boolean deleteRlabRqprExpr(List<Map<String, Object>> list) throws Exception;
	
	/* 분석결과 저장 */
	public boolean saveRlabRqprRslt(Map<String, Object> dataMap) throws Exception;
	
	/* 신뢰성 시험 마스터 정보 저장 */
	public boolean saveRlabExatMst(List<Map<String,Object>> list) throws Exception;

	/* 신뢰성 시험 상세 정보 리스트 조회 */
	public List<Map<String, Object>> getRlabExatDtlList(Map<String, Object> input);
	
	/* 신뢰성시험 상세 정보 등록 */
	public boolean saveRlabExatDtl(List<Map<String,Object>> list) throws Exception;
	
	/* 신뢰성시험 상세 정보 삭제 */
	public boolean deleteRlabExatDtl(List<Map<String,Object>> list) throws Exception;

	/* 실험방법 내용 조회*/
	public String getExprWay(HashMap<String, String> input);

	/* 의견 상세 정보 조회*/
	public String retrieveOpiSbc(HashMap<String, String> input);

	/* 통보자 추가 저장*/
	public void insertRlabRqprInfm(Map<String, Object> dataMap);
	
	/* 신뢰성시험 장비 팝업 목록조회 */
	List<Map<String, Object>> retrieveMachineList(HashMap<String, Object> input);
}