package iris.web.space.batch;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import iris.web.space.batch.service.SpaceApprMailService;
import iris.web.space.rqpr.vo.SpaceMailInfo;
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
public class SpaceApprMailBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(SpaceApprMailBatch.class);

	@Resource(name = "spaceApprMailService")
	private SpaceApprMailService spaceApprMailService;

    @Transactional
    public void batchProcess() throws SQLException, ClassNotFoundException {

        LOGGER.debug("=================== SpaceApprMailBatch_START ======================");
        
        try {
        	List<SpaceMailInfo> spaceRqprApprCompleteList = spaceApprMailService.getSpaceRqprApprCompleteList();
        	
        	for(SpaceMailInfo spaceMailInfo : spaceRqprApprCompleteList) {
        		try {
            		spaceApprMailService.sendReceiptRequestMail(spaceMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== SpaceApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + spaceMailInfo.getRqprId() + " 접수요청 이메일 발송 오류 =====");
        			LOGGER.debug("=================== SpaceApprMailBatch_ERROR ======================");
                    e.printStackTrace();
        		}
        	}
        	
        	List<SpaceMailInfo> spaceRsltApprCompleteList = spaceApprMailService.getSpaceRsltApprCompleteList();
        	
        	for(SpaceMailInfo spaceMailInfo : spaceRsltApprCompleteList) {
        		try {
            		spaceApprMailService.sendSpaceRqprResultMail(spaceMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== SpaceApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + spaceMailInfo.getRqprId() + " 분석결과 통보 이메일 발송 오류 =====");
        			LOGGER.debug("=================== SpaceApprMailBatch_ERROR ======================");
                    e.printStackTrace();
        		}
        	}
        	
            LOGGER.debug("=================== SpaceApprMailBatch_END ======================");

        }catch(Exception e){
        	LOGGER.debug("=================== SpaceApprMailBatch_ERROR ======================");
            e.printStackTrace();
        }
    }
}