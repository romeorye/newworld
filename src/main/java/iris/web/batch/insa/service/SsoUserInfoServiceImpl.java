package iris.web.batch.insa.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.lghausys.im.ImServerPortTypeProxy;

import devonframe.dataaccess.CommonDao;

@Service("ssoUserInfoService")
public class SsoUserInfoServiceImpl implements SsoUserInfoService{

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	static final Logger LOGGER = LogManager.getLogger(SsoUserInfoServiceImpl.class);
	
	@Override
	public void insertUserInfoIf() throws Exception{
		
		commonDao.delete("common.ssoInfo.deleteSsoUserIf", "");
		
		// TODO Auto-generated method stub
		ImServerPortTypeProxy imServerImpl = new ImServerPortTypeProxy();
			
		com.lghausys.im.xsd.ImVO[] userInfoList = imServerImpl.getInterfaceInfo("IRIS", "IRIS_U001"); 
	
		if(userInfoList != null) {
			
			List<HashMap<String, Object>> userResultList = new ArrayList<HashMap<String, Object>>();				
			int cnt = userInfoList.length;			
			
			for(int i=0; i< cnt; i++) {
				HashMap<String, Object> userInfoMap = new HashMap<String, Object>();
				
				userInfoMap.put("saSabunNew", userInfoList[i].getSa_sabun_new());
				userInfoMap.put("ssoExFlag",    userInfoList[i].getSso_ex_flag());
				userInfoMap.put("saUser",       userInfoList[i].getSa_user());
				userInfoMap.put("saName",       userInfoList[i].getSa_name());
				userInfoMap.put("saEname",      userInfoList[i].getSa_name_e());
				userInfoMap.put("saCname",      userInfoList[i].getSa_name_c());
				userInfoMap.put("saDeptName",   userInfoList[i].getSa_dept_name());
				userInfoMap.put("saDeptNew",    userInfoList[i].getSa_dept_new());
				userInfoMap.put("saUpmu",       userInfoList[i].getSa_upmu());
				userInfoMap.put("saFunc",       userInfoList[i].getSa_func());
				userInfoMap.put("saFuncName",   userInfoList[i].getSa_func_name());
				userInfoMap.put("saJobxName",   userInfoList[i].getSa_jobx_name());
				userInfoMap.put("saJobx",       userInfoList[i].getSa_jobx());
				userInfoMap.put("saPhoneArea",  userInfoList[i].getSa_phon_area());
				userInfoMap.put("saPhoneO",     userInfoList[i].getSa_phon_o());
				userInfoMap.put("saHand",       userInfoList[i].getSa_hand());
				userInfoMap.put("ssoExAuth",    userInfoList[i].getSso_ex_auth());
				userInfoMap.put("saMail",       userInfoList[i].getSa_mail());
				userInfoMap.put("saGsber",  	userInfoList[i].getAcct_unit());
				userInfoMap.put("saExps", 		userInfoList[i].getSa_exps());
				userInfoMap.put("saTemp", 		userInfoList[i].getSa_temp());
				userInfoMap.put("saTempDate", 	userInfoList[i].getSa_temp_date());
				userInfoMap.put("saExpsName",   userInfoList[i].getSa_exps_name());     
				
				userResultList.add(userInfoMap);
			}
			
			commonDao.batchInsert("common.ssoInfo.saveUserInfo", userResultList);
			
			
			
		} else {
			LOGGER.debug(" >> insertUserInfoIf  >>>>>>>>>>>>>>>>>>>>>> : return message connect fail");
		}
	}
	
		
}
