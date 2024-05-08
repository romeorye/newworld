package iris.web.insaBatch.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.fxaInfoBatch.service.FxaInfoIFServiceImpl;

@Service("insaInfoService")
public class InsaInfoServiceImpl implements InsaInfoService{

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	static final Logger LOGGER = LogManager.getLogger(FxaInfoIFServiceImpl.class);

	@Override
	public void insaInfoBatch() {
		// TODO Auto-generated method stub
		
		commonDao.select("common.ssoInfo.getSsoUser","");
		commonDao.select("common.ssoInfo.getSsoDept","");
		
		List<Map<String, Object>> empInfoList = new ArrayList<Map<String,Object>>();;
		List<Map<String, Object>> addEmpInfoList = new ArrayList<Map<String,Object>>();;
		empInfoList = commonDao.selectList("common.ssoInfo.getSsoTeamInfo","");

		for(int i=0; i < empInfoList.size(); i++){
			 Map<String, Object> userInfo = empInfoList.get(i);
			
			 HashMap<String, Object> empInfo = new HashMap<String, Object>();;
			 empInfo.put("saDeptName", 	userInfo.get("saDeptName"));
			 empInfo.put("saDeptNew", 	userInfo.get("saDeptNew"));
			 
			 addEmpInfoList.add(empInfo);
		 }

		commonDao.batchUpdate("common.ssoInfo.updatePrjNm", addEmpInfoList);
		
		/* List<Map<String, Object>> empInfoList = null;
		 List<Map<String, Object>> deptInfoList = null;
		
		 List<Map<String, Object>> addEmpInfoList = null;
		 List<Map<String, Object>> addDeptInfoList = null;
		 
		 Map<String, Object> empInfo = null;
		 Map<String, Object> deptInfo = null;
		 
		 try{
			 empInfoList = commonDao.selectList("common.ssoInfo.getSsoUser","");
			 deptInfoList = commonDao.selectList("common.ssoInfo.getSsoDept","");
			 
			 for(int i=0; i < empInfoList.size(); i++){
				 Map<String, Object> userInfo = empInfoList.get(i);
				
				 empInfo.put("saSabunNew", 	userInfo.get("saSabunNew"));          
				 empInfo.put("ssoExFlag", 	userInfo.get("ssoExFlag"));
				 empInfo.put("saUser", 		userInfo.get("saUser")); 
				 empInfo.put("saName", 		userInfo.get("saName")); 
				 empInfo.put("saEname", 	userInfo.get("saEname")); 
				 empInfo.put("saCname", 	userInfo.get("saCname")); 
				 empInfo.put("saDeptName", 	userInfo.get("saDeptName"));
				 empInfo.put("saDeptNew", 	userInfo.get("saDeptNew"));
				 empInfo.put("saUpmu", 		userInfo.get("saUpmu")); 
				 empInfo.put("saFunc", 		userInfo.get("saFunc")); 
				 empInfo.put("saFuncName", 	userInfo.get("saFuncName"));
				 empInfo.put("saJobxName", 	userInfo.get("saJobxName"));
				 empInfo.put("saJobx", 		userInfo.get("saJobx")); 
				 empInfo.put("saPhoneArea", userInfo.get("saPhoneArea"));
				 empInfo.put("saPhoneO", 	userInfo.get("saPhoneO"));
				 empInfo.put("saHand", 		userInfo.get("saHand")); 
				 empInfo.put("ssoExAuth", 	userInfo.get("ssoExAuth"));
				 empInfo.put("saMail", 		userInfo.get("saMail")); 
				 empInfo.put("saGsber", 	userInfo.get("saGsber")); 
				 empInfo.put("saExps", 		userInfo.get("saExps")); 
				 empInfo.put("saExpsName", 	userInfo.get("saExpsName"));
				 
				 addEmpInfoList.add(empInfo);
			 }
			 

			 for(int i=0; i < deptInfoList.size(); i++){
				 Map<String, Object> deptIn = deptInfoList.get(i);
				
				 deptInfo.put("deptCode", 		deptIn.get("deptCode"));
				 deptInfo.put("psFlag", 		deptIn.get("psFlag"));
				 deptInfo.put("deptName", 		deptIn.get("deptName"));
				 deptInfo.put("deptEname", 		deptIn.get("deptEname"));
				 deptInfo.put("deptCname", 		deptIn.get("deptCname"));
				 deptInfo.put("deptLevel ", 	deptIn.get("deptLevel"));
				 deptInfo.put("deptUper",	 	deptIn.get("deptUper"));
				 deptInfo.put("uperdeptName", 	deptIn.get("uperdeptName"));
				
				 addDeptInfoList.add(deptInfo);
			 }
			 
			 commonDao.batchUpdate("common.ssoInfo.saveEmpInfo", addEmpInfoList);
			 commonDao.batchUpdate("common.ssoInfo.saveDeptInfo", addDeptInfoList);
			 
		 }catch(Exception e){
			 e.printStackTrace();
		 }*/
	}
	
	
	
}




