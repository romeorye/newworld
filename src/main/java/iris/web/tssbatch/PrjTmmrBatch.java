package iris.web.tssbatch;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import iris.web.system.base.IrisBaseController;
import iris.web.tssbatch.service.PrjTmmrService;

/********************************************************************************
 * NAME : TssPgPtcMbrBatch.java
 * DESC : 1. 유저가 퇴사,부서이동한 경우 프로젝트 참여연구원에 반영되어야 한다.
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.29  	 			 		최초생성
 *********************************************************************************/

@Controller
public class PrjTmmrBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(TssPgPtcMbrBatch.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));

    @Resource(name = "prjTmmrService")
    private PrjTmmrService prjTmmrService;	// 프로젝트 팀원변경 체크 서비스
    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "BatchPrjTmmr";
        String toDate = date_formatter.format(cal.getTime());
        HashMap<String, Object> input = new HashMap<String, Object>();
        
        // 1.프로젝트 참여연구원 부서,인원 변동 자동처리
        LOGGER.debug("PrjTmmrBatch_START-"+toDate);
        
        int prjTmmrResignCnt = 0;
        int prjTmmrMoveOutCnt = 0;
        int prjTmmrMoveInCnt = 0;
        
        // 1.1. 프로젝트 참여연구원 퇴사자 참여종료일 업데이트
        List<HashMap<String,Object>> prjTmmrResignList = prjTmmrService.retrievePrjTmmrResignList(input);
       
        if(prjTmmrResignList != null && prjTmmrResignList.size() > 0) {
        	for(HashMap<String,Object> prjTmmrResignMap : prjTmmrResignList) {
        		
        		//if( !"00999999".equals(prjTmmrResignMap.get("tmmrEmpNo")) ) { continue; }
        		
        		prjTmmrResignMap.put("_userId", userId);
        		
        		prjTmmrService.updatePrjTmmrResign(prjTmmrResignMap);
        		prjTmmrResignCnt++;
        	}
        }
        
        // 1.2. 프로젝트 참여연구원 부서이동(이동전) 참여종료일 업데이트
        List<HashMap<String,Object>> prjTmmrMoveOutList = prjTmmrService.retrievePrjTmmrMoveOutList(input);
        if(prjTmmrMoveOutList != null && prjTmmrMoveOutList.size() > 0) {
        	for(HashMap<String,Object> prjTmmrMoveOutMap : prjTmmrMoveOutList) {
        		
        		//if( !"00999999".equals(prjTmmrMoveOutMap.get("tmmrEmpNo")) ) { continue; }
        		
        		prjTmmrMoveOutMap.put("_userId", userId);
        		
        		prjTmmrService.updatePrjTmmrMoveOut(prjTmmrMoveOutMap);
        		prjTmmrMoveOutCnt++;
        	}
        }
        
        // 1.3. 프로젝트 참여연구원 부서이동(이동후) 신규등록
        List<HashMap<String,Object>> prjTmmrMoveInList = prjTmmrService.retrievePrjTmmrMoveInList(input);
        if(prjTmmrMoveInList != null && prjTmmrMoveInList.size() > 0) {
        	for(HashMap<String,Object> prjTmmrMoveInMap : prjTmmrMoveInList) {
        		
        		//if( !"00999999".equals(prjTmmrMoveInMap.get("tmmrEmpNo")) ) { continue; }
        		
        		prjTmmrMoveInMap.put("_userId", userId);
        		
        		prjTmmrService.insertPrjTmmrMoveIn(prjTmmrMoveInMap);
        		prjTmmrMoveInCnt++;
        	}
        }
        
        LOGGER.debug("process prjTmmrResignCnt : "+prjTmmrResignCnt);
        LOGGER.debug("process prjTmmrMoveOutCnt : "+prjTmmrMoveOutCnt);
        LOGGER.debug("process prjTmmrMoveInCnt : "+prjTmmrMoveInCnt);
        LOGGER.debug("total process count-"+ (prjTmmrResignCnt+prjTmmrMoveOutCnt+prjTmmrMoveInCnt) );
        
        LOGGER.debug("PrjTmmrBatch_End-"+toDate);  
    	
    
    }
}