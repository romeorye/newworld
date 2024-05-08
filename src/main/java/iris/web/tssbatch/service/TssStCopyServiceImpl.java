package iris.web.tssbatch.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.dbConn.DbConn;
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
public class TssStCopyServiceImpl implements TssStCopyService {

	static final Logger LOGGER = LogManager.getLogger(TssStCopyServiceImpl.class);

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Resource(name = "genTssCmplService")
	private GenTssCmplService genTssCmplService;

	@Resource(name = "genTssAltrService")
	private GenTssAltrService genTssAltrService;

	@Resource(name = "genTssPlnService")
	private GenTssPlnService genTssPlnService;

	@Resource(name = "natTssAltrService")
	private NatTssAltrService natTssAltrService;


	@Resource(name = "commonDaoPims")
	private CommonDao commonDaoPims;    // 지적재산권 조회 Dao

	/* 울산 DB Connection
	@Resource(name="commonDaoQasU")
	private CommonDao commonDaoQasU;
   */
	/* 청주 DB Connection .
	@Resource(name="commonDaoQasC")
	private CommonDao commonDaoQasC;
 */ 
	@Resource(name = "ousdCooTssAltrService")
	private OusdCooTssAltrService ousdCooTssAltrService;


	/* 과제 및 통합결재 조회
	 * (non-Javadoc)
	 * @see iris.web.batch.service.TssCopyBatchService#retrieveTssComItgRdcs()
	 */
	@Override
	public List<Map<String, Object>> retrieveTssComItgRdcs() {
		List<Map<String, Object>> rst = commonDao.selectList("batch.retrieveTssComItgRdcs", "");
		return rst;
	}


	/*일반과제 copy
	 * (non-Javadoc)
	 * @see iris.web.batch.service.TssCopyBatchService#insertGenTssCopy(java.util.HashMap)
	 */
	@Override
	public void insertTssCopy(Map<String, Object> input) {
		String tssCd = (String) input.get("affrCd");
		String psTssCd = "";

		if ("PL".equals(input.get("pgsStepCd"))) {
			/*******************계획*******************/
			//1. 계획 -> 진행
			String wbsCd = createWbsCd(input);
			if (wbsCd != null) {
				input.put("pgsStepCd", "PG");   //진행
				input.put("tssSt", "100");             //진행중
				input.put("pgTssCd", tssCd);
				input.put("wbsCd", wbsCd);

				if ("G".equals(input.get("tssScnCd"))) { //일반과제
					insertGenData(input);
					try{
						insertToQasTssQasIF(input); //QAS 과제등록
					}catch(Exception e){
						
					}
				} else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
					insertOusdData(input);
				} else if ("N".equals(input.get("tssScnCd"))) {//국책과제
					insertNatData(input);
				} else if ("D".equals(input.get("tssScnCd"))) {//기술팀과제
					insertTctmData(input);
					try{
						insertToQasTssQasIF(input); //QAS 과제등록
					}catch(Exception e){
						
					}
					
				} else if("M".equals(input.get("tssScnCd"))) {
					insertMkInnoData(input);
				}
			}
		} else if ("AL".equals(input.get("pgsStepCd"))) {
			/*******************변경*******************/
			psTssCd = getRetrievePgTss(tssCd);

			//변경 데이터 진행에 update
			input.put("psTssCd", psTssCd);
			input.put("pgTssCd", psTssCd);
			input.put("tssCd", tssCd);

			if ("G".equals(input.get("tssScnCd"))) { //일반과제
				updateGenData(input);
			} else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
				updateOusdData(input);
			} else if ("N".equals(input.get("tssScnCd"))) {//국책과제
				updateNatData(input);
			} else if ("D".equals(input.get("tssScnCd"))) {//기술팀과제
				updateTctmData(input);
			}

