package iris.web.stat.prj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PrjRsstStatService {

	 /**
     * 통계 > 일반과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrievePrjRsstStatList(HashMap<String, Object> input);

}
