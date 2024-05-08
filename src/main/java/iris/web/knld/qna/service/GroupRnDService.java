package iris.web.knld.qna.service;

/*********************************************************************************
 * NAME : GroupRnDService.java 
 * DESC : Knowledge - Group R&D 관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성                 
 *********************************************************************************/

public interface GroupRnDService {

	/* R&D position 코드 변환 */
	public String getRndPositionCd(String jobx);
}