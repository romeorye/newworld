package iris.web.sapBatch.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import com.sap.conn.jco.ext.DestinationDataProvider;

import devonframe.dataaccess.CommonDao;

/*********************************************************************************
 * NAME : SapBudgCostServiceImpl.java
 * DESC : SapBudgCostServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.28  jih	최초생성
 *********************************************************************************/

@Service("sapBudgCostService")
public class SapBudgCostServiceImpl implements  SapBudgCostService{

    static final Logger LOGGER = LogManager.getLogger(SapBudgCostServiceImpl.class);

    static Calendar cal = Calendar.getInstance();
    static SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));

    static String toDay	= date_formatter.format(cal.getTime());

    static InputStream inputStream;
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";  //sap 연결명(연결파일명으로 사용됨)

    @Resource(name="commonDao")
    private CommonDao commonDao;


    @Override
    public int insertBudgSCost(List<Map<String, Object>> list) {
        return commonDao.batchInsert("sapBatch.insertBudgSCost", list);
    }


    @Override
    public int insertBudgTCost(List<Map<String, Object>> list) {
        return commonDao.batchInsert("sapBatch.insertBudgTCost", list);
    }





    @Override
    public void sapConnection() throws IOException {
        LOGGER.debug("====시작");
        LOGGER.debug("HOST_NAME ::"+ this.getPropValues("SAP.sappool.HOST_NAME"));

        Properties connectProperties = new Properties();
        connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, this.getPropValues("SAP.sappool.HOST_NAME"));  //SAP 호스트 정보
        connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR,  this.getPropValues("SAP.sappool.SYSTEM_NO"));  //인스턴스번호
        connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, this.getPropValues("SAP.sappool.SAP_CLIENT"));     //SAP 클라이언트
        connectProperties.setProperty(DestinationDataProvider.JCO_USER,   this.getPropValues("SAP.sappool.USER_ID"));   //SAP유저명
        connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, this.getPropValues("SAP.sappool.PASSWORD"));  //SAP 패스워드
        connectProperties.setProperty(DestinationDataProvider.JCO_LANG,   this.getPropValues("SAP.sappool.LANGUAGE"));       //언어
        createDestinationDataFile(ABAP_AS, connectProperties);
    }

    public void createDestinationDataFile(String destinationName, Properties connectProperties)
    {
        File destCfg = new File(destinationName+".jcoDestination");

        //  if(!destCfg.exists()){

        try{
            FileOutputStream fos = new FileOutputStream(destCfg, false);

            connectProperties.store(fos, "for tests only !");
            fos.close();
        }catch (Exception e){
            throw new RuntimeException("Unable to create the destination files", e);
        }

        //  }

    }





    /**
     * batch log 생성
     * @param s
     */
    @Override
    public void log(String s) {
        try {

            FileWriter  fw = null ;
            fw  = new FileWriter(toDay+"_SAPBatch.log",true) ;
            PrintWriter pw  = new PrintWriter(fw) ;
            String d = (new java.sql.Timestamp(java.lang.System.currentTimeMillis())).toString().substring(0, 19) + " ";
            pw.println( d+s ) ;
            pw.close() ;
            System.out.println(s);
        } catch(Exception ex) {
            log( toDay+"_SAPBatch.log ->Logfile Creation Fail :"+ex.toString()) ;
        }
    }



    @Override
    public int updateTssGenTrwiBudgMst(HashMap map) {

        return commonDao.update("sapBatch.updateTssGenTrwiBudgMst",map);

    }


    /**
     * properties read
     * @param val
     * @return
     * @throws IOException
     */
    @Override
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



}


