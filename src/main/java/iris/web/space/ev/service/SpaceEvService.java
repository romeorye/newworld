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

	
	
}