package iris.web.prj.tss.tctm.service;

import java.util.*;

public interface TctmTssService {
    public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input);


    /*과제*/
    public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input);
	public void updateTctmTssInfo(HashMap<String, Object> input);
	public void deleteTctmTssInfo(HashMap<String, String> input);
	public void duplicateTctmTssInfo(HashMap<String, Object> input);
	public void updateTctmTssInfoCmpl(HashMap<String, Object> input);
	public void updateTctmTssInfoDcac(HashMap<String, Object> input);

    /*개요*/
    public Map<String, Object> selectTctmTssInfoSmry(HashMap<String, String> input);
	public void updateTctmTssSmryInfo(HashMap<String, Object> input);
	public void deleteTctmTssSmryInfo(HashMap<String, String> input);
	public void duplicateTctmTssSmryInfo(HashMap<String, Object> input);
	public void updateTctmTssSmryInfoCmpl(HashMap<String, Object> input);
	public void updateTctmTssSmryInfoDcac(HashMap<String, Object> input);


	/*산출물*/
	public List<Map<String, Object>> selectTctmTssInfoGoal(HashMap<String, String> input);
//    public void updateTctmTssGoalInfo(HashMap<String, Object> input);
	public void deleteTctmTssGoalInfo(HashMap<String, String> input);
	public void updateTctmTssYld(HashMap<String, Object> input);


    /*변경*/
	public List<Map<String, Object>> selectTctmTssInfoAltrList(HashMap<String, String> input);
    public void updateTctmTssInfoAltrSmry(HashMap<String, Object> input, HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs);
	public void cancelTctmTssInfoAltrSmry(HashMap<String, String> input);


	/*변경이력*/
    public List<Map<String, Object>> selectInfoAltrHisListAll(HashMap<String, String> input);
    public  List<Map<String, Object>> selectInfoAltrHisList(HashMap<String, Object> input);
    public  Map<String, Object> selectInfoAltrHisInfo(HashMap<String, Object> input);

	/*완료*/
    public Map<String, Object> selectTctmTssInfoCmpl(HashMap<String, String> input);
//    public void updateTctmTssCmplInfo(HashMap<String, Object> input);
//    public void deleteTctmTssCmplInfo(HashMap<String, Object> input);


	/*GRS*/
    public void deleteTctmTssEv(HashMap<String, Object> input);
    public void deleteTctmTssEvResult(HashMap<String, Object> input);


    public String selectNewTssCdt(HashMap<String, Object> input);
    public List<Map<String, Object>>  selectTssPlnTssYyt(HashMap<String, String> input);
    Map<String, Object> selectTssCsus(Map<String, Object> input);


	/**
	 * 첨부파일 목록
	 * @param input
	 * @return
	 */
	List<Map<String,Object>> selectAttachFileList(HashMap<String, String> input);

	/**
	 * 통합결제 1건 조회
	 * @param input
	 * @return
	 */
	Map<String,Object> selectCsus(Map<String, Object> input);
}
