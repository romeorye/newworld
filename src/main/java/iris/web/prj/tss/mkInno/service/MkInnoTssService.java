package iris.web.prj.tss.mkInno.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MkInnoTssService {

	List<Map<String, Object>> retrieveMkInnoTssList(HashMap<String, Object> input);

	Map<String, Object> retrieveMkInnoMstInfo(HashMap<String, Object> input);

	Map<String, Object> retrieveMkInnoSmryInfo(HashMap<String, Object> input);

	/**
	 * 제조혁신과제 인원 조회
	 */
	List<Map<String, Object>> retrieveMkInnoMbrList(HashMap<String, Object> input);

	//List<Map<String, Object>> retrieveMkInnoYldList(HashMap<String, Object> input);

	/**
	 * 제조혁신과제 마스터, smry 저장
	 * @throws Exception 
	 */
	void saveMkInnoMst(Map<String, Object> dataMap) throws Exception;

	/**
	 * 제조혁신과제 참여연구원 저장
	 * @throws Exception 
	 */
	void saveMkInnoMbr(List<Map<String, Object>> mbrDataSetList) throws Exception;

	/**
	 * 제조혁신과제 첨부파일 조회(품의서용)
	 * @param inputInfo
	 * @return
	 */
	List<Map<String, Object>> retrieveMkInnoTssAttc(HashMap<String, Object> inputInfo);

	/**
	 * 제조혁신 과제 전자결재건 체크
	 * @param input
	 * @return
	 */
	Map<String, Object> retrieveMkInnoCsusInfo(HashMap<String, Object> input);

	/**
	 * 제조혁신 과제  전자결재 등록
	 * @param ds
	 */
	void insertMkInnoTssCsusRq(Map<String, Object> ds);

	/**
	 * 제조혁신 과제  전자결재 업데이트
	 * @param ds
	 */
	void updateMkInnoTssCsusRq(Map<String, Object> ds);

	/**
	 * 제조혁신과제 신규과제 등록
	 * @param ds
	 */
	void saveMkInnoTssReg(Map<String, Object> ds)  throws Exception;

	/**
	 * 제조혁신과제 완료보고서 저장
	 * @param ds
	 */
	void updateCmplAttcFilId(Map<String, Object> ds) throws Exception;

	/**
	 * 제조혁신과제 진행 -> 완료
	 * @param ds
	 */
	String saveMkInnoTssCmpl(Map<String, Object> input);

	/**
	 * 제조혁신과제 연구원 삭제
	 * @param ds
	 */
	void deleteMkInnoTssPlnPtcRsstMbr(Map<String, Object> ds);

}
