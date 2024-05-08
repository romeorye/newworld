package iris.web.knld.qna.service;


import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : GroupRnDServiceImpl.java 
 * DESC : Knowledge - Group R&D 관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("knldGroupRnDService")
public class GroupRnDServiceImpl implements GroupRnDService {
	
	static final Logger LOGGER = LogManager.getLogger(GroupRnDServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	/* R&D position 코드 변환 */
	public String getRndPositionCd(String jobx) {
	    switch (jobx)
	    {
	        case "FE0": return "01";
	        case "FB0": return "02";
	        case "EF0": return "03";
	        case "EE0": return "04";
	        case "EC0": return "05";
	        case "AF0": return "06";
	        case "AE0": return "07";
	        case "AD0": return "08";
	        case "사장": return "09";
	        case "AC0": return "10";
	        case "FD0": return "11";
	        case "EH0": return "12";
	        case "총괄연구원": return "13";
	        case "수석연구원": return "14";
	        case "FC0": return "15";
	        case "부책임연구원": return "16";
	        case "EB7": return "17";
	        case "주임": return "18";
	        case "수석부장": return "19";
	        case "EB6": return "20";
	        case "연구원": return "21";
	        case "FA0": return "22";
	        case "기타": return "23";
	        default: return "23";
	    }
	}
}