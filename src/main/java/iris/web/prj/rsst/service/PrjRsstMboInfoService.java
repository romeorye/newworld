package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/********************************************************************************
 * NAME : PrjRsstMboInfoService.java
 * DESC : 프로젝트 - 연구팀(Project) - MBO(특성지표) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.21  IRIS04	최초생성     
 *********************************************************************************/

public interface PrjRsstMboInfoService {

	/* MBO 리스트 조회 */
	List<Map<String, Object>> retrievePrjRsstMboSearchInfo(HashMap<String, Object> input);
	
	/* MBO 삭제 */
	void deletePrjRsstMboInfo(Map<String, Object> input);
		
	/* MBO 단건 조회 */
	Map<String, Object> retrievePrjRsstMboSearchDtlInfo(HashMap<String, Object> input);
	
	/* MBO 단건 입력&업데이트 */
	void insertPrjRsstMboInfo(Map<String, Object> input);
	
	/* MBO 단건 입력, 업데이트(데이터셋)*/
	public void savePrjRsstMboInfo(Map<String, Object> dataSet);
	
	/* MBO 실적년월 중복체크 */
	public String getMboDupYn(Map<String, Object> input);
	
	/* MBO 목표(목표년도+목표번호) 개수조회 */
	public int getMboGoalCnt(Map<String, Object> input);
	
	/* MBO 실적(실적년월,실적현황,첨부파일) 수정*/
	public void updatePrjRsstMboArlsInfo(Map<String, Object> dataSet);
	
}