package iris.web.prj.grs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("grsMngService")
public class GrsMngServiceImpl implements GrsMngService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	@Override
	public List<Map<String, Object>> selectListGrsMngList(HashMap<String, Object> input) {
		return commonDao.selectList("prj.grs.retrieveGrsReqList", input);
	}

	@Override
	public int updateGrsInfo(Map<String, Object> input) {
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(input);
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		return commonDao.insert("prj.grs.updateGrsInfo", input);
	}

	@Override
	public int deleteGrsInfo(Map<String, Object> input) {
		return commonDao.update("prj.grs.deleteGrsInfo", input);
	}

	@Override
	public void updateGrsReqInfo(Map<String, Object> input) {
		commonDao.update("prj.grs.insertGrsEvRslt", input);
	}

}
