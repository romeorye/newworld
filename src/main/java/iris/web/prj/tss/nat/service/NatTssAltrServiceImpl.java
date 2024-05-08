package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/*********************************************************************************
 * NAME : NatTssServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("natTssAltrService")
public class NatTssAltrServiceImpl implements NatTssAltrService {

    static final Logger LOGGER = LogManager.getLogger(NatTssAltrServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    //마스터
    @Override
    public Map<String, Object> retrieveNatTssAltrMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssAltrSmryInfo(Map<String, Object> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssSmryInfo", input);
    }

    @Override
    public int insertNatTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd) {
        commonDao.update("prj.tss.com.updateTssMst", mstDs);

        //개요 첨부파일ID 신규생성
        HashMap<String, Object> attachFile = commonDao.select("prj.tss.nat.getNatTssFileId", mstDs);
        if(attachFile != null && !attachFile.isEmpty()) {
            attachFile.put("userId", mstDs.get("userId"));
            commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
            mstDs.put("attcFilId", attachFile.get("newAttcFilId"));
        }

        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmry", mstDs); //진행과제코드로 변경개요 생성
        commonDao.batchUpdate("prj.tss.nat.altr.updateNatTssAltrSmryList", altrDs); //변경개요목록 저장
        commonDao.update("prj.tss.nat.altr.updateNatTssAltrSmry1", smryDs); //변경개요탭 저장
        commonDao.update("prj.tss.nat.altr.insertNatTssAltrSmryCrrd", mstDs); //수행기관
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrPtcRsstMbr", mstDs);
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrTrwiBudg", mstDs);
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrGoal", mstDs);
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrYld", mstDs);

        //산출물 첨부파일ID 신규생성
        HashMap<String, Object> yldMap = new HashMap<String, Object>();
        yldMap.put("tssCd",        mstDs.get("tssCd"));
        yldMap.put("newAttcFilId", mstDs.get("attcFilId"));
        yldMap.put("gbn",          "Y");
        yldMap.put("userId",       mstDs.get("userId"));
        commonDao.select("prj.tss.com.insertTssAttcFilIdCreate", yldMap);

        return 1;
    }

    @Override
    public int updateNatTssAltrMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs, boolean upWbsCd) {
        commonDao.update("prj.tss.com.updateTssMst", mstDs);
        commonDao.update("prj.tss.nat.altr.updateNatTssAltrSmry1", smryDs);

        for(int i = 0; i < altrDs.size(); i++) {
            //삭제
            if("3".equals(altrDs.get(i).get("duistate"))) {
                commonDao.delete("prj.tss.nat.altr.deleteNatTssAltrSmryList", altrDs.get(i));
            }
            //신규,수정
            else {
                commonDao.update("prj.tss.nat.altr.updateNatTssAltrSmryList", altrDs.get(i));
            }
        }

        return 1;
    }


    //변경개요
    @Override
    public Map<String, Object> retrieveNatTssAltrSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssPlnSmry", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssAltrSmryList(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.altr.retrieveNatTssAltrSmryList", input);
    }


    //개요
    @Override
    public List<Map<String, Object>> retrieveNatTssNosYmd(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveNatTssNosYmd", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssAltrSmryInst(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveNatTssAltrSmryInst", input);
    }

    @Override
    public int updateNatTssAltrSmry2(HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs) {
        commonDao.update("prj.tss.nat.altr.updateNatTssSmry", smryDs);

        for(int i = 0; i < altrDs.size(); i++) {
            //신규
            if("1".equals(altrDs.get(i).get("duistate"))) {
                commonDao.insert("prj.tss.nat.insertNatTssPlnSmryCrroInst", altrDs.get(i));
            }
            //수정
            else if("2".equals(altrDs.get(i).get("duistate"))) {
                commonDao.update("prj.tss.nat.updateNatTssPlnSmryCrroInst", altrDs.get(i));
            }
            //삭제
            else if("3".equals(altrDs.get(i).get("duistate"))) {
                commonDao.delete("prj.tss.nat.deleteNatTssPlnSmryCrro", altrDs.get(i));
            }
        }

        return 1;
    }



    //사업비
    @Override
    public List<Map<String, Object>> retrieveNatTssAltrTrwiBudg(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveNatTssPlnTrwiBudg", input);
    }

    @Override
    public int updateNatTssAltrTrwiBudg(List<Map<String, Object>> ds) {
        return commonDao.batchUpdate("prj.tss.nat.saveNatTssPlnTrwiBudg", ds);
    }



    //참여연구원
    @Override
    public List<Map<String, Object>> retrieveNatTssAltrPtcRsstMbr(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssPtcRsstMbr", input);
    }

    @Override
    public int updateNatTssAltrPtcRsstMbr(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssPtcRsstMbr", input);
    }

    @Override
    public int deleteNatTssAltrPtcRsstMbr(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssPtcRsstMbr", input);
    }



    //목표 및 산출물
    @Override
    public List<Map<String, Object>> retrieveNatTssAltrGoal(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
    }

    @Override
    public int updateNatTssAltrGoal(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssGoal", input);
    }

    @Override
    public int deleteNatTssAltrGoal(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssGoal", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssAltrYld(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssYld", input);
    }

    @Override
    public int updateNatTssAltrYld(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssYld", input);
    }

    @Override
    public int deleteNatTssAltrYld(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssYld", input);
    }



    //품의서
    @Override
    public List<Map<String, Object>> retrieveNatTssAltrAttc(HashMap<String, String> input) {
        return commonDao.selectList("common.attachFile.getAttachFileList", input);
    }

    @Override
    public Map<String, Object> retrieveNatTssAltrInfo(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.altr.retrieveNatTssAltrInfo", input);
    }

    @Override
    public int insertNatTssAltrCsusRq(Map<String, Object> input) {
        //        //과제 상태 변경
        //        commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        commonDao.insert("prj.tss.com.insertTssCsusRq", input);

        return 0;
    }
    /* 국책 개요 조회후 수정
     * 	@Override(non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssAltrService#updateNatTssSmryToSelect(java.util.Map)
     */
    @Override
    public void updateNatTssSmryToSelect(Map<String, Object> input) {
        commonDao.update("prj.tss.nat.altr.updateNatTssSmryToSelect", input);

    }
    /* 국책사업비 수정
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssAltrService#updateNatTssTrwiBudgSelect(java.util.Map)
     */
    @Override
    public void updateNatTssTrwiBudgSelect(Map<String, Object> input) {
        commonDao.delete("prj.tss.nat.deleteNatTssTrwiBudgOfTssCd", input);
        commonDao.update("prj.tss.nat.altr.insertNatTssAltrTrwiBudg", input);

    }
    /* 수행기관(개요)
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssAltrService#updateNatTssSmryCrroToSelect(java.util.Map)
     */
    @Override
    public void updateNatTssSmryCrroToSelect(Map<String, Object> input) {

        commonDao.delete("prj.tss.nat.deleteNatTssPlnSmryCrroOfTssCd", input);
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmryCrrd", input);
    }


}
