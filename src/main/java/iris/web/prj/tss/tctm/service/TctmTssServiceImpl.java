package iris.web.prj.tss.tctm.service;

import devonframe.dataaccess.CommonDao;
import iris.web.common.util.TestConsole;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("tctmTssService")
public class TctmTssServiceImpl implements TctmTssService {
    static final Logger LOGGER = LogManager.getLogger(TctmTssServiceImpl.class);

    @Resource(name = "commonDao")
    private CommonDao commonDao;

    @Override
    public List<Map<String, Object>> selectTctmTssList(HashMap<String, Object> input) {
        TestConsole.showMap(input);
        return commonDao.selectList("prj.tss.tctm.selectList", input);
    }

    @Override
    public Map<String, Object> selectTctmTssInfo(HashMap<String, String> input) {
        return commonDao.select("prj.tss.tctm.selectInfo", input);
    }

    @Override
    public void updateTctmTssInfo(HashMap<String, Object> input) {
        TestConsole.showMap(input);
        commonDao.insert("prj.tss.tctm.updateInfo", input);
    }

    @Override
    public void updateTctmTssSmryInfo(HashMap<String, Object> input) {
        TestConsole.showMap(input);
        commonDao.insert("prj.tss.tctm.updateSmryInfo", input);
    }

    @Override
    public void deleteTctmTssInfo(HashMap<String, Object> input) {
        commonDao.delete("prj.tss.tctm.deleteInfo", input);
    }

    @Override
    public void deleteTctmTssSmryInfo(HashMap<String, Object> input) {
        commonDao.delete("prj.tss.tctm.deleteSmryInfo", input);
    }

    @Override
    public String selectNewTssCdt(HashMap<String, Object> input) {
        return commonDao.select("prj.tss.tctm.selectNewTssCd", input);
    }
}
