package iris.web.sapBatch.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SapBudgCostService {


    int insertBudgSCost(List<Map<String, Object>> list);

    int insertBudgTCost(List<Map<String, Object>> list);

    public void log(String s);

    String getPropValues(String val) throws IOException;

    int updateTssGenTrwiBudgMst(HashMap map);

    void sapConnection() throws IOException;
}
