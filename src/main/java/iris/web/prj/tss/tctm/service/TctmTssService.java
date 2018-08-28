package iris.web.prj.tss.tctm.service;

import java.util.*;

public interface TctmTssService {
    public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input);

    public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input);

    public void updateTctmTssInfo(HashMap<String, Object> input);

    public void updateTctmTssSmryInfo(HashMap<String, Object> input);

    public void deleteTctmTssInfo(HashMap<String, Object> input);

    public void deleteTctmTssSmryInfo(HashMap<String, Object> input);

    public String selectNewTssCdt(HashMap<String, Object> input);

}
