package iris.web.genTssStatBatch;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import iris.web.genTssStatBatch.service.GenTssStatService;

public class GenTssStatBatch {


	@Resource(name = "genTssStatService")
	private GenTssStatService genTssStatService;

	static final Logger LOGGER = LogManager.getLogger(GenTssStatBatch.class);

    public void batchProcess() {
    	LOGGER.debug("genTssStatService >> Start >>>>>>>>>>>>>>>>>>>>>>");

    	//1. 데이터 조회
		try{
			genTssStatService.genTssStatBatch();
		}catch(Exception e){
			e.printStackTrace();
		}

    }


}
