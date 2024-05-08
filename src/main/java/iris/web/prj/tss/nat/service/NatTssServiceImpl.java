package iris.web.prj.tss.nat.service;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.StringUtil;

/*********************************************************************************
 * NAME : NatTssServiceImpl.java
 * DESC : NatTssServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.28  jih	최초생성
 *********************************************************************************/

@Service("natTssService")
public class NatTssServiceImpl implements  NatTssService{

    static final Logger LOGGER = LogManager.getLogger(NatTssServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Resource(name = "configService")
    private ConfigService configService;
    
    /**.
     * 조회 목록
     */
    @Override
    public List<Map<String, Object>> retrieveNatTssList(HashMap<String, Object> input) {

        return commonDao.selectList("prj.tss.nat.retrieveNatTssList", input); //
    }

    /**
     * 개요 조회
     */
    @Override
    public Map<String, Object> retrieveNatTssPlnSmry(HashMap<String, String> input) {

        return commonDao.select("prj.tss.nat.retrieveNatTssPlnSmry", input);
    }

    

    /**
     * 국책과제 계획단계 삭제
     */
    @Override
	public void deleteNatTssPlnMst(HashMap<String, String> input) {
		commonDao.update("prj.tss.nat.deleteNatTssPlnMst1", input);
		commonDao.delete("prj.tss.nat.deleteNatTssPlnMst2", input);
		commonDao.delete("prj.tss.nat.deleteNatTssPlnMst3", input);
	}

    /*개요정보입력
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#insertNatTssPlnSmry(java.util.HashMap)
     */
    @Override
    public int insertNatTssPlnSmry(HashMap<String, Object> smryDs) {
        return commonDao.insert("prj.tss.nat.insertNatTssPlnSmry", smryDs);
    }


    /**
     * 개요정보 수정
     */
    @Override
    public int updateNatTssPlnSmry(HashMap<String, Object> input) {
        return commonDao.update("prj.tss.nat.updateNatTssPlnSmry", input);
    }


    /**
     * 사업비 조회
     */

    @Override
    public List<Map<String, Object>> retrieveNatTssPlnTrwiBudg(HashMap<String, Object> input) {
        return  commonDao.selectList("prj.tss.nat.retrieveNatTssPlnTrwiBudg", input);


    }

    /**
     * 개요 수행기관 삭제
     */
    @Override
    public void deleteNatTssPlnSmryCrro(HashMap<String, Object> input) {

        commonDao.delete("prj.tss.nat.deleteNatTssPlnSmryCrro", input);
    }
    /* 개요 수행기관 입력
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#insertNatTssPlnSmryCrro(java.util.List)
     */
    @Override
    public void insertNatTssPlnSmryCrro(Map<String, Object> map) {
        commonDao.insert("prj.tss.nat.insertNatTssPlnSmryCrroInst", map);

    }
    /* 개요 수행기관 수정
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#updateNatTssPlnSmryCrro(java.util.List)
     */

    @Override
    public void updateNatTssPlnSmryCrro(Map<String, Object> map) {
        commonDao.update("prj.tss.nat.updateNatTssPlnSmryCrroInst", map);

    }

    /* 수행기관 조회
     * 	@Override(non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#retrieveSmryCrroInstList(java.util.HashMap)
     */
    @Override
    public List<Map<String, Object>> retrieveSmryCrroInstList(HashMap<String, Object> inputMap) {

        return commonDao.selectList("prj.tss.nat.retrieveSmryCrroInstList", inputMap);
    }



    /* 참여연구원 과제리더의 과제수  check
     * 	(non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#retrieveNatPtcRePer(java.lang.Object)
     */

    @Override
    public int retrieveNatPtcRePer(Object object) {

        HashMap<String, Object> 	rst = commonDao.select("prj.tss.nat.retrieveNatPtcRePer" ,object );
        return Integer.parseInt( rst.get("ptcProSum").toString());
    }
    /*참여연구원 연구원 참여율 check
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#retrieveNatPtcPlCnt(java.lang.Object)
     */
    @Override
    public int retrieveNatPtcPlCnt(Object object) {

        HashMap<String, Object> rst = commonDao.select("prj.tss.nat.retrieveNatPtcPlCnt" ,object );
        return Integer.parseInt( rst.get("cnt").toString());

    }
    /* 사업비 저장
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#saveNatTssPlnTrwiBudg(java.util.Map)
     */
    @Override
    public void saveNatTssPlnTrwiBudg(Map<String, Object> dsEach) {

        commonDao.update("prj.tss.nat.saveNatTssPlnTrwiBudg", dsEach);

    }
    /* 목표 평가 이력
     * (non-Javadoc)
     * @see iris.web.prj.tss.nat.service.NatTssService#retrieveGoalEvHis(java.util.HashMap)
     */
    @Override
    public List<Map<String, Object>> retrieveGoalEvHis(HashMap<String, String> input) {

        return commonDao.selectList("prj.tss.nat.retrieveGoalEvHis", input);
    }



    //정산
    @Override
    public Map<String, Object> retrieveNatTssStoa(HashMap<String, String> input) {
        return commonDao.select("prj.tss.nat.retrieveNatTssStoa", input);
    }

    @Override
    public int updateNatTssStoa(Map<String, Object> map) {
    	int chkCnt = 0;
       
    	try{
            commonDao.update("prj.tss.com.updateTssMstTssSt", map);
            chkCnt  = commonDao.update("prj.tss.nat.updateNatTssStoa", map);
            
        }catch(Exception e){
        	e.getMessage();
        }
        
        return chkCnt ;
    }


    //품의서
    @Override
    public List<Map<String, Object>> retrieveNatTssCsusCrro(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveSmryCrroInstList", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssCsusBudg1(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveNatTssCsusBudg1", input);
    }

