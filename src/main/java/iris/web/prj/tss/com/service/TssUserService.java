/********************************************************************************
 * NAME : IrisUserService.java
 * DESC : 영업자료게시판
 * PROJ : WINS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.07.25  김찬웅	최초생성
 *********************************************************************************/
package iris.web.prj.tss.com.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TssUserService {

    /* LG사용자 조회 */
    public List<Map<String, Object>> getTssUserList(HashMap<String, Object> input);

    public Map<String, Object> getTssBtnRoleChk(HashMap<String, String> input, Map<String, Object> mst);

    public Map<String, Object> getTssListRoleChk(HashMap<String, Object> input);

    public Map<String, Object> getTssListRoleChk2(HashMap<String, String> input);

    /* GRS 심의 담당자 조회*/
    public List<Map<String, Object>> getGrsUserList(HashMap<String, Object> input);
}