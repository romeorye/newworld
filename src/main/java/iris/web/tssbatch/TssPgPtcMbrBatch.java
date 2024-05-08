package iris.web.tssbatch;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import iris.web.common.util.StringUtil;
import iris.web.system.base.IrisBaseController;
import iris.web.tssbatch.service.TssPgPtcMbrService;

/********************************************************************************
 * NAME : TssPgPtcMbrBatch.java
 * DESC : 프로젝트(팀) 이 변경된 연구원은 모든 과제의 종료일자를 현재일자로 변겨어한다.
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.13  	 			 		최초생성
 *********************************************************************************/

@Controller
public class TssPgPtcMbrBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(TssPgPtcMbrBatch.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));


    @Resource(name = "tssPgPtcMbrService")
    private TssPgPtcMbrService tssPgPtcMbrService;

    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "BatchTssPG";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);

        String toDate = date_formatter.format(cal.getTime());
        
        LOGGER.debug("TssPgPtcMbrBatch_START-"+toDate);

     //   List<Map<String, Object>> data = tssPgPtcMbrService.retrieveTssPgMgr();
        
        tssPgPtcMbrService.updateTssPgMgr(input);
        
        LOGGER.debug("TssPgPtcMbrBatch_End-"+toDate);  
    	
    
    }
}