package iris.web.knld.pub.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : PubNoticeService.java
 * DESC : 지식관리 - 공지사항관리 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.07.15  이주성	최초생성
 *********************************************************************************/

public interface PubNoticeService {

	List<Map<String, Object>> getPubNoticeList(HashMap<String, Object> input);

	Map<String, Object> getPubNoticeInfo(HashMap<String, Object> input);

	void insertPubNoticeInfo(Map<String, Object> input);

	void deletePubNoticeInfo(HashMap<String, String> input);

	void updatePubNoticeRtrvCnt(HashMap<String, String> input);

	void updatePubNoticeUgyYn(Map<String, Object> input);

}