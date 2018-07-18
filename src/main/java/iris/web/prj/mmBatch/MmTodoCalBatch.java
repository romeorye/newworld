package iris.web.prj.mmBatch;

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

import iris.web.prj.mmBatch.service.MmTodoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : MmTodoCalBatch.java
 * DESC : M/M 입력, M/M마감 To-do 프로시져 호출
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.18  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class MmTodoCalBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(MmTodoCalBatch.class);
    
    @Resource(name = "mmTodoService")
    private MmTodoService mmTodoService;

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
//    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));

    @Transactional
    public void batchProcess() throws SQLException, ClassNotFoundException {

        String toDate = date_formatter.format(cal.getTime());
        LOGGER.debug("=================== MmTodoCalBatch_START-"+toDate+"======================");
        
        Map<String, Object> inputParam = null;	// input파라미터맵
        int mmInTodoCnt = 0;
        int mmClsTodoCnt = 0;
        int toTalCnt = 0;


        try {
        	
        	// 1.1. M/M입력 뷰 조회
        	List<Map<String, Object>> mmInTodoList = mmTodoService.retrieveMmInTodoList();	// 현재 to-do 완료여부가 N인 대상 조회
        	if(mmInTodoList != null ) {
	        	for( Map<String, Object> mmInTodoMap : mmInTodoList) {
	        		
	        		// 1.2. M/M입력 TO-DO 프로시져 실행
	        		inputParam = new HashMap<String, Object>();
	        		inputParam.put("todoReqNo", mmInTodoMap.get("todoReqNo") );
	        		inputParam.put("todoEmpNo", mmInTodoMap.get("todoEmpNo") );
	        		mmTodoService.saveMmpUpMwTodoReq(inputParam);
	        		
	        		mmInTodoCnt++;
	        	}
        	}
        	
        	// 2.1. M/M마감 뷰 조회
        	List<Map<String, Object>> mmClsTodoList = mmTodoService.retrieveMmClsTodoList();	// 현재 to-do 완료여부가 N인 대상 조회
        	if(mmClsTodoList != null) {
	        	for( Map<String, Object> mmClsTodoMap : mmClsTodoList) {
	        		
	        		// 2.2. M/M마감 TO-DO 프로시져 실행
	        		inputParam = new HashMap<String, Object>();
	        		inputParam.put("todoReqNo", mmClsTodoMap.get("todoReqNo") );
	        		inputParam.put("todoEmpNo", mmClsTodoMap.get("todoEmpNo") );
	        		mmTodoService.saveMmlUpMwTodoReq(inputParam);
	        		
	        		mmClsTodoCnt++;
	        	}
        	}
        	
        	LOGGER.debug("=================== MmTodoCalBatch_mmInTodoCnt : "+mmInTodoCnt+"======================");
        	LOGGER.debug("=================== MmTodoCalBatch_mmClsTodoCnt : "+mmClsTodoCnt+"======================");
        	LOGGER.debug("=================== MmTodoCalBatch_toTalCnt : "+toTalCnt+"======================");
            LOGGER.debug("=================== MmTodoCalBatch_END-"+toDate+"======================");

        }catch(Exception e){
        	LOGGER.debug("=================== MmTodoCalBatch_ERROR ======================");
            e.printStackTrace();
        }
    }
}


