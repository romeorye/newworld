package iris.web.prj.mmBatch.service;

import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : MmTodoService.java
 * DESC : MmTodo 서비스
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.10.24  IRIS04   최초생성
 *********************************************************************************/

public interface MmTodoService {

	/** 
	 * M/M입력 뷰 조회
	 * **/
	List<Map<String, Object>> retrieveMmInTodoList();
	
	/** 
	 * M/M마감 뷰 조회
	 * **/
	List<Map<String, Object>> retrieveMmClsTodoList();
	
	/** 
	 * M/M입력 To-Do 프로시져호출
	 * **/
	void saveMmpUpMwTodoReq(Map<String, Object> input);
	
	/** 
	 *  M/M마감 To-Do 프로시져호출
	 * **/
	void saveMmlUpMwTodoReq(Map<String, Object> input);
}