    @Override
    public List<Map<String, Object>> retrieveNatTssCsusBudg2(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.nat.retrieveNatTssCsusBudg2", input);
    }

    @Override
    public void insertNatTssPlnCsusRq(Map<String, Object> map) {
        //        commonDao.update("prj.tss.com.updateTssMstTssSt", map);
        commonDao.insert("prj.tss.com.insertTssCsusRq", map);
    }

    @Override
    public void insertNatTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs,
            List<Map<String, Object>> smryDsListLst, boolean upWbsCd) {
        int mstCnt = commonDao.insert("prj.tss.com.insertTssMst", mstDs); //마스터 신규

        if(mstCnt > 0) {
            smryDs.put("tssCd" ,mstDs.get("tssCd"));
            commonDao.insert("prj.tss.nat.insertNatTssPlnSmry", smryDs); //개요 신규

            //필수산출물 생성
            if(!"".equals(String.valueOf(smryDs.get("attcFilId")))) {
            	//과제 제안서
                Calendar cal = Calendar.getInstance();
                int mm   = cal.get(Calendar.MONTH) + 1;
               
                smryDs.put("goalY",       mstDs.get("tssStrtDd").toString().substring(0,4));
                smryDs.put("yldItmType", "01");
                smryDs.put("arslYymm",  mstDs.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
                commonDao.update("prj.tss.com.updateTssYld", smryDs);
                
                //중단 완료 보고서
                smryDs.put("goalY",       mstDs.get("tssFnhDd").toString().substring(0,4));
                smryDs.put("yldItmType", "04");
                smryDs.put("arslYymm",       mstDs.get("tssFnhDd").toString().substring(0,7));
                commonDao.update("prj.tss.com.updateTssYld", smryDs);
            }

            for(int i = 0; i < smryDsListLst.size(); i++) {
                smryDsListLst.get(i).put("tssCd", mstDs.get("tssCd"));
                commonDao.insert("prj.tss.nat.insertNatTssPlnSmryCrroInst", smryDsListLst.get(i)); //개요기관 신규
            }
        }

    }
    
    /**
     * 국책과제 Master 수정
     */
    @Override
    public int updateNatTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> smryDsListLst, boolean upWbsCd) {
        int mstCnt = commonDao.update("prj.tss.nat.updateNatTssPlnMst", mstDs); //마스터 수정
        
        smryDs.put("tssCd" ,mstDs.get("tssCd"));
        
        if(mstCnt > 0) {
            commonDao.update("prj.tss.nat.updateNatTssPlnSmry", smryDs); //개요 수정

            HashMap<String, Object> map = new HashMap<String, Object>();

            for(int i = 0; i < smryDsListLst.size(); i++) {
                map = (HashMap<String, Object>) smryDsListLst.get(i);
                map.put("tssCd", smryDs.get("tssCd"));

                if("3".equals(smryDsListLst.get(i).get("duistate"))) {
                    commonDao.delete("prj.tss.nat.deleteNatTssPlnSmryCrro", map); //개요기관 삭제
                }
                else {
                    if(StringUtil.isNullString(map.get("crroInstSn").toString())) {
                        commonDao.insert("prj.tss.nat.insertNatTssPlnSmryCrroInst", map); //개요기관 신규
                    }
                    else {
                        commonDao.update("prj.tss.nat.updateNatTssPlnSmryCrroInst", map); //개요기관 수정
                    }
                }
            }
            
          //과제 제안서
            Calendar cal = Calendar.getInstance();
            int mm   = cal.get(Calendar.MONTH) + 1;
           
            smryDs.put("goalY",      mstDs.get("tssStrtDd").toString().substring(0,4));
            smryDs.put("yldItmType", "01");
            smryDs.put("arslYymm",  mstDs.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
            commonDao.update("prj.tss.com.updateTssYldItmDate", smryDs);
            
            //중단 완료 보고서410
            
            smryDs.put("goalY",      mstDs.get("tssFnhDd").toString().substring(0,4));
            smryDs.put("yldItmType", "04");
            smryDs.put("arslYymm",   mstDs.get("tssFnhDd").toString().substring(0,7));
            commonDao.update("prj.tss.com.updateTssYldItmDate", smryDs);	
        }
        
        return 1;
    }


    @Override
    public Map<String, Object> retrieveNatTssPgsCsus(HashMap<String, String> input) {
        //마스터조회
        Map<String, String> mstDs = commonDao.select("prj.tss.com.retrieveTssMst", input);

        HashMap<String, String> inputMap = new HashMap<String, String>();
        inputMap.put("tssSt", "104"); //104:품의완료
        inputMap.put("tssCd", mstDs.get("tssCd"));
        inputMap.put("userId", input.get("userId"));
        inputMap.put("pkWbsCd",   mstDs.get("pkWbsCd"));

        //1.계획과제 상태값 104로 변경
        commonDao.update("prj.tss.com.updateTssMstTssSt", inputMap);

        inputMap.put("pgsStepCd", "PG");
        inputMap.put("pgTssCd",   mstDs.get("tssCd"));

        //3.진행과제  max+1로 마스터 신규 생성
        commonDao.insert("prj.tss.nat.pgs.insertNatTssMst", inputMap);

        //개요 생성
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmry", inputMap);

        //개요 수행기관
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmryCrrd", inputMap);

        //참여인원
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrPtcRsstMbr", inputMap);

        //3.사업비
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrTrwiBudg", inputMap);

        //목표
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrGoal", inputMap);

        //산출물
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrYld", inputMap);

        int tssNosSt = Integer.parseInt(String.valueOf(mstDs.get("tssNosSt")).trim());
        inputMap.put("tssNosSt", String.valueOf(tssNosSt - 1));

        //2. 투자품목 - 이전차수 진행과제코드 구하기
        Map<String, String> rtTssCd = commonDao.select("prj.tss.nat.retrieveBrNosStPgsTssCd", inputMap);

        inputMap.put("pgTssCd", rtTssCd.get("tssCd"));
        commonDao.insert("prj.tss.nat.pgs.insertNatTssPgsIvst", inputMap);

        //연구비
        commonDao.insert("prj.tss.nat.pgs.insertNatTssPgsCrd", inputMap);

        return commonDao.select("prj.tss.com.retrieveTssMst", inputMap);
    }
}
