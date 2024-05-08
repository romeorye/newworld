package iris.web.prj.tss.nat.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface NatTssService {

	List<Map<String, Object>> retrieveNatTssList(HashMap<String, Object> input);
 //대외 협력 과제 개요 조회
	Map<String, Object> retrieveNatTssPlnSmry(HashMap<String, String> input);

//master 수정
	int updateNatTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> smryDsListLst, boolean upWbsCd);
// 계획단계 삭제
	void deleteNatTssPlnMst(HashMap<String, String> input);
//개요 저장
	int insertNatTssPlnSmry(HashMap<String, Object> input);
//개요 수정
	int updateNatTssPlnSmry(HashMap<String, Object> input);
//개요 삭제
	void deleteNatTssPlnSmryCrro(HashMap<String, Object> input);
//개요 수행기관 저장
	void insertNatTssPlnSmryCrro(Map<String, Object> map);

	void updateNatTssPlnSmryCrro(Map<String, Object> map);

//사업비 조회
	List<Map<String, Object>> retrieveNatTssPlnTrwiBudg(HashMap<String, Object> input);
//개요 수행기관 조회
	List<Map<String, Object>> retrieveSmryCrroInstList(HashMap<String, Object> inputMap);
//참여연구원 과제리더의 과제수  check
	int retrieveNatPtcRePer(Object object);
//	참여연구원 연구원 참여율 check
	int retrieveNatPtcPlCnt(Object object);
// 사업비 저장
	void saveNatTssPlnTrwiBudg(Map<String, Object> dsEach);

	List<Map<String, Object>> retrieveGoalEvHis(HashMap<String, String> input);


	//정산
    Map<String, Object> retrieveNatTssStoa(HashMap<String, String> input);

    int updateNatTssStoa(Map<String, Object> map);


    //품의서
    List<Map<String, Object>> retrieveNatTssCsusCrro(HashMap<String, String> input);

    List<Map<String, Object>> retrieveNatTssCsusBudg1(HashMap<String, String> input);

    List<Map<String, Object>> retrieveNatTssCsusBudg2(HashMap<String, String> input);

    void insertNatTssPlnCsusRq(Map<String, Object> map);

    void insertNatTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, List<Map<String, Object>> smryDsListLst, boolean upWbsCd);

    Map<String, Object> retrieveNatTssPgsCsus(HashMap<String, String> input);
}

