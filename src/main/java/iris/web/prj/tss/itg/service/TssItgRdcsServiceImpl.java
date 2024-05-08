package iris.web.prj.tss.itg.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : TssItgRdcsServiceImpl.java 
 * DESC : TssItgRdcsServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.28  jih	최초생성            
 *********************************************************************************/

@Service("tssItgRdcsService")
public class TssItgRdcsServiceImpl implements  TssItgRdcsService{
	
	static final Logger LOGGER = LogManager.getLogger(TssItgRdcsServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Override
	public List<Map<String, Object>> retrieveTssItgRdcsList(HashMap<String, Object> input) {
		
		return commonDao.selectList("prj.tss.itg.retrieveTssItgRdcsList", input);
	}
	
	


    
}


