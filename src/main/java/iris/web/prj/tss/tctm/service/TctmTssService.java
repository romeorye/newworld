package iris.web.prj.tss.tctm.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TctmTssService {
	List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input);


	/*과제*/
	Map<String, Object> selectTctmTssInfo(HashMap<String, String> input);

	void updateTctmTssInfo(HashMap<String, Object> input);

	void deleteTctmTssInfo(HashMap<String, String> input);

	void duplicateTctmTssInfo(HashMap<String, Object> input);

	void updateTctmTssInfoCmpl(HashMap<String, Object> input);

	void updateTctmTssInfoDcac(HashMap<String, Object> input);

	/*개요*/
	Map<String, Object> selectTctmTssInfoSmry(HashMap<String, String> input);

	void updateTctmTssSmryInfo(HashMap<String, Object> input);

	void deleteTctmTssSmryInfo(HashMap<String, String> input);

	void duplicateTctmTssSmryInfo(HashMap<String, Object> input);

	void updateTctmTssSmryInfoCmpl(HashMap<String, Object> input);

	void updateTctmTssSmryInfoDcac(HashMap<String, Object> input);


	/*산출물*/
	List<Map<String, Object>> selectTctmTssInfoGoal(HashMap<String, String> input);

	//    public void updateTctmTssGoalInfo(HashMap<String, Object> input);
	void deleteTctmTssGoalInfo(HashMap<String, String> input);

	void updateTctmTssYld(HashMap<String, Object> input);

	void updateYldFile(HashMap<String, Object> input);


	/*변경*/
	List<Map<String, Object>> selectTctmTssInfoAltrList(HashMap<String, String> input);

	void updateTctmTssInfoAltrSmry(HashMap<String, Object> input, HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs);

	void cancelTctmTssInfoAltrSmry(HashMap<String, String> input);


	/*변경이력*/
	List<Map<String, Object>> selectInfoAltrHisListAll(HashMap<String, String> input);

	List<Map<String, Object>> selectInfoAltrHisList(HashMap<String, Object> input);

	Map<String, Object> selectInfoAltrHisInfo(HashMap<String, Object> input);


	/*GRS*/
	void deleteTctmTssEv(HashMap<String, Object> input);

	void deleteTctmTssEvResult(HashMap<String, Object> input);


	String selectNewTssCdt(HashMap<String, Object> input);

	List<Map<String, Object>> selectTssPlnTssYyt(HashMap<String, String> input);

	Map<String, Object> selectTssCsus(Map<String, Object> input);


	/**
	 * 첨부파일 목록
	 *
	 * @param input
	 * @return
	 */
	List<Map<String, Object>> selectAttachFileList(Map<String, String> input);

	/**
	 * 통합결제 1건 조회
	 *
	 * @param input
	 * @return
	 */
	Map<String, Object> selectCsus(Map<String, Object> input);
}
