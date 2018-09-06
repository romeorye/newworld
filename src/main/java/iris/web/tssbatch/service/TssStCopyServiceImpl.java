package iris.web.tssbatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.prj.tss.gen.service.GenTssAltrService;
import iris.web.prj.tss.gen.service.GenTssCmplService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.nat.service.NatTssAltrService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssAltrService;

/*********************************************************************************
 * NAME : TssCopyBatchServiceImpl.java
 * DESC : TssCopyBatchServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.23  	최초생성
 *********************************************************************************/

@Service("tssStCopyService")
public class TssStCopyServiceImpl implements  TssStCopyService{

    static final Logger LOGGER = LogManager.getLogger(TssStCopyServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Resource(name="genTssCmplService")
    private GenTssCmplService genTssCmplService;

    @Resource(name="genTssAltrService")
    private GenTssAltrService genTssAltrService;

    @Resource(name="genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Resource(name="natTssAltrService")
    private NatTssAltrService natTssAltrService;

    @Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;	// 지적재산권 조회 Dao

    @Resource(name="ousdCooTssAltrService")
    private OusdCooTssAltrService ousdCooTssAltrService;


    /* 과제 및 통합결재 조회
     * (non-Javadoc)
     * @see iris.web.batch.service.TssCopyBatchService#retrieveTssComItgRdcs()
     */
    @Override
    public List<Map<String, Object>> retrieveTssComItgRdcs() {
        List<Map<String, Object>>  rst = 	commonDao.selectList("batch.retrieveTssComItgRdcs", "");
        return rst;
    }


    /*일반과제 copy
     * (non-Javadoc)
     * @see iris.web.batch.service.TssCopyBatchService#insertGenTssCopy(java.util.HashMap)
     */
    @Override
    public int insertTssCopy(Map<String, Object> input) {
        String tssCd = (String) input.get("affrCd");
        String psTssCd = "";

        if ("PL".equals(input.get("pgsStepCd"))) {
            /*******************계획*******************/
            //1. 계획 -> 진행
            String wbsCd = this.createWbsCd(input);
            if (wbsCd != null) {
                input.put("pgsStepCd", "PG");   //진행
                input.put("tssSt", "100");             //진행중
                input.put("pgTssCd", tssCd);
                input.put("wbsCd", wbsCd);

                if ("G".equals(input.get("tssScnCd"))) { //일반과제
                    this.insertGenData(input);
                } else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
                    this.insertOusdData(input);
                } else if ("N".equals(input.get("tssScnCd"))) {//국책과제
                    this.insertNatData(input);
                }
            }
        } else if ("AL".equals(input.get("pgsStepCd"))) {
            /*******************변경*******************/
            psTssCd = this.getRetrievePgTss(tssCd);

            //변경 데이터 진행에 update
            input.put("psTssCd", psTssCd);
            input.put("pgTssCd", psTssCd);
            input.put("tssCd", tssCd);

            if ("G".equals(input.get("tssScnCd"))) { //일반과제
                this.updateGenData(input);
            } else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
                this.updateOusdData(input);
            } else if ("N".equals(input.get("tssScnCd"))) {//국책과제
                this.updateNatData(input);
            }

            //변경시 과제리더 업데이트 처리
            String pmisSaSabunNew = "";
            pmisSaSabunNew = commonDao.select("batch.getPmisSaSabunNew", input);

            if (!"".equals(pmisSaSabunNew)) {
                input.put("pmisSaSabunNew", pmisSaSabunNew);
                commonDao.update("batch.updateTssMstSabunNew", input);
            }
        } else if ("CM".equals(input.get("pgsStepCd"))) {
            /*******************완료*******************/
            if ("G".equals(input.get("tssScnCd"))) { //일반과제
                this.updateGenNmData(input);
            } else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
                this.updateOusdNmData(input);
            } else if ("N".equals(input.get("tssScnCd"))) {//국책과제
                this.updateNatNmData(input);

                psTssCd = this.getRetrievePgTss(tssCd);

                String finYn = String.valueOf(input.get("finYn")).trim();
                if (!"Y".equals(finYn)) {                       // 최종차수 여부
                    input.put("pgsStepCd", "PL");       // 계획
                    input.put("tssSt", "104");                  // 품의완료
                    input.put("pgTssCd", psTssCd);

                    int tssNosSt = Integer.parseInt(String.valueOf(input.get("tssNosSt")).trim());
                    input.put("tssNosSt", tssNosSt + 1);

                    input.put("batType", "01"); //차수 값 null로 입력
                    this.insertNatData(input);

                    //계획 -> 진행으로 바로 변경
                    input.put("batType", "");

                    input.put("pgsStepCd", "PG");       // 진행
                    input.put("tssSt", "100");                  //진행중
                    input.put("pgTssCd", input.get("tssCd"));

                    this.insertNatData(input);
                }
            }
        } else if ("DC".equals(input.get("pgsStepCd"))) {
            /*******************중단*******************/
            if ("G".equals(input.get("tssScnCd"))) { //일반과제
                this.updateGenNmData(input);
            } else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
                this.updateOusdNmData(input);
            } else if ("N".equals(input.get("tssScnCd"))) {//국책과제
                this.updateNatNmData(input);
            }
        }

        //과제 생성시 지적재산권
        this.saveTssPimsInfo(input);

        return 0;
    }


    /**
     * 일반과제 계획 -> 진행시 진행데이터생성
     * @param input
     * @return
     */
    private int insertGenData(Map<String, Object> input) {
        //		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
        commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", input);
        //		1.2 IRIS_TSS_GEN_SMRY 		- 일반과제 개요
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrSmry", input); //진행과제코드로 변경개요
        //		1.3 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);
        //	 	1.4 IRIS_TSS_GEN_WBS 		- 일반과제WBS
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrWBS", input);
        //		1.5 IRIS_TSS_GEN_TRWI_BUDG_LIST - 일반과제투입예산목록(계획)
        commonDao.insert("prj.tss.gen.altr.insertGenTssTrwlBudgList", input);
        //		1.5 IRIS_TSS_GEN_TRWI_BUDG_LIST - 일반과제투입예산마스터
        commonDao.insert("prj.tss.gen.altr.insertGenTssTrwlBudgMst", input);
        //		1.6 IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);
        //		1.7 IRIS_TSS_YLD_ITM		- 과제산출물
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);
        //		1.8. WbsCd 생성
        commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
        return 0;
    }


    /**
     * 대외협력 계획 -> 진행시 진행데이터생성
     * @param input
     * @return
     */
    private int insertOusdData(Map<String, Object> input) {
        //		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
        commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", input);
        //		1.2 IRIS_TSS_OUSD_COO_SMRY 	- 대외협력과제 개요
        commonDao.insert("prj.tss.ousdcoo.insertCopyOusdCooTssSmry", input); //진행과제코드로 변경개요
        //		1.3 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);
        //		1.6 IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);
        //		1.7 IRIS_TSS_YLD_ITM		- 과제산출물
        commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);
        //		1.8 WbsCd 생성
        commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
        return 0;
    }


    /**
     * 국책과제 계획 -> 진행시 진행데이터생성 or 완료 -> 계획시 진행데이터생성
     * @param input
     * @return
     */
    private int insertNatData(Map<String, Object> input) {
    	//		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
        commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", input);
        //	 	1.2 IRIS_TSS_NAT_PLCY_SMRY_CRRO_INST
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmryCrrd", input);
        //	 	1.3 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrPtcRsstMbr", input);
        //		1.4 IRIS_TSS_NAT_PLCY_BIZ_EXP - 국책사업비
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrTrwiBudg", input);
        //		1.5 IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrGoal", input);
        //		1.6 IRIS_TSS_YLD_ITM		- 과제산출물
        commonDao.insert("prj.tss.nat.altr.insertNatTssAltrYld", input);

        //완료단계일 경우 추가적으로 진행
        if("01".equals(String.valueOf(input.get("batType")))) {
            //  1.7 투자품목
            commonDao.insert("prj.tss.nat.pgs.insertNatTssPgsIvst", input);
            //  1.8 연구비카드
            commonDao.insert("prj.tss.nat.pgs.insertNatTssPgsCrd", input);

            //  1.9 개요 첨부파일ID 신규생성 후 개요생성
            HashMap<String, Object> attachFile = commonDao.select("prj.tss.nat.getNatTssFileId", input);
            if(attachFile != null && !attachFile.isEmpty()) {
                attachFile.put("userId", input.get("userId"));
                commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
                input.put("attcFilId", attachFile.get("newAttcFilId"));
            }
            commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmry", input); //진행과제코드로 변경개요

            //  1.10 산출물 첨부파일ID 신규생성
            HashMap<String, Object> yldMap = new HashMap<String, Object>();
            yldMap.put("tssCd",        input.get("tssCd"));
            yldMap.put("newAttcFilId", input.get("attcFilId"));
            yldMap.put("gbn",          "Y");
            yldMap.put("userId",       input.get("userId"));
            commonDao.select("prj.tss.com.insertTssAttcFilIdCreate", yldMap);
        }
        //계획단계일 경우
        else {
            //     1.8 IRIS_TSS_NAT_PLCY_SMRY       - 국책과제 개요
            commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmry", input); //진행과제코드로 변경개요
            //     1.9 WbsCd 생성
            commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
        }
        return 0;
    }


    /**
     * 일반과제 변경 -> 진행데이터에 update
     * @param input
     * @return
     */
    private int updateGenData(Map<String, Object> input) {

        //		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
        genTssAltrService.updateGenTssMgmtMstToSelect(input);
        //		1.2 IRIS_TSS_GEN_SMRY 		- 일반과제 개요
        genTssAltrService.updateGenTssSmryToSelect(input);

        this.getChangData(input);
        //		1.3 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
        genTssAltrService.updateGenTssPtcRssMbrToSelect(input);
        //		1.4 IRIS_TSS_GEN_WBS 		- 일반과제WBS
        genTssAltrService.updateGenTssWbsToSelect(input);
        //		1.6 IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
        genTssAltrService.updateGenTssGoalArslToSelect(input);
        //		1.7 IRIS_TSS_YLD_ITM		- 과제산출물

        genTssAltrService.updateGenTssYldItmToSelect(input);
        //			1.1.1 상태값 변경
        input.put("tssSt", "100");
        genTssPlnService.updateGenTssPlnMstTssSt(input);
        return 0;
    }


    public void getChangData(Map<String, Object> input){
        String oldTssCd = (String)input.get("tssCd");
        String oldPgTssCd  =(String)input.get("pgTssCd");

        input.put("tssCd" ,oldPgTssCd );
        input.put("pgTssCd" ,oldTssCd );
    }


    /**
     * 대외협력과제 변경 -> 진행데이터에 update
     * @param input
     * @return
     */
    private int updateOusdData(Map<String, Object> input) {

        //		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
        genTssAltrService.updateGenTssMgmtMstToSelect(input);

        this.getChangData(input);

        input.put("psTssCd", input.get("pgTssCd")) ;

        //		1.2 IRIS_TSS_OUSD_COO_SMRY 		- 대외협력 과제 개요
        ousdCooTssAltrService.updateOusdTssSmryToSelect(input);

        //		1.3 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
        genTssAltrService.updateGenTssPtcRssMbrToSelect(input);

        //		1.6 IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
        genTssAltrService.updateGenTssGoalArslToSelect(input);
        //		1.7 IRIS_TSS_YLD_ITM		- 과제산출물

        genTssAltrService.updateGenTssYldItmToSelect(input);
        //				1.1.1 상태값 변경
        input.put("tssSt", "100");
        genTssPlnService.updateGenTssPlnMstTssSt(input);
        return 0;
    }


    /**
     * 국책과제 변경 -> 진행데이터에 update
     * @param input
     * @return
     */
    private int updateNatData(Map<String, Object> input) {

        //		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
        genTssAltrService.updateGenTssMgmtMstToSelect(input);
        //		1.2 IRIS_TSS_NAT_PLCY_SMRY 		- 국책과제 개요
        natTssAltrService.updateNatTssSmryToSelect(input);

        this.getChangData(input);

        //		1.3 수행기관 //IRIS_TSS_NAT_PLCY_SMRY_CRRO_INST
        natTssAltrService.updateNatTssSmryCrroToSelect(input);

        //		1.4 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
        genTssAltrService.updateGenTssPtcRssMbrToSelect(input);
        genTssAltrService.updateGenTssGoalArslToSelect(input);
        //      1.5 IRIS_TSS_YLD_ITM		- 과제산출물
        genTssAltrService.updateGenTssYldItmToSelect(input);
        //		1.6 IRIS_TSS_NAT_PLCY_BIZ_EXP 사업비
        natTssAltrService.updateNatTssTrwiBudgSelect(input);
        //		1.7 상태값 변경
        input.put("tssSt", "100");
        genTssPlnService.updateGenTssPlnMstTssSt(input);
        return 0;
    }


    /**
     * 일반과제 완료시 사용자정보 Update
     * @param input
     * @return
     */
    private int updateGenNmData(Map<String, Object> input) {

        //  1. 마스터
        try {
            commonDao.update("prj.tss.com.updateMstUserNmDeptNm", input);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        //  2. 멤버
        commonDao.update("prj.tss.com.updateMbrUserNmDeptNm", input);
        //  3. WBS
        commonDao.update("prj.tss.gen.updateWbsUserNmDeptNm", input);

        return 0;
    }


    /**
     * 대외협력과제 완료시 사용자정보 Update
     * @param input
     * @return
     */
    private int updateOusdNmData(Map<String, Object> input) {

        //  1. 마스터
        commonDao.update("prj.tss.com.updateMstUserNmDeptNm", input);
        //  2. 멤버
        commonDao.update("prj.tss.com.updateMbrUserNmDeptNm", input);

        return 0;
    }


    /**
     * 국책과제 완료시 사용자정보 Update
     * @param input
     * @return
     */
    private int updateNatNmData(Map<String, Object> input) {

        //  1. 마스터
        commonDao.update("prj.tss.com.updateMstUserNmDeptNm", input);
        //  2. 멤버
        commonDao.update("prj.tss.com.updateMbrUserNmDeptNm", input);
        //  2. 연구비카드
        commonDao.update("prj.tss.nat.updateCdcdUserNmDeptNm", input);

        return 0;
    }


    /**
     * 에러로그 insert
     * @param input
     * @return
     */
    private int insertErrLog(Map<String, Object> input) {

        commonDao.insert("batch.insertErrLog", input);

        return 0;
    }


    /**
     * 진행 과제코드를 조회함
     * @param tssCd
     * @return
     */
    private String getRetrievePgTss(String tssCd) {

        Map<String, Object> rst= commonDao.select("prj.tss.gen.altr.getRetrievePgTss", tssCd);
        return rst.get("tssCd").toString();
    }


    /**
     * WBS_CD 생성
     * @param input
     * @return
     */
    public String createWbsCd(Map<String, Object> input) {
        boolean errYn = false;
        String errMsg = "";
        String errCd = "";
        String wbsCdSeq = null;
        String wbsCd = null;

        String wbsCdSeqS = null;
        String tssScnCd = null;

        HashMap<String, Object> getWbs = commonDao.select("prj.tss.com.getWbsCdStd", input);

        int matchSeq = -1;

        //상위사업부코드 약어 확인
        if (getWbs == null || getWbs.size() <= 0) {
            errYn = true;
            errCd = "E001";
            errMsg = "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.";
        }
        //seq가 max인지 확인
        else {
            wbsCdSeqS = String.valueOf(getWbs.get("wbsCdSeq"));
            tssScnCd = String.valueOf(input.get("tssScnCd"));

            if (!"".equals(wbsCdSeqS) && null != wbsCdSeqS && !"null".equals(wbsCdSeqS)) {
                if ("G".equals(tssScnCd)) {
                    if (wbsCdSeqS.charAt(0) >= 78) errYn = true; //78:N
                } else if ("O".equals(tssScnCd)) {
                    if (wbsCdSeqS.charAt(0) >= 87) errYn = true; //87:W
                } else if ("N".equals(tssScnCd)) {
                    if (wbsCdSeqS.charAt(0) >= 90) errYn = true; //90:Z
                }

                errCd = "E002";
                errMsg = "과제를 더이상 생성할 수 없습니다. 과제 개수를 확인해 주세요.";
            }
        }


        if (errYn) {
            input.put("btchNm", "TssStCopy_createWbsCd");
            input.put("errCd", errCd);
            input.put("errMsg", errMsg);
            input.put("errPath", input.get("affrCd"));
            input.put("userId", "Batch");

            this.insertErrLog(input);
        } else {
            //seq가 null일 경우
            if ("".equals(wbsCdSeqS) || null == wbsCdSeqS || "null".equals(wbsCdSeqS)) {
                matchSeq = 0;
            }

            //일반과제
            if ("G".equals(tssScnCd)) {
                if (matchSeq != 0) {
                    //1~9 사이 숫자 비교
                    for (int i = 1; i <= 9; i++) {
                        if (String.valueOf(i).equals(wbsCdSeqS)) {
                            matchSeq = i;
                            break;
                        }
                    }

                    //A~N 사이 문자 비교
                    for (int i = 65; i < 78; i++) {
                        if (wbsCdSeqS.charAt(0) == i) {
                            matchSeq = i;
                            break;
                        }
                    }
                }

                if (matchSeq < 9) {
                    wbsCdSeq = String.valueOf(matchSeq + 1);
                } else if (matchSeq == 9) {
                    wbsCdSeq = "A";
                } else {
                    wbsCdSeq = String.valueOf((char) (matchSeq + 1));
                }
            }
            //대외협력과제
            else if ("O".equals(tssScnCd)) {
                //O~W 사이 문자 비교
                if (matchSeq != 0) {
                    for (int i = 79; i < 87; i++) {
                        if (wbsCdSeqS.charAt(0) == i) {
                            matchSeq = i;
                            break;
                        }
                    }
                }

                if (matchSeq == 0) {
                    wbsCdSeq = String.valueOf((char) 79);
                } else {
                    wbsCdSeq = String.valueOf((char) (matchSeq + 1));
                }
            }
            //국책과제
            else if ("N".equals(tssScnCd)) {
                //X,Y,Z 문자 비교
                if (matchSeq != 0) {
                    for (int i = 88; i < 90; i++) {
                        if (wbsCdSeqS.charAt(0) == i) {
                            matchSeq = i;
                            break;
                        }
                    }
                }

                if (matchSeq == 0) {
                    wbsCdSeq = String.valueOf((char) 88);
                } else {
                    wbsCdSeq = String.valueOf((char) (matchSeq + 1));
                }
            }

            //WBS_CD 조합 후 생성
            wbsCd = String.valueOf(getWbs.get("wbsCdStd")) + wbsCdSeq;
        }

        return wbsCd;
    }
    
    public void deleteGenTssPlnMstTssSt(HashMap<String, Object> input){
    	commonDao.delete("batch.deleteGenTssPlnMstTssSt", input);
    }
    
    
    public void saveTssPimsInfo(Map<String, Object> input){
    	String psTssCd = this.getRetrievePgTss(input.get("affrCd").toString());
    	input.put("pgTssCd", psTssCd);
    	//과제 지적재산권 등록 및 수정
    	commonDaoPims.update("batch.saveTssPimsInfo", input);
    	 LOGGER.debug("###############saveTssPimsInfo############################################ : " + input);
    	
    	//과제 인원 지적재산권 삭제
    	commonDaoPims.delete("batch.delPimsInfo", input);
    	//과제 인원 지적재산권 등록
    	List<HashMap<String, Object>>  saveResult = commonDao.selectList("batch.savePimsList", input);
    	LOGGER.debug("###############saveResult############################################ : " + saveResult.size());
    	
    	if( saveResult.size() > 0 ){
    		for(HashMap<String, Object> map : saveResult){
    			LOGGER.debug("###############map############################################ : " + map);
    			commonDaoPims.insert("batch.insertTssPimsInfo", map);
    		}
    	}
    }
}


