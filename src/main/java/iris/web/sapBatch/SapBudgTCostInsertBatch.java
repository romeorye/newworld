package iris.web.sapBatch;

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

import iris.web.sapBatch.service.SapBudgCostService;
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
public class SapBudgTCostInsertBatch  extends IrisBaseController {

	
	@Resource(name = "sapBudgCostService")
	private SapBudgCostService sapBudgCostService;	
	
	static final Logger LOGGER = LogManager.getLogger(SapBudgTCostInsertBatch.class);
	
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));
    
    
    /*
     * connection 정보
     */
    
    static String functionName = "ZCOPMS04";
    static String tableName ="T_COST";
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)

    List<Map<String, Object>> list = null;
     
	public void batchProcess() {
		
		LOGGER.debug("SapBudgSCostInsertBatch_START");	
		sapBudgCostService.log("SapBudgTCostInsertBatch_START >> SapBudgTCostInsertBatch : batchProcess  Start >>>>>>>>>>>>>>>>>>>>>>");
		//1.sap 연결
		try {
			sapBudgCostService.sapConnection() ;
		} catch (IOException e) {
			sapBudgCostService.log("ERROR >> SapBudgTCostInsertBatch : batchProcess  Connection Error "+e.toString());	
			e.printStackTrace();
		}
		// 2. sap 데이터 조회
		try {
			list = this.getInserDataToTable();
		} catch (JCoException e) {
			sapBudgCostService.log("ERROR >> SapBudgTCostInsertBatch : batchProcess  Saq Search Error"+e.toString());	
			e.printStackTrace();
		}
		// 3. row data 저장
		sapBudgCostService.insertBudgTCost(list);
		
		sapBudgCostService.log("SapBudgTCostInsertBatch_End >> SapBudgtCostInsertBatch : batchProcess  End >>>>>>>>>>>>>>>>>>>>>>");
	}
	
	

	/**
	 * 데이터 조회 
	 * @return
	 * @throws JCoException
	 */
	 public List<Map<String, Object>>  getInserDataToTable() throws JCoException{

		LOGGER.debug("테이블가져오기 실행");
	    
	    JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
	    JCoFunction function = destination.getRepository().getFunction(functionName); 
	    
	    //연결정보확인.
	    LOGGER.debug("Attributes:");
	    LOGGER.debug(destination.getAttributes());
	    
	        if(function == null)

	            throw new RuntimeException("SAP_DATA not found in SAP.");

	        try{ 
	            function.execute(destination);
	            LOGGER.debug("실행완료::!!");

	        }catch(AbapException e){
	        	sapBudgCostService.log("ERROR >> sapBudgTCostBatch : listBtn  function.execute Error"+e.toString());	
	            System.out.println(e.toString());
//	            return list;

	        }
	        // 테이블 호출
	        JCoTable codes = function.getTableParameterList().getTable(tableName);
           list = new ArrayList<Map<String, Object>>(); 
	 
         // 데이터 조회
           
          for (int i = 0; i < codes.getNumRows(); i++){

	         codes.setRow(i);    
             Map<String, Object> map = new HashMap<String, Object>();
             map.put("erpCd",	codes.getString("ERP_CD"		));
             map.put("prvDt",	codes.getString("PRV_DT"		));
             map.put("acctCd",	codes.getString("ACCT_CD"		));
             map.put("belnr",	codes.getString("BELNR"			));
             map.put("buzei",	codes.getString("BUZEI"			));
             map.put("acctNm",	codes.getString("ACCT_NM"		));
             map.put("dlcoCd",	codes.getString("DLCO_CD"		));
             map.put("dlcoNm",	codes.getString("DLCO_NM"		));
             map.put("koRslt",	codes.getString("KO_RSLT"		));
             map.put("spotRslt",	codes.getString("SPOT_RSLT"		));
             map.put("sAcctCd",	codes.getString("S_ACCT_CD"		));
             map.put("sAcctNm",	codes.getString("S_ACCT_NM"		));
             map.put("erpNm",	codes.getString("ERP_NM"		));
             map.put("desc1",	codes.getString("DESC1"			));
             map.put("desc2",	codes.getString("DESC2"			));
             map.put("desc3",	codes.getString("DESC3"			));
             map.put("fiscYy",	codes.getString("FISC_YY"		));
             map.put("profDt",	codes.getString("PROF_DT"		));
             map.put("inputId",	codes.getString("INPUT_ID"		));
             map.put("spotCurr",	codes.getString("SPOT_CURR"		));
             map.put("blart",	codes.getString("BLART"			));
             map.put("wrttp",	codes.getString("WRTTP"			));
             map.put("beknz",	codes.getString("BEKNZ"			));
             map.put("awtyp",	codes.getString("AWTYP"			));
             map.put("gubun",	codes.getString("GUBUN"			));
             list.add(map);
           
	        }
          return list;
	    }	  
	
	
}
	

