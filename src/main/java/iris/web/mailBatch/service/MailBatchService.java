package iris.web.mailBatch.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MailBatchService {

	List<Map<String, Object>> retrieveTssPgMgr();

	void updateTssPgMgr( HashMap<String, Object> input);
	
	void makeMailSend(HashMap<String, Object> input);
	
	void makeMailSendWbs(HashMap<String, Object> input);

	void grsReqMailSend(HashMap<String, Object> input);
}
