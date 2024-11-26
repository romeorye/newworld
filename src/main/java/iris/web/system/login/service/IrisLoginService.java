package iris.web.system.login.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/*********************************************************************************
 * NAME : NwinsLoginService.java 
 * DESC : 로긴처리관련 Service
 * PROJ : WINS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.08  조종민	최초생성            
 *********************************************************************************/

public interface IrisLoginService {

    public void updateSecurityInfo(HashMap<String, String> input);

    public void updateVowInfo(HashMap<String, String> input);
    
    public List<Map<String, Object>> evalUser(HashMap<String, String> input);
    
    public int sessionLog(HashMap<String, String> input);
    
    public HashMap<String, Object> retrievePassDt(HashMap<String, String> input);
    
    public void updateLoginInfo(HashMap<String, String> input);
    
    public HashMap<String, Object> retrieveUserDetail(HashMap<String, String> input);
    
    public void loginFailureCount(HashMap<String, String> input);
    
    public HashMap<String, Object> retrieveUserDetl(HashMap<String, String> input);
    
    public String retrieveUserAuthGCdLData(HashMap<String, String> input);
    
    public int updatePassDo(HashMap<String, String> input);
    
    public void updateContractInfo(HashMap<String, String> input);
    
    public void insertLoginLog(HashMap<String, String> input);

}
