package iris.web.prj.tclgInfo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSenderFactory;
import iris.web.common.mail.service.MailInfoService;
import iris.web.prj.tss.rfp.service.RfpInfoServiceImpl;


@Service("tclgInfoReqService")
public class TclgInfoReqServiceImpl  implements TclgInfoReqService{
	
static final Logger LOGGER = LogManager.getLogger(RfpInfoServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
    private MailSenderFactory mailSenderFactory;
	
	@Resource(name="mailInfoService")
    private MailInfoService mailInfoService;
	
	/**
	 * 
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrievePrjInfo(HashMap<String, Object> input){
		return commonDao.select("prj.tclgInfo.retrievePrjInfo", input);
	}
	
	public List<Map<String, Object>> retrieveTclgInfoRqSearchList(HashMap<String, Object> input){
		return commonDao.selectList("prj.tclgInfo.retrieveTclgInfoRqSearchList", input);
	}
	
	public void insertTclgInfoReq(HashMap<String, Object> input){
		
		if( commonDao.insert("prj.tclgInfo.insertTclgInfoReq", input)  > 0 ){
			
			
		}else{
			
		}
		
	}
	
	public Map<String, Object> retrieveTclgInfoDetail(HashMap<String, Object> input){
		return commonDao.select("prj.tclgInfo.retrieveTclgInfoDetail", input);
	}
}
