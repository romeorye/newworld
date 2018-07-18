package iris.web.prj.mgmt.grst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : GrsReqServiceImpl.java
 * DESC : grsReqServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.28  jih	최초생성
 *********************************************************************************/

@Service("grsTempService")
public class GrsTempServiceImpl implements  GrsTempService{

    static final Logger LOGGER = LogManager.getLogger(GrsTempServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    /*목록조회
     * (non-Javadoc)
     * @see iris.web.prj.mgmt.grst.serice.GrsTempService#retrieveGrsTempList(java.util.HashMap)
     */
    @Override
    public List<Map<String, Object>> retrieveGrsTempList(HashMap<String, Object> input) {

        return commonDao.selectList("prj.mgmt.grst.retrieveGrsTempList", input);
    }
    /* 입력 , 수정 주정보
     * (non-Javadoc)
     * @see iris.web.prj.mgmt.grst.serice.GrsTempService#saveGrsTemp(java.util.HashMap)
     */
    @Override
    public int saveGrsTemp(HashMap<String, Object> input) {
        return commonDao.update("prj.mgmt.grst.saveGrsTemp", input);
    }
    /* 입력 ,수정  상세정보
     * (non-Javadoc)
     * @see iris.web.prj.mgmt.grst.serice.GrsTempService#saveGrsTempLst(java.util.Map)
     */
    @Override
    public void saveGrsTempLst(Map<String, Object>  ds) {
        commonDao.update( "prj.mgmt.grst.saveGrsTempLst" , ds);
    }
    /**
     * 시퀀스 조회
     */
    @Override
    public Map<String, Object> getSeqGrsTemp() {

        return commonDao.select("prj.mgmt.grst.getSeqGrsTemp");
    }
    /* 상세정보 조회
     * (non-Javadoc)
     * @see iris.web.prj.mgmt.grst.serice.GrsTempService#retrieveGrsTempDtl(java.util.HashMap)
     */
    @Override
    public HashMap<String, Object> retrieveGrsTempDtl(HashMap<String, Object> inputMap) {

        return commonDao.select("prj.mgmt.grst.retrieveGrsTempDtl" ,inputMap );
    }
    @Override
    public int deleteGrsTemp(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.mgmt.grst.deleteGrsTemp", input);
    }

}


