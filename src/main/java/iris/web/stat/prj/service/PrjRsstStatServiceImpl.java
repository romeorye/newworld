package iris.web.stat.prj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("prjRsstStatService")
public class PrjRsstStatServiceImpl implements PrjRsstStatService {

    static final Logger LOGGER = LogManager.getLogger(PrjRsstStatServiceImpl.class);

    @Resource(name = "commonDao")
    private CommonDao   commonDao;

    @Resource(name = "commonDaoPims")
    private CommonDao   commonDaoPims;                                              // 지적재산권 조회 Dao

    /**
     * 통계 > 프로젝트 리스트 조회
     * 
     * @param input
     *            HashMap<String, Object>
     * @return ModelAndView
     */
    @Override
    public List<Map<String, Object>> retrievePrjRsstStatList(HashMap<String, Object> input) {
        List<Map<String, Object>> prjList = null;
        List<Map<String, Object>> prptList = null;
        Map<String, Object> searchParam = null;

        // 프로젝트 리스트 조회
        prjList = commonDao.selectList("stat.prj.retrievePrjRsstStatList", input);

        /*//실적 지적재산권 조회 후 삽입처리
        try {
        	for(int i=0;i < prjList.size(); i++) {
        		Map<String, Object> tmpPrjtMap = prjList.get(i);
        		
        		searchParam = new HashMap<String, Object>();
        		searchParam.put("searchYear" , input.get("yyyy"));
        		searchParam.put("wbsCd"      , tmpPrjtMap.get("wbsCd"));
        		prptList = commonDaoPims.selectList("prj.rsst.ptotprpt.oracle.retrievePrjErpPrptByYearList", searchParam);
        		
        		if( prptList != null && prptList.size() > 0 ) {
        			prjList.get(i).put("prptArslCnt", prptList.get(0).get("patCnt"));  
        		}
        	}
        } catch (Exception e) {
            e.printStackTrace();
        }*/

        return prjList;
    }

}
