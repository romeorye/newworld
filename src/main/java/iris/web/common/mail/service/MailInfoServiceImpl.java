package iris.web.common.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("mailInfoService")
public class MailInfoServiceImpl implements MailInfoService {

	
	@Resource(name="commonDao")
    private CommonDao commonDao;
	
	
	
	public void insertMailSndHist(Map<String, Object> input){
		commonDao.insert("common.mail.insertMailSndHist", input);
	}
	
	public void insertMailSndHist(List<HashMap<String, Object>> mailSndList) {
		commonDao.batchInsert("common.mail.insertMailSndHist", mailSndList);
	}
}
