package iris.web.batch.sap;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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

import iris.web.batch.sap.service.SapBudgCostService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SapBudgSCostInsertBatch.java
 * DESC :
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.05.23  PARKWS 			  최초생성
 *********************************************************************************/


@Controller
public class SapBudgSCostInsertBatch  extends IrisBaseController {


    @Resource(name = "sapBudgCostService")
    private SapBudgCostService sapBudgCostService;

    static final Logger LOGGER = LogManager.getLogger(SapBudgSCostInsertBatch.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));


    /*
     * connection 정보
     */

    static String functionName = "ZCOPMS04";
    static String tableName ="S_COST";
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)

    List<Map<String, Object>> list = null;
    int yy;
    int mm;

    public void batchProcess() {

        LOGGER.debug("SapBudgSCostInsertBatch_START");
        sapBudgCostService.log("SapBudgSCostInsertBatch_START >> SapBudgSCostInsertBatch : batchProcess  Start >>>>>>>>>>>>>>>>>>>>>>");
        //1.sap 연결
        try {
            sapBudgCostService.sapConnection() ;
        } catch (IOException e) {
            sapBudgCostService.log("ERROR >> SapBudgSCostInsertBatch : batchProcess  Connection Error "+e.toString());
            e.printStackTrace();
        }

        //2. sap 데이터 조회
        try {
            cal.add(Calendar.MONTH, -1);

            yy = cal.get(Calendar.YEAR);
            mm = cal.get(Calendar.MONTH) + 1;

            list = this.getInserDataToTable();

        } catch (JCoException e) {
            sapBudgCostService.log("ERROR >> SapBudgSCostInsertBatch : batchProcess  Saq Search Error"+e.toString());
            e.printStackTrace();
        }

        if(list.isEmpty()) {
            sapBudgCostService.log("SapBudgSCostInsertBatch_noData >> getInserDataToTable :Not found data >>>>>>>>>>>>>>>>>>>>>>");
        } else {
            // 3. row data 저장
            int rstCnt = sapBudgCostService.insertBudgSCost(list);

            // 4.예산 table 저장 IRIS_TSS_GEN_TRWI_BUDG_MST -과제의 계획이 미리 저장되어 있어야지 update 가능함
            if(rstCnt > 0) {
                HashMap map = new HashMap();
                String pMm = String.valueOf(mm);
                if(pMm.length() == 1) pMm = "0"+pMm;

                map.put("yyyymm", String.valueOf(yy) + pMm);

                //sapBudgCostService.updateTssGenTrwiBudgMst(map);
            }
        }

        sapBudgCostService.log("SapBudgSCostInsertBatch_End >> SapBudgSCostInsertBatch : batchProcess  End >>>>>>>>>>>>>>>>>>>>>>");
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
        LOGGER.debug("Attributes:");
        LOGGER.debug(destination.getAttributes());


        JCoFunction function = destination.getRepository().getFunction(functionName);

        if(function == null) throw new RuntimeException("SAP_DATA not found in SAP.");

        try{
            function.getImportParameterList().setValue("I_YEAR", yy);
            function.getImportParameterList().setValue("I_MONTH", mm);

            function.execute(destination);
            LOGGER.debug("실행완료::!!");
        }catch(AbapException e){
            sapBudgCostService.log("ERROR >> sapBudgSCostBatch : IRIS_SAP_BUDG_S_COST  function.execute Error"+e.toString());
            System.out.println(e.toString());
        }

        // 테이블 호출
        JCoTable codes = function.getTableParameterList().getTable(tableName);
        list = new ArrayList<Map<String, Object>>();

        // 데이터 조회

        String pKoRslt = "";
        int pKoRsltLen = 0;

        for(int i = 0; i < codes.getNumRows(); i++) {
            codes.setRow(i);

            Map<String, Object> map = new HashMap<String, Object>();

            pKoRslt = codes.getString("KO_RSLT").trim();
            pKoRsltLen = pKoRslt.length();
            if("-".equals(pKoRslt.substring(pKoRsltLen-1, pKoRsltLen))) {
                pKoRslt = "-" + pKoRslt.substring(0, pKoRsltLen-1);
            }

            map.put("erpCd", 		codes.getString("ERP_CD"));
            map.put("yyyymm", 		codes.getString("YYYYMM"));
            map.put("lGroup", 		codes.getString("L_GROUP"));
            map.put("sGroup", 		codes.getString("S_GROUP"));
            map.put("lGrouptxt", 	codes.getString("L_GROUPTXT"));
            map.put("sGrouptxt", 	codes.getString("S_GROUPTXT"));
            map.put("koRslt", 		pKoRslt);

            list.add(map);
        }

        return list;
    }
}


