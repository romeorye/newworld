/********************************************************************************
 * NAME : IrisUserServiceImpl.java
 * DESC : 영업자료게시판
 * PROJ : WINS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.07.25  김찬웅	최초생성
 *********************************************************************************/
package iris.web.prj.tss.com.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

@Service("tssUserService")
public class TssUserServiceImpl implements TssUserService {

	@Resource(name = "commonDao")
	private CommonDao commonDao;

	/* LG사용자 조회 */
	@Override
	public List<Map<String, Object>> getTssUserList(HashMap<String, Object> input) {
		return commonDao.selectList("prj.tss.com.getTssUserList", input);
	}

	@Override
	public Map<String, Object> getTssBtnRoleChk(HashMap<String, String> input, Map<String, Object> mstMap) {

		String inputRole = input.get("_roleId");
		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("tssRoleType", "R");
		map.put("tssRoleId", "");

		//시스템관리자
		if (inputRole.indexOf("WORK_IRI_T01") > -1) {
			map.put("tssRoleType", "W");
			map.put("tssRoleId", "TR01");
			
		}else if (inputRole.indexOf("WORK_IRI_T03") > -1) { //과제리더
			map.put("tssRoleType", "W");
			map.put("tssRoleId", "TR01");
		} else {
			//GRS담당자
			if (inputRole.indexOf("WORK_IRI_T08") > -1 || inputRole.indexOf("WORK_IRI_T09") > -1
					|| inputRole.indexOf("WORK_IRI_T10") > -1 || inputRole.indexOf("WORK_IRI_T11") > -1
					|| inputRole.indexOf("WORK_IRI_T12") > -1 || inputRole.indexOf("WORK_IRI_T13") > -1 || inputRole.indexOf("WORK_IRI_T14") > -1
					|| inputRole.indexOf("WORK_IRI_T26") > -1 || inputRole.indexOf("WORK_IRI_T26") > -1
					) {


				map.put("tssRoleType", "R");
			}

			//일반사용자
			if (inputRole.indexOf("WORK_IRI_T02") > -1 || inputRole.indexOf("WORK_IRI_T19") > -1) {
				map.put("roleId", "WORK_IRI_T02");
				map.put("userId", input.get("_userSabun"));
				map.put("tssCd", mstMap.get("tssCd"));

				map = commonDao.select("prj.tss.com.getTssRole", map);

				//프로젝트pl, 과제리더, 참여연구원
				if ("TR02".equals(map.get("tssRoleId")) || "TR03".equals(map.get("tssRoleId")) || "TR04".equals(map.get("tssRoleId"))) {
					map.put("tssRoleType", "W");
				}
				//연구소장
				else {
					map.put("tssRoleType", "R");
				}
			}
		}

		return map;
	}

	@Override
	public Map<String, Object> getTssListRoleChk(HashMap<String, Object> input) {
		String inputRole = String.valueOf(input.get("_roleId"));
		HashMap<String, Object> map = new HashMap<String, Object>();

		//시스템관리자
		if (inputRole.indexOf("WORK_IRI_T01") > -1) {
			map.put("tssRoleType", "S1");
		}else if (inputRole.indexOf("WORK_IRI_T03") > -1) {	//과제리더
			map.put("tssRoleType", "S1");
		}else if (inputRole.indexOf("WORK_IRI_T05") > -1) { //mm담당자
			map.put("tssRoleType", "S1");
		}else if (inputRole.indexOf("WORK_IRI_T15") > -1) {
			map.put("tssRoleType", "S1");
		}else if (inputRole.indexOf("WORK_IRI_T16") > -1) {
			map.put("tssRoleType", "S1");
		}else {
			ArrayList<String> list = new ArrayList<String>();
			list.add("00");

			//창호재 GRS
			if (inputRole.indexOf("WORK_IRI_T08") > -1) {
				list.add("01");
				list.add("02");
			}
			//장식재 GRS
			if (inputRole.indexOf("WORK_IRI_T09") > -1) {
				list.add("03");
				list.add("12");
				list.add("13");
				list.add("14");
			}
			//단열재 GRS
			if (inputRole.indexOf("WORK_IRI_T27") > -1) {
				list.add("03");
				list.add("12");
			}
			//바닥재 GRS
			if (inputRole.indexOf("WORK_IRI_T28") > -1) {
				list.add("03");
				list.add("13");
			}
			//벽지 GRS
			if (inputRole.indexOf("WORK_IRI_T29") > -1) {
				list.add("03");
				list.add("14");
			}
			//AL GRS
			if (inputRole.indexOf("WORK_IRI_T10") > -1) {
				list.add("02");
			}
			//표면소재 GRS
			if (inputRole.indexOf("WORK_IRI_T11") > -1) {
				list.add("06");
				list.add("15");
			}
			//고기능소재 GRS
			if (inputRole.indexOf("WORK_IRI_T12") > -1) {
				list.add("04");
				list.add("15");
			}
			//자동차 GRS
			if (inputRole.indexOf("WORK_IRI_T13") > -1) {
				list.add("05");
			}
			//법인 GRS
			if (inputRole.indexOf("WORK_IRI_T14") > -1) {
				list.add("07");
				list.add("08");
			}
			//주방 GRS
			if (inputRole.indexOf("WORK_IRI_T25") > -1) {
				list.add("11");
			}
			//개발실 GRS
			if (inputRole.indexOf("WORK_IRI_T26") > -1) {
				list.add("03");
				list.add("12");
				list.add("13");
				list.add("14");
			}

			if  (inputRole.indexOf("WORK_IRI_T26 ") > -1 && input.get("deptCode").equals("58190041") ) {		//기반기술
				list.add("07");
				list.add("08");
			}
		
			map.put("tssRoleType", "S3");
			map.put("tssRoleCd", list);

			//일반사용자
			if (inputRole.indexOf("WORK_IRI_T02") > -1 || inputRole.indexOf("WORK_IRI_T19") > -1) {
				map.put("roleId", "WORK_IRI_T02");
				map.put("userId", input.get("_userSabun"));
				map.put("tssCd", "");

				map = commonDao.select("prj.tss.com.getTssRole", map);

				//연구소장
				if ("TR05".equals(map.get("tssRoleId"))) {
					map.put("tssRoleType", "S1");
				} else {
					map.put("tssRoleType", "S2");
				}
			}
			
		}

		return map;
	}

	@Override
	public List<Map<String, Object>> getGrsUserList(HashMap<String, Object> input) {
		return commonDao.selectList("prj.tss.com.getGrsUserList", input);
	}

	@Override
	public Map<String, Object> getTssListRoleChk2(HashMap<String, String> input) {
		HashMap<String, Object> map = (HashMap<String, Object>) input.clone();
		return getTssListRoleChk(map);
	}
}