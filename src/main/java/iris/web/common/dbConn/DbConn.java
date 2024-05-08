package iris.web.common.dbConn;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbConn {
	Connection con;
    
    String url = "";
    String id = "";
    String pw = "";
    
    public Connection getUConn() throws Exception{
		url = "jdbc:oracle:thin:@165.186.187.9:1521:ORA7";
	    id = "lims";
	    pw = "!lims123";
		
	    try{
	    	con = DriverManager.getConnection(url, id, pw);
	    	
	    	return con;
	    }catch(Exception e){
	    	throw new Exception("울산QAS 접속시 오류가 발생했습니다.");
	    }
	}
	
	public Connection getOConn() throws Exception{
		url = "jdbc:oracle:thin:@165.244.142.27:1526:PSAA01";
	    id = "lims";
	    pw = "cjdwnflatm01";
	    
	    try{
	    	con = DriverManager.getConnection(url, id, pw);
	    	
	    	return con;
	    }catch(Exception e){
	    	throw new Exception("옥산QAS 접속시 오류가 발생했습니다.");
	    }
	}

	public void closeConnection(){
		 
        try{
            //자원 반환
        	con.close();
        	
        }catch(Exception e){
            e.printStackTrace();
        }
 
    }
	
    
}
