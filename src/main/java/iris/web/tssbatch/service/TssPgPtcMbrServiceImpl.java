package iris.web.tssbatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;





/*********************************************************************************
 * NAME : TssPgPtcMbrServiceImpl.java
 * DESC : TssPgPtcMbrServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.23  	최초생성
 *********************************************************************************/
@Service("tssPgPtcMbrService")
public class TssPgPtcMbrServiceImpl implements TssPgPtcMbrService{

    @Resource(name="commonDao")
    private CommonDao commonDao;

	@Override
	public List<Map<String, Object>> retrieveTssPgMgr() {
		
		 List<Map<String, Object>>  rst = 	commonDao.selectList("batch.retrieveTssPgMgr", "");
	        return rst;
	}

	@Override
	public void updateTssPgMgr( HashMap<String, Object> input) {
		commonDao.update("batch.updateTssPgMgr", input);
	}
}
