package iris.web.prj.tss.mkInno.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import iris.web.prj.tss.gen.service.GenTssService;

@Service("mkInnoTssService")
public class MkInnoTssServiceImpl implements MkInnoTssService {
	
	static final Logger LOGGER = LogManager.getLogger(MkInnoTssServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "genTssService")
	private GenTssService genTssService;
	
	
	/**
	 * 제조혁신과제 리스트
	 */
	 
	public List<Map<String, Object>> retrieveMkInnoTssList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.com.retrieveMkInnoTssList", input);
	}
	
	/**
	 * 제조혁신과제 상세 마스터 조회
	 */
	public Map<String, Object> retrieveMkInnoMstInfo(HashMap<String, Object> input){
		return commonDao.select("mkInno.com.retrieveMkInnoMstInfo", input);
		
	}

	/**
	 * 제조혁신과제 개요 조회
	 */
	public Map<String, Object> retrieveMkInnoSmryInfo(HashMap<String, Object> input){
		return commonDao.select("mkInno.com.retrieveMkInnoSmryInfo", input);
		
	}

	/**
	 * 제조혁신과제 인원 조회
	 */
	public List<Map<String, Object>> retrieveMkInnoMbrList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.com.retrieveMkInnoMbrList", input);
	}

	/**
	 * 제조혁신과제 산출물 조회
	 
	public List<Map<String, Object>> retrieveMkInnoYldList(HashMap<String, Object> input){
		return commonDao.selectList("mkInno.com.retrieveMkInnoYldList", input);
	}
	*/
	
	/**
	 * 제조혁신과제 마스터, smry 저장
	 * @throws Exception 
	 */
	public void saveMkInnoMst(Map<String, Object> dataMap) throws Exception {
		HashMap<String, Object> input = (HashMap<String, Object>)dataMap.get("input");
		Map<String, Object> mstDataSet = (Map<String, Object>)dataMap.get("mstDataSet");
		Map<String, Object> smryDataSet = (Map<String, Object>)dataMap.get("smryDataSet");
		
		mstDataSet.put("userId", input.get("_userId"));
		if(commonDao.update("mkInno.tss.saveMkInnoMst", mstDataSet) > 0 ){
			smryDataSet.put("userId",  input.get("_userId"));
			if(commonDao.update("mkInno.tss.saveMkInnoSmry", smryDataSet) > 0){
				
			}else{
				throw new Exception("마스터 정보 저장 오류");
			}
		}else{
			throw new Exception("SMRY 저장 오류");
		}
		
	}

	/**
	 * 제조혁신과제 참여연구원 저장
	 * @throws Exception 
	 */
	public void saveMkInnoMbr(List<Map<String, Object>> mbrDataSetList) throws Exception{
		if(commonDao.batchInsert("mkInno.tss.saveMkInnoMbr", mbrDataSetList) > 0 ){
		}else{
			throw new Exception("참여연구원 정보 저장 오류");
		}
	}	
	
	
	/**
	 * 품의서 첨부파일 조회
	 */
	public List<Map<String, Object>> retrieveMkInnoTssAttc(HashMap<String, Object> inputInfo){
		return commonDao.selectList("mkInno.com.retrieveMkInnoTssAttc", inputInfo);
	}
	
	/**
	 * 제조혁신 전자결재건 체크
	 * @param input
	 * @return
	 */
	public Map<String, Object> retrieveMkInnoCsusInfo(HashMap<String, Object> input){
		return commonDao.select("mkInno.com.retrieveMkInnoCsusInfo", input);
	}
	
	/**
	 * 제조혁신 과제  전자결재 등록
	 * @param ds
	 */
	public void insertMkInnoTssCsusRq(Map<String, Object> ds){
		commonDao.insert("mkInno.com.insertMkInnoTssCsusRq", ds);
	}

	/**
	 * 제조혁신 과제  전자결재 업데이트
	 * @param ds
	 */
	public void updateMkInnoTssCsusRq(Map<String, Object> ds){
		commonDao.update("mkInno.com.updateMkInnoTssCsusRq", ds);
	}
	
	/**
	 * 제조혁신과제 신규과제 등록
	 * @param ds
	 * @throws Exception 
	 */
	public void saveMkInnoTssReg(Map<String, Object> ds) throws Exception {
		HashMap<String, Object> input = (HashMap) ds;
		HashMap<String, Object> getWbs = genTssService.getTssCd(input);

		int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
		String seqMaxS = String.valueOf(seqMax + 1);
		
		ds.put("wbsCd", ds.get("tssScnCd") + seqMaxS);
		ds.put("pkWbsCd", ds.get("wbsCd"));
		ds.put("pgsStepCd", "PL");
		ds.put("tssSt", "100");
		
		if( commonDao.insert("mkInno.tss.saveMkInnoTssReg", ds) > 0 ){
		}else{
			throw new Exception("과제 등록중 오류가 발생하였습니다.");
		}
	}
	
	/**
	 * 제조혁신과제 완료보고서 저장
	 * @param ds
	 * @throws Exception 
	 */
	public void updateCmplAttcFilId(Map<String, Object> ds) throws Exception {
		if( commonDao.update("mkInno.tss.updateCmplAttcFilId", ds) > 0 ){
		}else{
			throw new Exception("첨부파일 등록중 오류가 발생하였습니다.");
		}
	}
	
	/**
	 * 제조혁신과제 진행 -> 완료
	 * @param ds
	 */
	public String saveMkInnoTssCmpl(Map<String, Object> input) {
		String pgTssCd = (String) input.get("tssCd");
		String cmTssCd = "";
		
		input.put("pgTssCd", pgTssCd);
		input.put("pgsStepCd", "CM");
		input.put("tssSt", "100");
		input.put("tssScnCd", "M");

		commonDao.insert("mkInno.tss.insertMkInnoTsslMst", input);  
		cmTssCd = (String)  input.get("tssCd");
		commonDao.insert("mkInno.tss.insertMkInnoTssSmry", input);            	//개요
		commonDao.insert("mkInno.tss.insertMkInnoTssPtcRsstMbr", input);	//참여연구원

		commonDao.update("mkInno.tss.updateMstTssSt", input);  
		
		return cmTssCd;
	}
	
	/**
	 * 제조혁신과제 연구원 삭제
	 * @param ds
	 */
	public void deleteMkInnoTssPlnPtcRsstMbr(Map<String, Object> ds) {
		commonDao.update("mkInno.tss.deleteMkInnoTssPtcRsstMbr", ds);  
	}
}
