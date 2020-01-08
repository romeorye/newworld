package iris.web.knld.nrm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface NrmInfoService {

	public List<Map<String, Object>> retrieveNrmSearchList(HashMap<String, Object> input);

	public Map<String, Object> retrieveNrmInfo(HashMap<String, Object> input);

	public void saveNrmInfo(Map<String, Object> nrmInfo) throws Exception; 

}
