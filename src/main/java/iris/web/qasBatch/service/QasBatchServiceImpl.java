package iris.web.qasBatch.service;

import devonframe.dataaccess.CommonDao;
import iris.web.fxaInfoBatch.service.FxaInfoIFServiceImpl;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;

@Service("qasBatchService")
public class QasBatchServiceImpl implements QasBatchService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	/* 울산 DB Connection */
	@Resource(name="commonDaoQasU")
	private CommonDao commonDaoQasU;

	/* 청주 DB Connection */
	@Resource(name="commonDaoQasC")
	private CommonDao commonDaoQasC;

	static final Logger LOGGER = LogManager.getLogger(FxaInfoIFServiceImpl.class);

	@Override
	public void batchProcess() {

		LOGGER.debug("=============== QAS Gate 배치 울산 > IRIS ===============");
		List<HashMap<String, Object>> gateList = commonDaoQasU.selectList("prj.tss.com.selectGateQasIF");
		for (int i = 0; i < gateList.size(); i++) {

			// 게이트 정보 IRIS IRIS_TSS_QGATE_IF에 등록
			commonDao.insert("prj.tss.com.insertGateToIrisQasIF", gateList.get(i));

			//일반과제(gateNo:산출물코드) 1:06, 2:07, 3:08
			HashMap<String,String> genYldCd = new HashMap<String,String>(){
				{
					put("1","06"); //gate1, 산출물 06
					put("2","07"); //gate2, 산출물 07
					put("3","08"); //gate3, 산출물 08
				}
			};

			//기술팀과제(gateNo:산출물코드) 1:02, 2:03, 3:04
			HashMap<String,String> tctmYldCd = new HashMap<String,String>(){
				{
					put("1","02");	//gate1, 산출물 02
					put("2","03");	//gate2, 산출물 03
					put("3","04");	//gate3, 산출물 04
				}
			};

			if(gateList!=null){
				HashMap<String, Object> gate = gateList.get(i);
				// 과제 기 본정보 조회
				HashMap tssInfo = commonDao.select("prj.tss.com.selectTssInfoQasIF", gateList.get(i));
				// 게이트 정보 산출물 연결
				if(tssInfo!=null && tssInfo.get("tssScnCd").equals("G")){
					//일반 과제
					tssInfo.put("ATTACHURL", gate.get("ATTACHURL"));
					tssInfo.put("yldItmType", genYldCd.get(gate.get("STEPNO")));
					commonDao.update("prj.tss.com.updateGateToYldQasIF", tssInfo);
				}else if(tssInfo!=null && tssInfo.get("tssScnCd").equals("D")){
					//기술팀 과제
					tssInfo.put("ATTACHURL", gate.get("ATTACHURL"));
					tssInfo.put("yldItmType", tctmYldCd.get(gate.get("STEPNO")));
					commonDao.update("prj.tss.com.updateGateToYldQasIF", tssInfo);
				}

			}
		}

	}

//		commonDao.batchInsert("genTssStat.batch.insertViewInfo", addViewInfoList);
}





