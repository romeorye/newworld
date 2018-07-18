package iris.web.common.util;

import java.security.MessageDigest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class HelpDesk {

	static final Logger LOGGER = LogManager.getLogger(HelpDesk.class);
	
	
	public String user_id(String sabun){
	    //회사코드 추가
	    String user_id ="";
	    user_id =  "921700"+sabun;
	    
	    return user_id;
	}


	public String fmd5_user_id(String sabun ){
	    //공유키 추가
	    String fmd5_user_id =  "921700" + sabun +"lgcns0924";
	    StringBuffer sb = new StringBuffer();
	    
	    sb.append(fmd5_user_id);
	    byte[] bNoti = sb.toString().getBytes();
	    MessageDigest md = null;
	    try{
	        md = MessageDigest.getInstance("MD5");
	    }catch(java.security.NoSuchAlgorithmException e){}
	    byte[] digest = md.digest(bNoti);
	    StringBuffer strBuf = new StringBuffer();
	    for (int i=0 ; i < digest.length ; i++) {
	        int c = digest[i] & 0xff;
	        if (c <= 15){
	            strBuf.append("0");
	        }

	        strBuf.append(Integer.toHexString(c));
	    }
	    fmd5_user_id = strBuf.toString();
	    
	    return fmd5_user_id;
	}
}
