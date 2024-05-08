package iris.web.prj.mmBatch.service;

import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : MmTodoServiceImpl.java 
 * DESC : MmTodo 서비스 implement
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.10.24  IRIS04   최초생성            
 *********************************************************************************/

@Service("mmTodoService")
public class MmTodoServiceImpl implements  MmTodoService{
	
	static final Logger LOGGER = LogManager.getLogger(MmTodoServiceImpl.class);
	
	static Calendar cal = Calendar.getInstance();
	static SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
	
	static String toDay	= date_formatter.format(cal.getTime());
	
	static InputStream inputStream;
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;
	
	/** 
	 * M/M입력 뷰 조회
	 * **/
	@Override
	public List<Map<String, Object>> retrieveMmInTodoList(){
		return commonDao.selectList("prj.mm.batch.retrieveMmInTodoList");
	}
	
	/** 
	 * M/M마감 뷰 조회
	 * **/
	@Override
	public List<Map<String, Object>> retrieveMmClsTodoList(){
		return commonDao.selectList("prj.mm.batch.retrieveMmClsTodoList");
	}
	
	/** 
	 * M/M입력 To-Do 프로시져호출
	 * **/
	@Override
	public void saveMmpUpMwTodoReq(Map<String, Object> input) {
		commonDaoTodo.insert("prj.mm.batch.saveMmpUpMwTodoReq", input);
	}
	
	/** 
	 *  M/M마감 To-Do 프로시져호출
	 * **/
	@Override
	public void saveMmlUpMwTodoReq(Map<String, Object> input){
		commonDao.insert("prj.mm.batch.saveMmlUpMwTodoReq",input);
	}
	
	
	/**
	 * batch log 생성
	 * @param s
	 */
	public void log(String s) {
        try {
        	
            FileWriter  fw = null ;
            fw  = new FileWriter(toDay+"_MmTodoCalBatch.log",true) ;
            PrintWriter pw  = new PrintWriter(fw) ;
            String d = (new java.sql.Timestamp(java.lang.System.currentTimeMillis())).toString().substring(0, 19) + " ";
            pw.println( d+s ) ;
            pw.close() ;
            System.out.println(s);
        } catch(Exception ex) {
            log( toDay+"_MmTodoCalBatch.log ->Logfile Creation Fail :"+ex.toString()) ;
        }
    }
	/**
	 * properties read
	 * @param val
	 * @return
	 * @throws IOException
	 */
	public  String getPropValues(String val) throws IOException {
		String result = "";
		try {
			Properties prop = new Properties();
			String propFileName = "project.properties";
			
			inputStream =  this.getClass().getClassLoader().getResourceAsStream("/config/project.properties");
			
			if (inputStream != null) {
				prop.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propFileName + "' not found in the classpath");
			}
 
			Date time = new Date(System.currentTimeMillis());
 
			// get the property value and print it out
			result = prop.getProperty(val);
			
		
			System.out.println(result + "\nProgram Ran on " + time + " by user=" + result);
		} catch (Exception e) {
			System.out.println("Exception: " + e);
		} finally {
			inputStream.close();
		}
		return result;
	}
	
}// end class


