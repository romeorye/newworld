package iris.web.prj.mgmt.smryCl.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : SmryClServiceImpl.java
 * DESC : SmryClServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.28
 *********************************************************************************/

@Service("smryClService")
public class SmryClServiceImpl implements  SmryClService{

    static final Logger LOGGER = LogManager.getLogger(SmryClServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Override
    public Map<String, Object> retrieveSmryClDtl(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public int updateSmryCl(HashMap<String, Object> input) {
        return commonDao.update("prj.mgmt.smryCl.updateSmryCl", input);
    }
}


