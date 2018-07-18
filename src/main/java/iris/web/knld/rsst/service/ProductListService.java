package iris.web.knld.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : ProductListService.java
 * DESC : 지식관리 - 연구산출물관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.10  			최초생성
 *********************************************************************************/

public interface ProductListService {

	List<Map<String, Object>> getProductList(HashMap<String, Object> input);

	Map<String, Object> getProductListInfo(HashMap<String, Object> input);

	void insertProductListInfo(Map<String, Object> input);

	void deleteProductListInfo(HashMap<String, String> input);

	void updateProductListRtrvCnt(HashMap<String, String> input);

	/* 트리 리스트 조회 */
	public List<Map<String, Object>> getKnldProductTreeList(Map<String, Object> input);

	/*통합검색 권한 체크*/
	String getMenuAuthCheck(HashMap<String, String> input);

}