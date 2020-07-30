package iris.web.qasBatch.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.dbConn.DbConn;

@Service("qasBatchService")
public class QasBatchServiceImpl implements QasBatchService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;
	
/*
	 울산 DB Connection 
	@Resource(name="commonDaoQasU")
	private CommonDao commonDaoQasU;
	

	 청주 DB Connection 
	@Resource(name="commonDaoQasC")
	private CommonDao commonDaoQasC;
*/
	static final Logger LOGGER = LogManager.getLogger(QasBatchServiceImpl.class);

	@Override
	public void batchProcess() throws Exception {
		DbConn dbConn = new DbConn();
		//LOGGER.debug("=============== QAS Gate 배치 울산 > IRIS ===============");
		try{
			getGate(dbConn.getUConn());
			dbConn.closeConnection();
			
		}catch(Exception e){
			dbConn.closeConnection();
			throw new Exception("울산QAS  오류가 발생했습니다.");
		}
		
		//LOGGER.debug("=============== QAS Gate 배치 청주 > IRIS ===============");
		try{
			getGate(dbConn.getOConn());
			dbConn.closeConnection();
			
		}catch(Exception e){
			dbConn.closeConnection();
			throw new Exception("옥산QAS  오류가 발생했습니다.");
		}
	}

	private void getGate(Connection con) throws Exception {
		//List<HashMap<String, Object>> gateList = ((CommonDao) con).selectList("prj.tss.com.selectGateQasIF");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<HashMap<String, Object>> gateList = new ArrayList<>();
				
		StringBuffer sb = new StringBuffer();
      
		sb.append("SELECT  SEQ AS seq,				");
		sb.append("        WBS_CD AS wbsCd,			");
		sb.append("        STEP_NO AS stepNo,		");
		sb.append("        REQ_TYPE AS reqType,		");
		sb.append("        nvl(ATTACH_URL, '0')  AS attachUrl	");
		sb.append("FROM    IF_QGATE_PROC			");
		
		pstmt = con.prepareStatement(sb.toString());
		
		rs = pstmt.executeQuery();
		
		while (rs.next()) {
			HashMap<String, Object> data = new HashMap<String, Object>();
			
			data.put("SEQ", 		rs.getString("seq"));
			data.put("WBSCD", 		rs.getString("wbsCd"));
			data.put("STEPNO", 		rs.getString("stepNo"));
			data.put("REQTYPE", 	rs.getString("reqType"));
			
			if ( rs.getString("attachUrl").equals("0")){
				data.put("ATTACHURL", 	"");
			}else{
				data.put("ATTACHURL", 	rs.getString("attachUrl"));
			}
			
			gateList.add(data);
		}
		
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
				if(tssInfo!=null && tssInfo.get("tssScnCd").equals("G") && gate.get("REQTYPE").equals("C") ){
					//일반 과제
					tssInfo.put("ATTACHURL", gate.get("ATTACHURL"));
					tssInfo.put("yldItmType", genYldCd.get(gate.get("STEPNO")));
					commonDao.update("prj.tss.com.updateGateToYldQasIF", tssInfo);
				}else if(tssInfo!=null && tssInfo.get("tssScnCd").equals("D") && gate.get("REQTYPE").equals("C") ){
					//기술팀 과제
					tssInfo.put("ATTACHURL", gate.get("ATTACHURL"));
					tssInfo.put("yldItmType", tctmYldCd.get(gate.get("STEPNO")));
					commonDao.update("prj.tss.com.updateGateToYldQasIF", tssInfo);
				}

			}
		}
		
		rs.close();
		pstmt.close();
	}
}