			if( !"D".equals(input.get("tssScnCd")) )  {
				//변경시 과제리더 업데이트 처리
	            String chgTssSabun = "";
	            chgTssSabun = commonDao.select("batch.getChgTssSabunNew", input);

	            if(!"".equals(chgTssSabun)){
	            	//모두연구원 권한으로업데이트
	            	commonDao.update("batch.updateTssPtcSabunNew", input);
	            	
	            	input.put("chgTssSabun", chgTssSabun);
	            	commonDao.update("batch.updateTssPtcLeaderSabunNew", input);
	            	commonDao.update("batch.updateTssMstSabunNew", input);
	            }
			}
			
		} else if ("CM".equals(input.get("pgsStepCd"))) {
			/*******************완료*******************/
			if ("G".equals(input.get("tssScnCd"))) { //일반과제
				updateGenNmData(input);
			} else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
				updateOusdNmData(input);
			} else if ("N".equals(input.get("tssScnCd"))) {//국책과제
				updateNatNmData(input);

                psTssCd = getRetrievePgTss(tssCd);

                String finYn = String.valueOf(input.get("finYn")).trim();
                if (!"Y".equals(finYn)) {                       // 최종차수 여부
                    input.put("pgsStepCd", "PL");       // 계획
                    input.put("tssSt", "104");                  // 품의완료
                    input.put("pgTssCd", psTssCd);

                    int tssNosSt = Integer.parseInt(String.valueOf(input.get("tssNosSt")).trim());
                    input.put("tssNosSt", tssNosSt + 1);

                    input.put("batType", "01"); //차수 값 null로 입력
                    insertNatData(input);

                    //계획 -> 진행으로 바로 변경
                    input.put("batType", "");

                    input.put("pgsStepCd", "PG");       // 진행
                    input.put("tssSt", "100");                  //진행중
                    input.put("pgTssCd", input.get("tssCd"));

                    insertNatData(input);
                }
			} else if ("D".equals(input.get("tssScnCd"))) {//기술팀과제
				updateTctmNmData(input);
			} 
		} else if ("DC".equals(input.get("pgsStepCd"))) {
			/*******************중단*******************/
			if ("G".equals(input.get("tssScnCd"))) { //일반과제
				updateGenNmData(input);
			} else if ("O".equals(input.get("tssScnCd"))) {//대외협력과제
				updateOusdNmData(input);
			} else if ("N".equals(input.get("tssScnCd"))) {//국책과제
				updateNatNmData(input);
			} else if ("D".equals(input.get("tssScnCd"))) {//기술팀과제
				updateTctmNmData(input);
			}
		}
	}


	/**
	 * 일반과제 계획 -> 진행시 진행데이터생성
	 *
	 * @param input
	 * @return
	 */
	private void insertGenData(Map<String, Object> input) {
		//		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
		commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", input);
		//		1.2 IRIS_TSS_GEN_SMRY 		- 일반과제 개요
		commonDao.insert("prj.tss.com.insertGenTssSmry", input); //진행과제코드로 변경개요
		//		1.3 IRIS_TSS_PTC_RSST_MBR 	- 과제참여연구원
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrPtcRsstMbr", input);
		//	 	1.4 IRIS_TSS_GEN_WBS 		- 일반과제WBS
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrWBS", input);
		//		1.5 IRIS_TSS_GEN_TRWI_BUDG_LIST - 일반과제투입예산목록(계획)
		//commonDao.insert("prj.tss.gen.altr.insertGenTssTrwlBudgList", input);
		//		1.5 IRIS_TSS_GEN_TRWI_BUDG_LIST - 일반과제투입예산마스터
		//commonDao.insert("prj.tss.gen.altr.insertGenTssTrwlBudgMst", input);
		//		1.6 IRIS_TSS_GOAL_ARSL 		- 과제목표/실적
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrGoal", input);
		//		1.7 IRIS_TSS_YLD_ITM		- 과제산출물
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);
		//		1.8. WbsCd 생성
		commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
	}


	/**
	 * 대외협력 계획 -> 진행시 진행데이터생성
	 *
	 * @param input
	 * @return
	 */
	private void insertOusdData(Map<String, Object> input) {
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
	}


	/**
	 * 국책과제 계획 -> 진행시 진행데이터생성 or 완료 -> 계획시 진행데이터생성
	 *
	 * @param input
	 * @return
	 */
	private void insertNatData(Map<String, Object> input) {
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
		if ("01".equals(String.valueOf(input.get("batType")))) {
			//  1.7 투자품목
			commonDao.insert("prj.tss.nat.pgs.insertNatTssPgsIvst", input);
			//  1.8 연구비카드
			commonDao.insert("prj.tss.nat.pgs.insertNatTssPgsCrd", input);

			//  1.9 개요 첨부파일ID 신규생성 후 개요생성
			HashMap<String, Object> attachFile = commonDao.select("prj.tss.nat.getNatTssFileId", input);
			if (attachFile != null && !attachFile.isEmpty()) {
				attachFile.put("userId", input.get("userId"));
				commonDao.insert("prj.tss.com.insertTssAttachFile", attachFile);
				input.put("attcFilId", attachFile.get("newAttcFilId"));
			}
			commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmry", input); //진행과제코드로 변경개요

			//  1.10 산출물 첨부파일ID 신규생성
			HashMap<String, Object> yldMap = new HashMap<String, Object>();
			yldMap.put("tssCd", input.get("tssCd"));
			yldMap.put("newAttcFilId", input.get("attcFilId"));
			yldMap.put("gbn", "Y");
			yldMap.put("userId", input.get("userId"));
			commonDao.select("prj.tss.com.insertTssAttcFilIdCreate", yldMap);
		}
		//계획단계일 경우
        else {
            //     1.8 IRIS_TSS_NAT_PLCY_SMRY       - 국책과제 개요
            commonDao.insert("prj.tss.nat.altr.insertNatTssAltrSmry", input); //진행과제코드로 변경개요
            //     1.9 WbsCd 생성
            commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);
        }
	}

	/**
	 * 기술팀과제 계획 -> 진행시 진행데이터생성
	 *
	 * @param input
	 * @return
	 */
	private void insertTctmData(Map<String, Object> input) {
		commonDao.insert("prj.tss.gen.cmpl.insertGenTssCmplMst", input);    //마스터
		commonDao.insert("prj.tss.tctm.insertTctmTssAltrSmry", input);            //개요
		commonDao.insert("prj.tss.gen.altr.insertGenTssAltrYld", input);        //산출물
		commonDao.insert("prj.tss.com.updateTssMstWbsCd", input);            //WBS_CD Update
	}
	
	/**
	 * 제조혁신 과제 계획 -> 진행시 진행데이터생성
	 *
	 * @param input
	 * @return
	 */
	private void insertMkInnoData(Map<String, Object> input) {
		commonDao.insert("mkInno.tss.insertMkInnoTsslMst", input);    			//마스터
		commonDao.insert("mkInno.tss.insertMkInnoTssSmry", input);            	//개요
		commonDao.insert("mkInno.tss.insertMkInnoTssPtcRsstMbr", input);	//참여연구원
		//commonDao.insert("mkInno.tss.insertMkInnoTssYld", input);        		//산출물
	}


	/**
	 * 일반과제 변경 -> 진행데이터에 update
	 *
	 * @param input
	 * @return
	 */
	private void updateGenData(Map<String, Object> input) {

		//		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
		genTssAltrService.updateGenTssMgmtMstToSelect(input);
		//		1.2 IRIS_TSS_GEN_SMRY 		- 일반과제 개요
		genTssAltrService.updateGenTssSmryToSelect(input);

		getChangData(input);
		//input.put("psTssCd", input.get("pgTssCd")) ;
		
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
	}


	public void getChangData(Map<String, Object> input) {
		String oldTssCd = (String) input.get("tssCd");
		String oldPgTssCd = (String) input.get("pgTssCd");

		input.put("tssCd", oldPgTssCd);
		input.put("pgTssCd", oldTssCd);
	}


	/**
	 * 대외협력과제 변경 -> 진행데이터에 update
	 *
	 * @param input
	 * @return
	 */
	private void updateOusdData(Map<String, Object> input) {

		//		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
		genTssAltrService.updateGenTssMgmtMstToSelect(input);

		getChangData(input);

		input.put("psTssCd", input.get("pgTssCd"));

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
	}


	/**
	 * 국책과제 변경 -> 진행데이터에 update
	 *
	 * @param input
	 * @return
	 */
	private void updateNatData(Map<String, Object> input) {

		//		1.1 IRIS_TSS_MGMT_MST		- 과제관리마스터
		genTssAltrService.updateGenTssMgmtMstToSelect(input);
		//		1.2 IRIS_TSS_NAT_PLCY_SMRY 		- 국책과제 개요
		natTssAltrService.updateNatTssSmryToSelect(input);

		getChangData(input);

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
	}

	/**
	 * 기술팀과제 변경 -> 진행데이터에 update
	 *
	 * @param input
	 * @return
	 */
	private void updateTctmData(Map<String, Object> input) {
		//		마스터
		genTssAltrService.updateGenTssMgmtMstToSelect(input);
		//		개요
		commonDao.insert("prj.tss.tctm.updateTctmTssAltrSmry", input);
		getChangData(input);
		//		산출물
		genTssAltrService.updateGenTssYldItmToSelect(input);
		//		상태값
		input.put("tssSt", "100");
		genTssPlnService.updateGenTssPlnMstTssSt(input);
	}


	/**
	 * 일반과제 완료시 사용자정보 Update
	 *
	 * @param input
	 * @return
	 */
	private void updateGenNmData(Map<String, Object> input) {

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

	}

	/**
	 * 대외협력과제 완료시 사용자정보 Update
	 *
	 * @param input
	 * @return
	 */
	private void updateOusdNmData(Map<String, Object> input) {
		//  1. 마스터
		commonDao.update("prj.tss.com.updateMstUserNmDeptNm", input);
		//  2. 멤버
		commonDao.update("prj.tss.com.updateMbrUserNmDeptNm", input);
	}

	/**
	 * 국책과제 완료시 사용자정보 Update
	 *
	 * @param input
	 * @return
	 */
	private void updateNatNmData(Map<String, Object> input) {

		//  1. 마스터
		commonDao.update("prj.tss.com.updateMstUserNmDeptNm", input);
		//  2. 멤버
		commonDao.update("prj.tss.com.updateMbrUserNmDeptNm", input);
		//  2. 연구비카드
		commonDao.update("prj.tss.nat.updateCdcdUserNmDeptNm", input);
	}

	/**
	 * 기술팀과제 완료시 사용자정보 Update
	 *
	 * @param input
	 * @return
	 */
	private void updateTctmNmData(Map<String, Object> input) {
		commonDao.update("prj.tss.com.updateMstUserNmDeptNm", input);    //마스터
	}


	/**
	 * 에러로그 insert
	 *
	 * @param input
	 * @return
	 */
	private void insertErrLog(Map<String, Object> input) {

		commonDao.insert("batch.insertErrLog", input);

	}


	/**
	 * 진행 과제코드를 조회함
	 *
	 * @param tssCd
	 * @return
	 */
	private String getRetrievePgTss(String tssCd) {

		Map<String, Object> rst = commonDao.select("prj.tss.gen.altr.getRetrievePgTss", tssCd);
		return rst.get("tssCd").toString();
	}


	/**
	 * WBS_CD 생성
	 *
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
				} else if ("D".equals(tssScnCd)) {
					if (wbsCdSeqS.charAt(0) >= 78) errYn = true; //78:N
				} else if ("M".equals(tssScnCd)) {
					if (wbsCdSeqS.charAt(0) >= 78) errYn = true; //78:N
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

			insertErrLog(input);
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
			} else if ("O".equals(tssScnCd)) {
				//대외협력과제
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
			} else if ("N".equals(tssScnCd)) {
				//국책과제
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
			}else if ("D".equals(tssScnCd)) {
				// 기술팀 과제
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
			}else if ("M".equals(tssScnCd)) {
				// 제조혁신 과제
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

			//WBS_CD 조합 후 생성
			wbsCd = String.valueOf(getWbs.get("wbsCdStd")) + wbsCdSeq;
		}

		return wbsCd;
	}

	public void deleteGenTssPlnMstTssSt(HashMap<String, Object> input) {
		commonDao.delete("batch.deleteGenTssPlnMstTssSt", input);
	}

	// QAS 과제 등록
	@Override
	public void insertToQasTssQasIF(Map<String, Object> input) throws Exception {
		DbConn dbConn = new DbConn();
		Connection con;
		
		HashMap<String,Object> tssInfo = commonDao.select("prj.tss.com.selectTssInfo",input);
		PreparedStatement pstmt = null;
		
		StringBuffer sb = new StringBuffer();
		
		try {
			//제품만 등록
			if(tssInfo!=null && "00".equals(tssInfo.get("tssAttrCd"))){
				tssInfo.put("userId", "Batch");
				//공장 
				if( input.get("fcCd").equals("U") ){
					con = dbConn.getUConn();
				}else{
					con = dbConn.getOConn();
				}
				
				sb.append("MERGE INTO IF_QGATE 							");
				sb.append("					USING DUAL 					");
				sb.append("					ON (WBS_CD = ? )			");
				sb.append("					WHEN NOT MATCHED THEN 		");
				sb.append("			INSERT  							");
				sb.append("				   (                            ");
				sb.append("					   WBS_CD,                  ");
				sb.append("					   TSS_NM,                  ");
				sb.append("					   PRJ_CD,                  ");
				sb.append("					   PRJ_NM,                  ");
				sb.append("					   BIZ_DPT_CD,              ");
				sb.append("					   PROD_G,                  ");
				sb.append("					   SA_SABUN_CD,             ");
				sb.append("					   SA_SABUN_NM,             ");
				sb.append("					   TSS_STRT_DD,             ");
				sb.append("					   CUST_SQLT,               ");
				sb.append("					   TSS_TYPE,                ");
				sb.append("					   NPROD_SALS_PLN_Y,        ");
				sb.append("					   CTY_OT_PLN_M,            ");
				sb.append("					   FRST_RGST_DT,            ");
				sb.append("					   FRST_RGST_ID,            ");
				sb.append("					   LAST_MDFY_DT,            ");
				sb.append("					   LAST_MDFY_ID             ");
				sb.append("				   )                            ");
				sb.append("				   VALUES                       ");
				sb.append("				   (                            ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   ?,                       ");
				sb.append("					   SYSDATE,                 ");
				sb.append("					   ?,                       ");
				sb.append("					   SYSDATE,                 ");
				sb.append("					   ?                        ");
				sb.append("				   )                            ");
				sb.append("					WHEN MATCHED THEN           ");
				sb.append("					UPDATE SET                  ");
				sb.append("						TSS_NM = ?,             ");
				sb.append("						PRJ_CD = ?,             ");
				sb.append("						PRJ_NM = ?,             ");
				sb.append("						BIZ_DPT_CD = ?,         ");
				sb.append("						PROD_G = ?,             ");
				sb.append("						SA_SABUN_CD = ?,        ");
				sb.append("						SA_SABUN_NM = ?,        ");
				sb.append("						TSS_STRT_DD = ?,        ");
				sb.append("						CUST_SQLT = ?,          ");
				sb.append("						TSS_TYPE = ?,           ");
				sb.append("						NPROD_SALS_PLN_Y = ?,   ");
				sb.append("						CTY_OT_PLN_M = ?,       ");
				sb.append("						LAST_MDFY_DT = SYSDATE, ");
				sb.append("						LAST_MDFY_ID = ?        ");
			
				pstmt = con.prepareStatement(sb.toString()); 

				pstmt.setString(1,  tssInfo.get("wbsCd").toString());
				pstmt.setString(2,  tssInfo.get("wbsCd").toString());
				pstmt.setString(3,  tssInfo.get("tssNm").toString());
				pstmt.setString(4,  tssInfo.get("prjCd").toString());
				pstmt.setString(5,  tssInfo.get("prjNm").toString());
				pstmt.setString(6,  tssInfo.get("bizDptNm").toString());
				pstmt.setString(7,  tssInfo.get("prodGNm").toString());
				pstmt.setString(8,  tssInfo.get("saSabunNew").toString());
				pstmt.setString(9,  tssInfo.get("saSabunNm").toString());
				pstmt.setString(10, tssInfo.get("tssStrtDd").toString());
				pstmt.setString(11, tssInfo.get("custSqlt").toString());
				pstmt.setString(12, tssInfo.get("tssType").toString());
				pstmt.setString(13, tssInfo.get("nprodSalsPlnY").toString());
				pstmt.setString(14, tssInfo.get("ctyOtPlnM").toString());
				pstmt.setString(15, tssInfo.get("userId").toString());
				pstmt.setString(16, tssInfo.get("userId").toString());
				pstmt.setString(17, tssInfo.get("tssNm").toString());
				pstmt.setString(18, tssInfo.get("prjCd").toString());
				pstmt.setString(19, tssInfo.get("prjNm").toString());
				pstmt.setString(20, tssInfo.get("bizDptNm").toString());
				pstmt.setString(21, tssInfo.get("prodGNm").toString());
				pstmt.setString(22, tssInfo.get("saSabunNew").toString());
				pstmt.setString(23, tssInfo.get("saSabunNm").toString());
				pstmt.setString(24, tssInfo.get("tssStrtDd").toString());
				pstmt.setString(25, tssInfo.get("custSqlt").toString());
				pstmt.setString(26, tssInfo.get("tssType").toString());
				pstmt.setString(27, tssInfo.get("nprodSalsPlnY").toString());
				pstmt.setString(28, tssInfo.get("ctyOtPlnM").toString());
				pstmt.setString(29, tssInfo.get("userId").toString());
				
				pstmt.executeUpdate();
			}
			
			
		}catch(Exception e){
			pstmt.close();
			dbConn.closeConnection();
			throw new Exception("QAS 등록시 오류가 발생했습니다.");
		}
		
		pstmt.close();
		dbConn.closeConnection();
	}
}


