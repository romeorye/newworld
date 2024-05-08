/********************************************************************************
 * NAME : AttachFileService.java 
 * DESC : 첨부파일
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.25  김찬웅	최초생성            
 *********************************************************************************/
package iris.web.system.attach.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AttachFileService {

	/* 첨부파일 리스트 조회 */
    public List<Map<String, Object>> getAttachFileList(Map<String, Object> input);
    /* 첨부파일 정보 조회 */
	public Map<String, Object> getAttachFileInfo(Map<String, Object> input);
    /* 첨부파일 정보 니스트 조회 */
	public List<Map<String, Object>> getAttachFileInfoList(Map<String, Object> input);
    /* 첨부파일 ID 조회 */
	public String getAttachFileId();
    /* 첨부파일 seq 조회 */
	public int getAttachFileSeq(String attcFilId);
	/* 첨부파일 저장 */
    public boolean insertAttachFile(List<Map<String, Object>> list) throws Exception;
	/* 첨부파일 수정 */
    public boolean updateAttachFile(List<Map<String, Object>> list) throws Exception;
	/* 첨부파일 삭제 */
    public boolean deleteAttachFile(List<Map<String, Object>> list) throws Exception;
    /* DRM 권한 조회*/
	public Map<String, Object> retrieveDrmConfig(HashMap<String, Object> input);
}