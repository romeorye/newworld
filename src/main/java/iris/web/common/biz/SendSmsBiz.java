package iris.web.common.biz;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import iris.web.common.util.CommonUtil;


public class SendSmsBiz {

    public void writeToFile( String str, String logpath ) {

        try {
            FileOutputStream fw = new FileOutputStream( logpath, true );
            byte[] c = new byte[200];
            c = str.getBytes();

            fw.write(c);
            fw.write("\n".getBytes());
            fw.flush();
            fw.close();
        } catch(IOException e) {
            System.out.println(e);
        }
    }
    
    //SMS Dacom으로 보내기
    //sendData(수신자번호, 발신자번호, 발신메세지, 예약시간, 로그파일경로)
    public void sendData( String hand_numb, String send_numb, String message, String rsrv_date, String logpath ) {

        try {

            URL servletUrl = null;
            
            servletUrl = new URL("http://sms.lghausys.com:8010/lghausys/lghausys_wins_service.asp");

            HttpMessage hmsg = new HttpMessage(servletUrl);
            
            String seqn_numb = "wins_" + new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
            
            hand_numb = hand_numb.replaceAll("-", "");  //수신자번호
            send_numb = send_numb.replaceAll("-", "");  //발신자번호
                        
            System.out.println("수신자번호===>"+hand_numb);
            System.out.println("발신자번호===>"+send_numb);
            System.out.println("메세지내용===>"+message);
            
            
            Properties props = new Properties();
            //props.put("seqn",     seqn_numb);  // NO.
            props.put("receiver", hand_numb);  // 수신자 번호
            props.put("sender",   send_numb);  // 발신자 번호
            props.put("msg",      CommonUtil.replaceSecOutput(message)  );  // 메세지
            //props.put("reserved", rsrv_date);  // 예약시간

            InputStream in = hmsg.sendPostMessage(props);

        } catch (Exception e) {
            writeToFile( "전송실패 ==> " + e, logpath );
            e.printStackTrace();
        }
    }
    
    
    
}
