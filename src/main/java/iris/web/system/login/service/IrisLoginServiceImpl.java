/*
 * @(#) LoginServiceImpl.java
 *
 * Copyright 2012 by LG CNS, Inc.,
 * All rights reserved.
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * 본 클래스를 실제 프로젝트에 사용하는 경우 XXXX 프로젝트 담당자에게
 * 프로젝트 정식명칭, 담당자 연락처(Email)등을 mail로 알려야 한다.
 *
 * 소스를 변경하여 사용하는 경우 XXXX 프로젝트 담당자에게
 * 변경된 소스 전체와 변경된 사항을 알려야 한다.
 * 저작자는 제공된 소스가 유용하다고 판단되는 경우 해당 사항을 반영할 수 있다.
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
package iris.web.system.login.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/*********************************************************************************
 * NAME : NwinsLoginServiceImpl.java 
 * DESC : 로긴처리관련 ServiceImpl
 * PROJ : WINS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.08  조종민	최초생성            
 *********************************************************************************/

@Service("irisLoginService")
public class IrisLoginServiceImpl implements IrisLoginService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;

    public void updateSecurityInfo(HashMap<String, String> input) {
    	commonDao.update("irisLogin.updateSecurityInfo", input);
    }

    public void updateVowInfo(HashMap<String, String> input) {
    	commonDao.update("irisLogin.updateVowInfo", input);
    }

    public List<Map<String, Object>> evalUser(HashMap<String, String> input) {
        //String digestedPw = DigestManager.digest(user.getUsrPw(), "SHA-512");
        //int count = 1; //((Integer)commonDao.select("Login.checkUser", user)).intValue();

        return commonDao.selectList("irisLogin.evalUser",input);
    }    
    
    public int sessionLog(HashMap<String, String> input) {
    	return commonDao.insert("irisLogin.sessionLog", input);
    }
    
    public HashMap<String, Object> retrievePassDt(HashMap<String, String> input) {
    	return commonDao.select("irisLogin.retrievePassDt",input);
        //return commonDao.selectList("irisLogin.retrievePassDt",input);
    }      
    
    public void updateLoginInfo(HashMap<String, String> input) {
    	commonDao.update("irisLogin.updateLoginInfo", input);
    }    
    
    public HashMap<String, Object> retrieveUserDetail(HashMap<String, String> input) {
    	return commonDao.select("irisLogin.retrieveUserDetail",input);
    }   
    
    public void loginFailureCount(HashMap<String, String> input) {
    	 commonDao.select("irisLogin.loginFailureCount",input);
    }     
    
    public HashMap<String, Object> retrieveUserDetl(HashMap<String, String> input) {
    	return commonDao.select("irisLogin.retrieveUserDetl",input);
    }      
    
    public String retrieveUserAuthGCdLData(HashMap<String, String> input) {
    	return commonDao.select("irisLogin.retrieveUserAuthGCdLData",input);
    }       
    
    public int updatePassDo(HashMap<String, String> input) {
    	return commonDao.update("irisLogin.updatePassDo", input);
    }    
    
    public void updateContractInfo(HashMap<String, String> input) {
    	commonDao.update("irisLogin.updateContractInfo", input);
    } 
/*    
    private Map<String, Object> convertListToMap(List<Map<String, Object>> codeList) {
        Map<String, Object> codeMap = new HashMap<String, Object>();
        for(Map<String, Object> map : codeList) {
            codeMap.put((String)map.get("code"), map.get("value"));
        }
        return codeMap;
    } 
*/
    
}