package iris.web.prs.purRq.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sap.conn.jco.JCoException;

public interface PurRqInfoService {

	List<Map<String, Object>> retrievePurRqList(HashMap<String, Object> input);

	int insertPurRqInfo(Map<String, Object> dataMap) throws Exception;

	HashMap<String, Object> retrievePurRqInfo(HashMap<String, Object> input);
	
	int getBanfnPrsNumber();
	
	boolean deletePurRqInfo(Map<String, Object> input) throws Exception;
	
	boolean updatePurRqInfo(Map<String, Object> input) throws Exception;

	List<Map<String, Object>> retrieveMyPurRqList(HashMap<String, Object> input);
	
	int insertPurApprovalInfo(Map<String, Object> input) throws Exception;
	
	String sendSapExpensePr(Map<String, Object> dataMap) throws JCoException;
	
	List<Map<String, Object>> retrieveERPPrInfo(HashMap<String, Object> input);
}
