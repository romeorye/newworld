package iris.web.prj.rsst.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RsstClsService {

	/* 프로젝트 마감 리스트 조회 */
	List<Map<String, Object>> retrievePrjClsList(HashMap<String, Object> input);

	/* 프로젝트 월마감 MBO 조회*/
	List<Map<String, Object>> retrievePrjRsstMboList(HashMap<String, Object> input);

	/* 프로젝트 월마감 필수산출물 조회*/
	List<Map<String, Object>> retrievePrjRsstPduList(HashMap<String, Object> input);

	/* 프로젝트 월마감 지적재산권 조회*/
	List<Map<String, Object>> retrievePrjPrptList(HashMap<String, Object> input);

	/* 프로젝트 월마감 정보 조회*/
	HashMap<String, Object> retrievePrjClsDtl(HashMap<String, Object> input);

	/* 프로젝트 월마감 단건 입력&업데이트 */
	void insertPrjRsstCls(List<Map<String, Object>> dataSetList, HashMap<String, Object> input);
	//void insertPrjRsstCls(HashMap<String, Object> input);

	/* 과제 진척률 리스트 */
	List<Map<String, Object>> retrieveTssPgsSearchInfo(HashMap<String, Object> input);

	/**
	 * 프로젝트 전월 월마감 건수 체크
	 * @param input
	 * @return
	 */
	int retrievePrjMmCls(HashMap<String, Object> input);

	/* 프로젝트 전월 마감 진척율 리스트 */
	List<Map<String, Object>> retrievePrjClsProgSearchInfo(HashMap<String, Object> input);


}
