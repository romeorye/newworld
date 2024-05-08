package iris.web.space.pfmc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : SpacePfmcMstService.java 
 * DESC : 공간평가 - 성능마스터 Service
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2018.08.14  동윤석	최초생성                 
 *********************************************************************************/

public interface SpacePfmcMstService {
	

	/* 성능마스터 제품 조회 */
	public List<Map<String, Object>> getSpacePfmcMstList(Map<String, Object> input);

}