package iris.web.space.ev.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : SpaceEvService.java
 * DESC : 공간평가 - 평가법 관리 Service
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.08.03  정현웅	최초생성
 *********************************************************************************/

public interface SpaceEvService {


	/* 공간평가 평가법관리 사업부 조회 */
	public List<Map<String, Object>> getSpaceEvBzdvList(Map<String, Object> input);

	/* 공간평가 평가법관리 제품군 조회 */
	public List<Map<String, Object>> getSpaceEvProdClList(Map<String, Object> input);

	/* 공간평가 평가법관리 분류 조회 */
	public List<Map<String, Object>> getSpaceEvClList(Map<String, Object> input);

	/* 공간평가 평가법관리 제품 조회 */
	public List<Map<String, Object>> getSpaceEvProdList(Map<String, Object> input);

	/* 공간평가 평가법관리 상세 조회 */
	public List<Map<String, Object>> getSpaceEvMtrlList(Map<String, Object> input);

	/* 공간평가 평가결과서 조회 */
	public List<Map<String, Object>> spaceRqprRsltList(Map<String, Object> input);

	/* 공간평가 평가법관리 등록 */
	public List<Map<String, Object>> spaceEvMtrlReqPop(Map<String, Object> input);

	//자재단위평가 등록
	public boolean insertSpaceEvMtrl(Map<String, Object> ds)  throws Exception;

	//자재단위평가 삭제
	void deleteSpaceEvMtrl(HashMap<String, String> input);

	//사업부 삭제
	void deleteSpaceEvCtgr0(HashMap<String, String> input);

	//제품군 삭제
	void deleteSpaceEvCtgr1(HashMap<String, String> input);

	//분류 삭제
	void deleteSpaceEvCtgr2(HashMap<String, String> input);

	//제품 삭제
	void deleteSpaceEvCtgr3(HashMap<String, String> input);

	//사업부 저장
	public int saveSpaceEvCtgr0(List<Map<String, Object>> input);

	//제품군 저장
	public int saveSpaceEvCtgr1(List<Map<String, Object>> input);

	//분류 저장
	public int saveSpaceEvCtgr2(List<Map<String, Object>> input);

	//제품 저장
	public int saveSpaceEvCtgr3(List<Map<String, Object>> input);


}