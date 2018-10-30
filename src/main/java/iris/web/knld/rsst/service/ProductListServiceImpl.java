package iris.web.knld.rsst.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;

/*********************************************************************************
 * NAME : ProductListServiceImpl.java
 * DESC : 지식관리 - 연구산출물관리 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.10  			최초생성
 *********************************************************************************/

@Service("productListService")
public class ProductListServiceImpl implements ProductListService {

	static final Logger LOGGER = LogManager.getLogger(ProductListServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	public List<Map<String, Object>> getProductList(HashMap<String, Object> input) {
		return commonDao.selectList("knld.rsst.getProductList", input);
	}

	public Map<String, Object> getProductListInfo(HashMap<String, Object> input) {
		return commonDao.select("knld.rsst.getProductListInfo", input);
	}

	/* 연구산출물 입력&업데이트 */
	@Override
	public void insertProductListInfo(Map<String, Object> input) {
		String prdtId = NullUtil.nvl(input.get("prdtId"), "");

		if("".equals(prdtId)) {
			commonDao.insert("knld.rsst.insertProductListInfo", input);
		}else {
			commonDao.update("knld.rsst.updateProductListInfo", input);
		}
	}

	/* 연구산출물 삭제  */
	@Override
	public void deleteProductListInfo(HashMap<String, String> input) {
		String prdtId = NullUtil.nvl(input.get("prdtId"), "");
		commonDao.update("knld.rsst.deleteProductListInfo", input);
	}

	/* 연구산출물 조회건수 증가  */
	@Override
	public void updateProductListRtrvCnt(HashMap<String, String> input) {
		String prdtId = NullUtil.nvl(input.get("prdtId"), "");
		commonDao.update("knld.rsst.updateProductListRtrvCnt", input);
	}

	/* 트리 리스트 조회 */
	public List<Map<String, Object>> getKnldProductTreeList(Map<String, Object> input) {
		return commonDao.selectList("knld.rsst.getKnldProductTreeList", input);
	}

	/*통합검색 권한 체크*/
	public String getMenuAuthCheck(HashMap<String, String> input){
		String authYn = "N";
		String roleArry[] =input.get("_roleId").toString().split("\\|");

		//시스템 권한이 있는지 체크
		for(int i=0; i < roleArry.length; i++){
			if(roleArry[i].equals("WORK_IRI_T01")  ){
				authYn = "Y";
				break;
			}else{
				if(input.get("rtrvRqDocCd").equals("AA") ){		//
					if(roleArry[i].equals("WORK_IRI_T06")){
						authYn = "Y";
						break;
					}else{
						authYn = commonDao.select("knld.rsst.getMenuAuthCheck", input);
					}
					//프로젝트, 과제 담당자
				}else if(input.get("rtrvRqDocCd").equals("O") ||  input.get("rtrvRqDocCd").equals("G") ||input.get("rtrvRqDocCd").equals("N") ||  input.get("rtrvRqDocCd").equals("PRJ") ){
					if(roleArry[i].equals("WORK_IRI_T03")){
						authYn = "Y";
						break;
					}else{
						authYn = commonDao.select("knld.rsst.getMenuAuthCheck", input);
					}
				}else{
					authYn = "Y";
				}
			}
		}

		return authYn;
	}

}