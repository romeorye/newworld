package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjPtotPrptInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - 지적재산권(Ptot_Prpt) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.24  IRIS04	최초생성
 *********************************************************************************/

public interface PrjPtotPrptInfoService {

	/* 지적재산권 목록 조회 */
	List<Map<String, Object>> retrievePrjPtotPrptSearchInfo(HashMap<String, Object> input);

	/* 지적재산권 삭제 */
	void deletePrjPtotPrptInfo(Map<String, Object> input);

	/* 지적재산권 리스트 입력&업데이트 */
	void insertPrjPtotPrptInfo(Map<String, Object> input);

	/* 실적 지적재산권 목록 조회 */
	List<Map<String, Object>> retrievePrjErpPrptInfo(HashMap<String, Object> input);

}