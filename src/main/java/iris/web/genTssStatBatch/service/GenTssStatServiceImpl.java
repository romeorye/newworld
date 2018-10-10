package iris.web.genTssStatBatch.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.fxaInfoBatch.service.FxaInfoIFServiceImpl;

@Service("genTssStatService")
public class GenTssStatServiceImpl implements GenTssStatService{

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="commonDaoSalStat")
	private CommonDao commonDaoSalStat;

	static final Logger LOGGER = LogManager.getLogger(FxaInfoIFServiceImpl.class);

	@Override
	public void genTssStatBatch() {
		// TODO Auto-generated method stub

		List<Map<String, Object>> viewInfoList = new ArrayList<Map<String,Object>>();;
		List<Map<String, Object>> addViewInfoList = new ArrayList<Map<String,Object>>();;
		viewInfoList = commonDaoSalStat.selectList("genTssStat.batch.getViewInfo","");

		for(int i=0; i < viewInfoList.size(); i++){
			 Map<String, Object> userInfo = viewInfoList.get(i);

			 HashMap<String, Object> viewInfo = new HashMap<String, Object>();;
			 viewInfo.put("npCd", 	userInfo.get("npCd"));
			 viewInfo.put("pjtNm", 	userInfo.get("pjtNm"));
			 viewInfo.put("lnchYm", 	userInfo.get("lnchYm"));
			 viewInfo.put("expLnchYm", 	userInfo.get("expLnchYm"));
			 viewInfo.put("ym", 	userInfo.get("ym"));
			 viewInfo.put("salSumAmt", 	userInfo.get("salSumAmt"));

			 addViewInfoList.add(viewInfo);
		 }

		commonDao.batchInsert("genTssStat.batch.insertViewInfo", addViewInfoList);
	}

}




