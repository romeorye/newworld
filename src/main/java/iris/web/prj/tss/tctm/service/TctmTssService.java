package iris.web.prj.tss.tctm.service;

import java.util.*;

public interface TctmTssService {
    public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input);


    /*과제*/
    public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input);
	public void updateTctmTssInfo(HashMap<String, Object> input);
	public void deleteTctmTssInfo(HashMap<String, String> input);

    /*개요*/
    public Map<String, Object> selectTctmTssInfoSmry(HashMap<String, String> input);
	public void updateTctmTssSmryInfo(HashMap<String, Object> input);
	public void deleteTctmTssSmryInfo(HashMap<String, String> input);

	/*산출물*/
	public List<Map<String, Object>> selectTctmTssInfoGoal(HashMap<String, String> input);
//    public void updateTctmTssGoalInfo(HashMap<String, Object> input);
	public void deleteTctmTssGoalInfo(HashMap<String, String> input);
	public void updateTctmTssYld(HashMap<String, Object> input);


    /*변경개요*/
	public List<Map<String, Object>> selectTctmTssInfoAltrSmry(HashMap<String, String> input);
    public void updateTctmTssInfoAltrSmry(HashMap<String, Object> input, HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> altrDs);
	public void deleteTctmTssInfoAltrSmry(HashMap<String, String> input);


	/*변경이력*/
    public List<Map<String, Object>> selectTctmTssInfoAltrHis(HashMap<String, String> input);
	//    public void updateTctmTssAltrHisInfo(HashMap<String, Object> input);
	//    public void deleteTctmTssAltrHisInfo(HashMap<String, Object> input);

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


}
