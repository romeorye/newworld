package iris.web.prj.converter.service;

/*********************************************************************************
 * NAME : EditorContentsConverterService.java
 * DESC : 에디터 이미지 사이즈 체크
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.06  IRIS04	최초생성
 *********************************************************************************/
public interface EditorContentsConverterService {
	
	/*
	 * 에디터 이미지 너비 제한 처리
	 * */
	public String convertImageWidthLimit(String input, int imageWidthLimit);
}
