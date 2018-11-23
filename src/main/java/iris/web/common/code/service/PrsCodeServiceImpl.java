package iris.web.common.code.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("prsCodeService")
public class PrsCodeServiceImpl implements PrsCodeService{
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	
	@Override
    public List<Map<String, Object>> retrieveEkgrpInfo(HashMap<String, Object> input) {
        return commonDao.selectList("common.prsCode.retrieveEkgrpInfo",input);
    }
	
	@Override
	public List<Map<String, Object>> retrieveWbsCdInfoList(HashMap<String, Object> input) {
		return commonDao.selectList("common.prsCode.retrieveWbsCdInfoList",input);
	}
	
}
