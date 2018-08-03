package iris.web.space.ev.service;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;
import org.springframework.ui.velocity.VelocityEngineUtils;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.space.rqpr.vo.SpaceMailInfo;
import iris.web.common.converter.RuiConstants;
import iris.web.common.util.FormatHelper;
import iris.web.common.util.StringUtil;

/*********************************************************************************
 * NAME : SpaceEvServiceImpl.java 
 * DESC : 공간평가 - 평가법 관리 ServiceImpl
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2018.08.03  정현웅	최초생성               
 *********************************************************************************/

@Service("spaceEvService")
public class SpaceEvServiceImpl implements SpaceEvService {
	
	static final Logger LOGGER = LogManager.getLogger(SpaceEvServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;

	@Resource(name = "configService")
    private ConfigService configService;

	
	
	
	
	/* 공간평가 평가법관리 - 사업부 조회 */
	public List<Map<String, Object>> getSpaceEvBzdvList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvBzdvList", input);
	}
	/* 공간평가 평가법관리 - 제품군 조회 */
	public List<Map<String, Object>> getSpaceEvProdClList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvProdClList", input);
	}
	/* 공간평가 평가법관리 - 분류 조회 */
	public List<Map<String, Object>> getSpaceEvClList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvClList", input);
	}
	/* 공간평가 평가법관리 - 제품 조회 */
	public List<Map<String, Object>> getSpaceEvProdList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvProdList", input);
	}
}