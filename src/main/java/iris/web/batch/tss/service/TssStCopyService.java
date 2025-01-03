package iris.web.batch.tss.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TssStCopyService {

	List<Map<String, Object>> retrieveTssComItgRdcs();

	void insertTssCopy(Map<String, Object> data);

	void deleteGenTssPlnMstTssSt(HashMap<String, Object> input);

	public String createWbsCd(Map<String, Object> input);

	// QAS 과제 등록
	void insertToQasTssQasIF(Map<String, Object> input) throws Exception;
}
