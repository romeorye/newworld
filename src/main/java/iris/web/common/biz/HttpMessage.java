package iris.web.common.biz;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Properties;

public class HttpMessage
{
    URL servlet = null;
    String args = null;

    /**
     * 지정된 URL의 서블릿과 통신하기 위해 사용될 수 있는 새로운 인스턴스를 생성한다.
     * @param servlet 통신을 원하는 서버 리소스(통상 서블릿)
     */
    public HttpMessage(URL servlet)
    {
        this.servlet = servlet;
    }
    /**
     * 아무런 query string 없이 서블릿에게 GET요청을 수행한다.
     *
     * @return 응답을 읽기 위한 InputStream
     * @exception I/O 오류가 발생한 경우 IOException
     */
    public InputStream sendGetMessage() throws IOException
    {
        return sendGetMessage(null);
    }
    /**
     * 제공되는 프로퍼티 리스트를 통해 query string을 만들어
     * 서블릿에게 GET요청을 수행한다.
     *
     * @param args query string을 만들기 위한 프로퍼티 리스트
     * @return 응답을 읽기 위한 InputStream
     * @exception I/O 오류가 발생한 경우 IOException
     */
    public InputStream sendGetMessage(Properties args) throws IOException
    {
        String argString = "";  // default
        if (args != null)
            argString = "?" + toEncodedString(args);
        URL url = new URL(servlet.toExternalForm() + argString);
        // Turn off caching
        URLConnection con = url.openConnection();
        con.setUseCaches(false);
        return con.getInputStream();
    }
    /**
     * 아무런 post data 없이 서블릿에게 POST 요청을 수행한다.
     *
     * @return 응답을 읽기 위한 InputStream
     * @exception I/O 오류가 발생한 경우 IOException
     */
    public InputStream sendPostMessage() throws IOException
    {
        return sendPostMessage(null);
    }
    /**
     * 제공되는 프로퍼티 리스트를 통해 query string을 만들어
     * 서블릿에게 POST 요청을 수행한다.
     *
     * @param args post data를 만들기 위한 프로퍼티 리스트
     * @return 응답을 읽기 위한 InputStream
     * @exception I/O 오류가 발생한 경우 IOException
     */
    public InputStream sendPostMessage(Properties args) throws IOException
    {
        String argString = "";  // default
        if (args != null)
            argString = toEncodedString(args);  // notice no "?"
        URLConnection con = servlet.openConnection();
        // Prepare for both input and output
        con.setDoInput(true);
        con.setDoOutput(true);
        // Turn off caching
        con.setUseCaches(false);
        // Work around a Netscape bug
        con.setRequestProperty("Content-Type",
                               "application/x-www-form-urlencoded");
        // Write the arguments as post data
        DataOutputStream out = new DataOutputStream(con.getOutputStream());
        out.writeBytes(argString);
        out.flush();
        out.close();
        return con.getInputStream();
    }
    /**
     * 직렬화 객체를 업로드하면서 서블릿에게 POST 요청을 수행한다.
     * 서블릿은 doPost() 메소드에서 다음과 같이 객체를 수신할 수 있다.
     *     ObjectInputStream objin =
     *       new ObjectInputStream(req.getInputStream());
     *     Object obj = objin.readObject();
     * 업로드된 객체의 타입은 content-type의 서브타입 처럼 취급될 수 있다.
     * (java-internal/classname).
     * @param obj 업로드할 직렬화 가능한 객체
     * @return 응답을 읽기 위한 InputStream
     * @exception I/O 오류가 발생한 경우 IOException
     */
    public InputStream sendPostMessage(Serializable obj) throws IOException
    {
        URLConnection con = servlet.openConnection();
        // Prepare for both input and output
        con.setDoInput(true);
        con.setDoOutput(true);
        // Turn off caching
        con.setUseCaches(false);
        // Set the content type to be java-internal/classname
        con.setRequestProperty("Content-Type",
                               "java-internal/" + obj.getClass().getName());
        // Write the serialized object as post data
        ObjectOutputStream out = new ObjectOutputStream(con.getOutputStream());
        out.writeObject(obj);
        out.flush();
        out.close();
        return con.getInputStream();
    }
    /*
     * 프로퍼티 리스트를 URL 인코딩된 query string으로 변환한다.
     */
    private String toEncodedString(Properties args)
    {
        StringBuffer buf = new StringBuffer();
        Enumeration names = args.propertyNames();
        while (names.hasMoreElements()) {
            String name = (String) names.nextElement();
            String value = args.getProperty(name);
            try {
				buf.append(URLEncoder.encode(name, "EUC-KR") + "=" + URLEncoder.encode(value, "EUC-KR"));
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            if (names.hasMoreElements()) buf.append("&");
        }
        return buf.toString();
    }
}
