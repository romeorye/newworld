package iris.web.prj.mgmt.trwiBudg.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TrwiBudgService {

	List<Map<String, Object>> retrieveTrwiBudgList(HashMap<String, Object> input) ;

	//TrwiBudg 저장
	int saveTrwiBudg(Map<String, Object> input);

	List<Map<String, Object>> retrieveTrwiBudgDtl(HashMap<String, Object> inputMap);
	//TrwiBudg 삭제
	void deleteTrwiBudg(HashMap<String, Object> input);

	void updateTrwiBudgPro(HashMap<String, Object> input);


			
}
