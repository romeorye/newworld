package iris.web.prs.purRq.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSenderFactory;
import iris.web.rlab.rqpr.service.RlabRqprServiceImpl;

@Service("purRqInfoService")
public class PurRqInfoServiceImpl implements PurRqInfoService{
	
	static final Logger LOGGER = LogManager.getLogger(RlabRqprServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;
	
	@Resource(name = "configService")
    private ConfigService configService;
	
	
	
	public List<Map<String, Object>> retrievePurRqList(HashMap<String, Object> input){
		return commonDao.selectList("prs.purRq.retrievePurRqList", input );
	}
	

}
