/********************************************************************************
 * NAME : AttachFileServiceImpl.java 
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

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("attachFileService")
public class AttachFileServiceImpl implements AttachFileService {

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* 첨부파일 리스트 조회 */
    public List<Map<String, Object>> getAttachFileList(Map<String, Object> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    /* 첨부파일 정보 조회 */
	public Map<String, Object> getAttachFileInfo(Map<String, Object> input) {
		return commonDao.select("common.attachFile.getAttachFileInfo", input);
	}

    /* 첨부파일 정보 리스트 조회 */
	public List<Map<String, Object>> getAttachFileInfoList(Map<String, Object> input) {
		return commonDao.selectList("common.attachFile.getAttachFileInfo", input);
	}

    /* 첨부파일 ID 조회 */
	public String getAttachFileId() {
		return commonDao.select("common.attachFile.getAttachFileId");
	}

    /* 첨부파일 seq 조회 */
	public int getAttachFileSeq(String attcFilId) {
		return commonDao.select("common.attachFile.getAttachFileSeq", attcFilId);
	}
	
	/* 첨부파일 등록 */
    public boolean insertAttachFile(List<Map<String, Object>> list) throws Exception {
    	if(list.size() == commonDao.batchInsert("common.attachFile.insertAttachFile", list)) {
    		return true;
    	} else {
    		throw new Exception("첨부파일 등록 오류");
    	}
    }

	/* 첨부파일 수정 */
    public boolean updateAttachFile(List<Map<String, Object>> list) throws Exception {
    	if(list.size() == commonDao.batchUpdate("common.attachFile.updateAttachFile", list)) {
    		return true;
    	} else {
    		throw new Exception("첨부파일 수정 오류");
    	}
    }

	/* 첨부파일 삭제 */
    public boolean deleteAttachFile(List<Map<String, Object>> list) throws Exception {
    	if(list.size() == commonDao.batchDelete("common.attachFile.deleteAttachFile", list)) {
    		return true;
    	} else {
    		throw new Exception("첨부파일 삭제 오류");
    	}
    }
    
    /* DRM 권한 조회*/
	public Map<String, Object> retrieveDrmConfig(HashMap<String, Object> input){
		return commonDao.select("common.attachFile.retrieveDrmConfig", input);
	}
}