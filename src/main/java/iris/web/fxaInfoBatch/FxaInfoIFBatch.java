package iris.web.fxaInfoBatch;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import com.sap.conn.jco.AbapException;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoTable;

import devonframe.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.fxaInfoBatch.service.FxaInfoIFService;
import iris.web.sapBatch.service.SapBudgCostService;
import iris.web.stat.code.service.ComCodeService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : FxaInfoIFBatch.java
 * DESC :
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.05.23  PARKWS            최초생성
 * 2024.07.03  SISEO             배치가 1번만 I/F테이블에 업데이트하도록 수정
 *********************************************************************************/


@Controller
public class FxaInfoIFBatch  extends IrisBaseController {


    @Resource(name = "sapBudgCostService")
    private SapBudgCostService sapBudgCostService;

    @Resource(name = "fxaInfoIFService")
    private FxaInfoIFService fxaInfoIFService;

    @Resource(name="comCodeService")
    private ComCodeService comCodeService;

    static final Logger LOGGER = LogManager.getLogger(FxaInfoIFBatch.class);

    /*
     * connection 정보
     */

    static String functionName = "ZFI_P2MS_ASSET_LIST";
    static String tableName ="IF_ASSETRSLT";
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)

    List<Map<String, Object>> list = null;

    public void batchProcess() {
        LOGGER.debug("FxaInfoIFBatch >> Start >>>>>>>>>>>>>>>>>>>>>>");

        List<Map<String,Object>> resultList = new ArrayList<>();
        Map<String, Object> result = new HashMap<>();
        String nowDate = StringUtil.getStandardDateFormat(StringUtil.getCurrentYYYYMMDDhhmiss().substring(0,8), false);

        try {
            HashMap<String, Object> input = new HashMap<String, Object>();
            input = new HashMap<String, Object>();
            input.put("code", "RFC_FUNC");
            input.put("codeDNm", functionName+'.'+tableName);
            input.put("delYn", "N");

            //[10]배치실행일자 조회
            resultList = comCodeService.retrieveCcomCodeList(input);

            String batchExecDtDisp = ""; //배치실행일자 10자리

            if (resultList.size()>0) {
                result = resultList.get(0);
                String batchExecDt = String.valueOf(result.get("batchExecDt"));
                if (!StringUtil.isNullString(batchExecDt) && batchExecDt.length()>=10) {
                    batchExecDtDisp = batchExecDt.substring(0,10);
                }

                //[20240703.siseo]배치실행일자를 체크하여 이미 배치가 처리가 되었으면 종료함.
                if (nowDate.equals(batchExecDtDisp)) {

                    LOGGER.debug("INFO >> FxaInfoIFBatch : ["+ nowDate +"] exists record and exits.");

                    return;
                }
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        //1.sap 연결
        try {
            sapBudgCostService.sapConnection() ;
        } catch (IOException e) {
            LOGGER.debug("ERROR >> FxaInfoIFBatch : batchProcess  Connection Error "+e.toString());
            e.printStackTrace();
        }
        // 2. sap 데이터 조회
        try {
            list = this.getInserDataToTable();
        } catch (JCoException e) {
            LOGGER.debug("ERROR >> FxaInfoIFBatch : batchProcess  Saq Search Error"+e.toString());
            e.printStackTrace();
        }
        if(list.isEmpty()) {
            LOGGER.debug("FxaInfoIFBatch >> getInserDataToTable :Not found data >>>>>>>>>>>>>>>>>>>>>>");
        }else {
            try{
                //IF 자산테이블에 저장
                fxaInfoIFService.insertFxaInfoIF(list);

                //[20]배치실행일자 저장
                try {
                    List<Map<String, Object>> codeList = new ArrayList<>();
                    result.put("batchYn", "Y");
                    result.put("_userId", "batch");
                    codeList.add(result);

                    comCodeService.saveCodeInfo(codeList);

                    LOGGER.debug("INFO >> FxaInfoIFBatch : ["+ nowDate +"] common code batch exec dt update ");
                } catch(Exception e) {
                    e.printStackTrace();
                }

            }catch(Exception e){
                e.printStackTrace();
            }
        }
        LOGGER.debug("FxaInfoIFBatch >> FxaInfoIFBatch : batchProcess  End >>>>>>>>>>>>>>>>>>>>>>");
    }

    /**
     * 데이터 저장
     * @return
     * @throws JCoException
     */
    public List<Map<String, Object>>  getInserDataToTable() throws JCoException{

        LOGGER.debug("테이블가져오기 실행");
        JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);

        //연결정보확인.
        JCoFunction function = destination.getRepository().getFunction(functionName);
        LOGGER.debug("####################################  RFC function:" + functionName);

        if(function == null) throw new RuntimeException("SAP_DATA not found in SAP.");

            try{
                String toDay = DateUtil.getDate();

                function.getImportParameterList().setValue("I_DATUM", toDay);
                function.getImportParameterList().setValue("I_ANLN1", "");

                function.execute(destination);

            }catch(AbapException e){
                    LOGGER.debug("ERROR >> FxaInfoIFBatch :   function.execute Error"+e.toString());
                    //System.out.println(e.toString());
            }

            // 테이블 호출
            JCoTable codes = function.getTableParameterList().getTable(tableName);
            LOGGER.debug("####################################  JCoTable codes:" + codes);

            list = new ArrayList<Map<String, Object>>();

                // 데이터 조회
            for (int i = 0; i < codes.getNumRows(); i++){
                codes.setRow(i);
                Map<String, Object> map = new HashMap<String, Object>();

                map.put("assetNo"        , codes.getString("ASSET_NO").trim());        /*자산번호                             */
                map.put("assetNm"        , codes.getString("ASSET_NM").trim());        /*자산명                               */
                map.put("cctrCd"        , codes.getString("CCTR_CD").trim());        /*코스트센터                           */
                map.put("assetClas"        , codes.getString("ASSET_CLAS").trim());    /*자산클래스                           */
                map.put("assetText"        , codes.getString("ASSET_TEXT").trim());    /*주요자산 텍스트                      */
                map.put("acqrDt"        , codes.getString("ACQR_DT").trim());        /*취득일자                             */
                map.put("redmRate"        , codes.getString("REDM_RATE").trim());        /*상각률                               */
                map.put("acqrBef"        , codes.getString("ACQR_BEF").trim());        /*취득가전기                           */
                map.put("acqrIcdc"        , codes.getString("ACQR_ICDC").trim());        /*취득가증감                           */
                map.put("acqrBal"        , codes.getString("ACQR_BAL").trim());        /*취득가잔액                           */
                map.put("apprBef"        , codes.getString("APPR_BEF").trim());        /*충당금 전기                          */
                map.put("apprIcdc"        , codes.getString("APPR_ICDC").trim());        /*충당금 증감                          */
                map.put("apprBal"        , codes.getString("APPR_BAL").trim());        /*충당금 잔액                          */
                   map.put("thtermRedm"    , codes.getString("THTERM_REDM").trim());    /*당기상각액                           */
                   map.put("thmmRedm"        , codes.getString("THMM_REDM").trim());        /*당월상각비                           */
                   map.put("exsiYys"        , codes.getString("EXSI_YYS").trim());        /*내용연수                             */
                   map.put("bookAmt"        , codes.getString("BOOK_AMT").trim());        /*장부가액                             */
                   map.put("invsmCd"        , codes.getString("INVSM_CD").trim());        /*투자 WBS Code                        */
                   map.put("bizTrty"        , codes.getString("BIZ_TRTY").trim());        /*사업영역                             */
                   map.put("wbs1"            , codes.getString("WBS1").trim());            /*WBS 1                                */
                   map.put("rulE1"            , codes.getString("RULE1").trim());        /*배부율 1                             */
                   map.put("wbs2"            , codes.getString("WBS2").trim());            /*WBS 2                                */
                   map.put("rule2"            , codes.getString("RULE2").trim());        /*배부율 2                             */
                   map.put("wbs3"            , codes.getString("WBS3").trim());            /*WBS 3                                */
                   map.put("rule3"            , codes.getString("RULE3").trim());        /*배부율 3                             */
                   map.put("pernr"            , codes.getString("PERNR").trim());        /*사원 번호                            */
                   map.put("ename"            , codes.getString("ENAME").trim());        /*사원 또는 지원자의 포맷된 이름       */
                   map.put("bwasl"            , codes.getString("BWASL").trim());            /*거래유형                             */
                   map.put("deakt"            , codes.getString("DEAKT").trim());        /*비활성화일                           */
                   map.put("menge"            , codes.getString("MENGE").trim());        /*수량 (nvarchar()                     */
                   map.put("meins"            , codes.getString("MEINS").trim());            /*기본 단위                            */

                list.add(map);
            }

          return list;
        }

}
