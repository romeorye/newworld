package iris.web.prj.mgmt.grst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GrsTempService {

    List<Map<String, Object>> retrieveGrsTempList(HashMap<String, Object> input) ;

    //grsTemp 저장
    int saveGrsTemp(HashMap<String, Object> input);
    //grsTemp List 저장
    void saveGrsTempLst(Map<String, Object> ds);

    Map<String, Object> getSeqGrsTemp();

    HashMap<String, Object> retrieveGrsTempDtl(HashMap<String, Object> inputMap);

    int deleteGrsTemp(List<Map<String, Object>> dsLst);

}
