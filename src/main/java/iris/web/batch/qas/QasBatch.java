package iris.web.batch.qas;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import iris.web.batch.qas.service.QasBatchService;

public class QasBatch {

	@Resource(name = "qasBatchService")
	private QasBatchService qasBatchService;

	static final Logger LOGGER = LogManager.getLogger(QasBatch.class);

	public void batchProcess() {
		LOGGER.debug("qasService >> Start >>>>>>>>>>>>>>>>>>>>>>");

		try {
			qasBatchService.batchProcess();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
