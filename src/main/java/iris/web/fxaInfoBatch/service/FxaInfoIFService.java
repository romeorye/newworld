package iris.web.fxaInfoBatch.service;

import java.util.List;
import java.util.Map;

public interface FxaInfoIFService {

	//IF 자산테이블에 저장 
	void insertFxaInfoIF(List<Map<String, Object>> list);

	//IF 자산이관 ERP 연동
	void insertFxaTrsfIF(List<Map<String, Object>> list) throws Exception;

	//WBS _ prj NM
	void insertWbsPrjIFInfo(List<Map<String, Object>> list);
}
