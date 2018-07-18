package iris.web.anl.batch;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import iris.web.anl.batch.service.AnlApprMailService;
import iris.web.anl.rqpr.vo.AnlMailInfo;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : MmTodoCalBatch.java
 * DESC : 분석 결재관련 메일 발송
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.18  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class AnlApprMailBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(AnlApprMailBatch.class);

	@Resource(name = "anlApprMailService")
	private AnlApprMailService anlApprMailService;

    @Transactional
    public void batchProcess() throws SQLException, ClassNotFoundException {

        LOGGER.debug("=================== AnlApprMailBatch_START ======================");
        
        try {
        	List<AnlMailInfo> anlRqprApprCompleteList = anlApprMailService.getAnlRqprApprCompleteList();
        	
        	for(AnlMailInfo anlMailInfo : anlRqprApprCompleteList) {
        		try {
            		anlApprMailService.sendReceiptRequestMail(anlMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== AnlApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + anlMailInfo.getRqprId() + " 접수요청 이메일 발송 오류 =====");
        			LOGGER.debug("=================== AnlApprMailBatch_ERROR ======================");
                    e.printStackTrace();
        		}
        	}
        	
        	List<AnlMailInfo> anlRsltApprCompleteList = anlApprMailService.getAnlRsltApprCompleteList();
        	
        	for(AnlMailInfo anlMailInfo : anlRsltApprCompleteList) {
        		try {
            		anlApprMailService.sendAnlRqprResultMail(anlMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== AnlApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + anlMailInfo.getRqprId() + " 분석결과 통보 이메일 발송 오류 =====");
        			LOGGER.debug("=================== AnlApprMailBatch_ERROR ======================");
                    e.printStackTrace();
        		}
        	}
        	
            LOGGER.debug("=================== AnlApprMailBatch_END ======================");

        }catch(Exception e){
        	LOGGER.debug("=================== AnlApprMailBatch_ERROR ======================");
            e.printStackTrace();
        }
    }
}