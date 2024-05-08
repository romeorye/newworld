package iris.web.prj.mm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sap.conn.jco.JCoException;

/********************************************************************************
 * NAME : MmClsInfoService.java
 * DESC : M/M 관리 - M/M 입력 - 투입M/M(mm) Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.29  IRIS04	최초생성
 *********************************************************************************/

public interface MmClsInfoService {

	/** M/M 입력 목록조회 (내가 참여중인  과제) **/
	List<Map<String, Object>> retrieveMmInSearchInfo(HashMap<String, Object> input);

	/** M/M마감 입력 **/
	void insertMmCls(Map<String, Object> input);

	/** M/M마감 수정 **/
	void updateMmCls(Map<String, Object> input);
	
	/** M/M마감 저장(저장/수정) **/
	public void saveMmCls(Map<String, Object> input);

	/** M/M 마감 목록조회 **/
	List<Map<String, Object>> retrieveMmClsSearchInfo(HashMap<String, Object> input);
	
	/**
	 * 연동 정보 수정
	 * @param map
	 */
	//void updateMmClsIlck(Map<String, Object> map);
	void updateMmClsIlck(ArrayList<Map<String, Object>> mapList);
		
	/**
	 * sap data조회 및 연동 정보 수정
	 * @param dataSetList
	 * @return
	 * @throws JCoException
	 */
	void updateMmIlckSap(List<Map<String, Object>> dataSetList , HashMap<String, Object> input) throws JCoException;
		
	/** 유저조직 프로젝트 조회 **/
	public String retrieveJoinProject(HashMap<String, Object> input);
	
	/** 
	 * M/M입력 뷰 조회
	 * **/
	public List<Map<String, Object>> retrieveMmInTodoList(Map<String, Object> input);
	
	/** 
	 * M/M마감 뷰 조회
	 * **/
	public List<Map<String, Object>> retrieveMmClsTodoList(Map<String, Object> input);
	
	/** 
	 * M/M입력 To-Do 프로시져호출
	 * **/
	public void saveMmpUpMwTodoReq(Map<String, Object> input);
	
	/** 
	 *  M/M마감 To-Do 프로시져호출
	 * **/
	public void saveMmlUpMwTodoReq(Map<String, Object> input);

	
	/**
	 * 프로젝트 리더 사번
	 */
	public String retrievePrjLeaderEmpNo(HashMap<String, String> input);

	

}