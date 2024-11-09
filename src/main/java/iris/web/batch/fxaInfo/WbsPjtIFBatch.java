package iris.web.batch.fxaInfo;

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

import iris.web.batch.fxaInfo.service.FxaInfoIFService;
import iris.web.batch.sap.service.SapBudgCostService;
import iris.web.common.util.StringUtil;
import iris.web.stat.code.service.ComCodeService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : WbsPjtIFBatch.java
 * DESC :
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.09  kyt               최초생성
 * 2024.07.03  SISEO             배치가 1번만 I/F테이블에 업데이트하도록 수정
 *********************************************************************************/


@Controller
public class WbsPjtIFBatch  extends IrisBaseController {


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

    static String functionName = "ZFI_P2MS_INVEST_MASTER";
    static String tableName ="T_WBS";
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)

    List<Map<String, Object>> list = null;

    public void batchProcess() {
        LOGGER.debug("WbsPjtIFBatch >> Start >>>>>>>>>>>>>>>>>>>>>>");

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
            LOGGER.debug("ERROR >> WbsPjtIFBatch : batchProcess  Connection Error "+e.toString());
            e.printStackTrace();
        }
        // 2. sap 데이터 조회
        try {
            list = this.getInserDataToTable();
        } catch (JCoException e) {
            LOGGER.debug("ERROR >> WbsPjtIFBatch : batchProcess  Saq Search Error"+e.toString());
            e.printStackTrace();
        }
        if(list.isEmpty()) {
            LOGGER.debug("WbsPjtIFBatch >> getInserDataToTable :Not found data >>>>>>>>>>>>>>>>>>>>>>");
        }else {
            try{
                //IF WBS테이블에 저장
                fxaInfoIFService.insertWbsPrjIFInfo(list);

                //[20]배치실행일자 저장
                try {
                    List<Map<String, Object>> codeList = new ArrayList<>();
                    result.put("batchYn", "Y");
                    result.put("_userId", "batch");
                    codeList.add(result);

                    comCodeService.saveCodeInfo(codeList);

                    LOGGER.debug("INFO >> WbsPjtIFBatch : ["+ nowDate +"] common code batch exec dt update ");
                } catch(Exception e) {
                    e.printStackTrace();
                }

            }catch(Exception e){
                e.printStackTrace();
            }
        }
        LOGGER.debug("WbsPjtIFBatch >> WbsPjtIFBatch : batchProcess  End >>>>>>>>>>>>>>>>>>>>>>");
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
                /*
                String toDay = DateUtil.getDate();

                function.getImportParameterList().setValue("I_DATUM", toDay);
                function.getImportParameterList().setValue("I_ANLN1", "");
               */
                function.execute(destination);

            }catch(AbapException e){
                    LOGGER.debug("ERROR >> WbsPjtIFBatch :   function.execute Error"+e.toString());
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

                map.put("wbsCd"        , codes.getString("ERP_CD").trim());        /*wbs cd                             */
                map.put("prjNm"        , codes.getString("ERP_NM").trim());        /*prj nm                               */


                list.add(map);
            }

            return list;
        }

}
