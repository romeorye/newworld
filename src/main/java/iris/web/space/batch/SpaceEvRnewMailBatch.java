package iris.web.space.batch;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import iris.web.space.batch.service.SpaceEvRnewMailService;
import iris.web.space.rqpr.vo.SpaceEvRnewMailInfo;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SpaceApprMailBatch.java
 * DESC : 공간평가 성적서 갱신 메일 발송
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.18  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class SpaceEvRnewMailBatch  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(SpaceApprMailBatch.class);

	@Resource(name = "spaceEvRnewMailService")
	private SpaceEvRnewMailService spaceEvRnewMailService;

    @Transactional
    public void batchProcess() throws SQLException, ClassNotFoundException {

        LOGGER.debug("=================== SpaceApprMailBatch_START ======================");

        try {
        	List<SpaceEvRnewMailInfo> spaceRqprApprCompleteList = spaceEvRnewMailService.getSpaceEvRnewMailList();

        	for(SpaceEvRnewMailInfo spaceEvRnewMailInfo : spaceRqprApprCompleteList) {
        		try {
        			spaceEvRnewMailService.sendSpaceEvRnewMail(spaceEvRnewMailInfo);
        		}catch(Exception e) {
        			LOGGER.debug("=================== SpaceApprMailBatch_ERROR ======================");
        			LOGGER.debug("===== rqprId : " + spaceEvRnewMailInfo.getRqprId() + " 공간평가 접수요청 이메일 발송 오류 =====");
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