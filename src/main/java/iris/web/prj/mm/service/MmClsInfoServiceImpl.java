package iris.web.prj.mm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;
import devonframe.util.StringUtil;
import iris.web.common.util.CommonUtil;

/********************************************************************************
 * NAME : PrjMmInfoServiceImpl.java
 * DESC : M/M 관리 - M/M 입력 Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.29  IRIS04	최초생성
 *********************************************************************************/

@Service("mmClsInfoService")
public class MmClsInfoServiceImpl implements MmClsInfoService {

	static final Logger LOGGER = LogManager.getLogger(MmClsInfoServiceImpl.class);


	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;
	
	static String functionName = "ZHRH_RFC_WBS_INTERFACE";
	static String tableName ="TABLE_OUT";
	static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)
	

	/** M/M 입력 목록조회 (내가 참여중인  과제) **/
	@Override
	public List<Map<String, Object>> retrieveMmInSearchInfo(HashMap<String, Object> input){
		List<Map<String, Object>> resultList;
		String toDate = CommonUtil.getDateTimeSec().substring(0,6);
		String toDay = CommonUtil.getFormattedDate(toDate, "-");
		
		if(input.get("searchMonth").equals(toDay)){
			resultList = commonDao.selectList("prj.mm.cls.retrieveMmInSearchInfo", input);
		}else{
			resultList = commonDao.selectList("prj.mm.cls.retrieveMmInBeforeSearchInfo", input);
		}
		
		return resultList;
	}

	/** M/M마감 입력 **/
	@Override
	public void insertMmCls(Map<String, Object> input) {
		commonDao.insert("prj.mm.cls.insertMmCls", input);
	}

	/** M/M마감 수정 **/
	@Override
	public void updateMmCls(Map<String, Object> input) {
		commonDao.update("prj.mm.cls.updateMmCls", input);
	}
	
	/** M/M마감 저장(저장/수정) **/
	@Override
	public void saveMmCls(Map<String, Object> input) {
		commonDao.update("prj.mm.cls.saveMmCls", input);
	}

	/** M/M 마감 목록조회 **/
	@Override
	public List<Map<String, Object>> retrieveMmClsSearchInfo(HashMap<String, Object> input){
		
		List<Map<String, Object>> resultList;
		String toDate = CommonUtil.getDateTimeSec().substring(0,6);
		String toDay = CommonUtil.getFormattedDate(toDate, "-");
		
		if(input.get("searchMonth").equals(toDay)){
			resultList = commonDao.selectList("prj.mm.cls.retrieveMmClsSearchInfo", input);
		}else{
			resultList = commonDao.selectList("prj.mm.cls.retrieveMmOutBeforeSearchInfo", input);
		}
		
	    return resultList;
	}
	
	/*연동 정보 수정
	 * (non-Javadoc)
	 * @see iris.web.mm.service.MmClsInfoService#updateMmClsIlck(java.util.Map)
	 */
	@Override
	public void updateMmClsIlck(ArrayList<Map<String, Object>> mapList) {
		commonDao.batchUpdate("prj.mm.cls.updateMmClsIlck", mapList);
		
	}
	
	/* 연동 정보 조회및 수정
	 * (non-Javadoc)
	 * @see iris.web.mm.service.MmClsInfoService#updateMmIlckSap(java.util.List)
	 */
		 @Override
		public void updateMmIlckSap(List<Map<String, Object>> dataSetList, HashMap<String, Object> input) throws JCoException{
			 ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			 //LOGGER.debug("테이블가져오기 실행");
		    JCoDestination destination = JCoDestinationManager.getDestination(ABAP_AS);
		    //연결정보확인.
		    JCoFunction function = destination.getRepository().getFunction(functionName); 
		    
		    JCoParameterList ParameterList = function.getImportParameterList();
            
            if(function == null) throw new RuntimeException("SAP_DATA not found in SAP.");
           
            JCoTable table = function.getTableParameterList().getTable("TABLE_OUT");
            try{
            	
            	for(Map<String, Object> data : dataSetList) {
            		table.appendRow();
            		//LOGGER.debug("============data ::!! : " + data);         	
    	        	String ilckst ="I";
    	        	if("Y".equals(data.get("ilckSt"))) {
    	        		ilckst = "U" ;
    	        	}
    	        	if( Integer.parseInt(data.get("ptcPro").toString()) >  0 ){
    	        		table.setValue("PERNR", data.get("saSabunNew"));// 사원번호
        	        	table.setValue("BEGDA" , data.get("mmYymm").toString().replace("-", "")+""+"01");
        	        	table.setValue("ENDDA" , "99991231");
        	        	table.setValue("ORGEH" ,  commonDao.select("prj.mm.cls.retrieveMmClsRealDeptCode", data.get("saSabunNew")));
        	        	//table.setValue("ORGEH" , data.get("deptCode"));
        	        	table.setValue("KOKRS" , "C100");
        	        	table.setValue("POSNR" , data.get("tssWbsCd"));
        	        	table.setValue("PROZT" , data.get("ptcPro"));
        	        	table.setValue("GUBUN" , ilckst);
    	        	}
    	        	
    		        Map<String, Object> map = new HashMap<String, Object>();
    		        map.put("prjCd", 		data.get("prjCd"));// 사원번호
    		        map.put("tssCd", 		data.get("tssCd"));// 사원번호
    		        map.put("saSabunNew", 	data.get("saSabunNew"));// 사원번호
    	            map.put("mmYymm", 		data.get("mmYymm"));// 시작일
    	            map.put("ilckSt", 		"Y");// 작업구분
    	            map.put("_userId" ,input.get("_userId") );
    	             
    	            list.add(map);
    	        }
            	
           	//LOGGER.debug("============table ::!! : " + table);
    	    function.execute(destination);
    	      LOGGER.debug("실행완료::!!");
    	     updateMmClsIlck(list);
    	        
            }catch(Exception e){
            	
            }finally{
            	
            }
	        
	}
		 
	/** 유저조직 프로젝트 조회 **/
	@Override
	public String retrieveJoinProject(HashMap<String, Object> input){
		String returnStr = "";
		
		Map<String, Object> rMap = null;
	    List<Map<String, Object>> resultList = commonDao.selectList("prj.mm.cls.retrieveJoinProject", input);
	    String[] arrJoinPrj = new String[resultList.size()]; 
	    for(int i=0; i< resultList.size(); i++) {
	    	rMap = resultList.get(i);
	    	arrJoinPrj[i] = NullUtil.nvl(rMap.get("prjCd"), ""); 
	    }
	    returnStr = StringUtil.arrayToString(arrJoinPrj,",");	// ',' 로 붙여서 리턴
	    
	    return returnStr;
	}
	
	/** 
	 * M/M입력 뷰 조회
	 * **/
	@Override
	public List<Map<String, Object>> retrieveMmInTodoList(Map<String, Object> input){
		return commonDao.selectList("prj.mm.cls.retrieveMmInTodoList", input);
	}
	
	/** 
	 * M/M마감 뷰 조회
	 * **/
	@Override
	public List<Map<String, Object>> retrieveMmClsTodoList(Map<String, Object> input){
		return commonDao.selectList("prj.mm.cls.retrieveMmClsTodoList", input);
	}
	
	/** 
	 * M/M입력 To-Do 프로시져호출
	 * **/
	@Override
	public void saveMmpUpMwTodoReq(Map<String, Object> input) {
		commonDaoTodo.insert("prj.mm.cls.saveMmpUpMwTodoReq", input);
	}
	
	/** 
	 *  M/M마감 To-Do 프로시져호출
	 * **/
	@Override
	public void saveMmlUpMwTodoReq(Map<String, Object> input){
		commonDao.insert("prj.mm.cls.saveMmlUpMwTodoReq",input);
	}
	
	/**
	 * 프로젝트 리더 사번
	 */
	public String retrievePrjLeaderEmpNo(HashMap<String, String> input){
		return commonDao.select("prj.mm.cls.retrievePrjLeaderEmpNo", input);
	}
			
}	// end class