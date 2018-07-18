package iris.web.knld.pub.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager; 
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/*********************************************************************************
 * NAME : PatentServiceImpl.java 
 * DESC : 지식관리 - 특허관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성               
 *********************************************************************************/

@Service("patentInfoService") 
public class PatentInfoServiceImpl implements PatentInfoService {
	
	static final Logger LOGGER = LogManager.getLogger(PatentInfoServiceImpl.class);

	@Override
	public void redirectUrlPatentInfo() {
		// TODO Auto-generated method stub
		
	}


	
}