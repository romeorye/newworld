package iris.web.tssbatch.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


/********************************************************************************
 * NAME : PrjTmmrServiceImpl.java
 * DESC : 프로젝트 참여연구원 변경처리 서비스 Interface
 * PROJ : IRIS 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.29  소영창	최초생성
 *********************************************************************************/
@Service("prjTmmrService")
public class PrjTmmrServiceImpl implements PrjTmmrService{

    @Resource(name="commonDao")
    private CommonDao commonDao;
    
    @Resource(name="commonDaoPims")
	private CommonDao commonDaoPims;	// 지적재산권 조회 Dao


	/* 프로젝트 팀원 퇴사자 대상조회 */
	@Override
	public List<HashMap<String, Object>> retrievePrjTmmrResignList(HashMap<String, Object> input){
		List<HashMap<String, Object>>  result = commonDao.selectList("prjTmmr.batch.retrievePrjTmmrResignList", input);
        return result;
	}
	
	/* 프로젝트 팀원 부서이동(이동 전) 대상조회 */
	@Override
	public List<HashMap<String, Object>> retrievePrjTmmrMoveOutList(HashMap<String, Object> input){
		List<HashMap<String, Object>>  result = commonDao.selectList("prjTmmr.batch.retrievePrjTmmrMoveOutList", input);
        return result;
	}
	
	/* 프로젝트 팀원 부서이동(이동 후) 대상조회 */
	@Override
	public List<HashMap<String, Object>> retrievePrjTmmrMoveInList(HashMap<String, Object> input){
		List<HashMap<String, Object>>  result = commonDao.selectList("prjTmmr.batch.retrievePrjTmmrMoveInList", input);
        return result;
	}
	
	/* 프로젝트 팀원 퇴사자 참여종료일 업데이트 */
	@Override
	public void updatePrjTmmrResign( HashMap<String, Object> input){
		commonDao.update("prjTmmr.batch.updatePrjTmmrEnd", input);
		//퇴사자 지적재산권 삭제
		//deletePrjPimsInfo(input);
	}
	
	/* 프로젝트 팀원 부서이동(이동 전) 참여종료일 업데이트 */
	@Override
	public void updatePrjTmmrMoveOut( HashMap<String, Object> input){
		commonDao.update("prjTmmr.batch.updatePrjTmmrEnd", input);
		//퇴사자 지적재산권 삭제
		//chgPrjPimsInfo(input);
	}
	
	/* 프로젝트 팀원 부서이동(이동 후) 신규추가 */
	@Override
	public void insertPrjTmmrMoveIn( HashMap<String, Object> input) {
		commonDao.insert("prjTmmr.batch.insertPrjTmmr", input);
		//퇴사자 지적재산권 등록
		//insertPrjPimsInfo(input);
	}
	
	/* 퇴사자 지적재산권 제거*/
	public void deletePrjPimsInfo(HashMap<String, Object> input){
		commonDaoPims.delete("prjTmmr.batch.deletePrjPimsInfo", input);
	}
	
	/* 인원변경시 지적재산권 제거*/
	public void chgPrjPimsInfo(HashMap<String, Object> input){
		commonDaoPims.delete("prjTmmr.batch.chgPrjPimsInfo", input);
	}
	
	/* 인원변경시 지적재산권 등록*/
	public void insertPrjPimsInfo(HashMap<String, Object> input){
		commonDaoPims.insert("prjTmmr.batch.insertPrjPimsInfo", input);
	}
	
	
}
