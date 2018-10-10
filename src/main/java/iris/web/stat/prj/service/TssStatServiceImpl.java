package iris.web.stat.prj.service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;
import iris.web.common.util.CommonUtil;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@Service("tssStatService")
public class TssStatServiceImpl implements TssStatService {

    static final Logger LOGGER = LogManager.getLogger(TssStatServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Override
    public List<Map<String, Object>> retrieveGenTssStatList(HashMap<String, Object> input) {
    	List<Map<String, Object>> dclist = new ArrayList();
    	List<Map<String, Object>> list = commonDao.selectList("stat.prj.retrieveGenTssStatList", input);

    	if(list.size() > 0){
    		for(Map<String, Object> data : list) {
        		data.put("dcacRsonTxt" , CommonUtil.stripHTML(NullUtil.nvl(data.get("dcacRsonTxt"), "")));
        		dclist.add(data);
        	}
    	}

    	return dclist;

    }

    @Override
    public List<Map<String, Object>> retrieveTctmStatList(HashMap<String, Object> input) {
    	List<Map<String, Object>> dclist = new ArrayList();
    	List<Map<String, Object>> list = commonDao.selectList("stat.prj.retrieveTctmStatList", input);

    	if(list.size() > 0){
    		for(Map<String, Object> data : list) {
        		data.put("dcacRsonTxt" , CommonUtil.stripHTML(NullUtil.nvl(data.get("dcacRsonTxt"), "")));
        		dclist.add(data);
        	}
    	}

    	return dclist;

    }

    @Override
    public List<Map<String, Object>> retrieveOusdTssStatList(HashMap<String, Object> input) {
        return commonDao.selectList("stat.prj.retrieveOusdTssStatList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssStatList(HashMap<String, Object> input) {
        return commonDao.selectList("stat.prj.retrieveNatTssStatList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssStatDtlPopList(HashMap<String, Object> input) {
        return commonDao.selectList("stat.prj.retrieveGenTssStatDtlPopList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveTechTeamTssStatDtlPopList(HashMap<String, Object> input) {
        return commonDao.selectList("stat.prj.retrieveTechTeamTssStatDtlPopList", input);
    }
}