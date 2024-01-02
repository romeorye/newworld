package iris.web.prj.tss.gen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/*********************************************************************************
 * NAME : GenTssServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("genTssAltrService")
public class GenTssAltrServiceImpl implements GenTssAltrService {

    static final Logger LOGGER = LogManager.getLogger(GenTssAltrServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> getMstStatusOfAltr(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.altr.getMstStatusOfAltr", input);
    }

    @Override
    public Map<String, Object> retrieveGenTssAltrMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public Map<String, Object> retrieveGenTssPtcMbrCnt(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssPtcMbrCnt", input);
    }

    @Override
    public Map<String, Object> retrieveDupChkWbsCd(HashMap<String, Object> mstDs) {
        return commonDao.select("prj.tss.gen.pln.retrieveDupChkWbsCd", mstDs);
    }

    @Override
    public int insertGenTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd) {

        mstDs.put("createMod", "Altr");

        int mstCnt = commonDao.insert("prj.tss.com.insertTssMst", mstDs);

        if(mstCnt > 0) {
            String tssCd = String.valueOf(mstDs.get("tssCd"));
            
            HashMap<String, Object> map = new HashMap<String, Object>();
            map.put("tssCd",  mstDs.get("pgTssCd"));
            map.put("userId", mstDs.get("userId"));

            if("100".equals(String.valueOf(mstDs.get("pgTssSt")))) {
                map.put("tssSt", "201"); //진행화면 -> 변경요청
            } else {
                map.put("tssSt", "202"); //GRS완료후 변경생성
            }

            commonDao.update("prj.tss.com.updateTssMstTssSt", map); //진행과제 상태코드 변경
            mstDs.put("pgTssSt", map.get("tssSt"));

            for(int i = 0; i < altrDs.size(); i++) {
                altrDs.get(i).put("tssCd", tssCd);
            }
            commonDao.batchUpdate("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs); //변경목록

            smryDs.put("tssCd",   tssCd);
            smryDs.put("pgTssCd", mstDs.get("pgTssCd"));

            /*
            //개요 첨부파일ID 신규생성
            HashMap<String, Object> attachFile = commonDao.select("prj.tss.gen.getGenTssFileId", mstDs);
            if(!attachFile.isEmpty()) {
                attachFile.put("userId", mstDs.get("userId"));
                commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
                smryDs.put("attcFilId", attachFile.get("newAttcFilId"));
            }
             */
            commonDao.insert("prj.tss.gen.altr.insertGenTssAltrSmry", smryDs); //진행과제코드로 변경개요
            commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmry1", smryDs); //변경개요
            commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", smryDs);
            commonDao.insert("prj.tss.gen.altr.insertGenTssAltrWBS", smryDs);
            commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", smryDs);
            commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", smryDs);

            //산출물 첨부파일ID 신규생성
            HashMap<String, Object> yldMap = new HashMap<String, Object>();
            yldMap.put("tssCd",        smryDs.get("tssCd"));
            yldMap.put("newAttcFilId", smryDs.get("attcFilId"));
            yldMap.put("gbn",          "Y");
            yldMap.put("userId",       smryDs.get("userId"));
            commonDao.select("prj.tss.com.insertTssAttcFilIdCreate", yldMap);
            
            commonDao.delete("prj.tss.com.deleteTmpTss", mstDs); //변경목록
        }

        return 1;
    }

    @Override
    public int updateGenTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd) {
        //commonDao.update("prj.tss.com.updateTssMst", mstDs);
        commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmry1", smryDs);

        for(int i = 0; i < altrDs.size(); i++) {
            //삭제
            if("3".equals(altrDs.get(i).get("duistate"))) {
                commonDao.delete("prj.tss.gen.altr.deleteGenTssAltrSmryList", altrDs.get(i));
            }
            //신규,수정
            else {
                commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs.get(i));
            }
        }

        return 1;
    }



    //변경개요
    @Override
    public Map<String, Object> retrieveGenTssAltrSmry(HashMap<String, String> input) {
        //return commonDao.select("prj.tss.gen.retrieveGenTssSmry", input);
    	return commonDao.select("prj.tss.gen.altr.retrieveGenTssAltrInfo", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssAltrSmryList(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.altr.retrieveGenTssAltrSmryList", input);
    }

    @Override
    public int insertGenTssAltrSmry(HashMap<String, Object> input, List<Map<String, Object>> altrDs) {
        return 1;
    }

    @Override
    public int updateGenTssAltrSmry1(HashMap<String, Object> input, List<Map<String, Object>> altrDs) {
        return 1;
    }

    @Override
    public int updateGenTssAltrSmry2(HashMap<String, Object> input) {
        return commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmry2", input);
    }



    //참여연구원
    @Override
    public List<Map<String, Object>> retrieveGenTssAltrPtcRsstMbr(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssPtcRsstMbr", input);
    }

    @Override
    public int updateGenTssAltrPtcRsstMbr(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssPtcRsstMbr", input);
    }

    @Override
    public int deleteGenTssAltrPtcRsstMbr(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssPtcRsstMbr", input);
    }



    //WBS
    @Override
    public List<Map<String, Object>> retrieveGenTssAltrWBS(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.altr.retrieveGenTssAltrWBS", input);
    }

    @Override
    public int updateGenTssAltrWBS(List<Map<String, Object>> ds) {
        String wbsSn = "";
        String maxWbsSn = null;
        Map<String, Object> snMap;
        HashMap<String, Object> dsMap;
        int rtVal = 0;

        for(int i = 0; i < ds.size(); i++) {
            dsMap = (HashMap<String, Object>)ds.get(i);
            wbsSn = (String)dsMap.get("wbsSn");

            //삭제
            if("3".equals(dsMap.get("duistate"))) {
                commonDao.delete("prj.tss.gen.deleteGenTssWBS", dsMap);
            }
            else {
                //신규 wbsSn값이면 max 추출
                if("r".equals(wbsSn.substring(0, 1))) {

                    snMap = commonDao.select("prj.tss.gen.retrieveGenTssWBSMaxSn", dsMap);
                    maxWbsSn = String.valueOf(snMap.get("maxWbsSn"));

                    dsMap.put("wbsSn", maxWbsSn);

                    //하위 depth의 값 변경
                    for(int j = 0; j < ds.size(); j++) {
                        if(wbsSn.equals(ds.get(j).get("pidSn"))) {
                            ds.get(j).put("pidSn", maxWbsSn);
                        }
                    }
                }

                rtVal = commonDao.update("prj.tss.gen.updateGenTssWBS", dsMap);
            }
        }

        return rtVal;
    }

    @Override
    public int deleteGenTssAltrWBS(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.gen.deleteGenTssWBS", input);
    }


    //투입예산
    @Override
    public void insertGenTssAltrTrwiBudg(HashMap<String, Object> input) {
        commonDao.select("prj.tss.gen.altr.insertGenTssAltrTrwiBudg", input);
    }



    //목표 및 산출물
    @Override
    public List<Map<String, Object>> retrieveGenTssAltrGoal(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
    }

    @Override
    public int updateGenTssAltrGoal(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssGoal", input);
    }

    @Override
    public int deleteGenTssAltrGoal(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssGoal", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssAltrYld(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssYld", input);
    }

    @Override
    public int updateGenTssAltrYld(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssYld", input);
    }

    @Override
    public int deleteGenTssAltrYld(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssYld", input);
    }



    //품의서
    @Override
    public List<Map<String, Object>> retrieveGenTssAltrAttc(HashMap<String, String> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    @Override
    public int insertGenTssAltrCsusRq(Map<String, Object> input) {
        //        //과제 상태 변경
        //        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        commonDao.insert("prj.tss.com.insertTssCsusRq", input);

        return 0;
    }

    @Override
    public int updateGenTssMgmtMstToSelect(Map<String, Object> input) {
        return  commonDao.update("prj.tss.gen.altr.updateGenTssMgmtMstToSelect", input);
    }

    @Override
    public int updateGenTssSmryToSelect(Map<String, Object> input) {
        return  commonDao.update("prj.tss.gen.altr.updateGenTssSmryToSelect", input);
    }

    @Override
    public int updateGenTssPtcRssMbrToSelect(Map<String, Object> input) {
        commonDao.delete("prj.tss.com.deleteTssPtcRsstMbrAllOfTssCd", input);
        //		this.deleteGenTssAltrPtcRsstMbr((List<Map<String, Object>>) input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);
        return 0;
    }

    @Override
    public int updateGenTssWbsToSelect(Map<String, Object> input) {
        //this.deleteGenTssAltrWBS((List<Map<String, Object>>) input);

        commonDao.delete("prj.tss.gen.altr.deleteGenTssAltrWBSOfTssCd", input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrWBS", input);
        return 0;
    }

    @Override
    public int updateGenTssGoalArslToSelect(Map<String, Object> input) {
        //		deleteGenTssAltrGoal((List<Map<String, Object>>) input);
        commonDao.delete("prj.tss.com.deleteTssGoalOfTssCd", input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);
        return 0;
    }

    @Override
    public int updateGenTssYldItmToSelect(Map<String, Object> input) {
        //		deleteGenTssAltrYld((List<Map<String, Object>>) input);

        commonDao.delete("prj.tss.com.deleteTssYldOfTssCd", input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);
        return 0;
    }
    
    
    /**
     *  변경개요 탭 정보 
     * @param input
     * @return
     */
	public Map<String, Object> retrieveGenTssAltrInfo(HashMap<String, String> input){
		if ( "".equals(input.get("tssCd"))  ){
			input.put("tssCd", input.get("pgTssCd") );
		}
		
		return commonDao.select("prj.tss.gen.altr.retrieveGenTssAltrInfo", input);
	}

}
