package iris.web.prj.tss.tctm.service;

import java.util.*;

public interface TctmTssService {
    public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input);

    public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input);

    public Map<String, Object> selectTctmTssInfoAltrI(HashMap<String, String> input);
    public Map<String, Object> selectTctmTssInfoCmpl(HashMap<String, String> input);
    public Map<String, Object> selectTctmTssInfoSmry(HashMap<String, String> input);
    public List<Map<String, Object>> selectTctmTssInfoGoal(HashMap<String, String> input);
    public Map<String, Object> selectTctmTssInfoAltrHis(HashMap<String, String> input);

    public void updateTctmTssInfo(HashMap<String, Object> input);
    public void updateTctmTssSmryInfo(HashMap<String, Object> input);
    public void updateTctmTssYld(HashMap<String, Object> input);
    public void updateTctmTssAltrInfo(HashMap<String, Object> input);

//    public void updateTctmTssGoalInfo(HashMap<String, Object> input);
//    public void updateTctmTssCmplInfo(HashMap<String, Object> input);
//    public void updateTctmTssAltrHisInfo(HashMap<String, Object> input);



    public void deleteTctmTssInfo(HashMap<String, Object> input);
    public void deleteTctmTssSmryInfo(HashMap<String, Object> input);
    public void deleteTctmTssGoalInfo(HashMap<String, Object> input);
    public void deleteTctmTssAltrIInfo(HashMap<String, Object> input);

//    public void deleteTctmTssAltrHisInfo(HashMap<String, Object> input);
//    public void deleteTctmTssCmplInfo(HashMap<String, Object> input);


    public void deleteTctmTssEv(HashMap<String, Object> input);
    public void deleteTctmTssEvResult(HashMap<String, Object> input);

    public String selectNewTssCdt(HashMap<String, Object> input);


    public List<Map<String, Object>>  selectTssPlnTssYyt(HashMap<String, String> input);

    Map<String, Object> selectTssCsus(Map<String, Object> input);


}
