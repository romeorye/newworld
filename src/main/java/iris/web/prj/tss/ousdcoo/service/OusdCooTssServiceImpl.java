package iris.web.prj.tss.ousdcoo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.util.HtmlUtil;
import devonframe.util.NullUtil;
import iris.web.prj.converter.service.EditorContentsConverterService;

/*********************************************************************************
 * NAME : OusdCooTssServiceImpl.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 Service Implement
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.14  IRIS04	최초생성
 *********************************************************************************/

@Service("ousdCooTssService")
public class OusdCooTssServiceImpl implements OusdCooTssService {

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Resource(name = "configService")
    private ConfigService configService;	// devon config 서비스

    @Resource(name = "editorContentsConverterService")
    private EditorContentsConverterService editorContentsConverterService;	// devon config 서비스


    @Override
    public List<Map<String, Object>> retrieveOusdCooTssList(HashMap<String, Object> input) {
	return commonDao.selectList("prj.tss.ousdcoo.retrieveOusdCooTssList", input);
    }

    @Override
	public void deleteOusdCooTssPlnMst(HashMap<String, String> input) {
		commonDao.update("prj.tss.ousdcoo.deleteOusdCooTssPlnMst1", input);
		commonDao.delete("prj.tss.ousdcoo.deleteOusdCooTssPlnMst2", input);
		commonDao.delete("prj.tss.ousdcoo.deleteOusdCooTssPlnMst3", input);
	}

    /*@Override
    public List<Map<String, Object>> retrieveTssPopupList(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssPopupList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveChargeMbr(String input) {
        return commonDao.selectList("prj.tss.com.retrieveChargeMbrList", input);
    }*/


    /* 대외협력과제 개요 */
    @Override
    public Map<String, Object> retrieveOusdCooTssSmry(HashMap<String, String> input) {
	return commonDao.select("prj.tss.ousdcoo.retrieveOusdCooTssSmry", input);
    }

    /* htlm 변화 처리된 대외협력과제 개요 조회
     * 모든 text 형 데이터 \n <br> 변환처리
     * */
    @Override
    public Map<String, Object> retrieveOusdCooTssSmryNtoBr(HashMap<String, String> input) {
	Map<String, Object> resultMap = commonDao.select("prj.tss.ousdcoo.retrieveOusdCooTssSmry", input);
	if(resultMap != null) {
	    resultMap.put("oucmPlnTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("oucmPlnTxt"),"")));
	    resultMap.put("rsstExpFnshCnd", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("rsstExpFnshCnd"),"")));
	    resultMap.put("rvwRsltTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("rvwRsltTxt"),"")));
	    resultMap.put("surrNcssTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("surrNcssTxt"),"")));
	    resultMap.put("sttsTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("sttsTxt"),"")));
	    resultMap.put("sbcSmryTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("sbcSmryTxt"),"")));
	    resultMap.put("ctqTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("ctqTxt"),"")));
	    resultMap.put("effSpheTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("effSpheTxt"),"")));
	    resultMap.put("fnoPlnTxt", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("fnoPlnTxt"),"")));
	    resultMap.put("altrRson", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("altrRson"),"")));
	    resultMap.put("addRson", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("addRson"),"")));
	    resultMap.put("dcacRson", HtmlUtil.nToBr( NullUtil.nvl(resultMap.get("dcacRson"),"")));
	}
	return resultMap;
    }

    @Override
    public int insertOusdCooTssSmry(HashMap<String, Object> input) {
	return commonDao.insert("prj.tss.ousdcoo.insertOusdCooTssSmry", input);
    }

    @Override
    public int updateOusdCooTssSmry(HashMap<String, Object> input) {
	return commonDao.update("prj.tss.ousdcoo.updateOusdCooTssSmry", input);
    }

    /* 비용지급 */
    @Override
    public Map<String, Object> retrieveOusdCooTssExpStoa(HashMap<String, String> input){
    	return commonDao.select("prj.tss.ousdcoo.retrieveOusdCooTssExpStoa", input);
    }

    @Override
    public int insertOusdCooTssExpStoa(HashMap<String, Object> input) {
	return commonDao.insert("prj.tss.ousdcoo.insertOusdCooTssExpStoa", input);
    }

    @Override
    public int updateOusdCooTssExpStoa(HashMap<String, Object> input) {
	return commonDao.insert("prj.tss.ousdcoo.updateOusdCooTssExpStoa", input);
    }

    @Override
    public int deleteOusdCooTssExpStoa(HashMap<String, Object> input) {
	return commonDao.insert("prj.tss.ousdcoo.deleteOusdCooTssExpStoa", input);
    }
    /* 완료 비용지급 조회 */
    @Override
    public Map<String, Object> retrieveCmplOusdCooTssExpStoa(HashMap<String, String> input){
    	return commonDao.select("prj.tss.ousdcoo.retrieveCmplOusdCooTssExpStoa", input);
    }

    /* 품의서 기타정보 */
    @Override
    public Map<String, Object> retrieveOusdCooRqEtcInfo(HashMap<String, String> input){
	return commonDao.select("prj.tss.ousdcoo.retrieveOusdCooRqEtcInfo", input);
    }

    /* 과제 공통 목표기술성과(텍스트타입 convert \n <br> 변환처리) */
    @Override
    public List<Map<String, Object>> retrieveGenTssPlnGoalNtoBr(HashMap<String, String> input){
	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();

	List<Map<String, Object>> goalList = commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
	if(goalList.size() > 0) {
	    for(Map<String, Object> convertMap : goalList) {
		resultList.add(convertNtoBrMap(convertMap));
	    }
	}

	return resultList;
    }

    /* 맵 convert \n <br> 변환처리 */
    @SuppressWarnings("rawtypes")
    public Map<String, Object> convertNtoBrMap(Map<String, Object> convertMap){
    	Map<String, Object> resultMap = new HashMap<String, Object>();

    	Iterator iterator = convertMap.entrySet().iterator();
		while (iterator.hasNext()) {
		    Entry entry = (Entry)iterator.next();
		    if(entry.getValue() instanceof String) {
		    	resultMap.put( (String)entry.getKey(),HtmlUtil.nToBr( NullUtil.nvl(entry.getValue(),"")) );
		    }else {
		    	resultMap.put( (String)entry.getKey(),entry.getValue() );
		    }
		}

		return resultMap;
    }
    
    /**  과제관리 > 대외협력과제 > 진행 > 변경이력 상세 조회  **/
    public List<Map<String, Object>> retrieveOusdCooTssAltrList(HashMap<String, Object> input){
    	return commonDao.selectList("prj.tss.com.retrieveOusdCooTssAltrList", input);
    }
    
    /** 과제관리 > 대외협력과제 > 진행 > 변경이력 상세 조회  **/
	public Map<String, Object> ousdCooTssAltrDetailSearch(HashMap<String, Object> input){
		return commonDao.select("prj.tss.com.ousdCooTssAltrDetailSearch", input);
	}


}