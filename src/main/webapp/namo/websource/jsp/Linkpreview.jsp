<%@ page pageEncoding="utf-8" %>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.SocketTimeoutException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.StringWriter"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.security.cert.X509Certificate"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="javax.net.ssl.SSLContext"%>
<%@page import="javax.net.ssl.TrustManager"%>
<%@page import="javax.net.ssl.X509TrustManager"%>


<%!
		public static String getPrintStackTrace(Exception e) {
			StringWriter errors = new StringWriter();
			//e.printStackTrace(new PrintWriter(errors));

			return errors.toString();
    }

	public void sslTrustAllCerts(){ TrustManager[] trustAllCerts = new TrustManager[] {
		new X509TrustManager() {
			public X509Certificate[] getAcceptedIssuers() {
				return null; 
			}
			public void checkClientTrusted(X509Certificate[] certs, String authType) { }
			public void checkServerTrusted(X509Certificate[] certs, String authType) { } } };
			SSLContext sc;
			
			try {
				sc = SSLContext.getInstance("SSL");
				sc.init(null, trustAllCerts, new SecureRandom());
				HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
			} catch(NoSuchAlgorithmException | KeyManagementException | CertificateException e){
				//e.printStackTrace();
				System.out.println(e.getMessage());
			}
			}


	public static URL getFinalURL(URL url) {
		try {
			
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			//System.setProperty("java.net.useSystemProxies", "true");
			System.setProperty("https.protocols", "TLSv1,TLSv1.1,TLSv1.2");
			con.setRequestMethod("GET");
			con.setRequestProperty("User-Agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
			con.setRequestProperty("Accept","text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
			//con.addRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62");
			con.addRequestProperty("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4");
			con.addRequestProperty("Referer", "https://www.google.com/");
			con.addRequestProperty("Accept-Encoding","gzip, deflate, br");
			con.setInstanceFollowRedirects(false);
			con.setConnectTimeout(5000);
			con.setReadTimeout(5000);
			con.connect();

			//Thread.sleep(1000);

			// Header에서 Status Code를 뽑는다.
			int resCode = con.getResponseCode();
			
			System.out.println(resCode);		
			// http코드가 301(영구이동), 302(임시 이동), 303(기타 위치 보기) 이면 또다시 이 함수를 태운다. 재귀함수.
			//if (resCode == HttpURLConnection.HTTP_SEE_OTHER || resCode == HttpURLConnection.HTTP_MOVED_PERM
			//		|| resCode == HttpURLConnection.HTTP_MOVED_TEMP) {
			if (resCode >= 300 && resCode <= 307 && resCode != 306 &&
            	resCode != HttpURLConnection.HTTP_NOT_MODIFIED) 
        	 {
				String Location = con.getHeaderField("Location");
				if (Location.startsWith("/")) {
					Location = url.getProtocol() + "://" + url.getHost() + Location;
				}	
				return getFinalURL(new URL(Location));
			}
		}catch(java.net.SocketTimeoutException e){ // time out exception check
			System.out.println("getting page time out!!");
			return null; // rediret url -> null 
		}catch (MalformedURLException | IOException | ProtocolException | SSLHandshakeException e){
			System.out.println(getPrintStackTrace(e));
		}
		return url;
	}
%>

<%
try{
	
	String url = request.getParameter("url");
     //if(url.startsWith("http://") && url.indexOf("localhost") < 0) {
    //	url = url.replaceAll("http://", "https://");
	 //}

	System.out.println("orgUrl :::::::::::" + url);

	URLConnection con = new URL(url).openConnection();
	URL redirectUrl = getFinalURL(con.getURL());
	con.setConnectTimeout(5000);
	con.setReadTimeout(5000);
	System.out.println("rediRect Url :::::::::::" + redirectUrl);

	String realUrl = "<redirectUrl>" + redirectUrl + "</redirectUrl>"; 
	if(redirectUrl == null){
		return ;
	}
	
 	InputStream tempInputStream = redirectUrl.openStream();
 	InputStreamReader isr = new InputStreamReader(tempInputStream, "utf-8");
 	StringBuffer sb = new StringBuffer();	
	int curByte;

	sb.append(realUrl);
	while ((curByte = isr.read()) != -1) {
		sb.append((char)curByte);
	}
	isr.close();
	tempInputStream.close();
	out.clearBuffer();

	/*
	StringBuilder sb = new StringBuilder();
    String line;
 
    InputStream in = redirectUrl.openStream();
    try {
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
        while ((line = reader.readLine()) != null) {
            sb.append(line).append(System.lineSeparator());
        }
    } finally {
        in.close();
    }
	sb.append(realUrl);
	*/
	response.reset();
	response.setContentType("text/plain; charset=utf-8");
	
	//System.out.println(sb.toString().indexOf("<meta charset=\"euc-kr\">"));
	if((sb.toString().indexOf("encoding=\"euc-kr\"") != -1 || sb.toString().indexOf("encoding=\"EUC-KR\"") != -1
		|| sb.toString().indexOf("charset=\"euc-kr\"") != -1 || sb.toString().indexOf("charset=\"EUC-KR\"") != -1
		|| sb.toString().indexOf("charset=euc-kr") != -1 || sb.toString().indexOf("charset=EUC-KR") != -1) 
		&& sb.toString().indexOf("charset=utf-8") == -1
		){
		InputStream tempInputStream2 = redirectUrl.openStream();
		InputStreamReader isr2 = new InputStreamReader(tempInputStream2, "euc-kr");
	    String realUrl2 = "<redirectUrl>" + redirectUrl + "</redirectUrl>"; 
		StringBuffer sb2 = new StringBuffer();

		sb2.append(realUrl2);

		int curByte2;
		while ((curByte2 = isr2.read()) != -1) {
			sb2.append((char)curByte2);
		}

		isr2.close();
		tempInputStream2.close();

		out.clearBuffer();
		response.reset();
		
		response.setContentType("text/plain; charset=euc-kr");
		out.print(sb2.toString());
	}else{
		out.print(sb.toString());
	}
}


catch (MalformedURLException | IOException | ProtocolException | SSLHandshakeException e){
	System.out.println(getPrintStackTrace(e));
}

%>