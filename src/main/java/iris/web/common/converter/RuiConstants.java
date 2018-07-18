/*
 * @(#) LRuiConstants.java
 *
 * Copyright ⓒ LG CNS, Inc. All rights reserved.
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * DevOn Framework의 클래스를 실제 프로젝트에 사용하는 경우 DevOn 개발담당자에게
 * 프로젝트 정식명칭, 담당자 연락처(Email)등을 mail로 알려야 한다.
 *
 * 소스를 변경하여 사용하는 경우 DevOn Framework 개발담당자에게
 * 변경된 소스 전체와 변경된 사항을 알려야 한다.
 * 저작자는 제공된 소스가 유용하다고 판단되는 경우 해당 사항을 반영할 수 있다.
 * 중요한 Idea를 제공하였다고 판단되는 경우 협의하에 저자 List에 반영할 수 있다.
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
package iris.web.common.converter;

/**
 * <pre>
 * RUI Converter에서 사용하는 상수 클래스
 * </pre>
 * 
 * @author DevOn Framework, LG CNS,Inc., devon@lgcns.com
 * @version DevOn Framework 4.2.0
 * @since DevOn Framework 4.2.0 
 */
public class RuiConstants {
    private RuiConstants() {}
    
    /**
     * metaData의 record의 row id 키 값
     */
    public static final String METADATA_RECORD_ID = "id";
    
    /**
     * 변환 작업시에 데이터셋 이름이 없을 경우 기본 명
     */
    public static final String METADATA_DATASET_DEFAULT_NAME = "dataSet";
    
    /**
     * metaData의 dataSet의 이름을 구분하는 키 값  
     */
    public static final String METADATA_DATASET_ID = "dataSetId";

    /**
     * metaData의 dataSet의 state을 구분하는 키 값  
     */
    public static final String METADATA_RECORD_STATE = "duistate";

    /**
     * request에서 rui의 데이터를 얻어오는 키값  
     */
    public static final String KEY_DATASETDATA = "dui_datasetdata";

    /**
     * reponse 데이터 키값  
     */
    public static final String KEY_DATA = "dui_data";

    /**
     * record의 그룹을 구분하는 키값  
     */
    public static final String KEY_RECORDS = "records";
    

    /**
     * dataSet 내에 metaData를 구분하는 키값
     */
    public static final String KEY_METADATA= "metaData";
    
    /**
     * Insert 시 row state 값
     */
    public static final String ROW_STATE_INSERT = "1"; 
    
    /**
     * Update 시 row state 값
     */
    public static final String ROW_STATE_UPDATE = "2";
    
    /**
     * Delete 시 row state 값
     */
    public static final String ROW_STATE_DELETE = "3";
}
