package iris.web.insaBatch.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.lghausys.im.ImServerPortTypeProxy;

import devonframe.dataaccess.CommonDao;

@Service("ssoDeptInfoService")
public class SsoDeptInfoServiceImpl  implements SsoDeptInfoService{

	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	static final Logger LOGGER = LogManager.getLogger(SsoDeptInfoServiceImpl.class);
	
	
	public void insertDeptInfoIf() throws Exception {
		
		commonDao.delete("common.ssoInfo.deleteSsoDeptIf", "");
		
		// TODO Auto-generated method stub
		ImServerPortTypeProxy imServerImpl = new ImServerPortTypeProxy();
				
		com.lghausys.im.xsd.ImVO[] deptInfoList = imServerImpl.getInterfaceInfo("IRIS", "IRIS_D001"); 
		
		if(deptInfoList != null) {
			List<HashMap<String, Object>> deptResultList = new ArrayList<HashMap<String, Object>>();

			int cnt = deptInfoList.length;			
			
			for(int i=0; i< cnt; i++) {
				HashMap<String, Object> deptInfoMap = new HashMap<String, Object>();

				deptInfoMap.put("deptCode",deptInfoList[i].getDept_code());                   
				deptInfoMap.put("psFlag",deptInfoList[i].getDept_act_code()); 																																																																											
				deptInfoMap.put("deptName",deptInfoList[i].getDept_name());     																																																																											
				deptInfoMap.put("deptEname",deptInfoList[i].getDept_name_e());   																																																																											
				deptInfoMap.put("deptCname",deptInfoList[i].getDept_name_c());   																																																																											
				deptInfoMap.put("deptLevel",deptInfoList[i].getDept_levl());     																																																																											
				deptInfoMap.put("deptUper",deptInfoList[i].getDept_uper());     																																																																											
				deptInfoMap.put("uperdeptName",deptInfoList[i].getDept_uper_name());						
									
				deptResultList.add(deptInfoMap);
			}	
				
			commonDao.batchInsert("common.ssoInfo.saveDeptInfo", deptResultList);

		} else {
			LOGGER.debug(" >> insertDeptInfoIf  >>>>>>>>>>>>>>>>>>>>>> : return message connect fail");
		}
	}
}
