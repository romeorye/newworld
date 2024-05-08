package iris.web.common.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbConn {

		
	
	/**
	 *  울산 QAS DB connection
	 */
	public static Connection getUsanCoConnection() {
		Connection conn = null;
        
        String DB_DRIVER   = "core.log.jdbc.driver.OracleDriver";
        String DB_URL      = "jdbc:oracle:thin:@165.186.187.9:1521:ORA7";    
        String DB_USER     = "lims";
        String DB_PASSWORD = "!lims123";
				
        try {
            Class.forName( DB_DRIVER );
            conn = DriverManager.getConnection( DB_URL, DB_USER, DB_PASSWORD );
            conn.setAutoCommit(false);
        } catch (Exception e) {
            System.out.println(e.toString());
        }  
        
        return conn;
	}
        
        
	/**
	 *  청주 QAS DB connection
	 * @return
	 */
	public static Connection getOksanConn(){
		Connection conn = null;
        
        String DB_DRIVER   = "core.log.jdbc.driver.OracleDriver";
        String DB_URL      = "jdbc:oracle:thin:@165.244.142.27:1526:PSAA01";    
        String DB_USER     = "lims";
        String DB_PASSWORD = "cjdwnflatm01";
				
        try {
            Class.forName( DB_DRIVER );
            conn = DriverManager.getConnection( DB_URL, DB_USER, DB_PASSWORD );
            conn.setAutoCommit(false);
        } catch (Exception e) {
            System.out.println(e.toString());
        }   
        
        return conn;
	}
		
	
}
