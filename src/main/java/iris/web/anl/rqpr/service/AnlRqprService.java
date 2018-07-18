package iris.web.anl.rqpr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : AnlRqprService.java 
 * DESC : 분석의뢰관리 - 분석의뢰관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface AnlRqprService {

	/* 분석의뢰 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprList(Map<String, Object> input);

	/* 분석의뢰 담당자 리스트 조회 */
	public List<Map<String, Object>> getAnlChrgList(Map<String, Object> input);

	/* 분석의뢰 정보 조회 */
	public Map<String,Object> getAnlRqprInfo(Map<String, Object> input);

	/* 분석의뢰 시료정보 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprSmpoList(Map<String, Object> input);

	/* 분석의뢰 관련분석 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprRltdList(Map<String, Object> input);
	
	/* 분석의뢰 등록 */
	public boolean insertAnlRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 수정 */
	public boolean updateAnlRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 삭제 */
	public boolean deleteAnlRqpr(Map<String, Object> input) throws Exception;

	/* 분석의뢰 의견 리스트 건수 조회 */
	public int getAnlRqprOpinitionListCnt(Map<String, Object> input);

	/* 분석의뢰 의견 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprOpinitionList(Map<String, Object> input);
	
	/* 분석의뢰 의견 저장 */
	public boolean saveAnlRqprOpinition(Map<String, Object> input) throws Exception;
	
	/* 분석의뢰 의견 삭제 */
	public boolean deleteAnlRqprOpinition(Map<String, Object> input) throws Exception;
	
	/* 분석의뢰 저장 */
	public boolean saveAnlRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 접수 */
	public boolean updateReceiptAnlRqpr(Map<String,Object> dataMap) throws Exception;

	/* 분석의뢰 반려/분석중단 처리 */
	public boolean updateAnlRqprEnd(Map<String,Object> dataMap) throws Exception;

	/* 실험정보 트리 리스트 조회 */
	public List<Map<String, Object>> getAnlExprTreeList(Map<String, Object> input);

	/* 실험정보 상세 콤보 리스트 조회 */
	public List<Map<String, Object>> getAnlExprDtlComboList(Map<String, Object> input);

	/* 분석결과 실험정보 리스트 조회 */
	public List<Map<String, Object>> getAnlRqprExprList(Map<String, Object> input);

	/* 분석결과 실험정보 조회 */
	public Map<String, Object> getAnlRqprExprInfo(Map<String, Object> input);
	
	/* 분석결과 실험정보 저장 */
	public boolean saveAnlRqprExpr(Map<String, Object> dataMap) throws Exception;
	
	/* 분석결과 실험정보 삭제 */
	public boolean deleteAnlRqprExpr(List<Map<String, Object>> list) throws Exception;
	
	/* 분석결과 저장 */
	public boolean saveAnlRqprRslt(Map<String, Object> dataMap) throws Exception;
	
	/* 실험 마스터 정보 저장 */
	public boolean saveAnlExprMst(List<Map<String,Object>> list) throws Exception;

	/* 실험 상세 정보 리스트 조회 */
	public List<Map<String, Object>> getAnlExprDtlList(Map<String, Object> input);
	
	/* 실험 상세 정보 등록 */
	public boolean saveAnlExprDtl(List<Map<String,Object>> list) throws Exception;
	
	/* 실험 상세 정보 삭제 */
	public boolean deleteAnlExprDtl(List<Map<String,Object>> list) throws Exception;

	/* 실험방법 내용 조회*/
	public String getExprWay(HashMap<String, String> input);

	/* 의견 상세 정보 조회*/
	public String retrieveOpiSbc(HashMap<String, String> input);

	/* 통보자 추가 저장*/
	public void insertAnlRqprInfm(Map<String, Object> dataMap);
}