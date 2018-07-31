package iris.web.rlab.batch;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import iris.web.rlab.batch.service.RlabApprMailService;
import iris.web.rlab.rqpr.vo.RlabMailInfo;
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
public class RlabApprMailBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(RlabApprMailBatch.class);

	@Resource(name = "rlabApprMailService")
	private RlabApprMailService rlabApprMailService;

    @Transactional
    public void batchProcess() throws SQLException, ClassNotFoundException {

        LOGGER.debug("=================== RlabApprMailBatch_START ======================");
        
        try {
        	List<RlabMailInfo> rlabRqprApprCompleteList = rlabApprMailService.getRlabRqprApprCompleteList();
        	
        	for(RlabMailInfo rlabMailInfo : rlabRqprApprCompleteList) {
        		try {
            		rlabApprMailService.sendReceiptRequestMail(rlabMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== RlabApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + rlabMailInfo.getRqprId() + " 접수요청 이메일 발송 오류 =====");
        			LOGGER.debug("=================== RlabApprMailBatch_ERROR ======================");
                    e.printStackTrace();
        		}
        	}
        	
        	List<RlabMailInfo> rlabRsltApprCompleteList = rlabApprMailService.getRlabRsltApprCompleteList();
        	
        	for(RlabMailInfo rlabMailInfo : rlabRsltApprCompleteList) {
        		try {
            		rlabApprMailService.sendRlabRqprResultMail(rlabMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== RlabApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + rlabMailInfo.getRqprId() + " 분석결과 통보 이메일 발송 오류 =====");
        			LOGGER.debug("=================== RlabApprMailBatch_ERROR ======================");
                    e.printStackTrace();
        		}
        	}
        	
            LOGGER.debug("=================== RlabApprMailBatch_END ======================");

        }catch(Exception e){
        	LOGGER.debug("=================== RlabApprMailBatch_ERROR ======================");
            e.printStackTrace();
        }
    }
}