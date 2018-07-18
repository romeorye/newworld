package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : OusdCooTssService.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.14  IRIS04	최초생성
 *********************************************************************************/

public interface OusdCooTssService {

    /* 마스터 */
    public List<Map<String, Object>> retrieveOusdCooTssList(HashMap<String, Object> input);

    void deleteOusdCooTssPlnMst(HashMap<String, String> input);

    /* 개요 */
    public Map<String, Object> retrieveOusdCooTssSmry(HashMap<String, String> input);

    /* 대외협력과제 개요(convert \n <br> 변환처리) */
    public Map<String, Object> retrieveOusdCooTssSmryNtoBr(HashMap<String, String> input);

    public int insertOusdCooTssSmry(HashMap<String, Object> input);

    public int updateOusdCooTssSmry(HashMap<String, Object> input);

    /* 비용지급 */
    public Map<String, Object> retrieveOusdCooTssExpStoa(HashMap<String, String> input);

    public int insertOusdCooTssExpStoa(HashMap<String, Object> input);

    public int updateOusdCooTssExpStoa(HashMap<String, Object> input);

    public int deleteOusdCooTssExpStoa(HashMap<String, Object> input);
    /* 완료 비용지급 조회 */
    public Map<String, Object> retrieveCmplOusdCooTssExpStoa(HashMap<String, String> input);

    /* 품의서 기타정보 */
    public Map<String, Object> retrieveOusdCooRqEtcInfo(HashMap<String, String> input);

    /* 과제 공통 목표기술성과(텍스트타입 convert \n <br> 변환처리) */
    public List<Map<String, Object>> retrieveGenTssPlnGoalNtoBr(HashMap<String, String> input);

    /* (문자열)에디터 이미지파일 디코드처리 */
    public String decodeNamoEditorValue(String editorValue) throws Exception;

    /* (맵)에디터 이미지파일 디코드처리
     * input Param : editorData1, editorData2, editorData3 ...(에디터데이터)
     *               editorDataFields(데이터셋 필드명)
     * */
    public Map<String, Object> decodeNamoEditorMap(Map<String, Object> input, Map<String, Object> dataSet) throws Exception;

    public Map<String, Object> decodeNamoEditorMap2(Map<String, Object> dataSet) throws Exception;

    /** 과제관리 > 대외협력과제 > 진행 > 변경이력 상세 조회  **/
	public Map<String, Object> ousdCooTssAltrDetailSearch(HashMap<String, Object> input);

	/**  과제관리 > 대외협력과제 > 진행 > 변경이력 상세 조회  **/
	public List<Map<String, Object>> retrieveOusdCooTssAltrList(HashMap<String, Object> input);

}