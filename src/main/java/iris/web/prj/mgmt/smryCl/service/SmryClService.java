package iris.web.prj.mgmt.smryCl.service;

import java.util.HashMap;
import java.util.Map;

public interface SmryClService {

    Map<String, Object> retrieveSmryClDtl(HashMap<String, String> inputMap);

    int updateSmryCl(HashMap<String, Object> input);
}
