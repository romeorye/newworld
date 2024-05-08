package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : OusdCooTssAltrServiceImpl.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 변경(Altr) service Implements
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.22  IRIS04	최초생성
 *********************************************************************************/

@Service("ousdCooTssAltrService")
public class OusdCooTssAltrServiceImpl implements OusdCooTssAltrService {

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssAltrServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    /** 변경 - 마스터,개요 신규저장(기존 진행데이터 복사) **/
    @Override
    public int insertOusdCooTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs) {

        // 1. 신규 마스터 복사
        //       HashMap<String, Object> getWbs = commonDao.select("prj.tss.com.getWbsCdStd", mstDs);
        //       mstDs.put("wbsCd",  getWbs.get("wbsCd"));
        //       mstDs.put("orgWbsCd",  getWbs.get("wbsCd"));
    	mstDs.put("createMod", "Altr");

    	commonDao.insert("prj.tss.com.insertTssMst", mstDs);
        String tssCd = String.valueOf(mstDs.get("tssCd"));

        // 2. 기존 마스터 상태값 변경(품의완료)
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("tssCd"  , mstDs.get("pgTssCd"));
        map.put("userId" , mstDs.get("userId"));
        map.put("tssSt"  , "104"); // 품의완료
        commonDao.update("prj.tss.com.updateTssMstTssSt", map); //기존 진행과제 상태코드 변경

        // 3. 변경목록 저장
        for(int i = 0; i < altrDs.size(); i++) {
            altrDs.get(i).put("tssCd", tssCd);
        }
        commonDao.batchUpdate("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs); //변경목록

        //개요 첨부파일ID 신규생성
        HashMap<String, Object> attachFile = commonDao.select("prj.tss.ousdcoo.getOudsTssFileId", mstDs);
        if(!attachFile.isEmpty()) {
            attachFile.put("userId", mstDs.get("userId"));
            commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
            mstDs.put("attcFilId", attachFile.get("newAttcFilId"));
        }

        // 4. 기존대외협력과제 내용 복사
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssSmry", mstDs);       //개요 복사
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssExpStoa", mstDs);    //비용지급실적 복사
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", mstDs);	   //참여인원 복사
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", mstDs);	       //목표 복사
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", mstDs);	       //산출물 복사

        // 5. 개요 변경사유 업데이트
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssAltrSmry", smryDs);       //개요 변경사유 업데이트

        //산출물 첨부파일ID 신규생성
        HashMap<String, Object> yldMap = new HashMap<String, Object>();
        yldMap.put("tssCd",        mstDs.get("tssCd"));
        yldMap.put("newAttcFilId", mstDs.get("attcFilId"));
        yldMap.put("gbn",          "Y");
        yldMap.put("userId",       mstDs.get("userId"));
        commonDao.select("prj.tss.com.insertTssAttcFilIdCreate", yldMap);

        return 1;
    }

    /** 변경 - 마스터,개요 **/
    @Override
    public int updateOusdCooTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd) {
        // 1. 마스터, 일반개요 수정
        commonDao.update("prj.tss.com.updateTssMst", mstDs);
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssPlnSmry", smryDs);

        return 1;
    }

    //사용안함
    /** 변경개요 신규저장(기존 진행데이터 복사) **/
    @Override
    public int insertOusdCooTssAltrSmry(HashMap<String, Object> input, List<Map<String, Object>> altrDs) {
        commonDao.batchUpdate("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs); //변경목록

        // 개요 변경사유 업데이트
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssAltrSmry", input);       //개요 변경사유 업데이트

        //첨부파일
        HashMap<String, Object> attachFile = commonDao.select("prj.tss.nat.getNatTssFileId", input);
        if(!attachFile.isEmpty()) {
            attachFile.put("userId", input.get("userId"));
            commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
            input.put("attcFilId", attachFile.get("newAttcFilId"));
        }

        // 기존대외협력과제 내용 복사
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssSmry", input);       //개요 복사
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssExpStoa", input);    //비용지급실적 복사
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);	   //참여인원 복사
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);	   //목표 복사
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);	   //산출물 복사

        return 1;
    }

    /** 변경개요 수정(변경사유 + 변경목록) **/
    @Override
    public int updateOusdCooTssAltrSmry(HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs) {
        // 개요 변경사유 업데이트
        commonDao.update("prj.tss.ousdcoo.updateOusdCooTssAltrSmry", smryDs);

        //변경목록 수정
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
    /**
     * 변경데이터를 진행로 update
     */
    @Override
    public void updateOusdTssSmryToSelect(Map<String, Object> input) {
        commonDao.update("prj.tss.ousdcoo.updateOusdTssSmryToSelect", input);
    }

    /*
	//마스터
	@Override
    public Map<String, Object> retrieveGenTssAltrMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

	@Override
    public Map<String, Object> retrieveGenTssPtcMbrCnt(HashMap<String, String> input) {
	    return commonDao.select("prj.tss.com.retrieveTssPtcMbrCnt", input);
    }

	@Override
    public int insertGenTssAltrMst(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.com.insertTssMst", input);
    }

    @Override
    public int updateGenTssAltrMst(HashMap<String, Object> input) {
        return commonDao.update("prj.tss.com.updateTssMst", input);
    }



	//변경개요
    @Override
    public Map<String, Object> retrieveGenTssAltrSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.altr.retrieveGenTssAltrSmry", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssAltrSmryList(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.altr.retrieveGenTssAltrSmryList", input);
    }

    @Override
    public int insertGenTssAltrSmry(HashMap<String, Object> input, List<Map<String, Object>> altrDs) {
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrSmry", input); //진행과제코드로 변경개요
        commonDao.batchUpdate("prj.tss.gen.altr.updateGenTssAltrSmryList", altrDs); //변경목록
        commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmry1", input); //변경개요
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrWBS", input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);

        return 1;
    }

    @Override
    public int updateGenTssAltrSmry1(HashMap<String, Object> input, List<Map<String, Object>> altrDs) {

        commonDao.update("prj.tss.gen.altr.updateGenTssAltrSmry1", input);

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

            //신규 wbsSn값이면 max 추출
            if("r".equals(wbsSn.substring(0, 1))) {

                snMap = commonDao.select("prj.tss.gen.altr.retrieveGenTssAltrWBSMaxSn", dsMap);
                maxWbsSn = String.valueOf(snMap.get("maxWbsSn"));

                dsMap.put("wbsSn", maxWbsSn);

                //하위 depth의 값 변경
                for(int j = 0; j < ds.size(); j++) {
                    if(wbsSn.equals(ds.get(j).get("pidSn"))) {
                        ds.get(j).put("pidSn", maxWbsSn);
                    }
                }
            }

            rtVal = commonDao.update("prj.tss.gen.altr.updateGenTssAltrWBS", dsMap);
        }

        return rtVal;
    }

    @Override
    public int deleteGenTssAltrWBS(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.gen.altr.deleteGenTssAltrWBS", input);
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
        //과제 상태 변경
        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
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
		this.deleteGenTssAltrPtcRsstMbr((List<Map<String, Object>>) input);
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);
		return 0;
	}

	@Override
	public int updateGenTssWbsToSelect(Map<String, Object> input) {
		this.deleteGenTssAltrWBS((List<Map<String, Object>>) input);
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrWBS", input);
		return 0;
	}

	@Override
	public int updateGenTssGoalArslToSelect(Map<String, Object> input) {
		deleteGenTssAltrGoal((List<Map<String, Object>>) input);
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);
		return 0;
	}

	@Override
	public int updateGenTssYldItmToSelect(Map<String, Object> input) {
		deleteGenTssAltrYld((List<Map<String, Object>>) input);
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);
		return 0;
	}



     */


}
