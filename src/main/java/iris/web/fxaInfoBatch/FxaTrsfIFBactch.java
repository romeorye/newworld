package iris.web.fxaInfoBatch;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import iris.web.fxaInfoBatch.service.FxaInfoIFService;
import iris.web.sapBatch.service.SapBudgCostService;
import iris.web.system.base.IrisBaseController;

@Controller
public class FxaTrsfIFBactch extends IrisBaseController {

	@Resource(name = "sapBudgCostService")
	private SapBudgCostService sapBudgCostService;	
	
	@Resource(name = "fxaInfoIFService")
	private FxaInfoIFService fxaInfoIFService;
	
	static final Logger LOGGER = LogManager.getLogger(FxaInfoIFBatch.class);
	
    List<Map<String, Object>> list = null;
    
    public void batchProcess() {
    	LOGGER.debug("FxaTrsfIFBatch_START >> Start >>>>>>>>>>>>>>>>>>>>>>");	
		//1.sap 연결
		try {
			sapBudgCostService.sapConnection() ;
		} catch (IOException e) {
			LOGGER.debug("ERROR >> FxaTrsfIFBatch : batchProcess  Connection Error "+e.toString());	
			e.printStackTrace();
		}
    	
    	//2. 데이터 조회
		try{
			fxaInfoIFService.insertFxaTrsfIF(list);
		}catch(Exception e){
			e.printStackTrace();
		}
		
    }
    
}
