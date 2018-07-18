package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjTrwiBudgInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - 비용&예산(Trwi_Budg) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.24  IRIS04	최초생성
 *********************************************************************************/

public interface PrjTrwiBudgInfoService {

	/** 비용/예산 1년 통계 조회 **/
	List<Map<String, Object>> retrievePrjTrwiBudgSearchInfo(HashMap<String, Object> input);

}