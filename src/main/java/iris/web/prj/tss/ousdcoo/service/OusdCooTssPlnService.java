package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;

/*********************************************************************************
 * NAME : OusdCooTssPlnService.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 계획(Pln) service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.18  IRIS04	최초생성
 *********************************************************************************/

public interface OusdCooTssPlnService {
    
    /** 대외협력 계획 마스터, 개요 입력 **/
    public int insertOusdCooTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);
    
    /** 대외협력 계획 마스터, 개요 수정 **/
    public int updateOusdCooTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd);

}