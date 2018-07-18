package iris.web.tssbatch;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import iris.web.common.util.StringUtil;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.system.base.IrisBaseController;
import iris.web.tssbatch.service.TssStCopyService;


/********************************************************************************
 * NAME : TssStCopyBatch.java
 * DESC : 과제 copy
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.21  	 			 최초생성
 *********************************************************************************/

@Controller
public class TssStCopyBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(TssStCopyBatch.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));


    @Resource(name = "tssStCopyService")
    private TssStCopyService tssStCopyService;


    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Transactional
    public void batchProcess() throws SQLException, ClassNotFoundException {

        String toDate = date_formatter.format(cal.getTime());
        LOGGER.debug("GenTssCopyBatch_START-"+toDate);

        String userId = "Batch";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);

        Map<String,Object> rtnMap = new HashMap<String, Object>(); // 메시지

        try {
            //1. 과제 및 통합결재 조회
            List<Map<String, Object>> retrieveTssComItgRdcs= tssStCopyService.retrieveTssComItgRdcs();

            //2. 과제 상태 변경 -> 104
            for(Map<String, Object> data : retrieveTssComItgRdcs) {
                String aprdocstate = String.valueOf(data.get("aprdocstate")); //품의상태

                if(!StringUtil.isNullString(aprdocstate)) {
                    String tssSt = "103";
                    boolean rst = false;

                    input.put("tssCd", data.get("affrCd")); //과제코드

                    if("A02".equals(aprdocstate)) {
                        if("503".equals(String.valueOf(data.get("tssSt")))) {
                            tssSt = "504"; //504 정산품의완료,
                        }else {
                            tssSt = "104"; //104 품의완료,
                            rst = true;
                        }
                        
                        input.put("tssSt", tssSt); //상태 코드
                        genTssPlnService.updateGenTssPlnMstTssSt(input);
                    }
                    else if("A03".equals(aprdocstate) || "A04".equals(aprdocstate)) {
                        
                    	if( data.get("tssScnCd").equals("N")){
                    		if(data.get("finYn").equals("Y") || (data.get("tssNosSt").equals("1") && data.get("pgsStepCd").equals("PL")) ){
                    			tssSt = "102"; // 
                    		}else{
                    			tssSt = "100"; // 
                    		}
                    	}else{
                    		tssSt = "102"; // GRS완료
                    	}
                        input.put("tssSt", tssSt); //상태 코드
                        
                        genTssPlnService.updateGenTssPlnMstTssSt(input);
                    }

                    if(rst) {
                        data.put("userId", userId) ;
                        //2.2 상태에 따른 tsscd 생성
                        tssStCopyService.insertTssCopy(data);
                    }
                }
            }

            LOGGER.debug("GenTssCopyBatch_End-"+toDate);

        }catch(Exception e){
            e.printStackTrace();
        }
    }



}


