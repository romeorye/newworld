package iris.web.prj.converter.service;

import java.awt.Image;

import javax.annotation.Resource;
import javax.swing.ImageIcon;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;

import devonframe.configuration.ConfigService;
import devonframe.util.NullUtil;

/*********************************************************************************
 * NAME : EditorContentsConverterServiceImpl.java
 * DESC : 에디터 이미지 사이즈 체크
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.06  IRIS04	최초생성
 *********************************************************************************/

@Service("editorContentsConverterService")
public class EditorContentsConverterServiceImpl implements  EditorContentsConverterService{
	
    @Resource(name = "configService")
    private ConfigService configService;	// devon config 서비스

    static final Logger LOGGER = LogManager.getLogger(EditorContentsConverterServiceImpl.class);
    
    public static final double DEFAULT_IMAGE_WIDTH_LIMIT = 950.000;

    @Override
	/*
	 * 에디터 이미지 너비 제한 처리
	 * */
	public String convertImageWidthLimit(String input, int imageWidthLimit) {
    	String parseImageString = "";
    	String resultString = "";
    	
    	parseImageString = this.parseImage(input,imageWidthLimit);
    	resultString = parseImageString.replaceAll("<body>", "").replaceAll("</body>", "").replaceAll("<BODY>", "").replaceAll("</BODY>", "");

    	return resultString;
    }
    
    /* 이미지 너비제한 함수 */
    public String parseImage(String input, int imageWidthLimit) {
    	
    	String uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_PRJ");  // 파일이 실제로 업로드 되는 경로
    	
    	double widthLimitPx = imageWidthLimit;	// 이미지 너비 제한 px
    	if(imageWidthLimit == 0 ) {
    		widthLimitPx = DEFAULT_IMAGE_WIDTH_LIMIT;
    	}
    	
    	Document doc = Jsoup.parseBodyFragment(input); 
    	Element body = doc.body();
    	
    	Elements imgs = body.getElementsByTag("img");
    	if(imgs.size() > 0) {
    		
    		int width = 0;
			int height = 0;
			String newStyleString = "";
    		
    		for(int i=0;i < imgs.size(); i++) {
    			Elements styles = imgs.get(i).getElementsByAttribute("style");
    			// 1. style 이 존재하는 경우
    			if( styles != null && !styles.isEmpty()) {
	    			String style = imgs.get(i).attr("style").toUpperCase();
	    			
	
//	    			if( style.contains("WIDTH") ) {

	    				String[] styleArr = style.split(";");
	    				for(int j=0; j< styleArr.length; j++) {
	    					// 너비
	    					// WIDTH, PX 문자열 존재, MAX-WIDTH, % 비존재시 계산
	    					if( styleArr[j] != null && styleArr[j].contains("WIDTH") && styleArr[j].contains("PX") && !styleArr[j].contains("-WIDTH") && !styleArr[j].contains("%") ){
	    						String strWidth = NullUtil.nvl( styleArr[j] , "").replaceAll("WIDTH", "").replaceAll(":", "").replaceAll("PX", "").trim();
	    						width = Integer.parseInt(strWidth);
	    					}
	    					// 높이
	    					if( styleArr[j] != null && styleArr[j].contains("HEIGHT") && styleArr[j].contains("PX") && !styleArr[j].contains("-HEIGHT") && !styleArr[j].contains("%") ){
	    						String strHeight = NullUtil.nvl( styleArr[j] , "").replaceAll("HEIGHT", "").replaceAll(":", "").replaceAll("PX", "").trim();
	    						height = Integer.parseInt(strHeight);
	    					}
	    				}
	    				// 1.1. 이미지 스타일 WIDTH 태그가 존재하고 값을 찾은경우
	    				if( width > 0 ) {
		    				if( width > widthLimitPx ) {
		    					double rate = Math.floor((widthLimitPx / width)*1000)/1000;
	//	    					LOGGER.debug("rate="+rate);
		    					height = (int) Math.floor( height * rate );
		    					
		    					if( height > 0 ) {
		    						newStyleString = "HEIGHT: " + height + "px; WIDTH: 950px";
		    					}else {
		    						newStyleString = "WIDTH: 950px";
		    					}
		    					
		    					imgs.get(i).attr("style", newStyleString ); 
		    				}
	    				}
	    				// 1.2. 이미지 스타일 WIDTH 태그와 값을 못찾은 경우 => => 업로드된 이미지 파일 사이즈 체크
//	    				else {
//	        				String src = imgs.get(i).attr("src");
//	        				if( src != null && !"".equals(src) ) {
//	        					String fileName = src.substring(src.lastIndexOf("/"), src.length());
//	        					
//	    	    				Image img = new ImageIcon(uploadPath+fileName).getImage();
//	    	    				if(img != null) {
//	    		    				width = img.getWidth(null);
//	    		    				height = img.getHeight(null);
//	    		    				
//	    		    				if( width > widthLimitPx ) {
//	    		    					double rate = Math.floor((widthLimitPx / width)*1000)/1000;
////	    		    					LOGGER.debug("rate="+rate);
//	    		    					height = (int) Math.floor( height * rate );
//	    		    					
//	    		    					newStyleString = "HEIGHT: " + height + "px; WIDTH: 950px";
//	    		    					
//	    		    					imgs.get(i).attr("style", newStyleString );
//	    		    				}
//	    	    				}				
//	        				}
//	    				}// end 1.2
	    			}// end 1
//    			}
    			// 2. style 이 없는 경우 => 업로드된 이미지 파일 사이즈 체크
    			else {
    				String src = imgs.get(i).attr("src");
    				if( src != null && !"".equals(src) ) {
    					String fileName = src.substring(src.lastIndexOf("/"), src.length());
    					
	    				Image img = new ImageIcon(uploadPath+fileName).getImage();
	    				if(img != null) {
		    				width = img.getWidth(null);
		    				height = img.getHeight(null);
		    				
		    				if( width > widthLimitPx ) {
		    					double rate = Math.floor((widthLimitPx / width)*1000)/1000;
//		    					LOGGER.debug("rate="+rate);
		    					height = (int) Math.floor( height * rate );
		    					
		    					newStyleString = "HEIGHT: " + height + "px; WIDTH: 950px";
		    					
		    					imgs.get(i).attr("style", newStyleString );
		    				}
	    				}				
    				}
    			}
    			
    		}
    	}
    	
    	return body.toString();
    }
}//end class
      



  



