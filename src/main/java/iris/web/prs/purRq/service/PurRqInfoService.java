package iris.web.prs.purRq.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PurRqInfoService {

    /**
     * 구매요청 리스트 조회(main)
     */
    List<Map<String, Object>> retrievePurRqList(HashMap<String, Object> input);

    /**
     * 구매요청 상세내용 조회
     */
    Map<String, Object> retrievePurRqDetail(HashMap<String, Object> input);

    /**
     * 구매요청상세 리스트 조회
     */
    List<Map<String, Object>> retrievePurRqDetailList(HashMap<String, Object> input);

    /**
     * 구매요청상세 ERP Pr 리스트 조회
     */
    List<Map<String, Object>> retrieveERPPrInfo(HashMap<String, Object> input);

    /**
     * 구매요청상세 PurRq 리스트 조회
     */
    List<Map<String, Object>> retrievePurRqInfo(HashMap<String, Object> input);

    /**
     * 구매요청번호 채번
     */
    int getBanfnPrsNumber();

    /**
     *  구매요청 등록
     */
    void insertPurRqInfo(Map<String, Object> purRqDetail) throws Exception;

    /**
     *  구매요청 삭제
     */
    void deletePurRqInfo(HashMap<String, Object> input) throws Exception;

    /**
     *  구매요청 수정
     */
    void updatePurRqInfo(Map<String, Object> purRqDetail) throws Exception;

    /**
     *  나의구매 요청 리스트
     */
    List<Map<String, Object>> retrieveMyPurRqList(HashMap<String, Object> input);

    /**
     *  SAP 구매요청 리스트 조회
     */
    List<Map<String, Object>> getPrRequestSAPStatus(List<Map<String, Object>> myPurRqList);

    /**
     *  결재의뢰 저장(ERP)
     */
    HashMap<String, Object> sendSapExpensePr(Map<String, Object> input);

    /**
     * 결재의뢰 저장(IRIS+)
     * @param purRqAppMap
     * @return
     * @throws Exception
     */
    int insertPurApprovalInfo(Map<String, Object> input) throws Exception;

    /**
     *  첨부파일 목록 조회
     */
    List<Map<String, Object>> retrieveAttachFileList(HashMap<String, Object> input);

}
