package iris.web.prj.grs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GrsReqService {

    List<Map<String, Object>> retrieveGrsReqList(HashMap<String, Object> input);

    Map<String, Object> retrieveGrsEvRslt(HashMap<String, String> input);

    List<Map<String, Object>> retrieveGrsEvStd(HashMap<String, String> input);

    int updateGrsEvRslt(Map<String, Object> map);

    int insertGrsEvRslt(Map<String, Object> map);

    List<Map<String, Object>> retrieveGrsEvStdGrsY();

    List<Map<String, Object>> retrieveGrsEvStdDtl(HashMap<String, String> input);

    int updateGrsEvStdRslt(Map<String, Object> ds);

    List<Map<String, Object>> retrieveGrsReqDtlLst(HashMap<String, Object> inputMap);

    Map<String, Object> retrieveGrsTodo(HashMap<String, String> input);

    void insertGrsEvRsltSave(List<Map<String, Object>> dsLst, HashMap<String, Object> input);

    boolean grsSendMail(Map<String, Object> input);

    void updateGrsDecode(HashMap<String, Object> data);

	List<Map<String, Object>> retrieveGrsDecodeList(HashMap<String, Object> input);
	
}
