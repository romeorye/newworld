package iris.web.mchn.open.eduAnl.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MchnEduAnlService {


	/* open기기 > 기기교육 > 기기교육관리 목록조회*/
	List<Map<String, Object>> retrieveMchnEduAnlSearchList(HashMap<String, Object> input);

	/* open기기 > 기기교육 > 기기교육관리 상세조회 */
	HashMap<String, Object> retrieveEduInfo(HashMap<String, Object> input);

	/* open기기 > 기기교육 > 기기교육관리 > 신규등록 > 분석기기 팝업 목록조회 */
	List<Map<String, Object>> retrieveMachineList(HashMap<String, Object> input);

	/* open기기 > 기기교육 > 기기교육관리 > 신규등록 > 기기교육 삭제 */
	void updateEduInfo(HashMap<String, Object> input);

	/* open기기 > 기기교육 > 기기교육관리 > 신규등록 > 기기교육 등록 및 수정 */
	void saveEduInfo(HashMap<String, Object> input);

	/*  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 화면 조회 */
	List<Map<String, Object>> retrieveMchnEduAnlRgstList(HashMap<String, Object> input);

	/*  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 화면 조회 (엑셀용) */
	List<Map<String, Object>> retrieveMchnEduAnlRgstListExcel(HashMap<String, Object> input);

	/* open기기 > 기기교육 > 기기교육관리 > 교육신청관리 수료, 미수료 업데이트 */
	void updateEduDetailInfo(List<Map<String, Object>> inputList, HashMap<String, Object> input  ) throws Exception;

	/* 메일발송 history
	void insertMailHis(List<Map<String, Object>> mailList);
	 */
}
