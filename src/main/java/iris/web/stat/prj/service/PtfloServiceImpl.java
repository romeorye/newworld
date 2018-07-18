package iris.web.stat.prj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : TssStatServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("ptfloService")
public class PtfloServiceImpl implements PtfloService {

    static final Logger LOGGER = LogManager.getLogger(PtfloServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Override
    public List<Map<String, Object>> retrievePtfloFunding_a(HashMap<String, Object> input) {
        return commonDao.selectList("stat.ptflo.retrievePtfloFunding_a", input);
    }
    @Override
    public List<Map<String, Object>> retrievePtfloFunding_p(HashMap<String, Object> input) {
    	return commonDao.selectList("stat.ptflo.retrievePtfloFunding_p", input);
    }

    @Override
    public List<Map<String, Object>> retrievePtfloTrm_a(HashMap<String, Object> input) {
        return commonDao.selectList("stat.ptflo.retrievePtfloTrm_a", input);
    }
    @Override
    public List<Map<String, Object>> retrievePtfloTrm_p(HashMap<String, Object> input) {
    	return commonDao.selectList("stat.ptflo.retrievePtfloTrm_p", input);
    }

    @Override
    public List<Map<String, Object>> retrievePtfloAttr_a(HashMap<String, Object> input) {
        return commonDao.selectList("stat.ptflo.retrievePtfloAttr_a", input);
    }
    @Override
    public List<Map<String, Object>> retrievePtfloAttr_p(HashMap<String, Object> input) {
    	return commonDao.selectList("stat.ptflo.retrievePtfloAttr_p", input);
    }

    @Override
    public List<Map<String, Object>> retrievePtfloSphe_a(HashMap<String, Object> input) {
        return commonDao.selectList("stat.ptflo.retrievePtfloSphe_a", input);
    }
    @Override
    public List<Map<String, Object>> retrievePtfloSphe_p(HashMap<String, Object> input) {
    	return commonDao.selectList("stat.ptflo.retrievePtfloSphe_p", input);
    }

    @Override
    public List<Map<String, Object>> retrievePtfloType_a(HashMap<String, Object> input) {
        return commonDao.selectList("stat.ptflo.retrievePtfloType_a", input);
    }
    @Override
    public List<Map<String, Object>> retrievePtfloType_p(HashMap<String, Object> input) {
    	return commonDao.selectList("stat.ptflo.retrievePtfloType_p", input);
    }

}