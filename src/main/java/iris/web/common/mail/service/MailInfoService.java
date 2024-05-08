package iris.web.common.mail.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MailInfoService {

	
	
	
	void insertMailSndHist(Map<String, Object> input);

	void insertMailSndHist(List<HashMap<String, Object>> sndMailList);
	
}
