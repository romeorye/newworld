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
import devonframe.util.NullUtil;
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
	@Override
	public List<Map<String, Object>> getSpaceEvBzdvList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvBzdvList", input);
	}
	/* 공간평가 평가법관리 - 제품군 조회 */
	@Override
	public List<Map<String, Object>> getSpaceEvProdClList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvProdClList", input);
	}
	/* 공간평가 평가법관리 - 분류 조회 */
	@Override
	public List<Map<String, Object>> getSpaceEvClList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvClList", input);
	}
	/* 공간평가 평가법관리 - 제품 조회 */
	@Override
	public List<Map<String, Object>> getSpaceEvProdList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvProdList", input);
	}
	/* 공간평가 평가법관리 - 상세 조회 */
	@Override
	public List<Map<String, Object>> getSpaceEvMtrlList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvMtrlList", input);
	}

	/* 공간평가 평가결과서 조회 */
	@Override
	public List<Map<String, Object>> spaceRqprRsltList(Map<String, Object> input) {
		return commonDao.selectList("space.ev.spaceRqprRsltList", input);
	}

	/* 자재단위평가 상세 */
	@Override
	public List<Map<String, Object>> getSpaceEvMtrlDtl(Map<String, Object> input) {
		return commonDao.selectList("space.ev.getSpaceEvMtrlDtl", input);
	}

	/* 공간평가 평가법관리 - 등록 */
	@Override
	public List<Map<String, Object>> spaceEvMtrlReqPop(Map<String, Object> input) {
		return commonDao.selectList("space.ev.spaceEvMtrlReqPop", input);
	}

	/* 자재단위평가 - 등록 저장 */
	@Override
    public boolean insertSpaceEvMtrl(Map<String, Object> ds) {
        //return commonDao.insert("space.ev.insertSpaceEvMtrl", ds);
        commonDao.insert("space.ev.insertSpaceEvMtrl", ds);
            return true;
    }

	/* 자재단위평가 - 수정 저장 */
	@Override
    public boolean updateSpaceEvMtrl(Map<String, Object> ds) {
        //return commonDao.insert("space.ev.insertSpaceEvMtrl", ds);
        commonDao.update("space.ev.updateSpaceEvMtrl", ds);
            return true;
    }

	/* 자재단위평가 삭제  */
	@Override
	public void deleteSpaceEvMtrl(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("space.ev.deleteSpaceEvMtrl", input);
	}

	/* 사업부 삭제  */
	@Override
	public void deleteSpaceEvCtgr0(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("space.ev.deleteSpaceEvCtgr0", input);
	}

	/* 제품군 삭제  */
	@Override
	public void deleteSpaceEvCtgr1(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("space.ev.deleteSpaceEvCtgr1", input);
	}

	/* 분류 삭제  */
	@Override
	public void deleteSpaceEvCtgr2(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("space.ev.deleteSpaceEvCtgr2", input);
	}

	/* 제품 삭제  */
	@Override
	public void deleteSpaceEvCtgr3(HashMap<String, String> input) {
		String rebId = NullUtil.nvl(input.get("rebId"), "");
		LOGGER.debug("###########rebId################"+rebId);
		commonDao.update("space.ev.deleteSpaceEvCtgr3", input);
	}

	//사업부저장
    @Override
    public int saveSpaceEvCtgr0(List<Map<String, Object>> ds) {
        String wbsSn = "";
        String maxWbsSn = null;
        Map<String, Object> snMap;
        HashMap<String, Object> dsMap;
        int rtVal = 0;

        for(int i = 0; i < ds.size(); i++) {
            dsMap = (HashMap<String, Object>)ds.get(i);

            //insert
            if("1".equals(dsMap.get("duistate"))) {
            	dsMap.put("curCtgrCd", "");
                commonDao.delete("space.ev.insertSpaceEvCtgr0", dsMap);
            }
            else if("2".equals(dsMap.get("duistate"))){
                rtVal = commonDao.update("space.ev.updateSpaceEvCtgr0", dsMap);
            }
        }

        return rtVal;
    }

	//제품군저장
    @Override
    public int saveSpaceEvCtgr1(List<Map<String, Object>> ds) {
    	String wbsSn = "";
        String maxWbsSn = null;
        Map<String, Object> snMap;
        HashMap<String, Object> dsMap;
        int rtVal = 0;

        for(int i = 0; i < ds.size(); i++) {
            dsMap = (HashMap<String, Object>)ds.get(i);

            //insert
            if("1".equals(dsMap.get("duistate"))) {
            	dsMap.put("curCtgrCd", "");
                commonDao.delete("space.ev.insertSpaceEvCtgr1", dsMap);
            }
            else if("2".equals(dsMap.get("duistate"))){
                rtVal = commonDao.update("space.ev.updateSpaceEvCtgr1", dsMap);
            }
        }

        return rtVal;
    }

	//분류저장
    @Override
    public int saveSpaceEvCtgr2(List<Map<String, Object>> ds) {
    	String wbsSn = "";
        String maxWbsSn = null;
        Map<String, Object> snMap;
        HashMap<String, Object> dsMap;
        int rtVal = 0;

        for(int i = 0; i < ds.size(); i++) {
            dsMap = (HashMap<String, Object>)ds.get(i);

            //insert
            if("1".equals(dsMap.get("duistate"))) {
            	dsMap.put("curCtgrCd", "");
                commonDao.delete("space.ev.insertSpaceEvCtgr2", dsMap);
            }
            else if("2".equals(dsMap.get("duistate"))){
                rtVal = commonDao.update("space.ev.updateSpaceEvCtgr2", dsMap);
            }
        }

        return rtVal;
    }

	//제품저장
    @Override
    public int saveSpaceEvCtgr3(List<Map<String, Object>> ds) {
    	String wbsSn = "";
        String maxWbsSn = null;
        Map<String, Object> snMap;
        HashMap<String, Object> dsMap;
        int rtVal = 0;

        for(int i = 0; i < ds.size(); i++) {
            dsMap = (HashMap<String, Object>)ds.get(i);

            //insert
            if("1".equals(dsMap.get("duistate"))) {
            	dsMap.put("curCtgrCd", "");
                commonDao.delete("space.ev.insertSpaceEvCtgr3", dsMap);
            }
            else if("2".equals(dsMap.get("duistate"))){
                rtVal = commonDao.update("space.ev.updateSpaceEvCtgr3", dsMap);
            }
        }

        return rtVal;
    }
}