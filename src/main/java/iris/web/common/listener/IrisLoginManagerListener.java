package iris.web.common.listener;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;

import devonframe.dataaccess.CommonDao;

import iris.web.system.login.service.IrisLoginService;


public class IrisLoginManagerListener implements HttpSessionBindingListener{
    
    
    private static IrisLoginManagerListener loginManager=null;
    public static Hashtable<String, String> loginUsers = new Hashtable<String, String>();
    public static Hashtable<HttpSession,String> loginSession = new Hashtable<HttpSession,String>();
    
    static final Logger LOGGER = LogManager.getLogger(IrisLoginManagerListener.class);
    
	@Resource(name = "NwinsLoginService")
	public IrisLoginService loginService;
    
    private IrisLoginManagerListener(){
        super();
    }
    
    
    public static synchronized IrisLoginManagerListener getInstance(){
        if(loginManager==null){
            loginManager = new IrisLoginManagerListener();
        }
        return loginManager;
    }
    
    //해당 세션에 이미 로그인 되어 있는지 체크
    public boolean isLogin(String sessionID){
        boolean isLogin = false;
        Enumeration<String> e = loginUsers.keys();
        String key="";
        while(e.hasMoreElements()){
            key = (String)e.nextElement();
            if(sessionID.equals(key)){
                isLogin = true;
            }
        }
        return isLogin;
    }
    
    //중복 로그인 막기 위해 아이디 사용중인지 체크
    public boolean isUsing(String userID){
        LOGGER.debug("*********로그인 중복체크 시작*********");
        LOGGER.debug("**체크할 사용자코드: [" + userID + "]");
        boolean isUsing = false;
        Enumeration<String> e = loginUsers.keys();
        String key="";
        while(e.hasMoreElements()){
            key = (String)e.nextElement();
            //System.out.println("세션데이터: [" + loginUsers.get(key) + "]");
            if(userID.equals(loginUsers.get(key))){
                
                LOGGER.debug("*********로그인하려는 사용자 아이디가 세션에 존재함.*********");
                LOGGER.debug("존재하는 사용자 세션ID [" + key + "]");
                LOGGER.debug("존재하는 사용자 ID     [" + loginUsers.get(key) + "]");
                LOGGER.debug("*********로그인 중복체크 끝*********");
                
                isUsing = true;
            }
        }
        return isUsing;
    }
    
    /**
     * 중복사용자 강제 종료 
     * @param userID
     */
    //public void removeSessionDupUser(String userID){
    public void removeSession(String userID){
        LOGGER.debug("중복 사용자 강제 종료 시작");
        LOGGER.debug("제거될 사용자ID:[" + userID+"]");
        Enumeration e = loginSession.keys();
        HttpSession session = null;
        
        try{
            while(e.hasMoreElements()){
                session = (HttpSession)e.nextElement();
                //System.out.println("UsrID: [" +loginSession.get(session) +"]");
                if(loginSession.get(session).equals(userID)){
                    LOGGER.debug("제거될 사용자 존재함.");
                    LOGGER.debug("제거될 사용자 ID: " + loginSession.get(session));
                    
                    Enumeration e1 = loginUsers.keys();
                    while(e1.hasMoreElements()){
                        String key = (String)e1.nextElement();
                        if(loginUsers.get(key).equals(userID)){
                            LOGGER.debug("제거될 세션ID: [" + key + "]");
                            
                            try{
                                LOGGER.debug("------중복사용자 세션 제거 프로세스1 : loginUsers 메모리 제거 시작----");
                                loginUsers.remove(key);
                                LOGGER.debug("중복사용자 loginUsers 메모리 제거 성공종료");
                            }catch(Exception ex1){
                                ex1.printStackTrace();
                            }
                        }
                    }
                    
                    try{
                        LOGGER.debug("------중복사용자 세션 제거 프로세스2 : loginSession 메모리 제거 시작----");
                        loginSession.remove(session);
                        LOGGER.debug("중복사용자 loginSession 메모리 제거 성공종료");
                    }catch(Exception ex2){
                        ex2.printStackTrace();
                    }
                    try{
                        LOGGER.debug("------중복사용자 세션 제거 프로세스3 : invalidate 제거 시작----");
                        session.invalidate();
                        LOGGER.debug("중복사용자 세션 invalidate 제거 성공종료");
                    }catch(java.lang.IllegalStateException ex3){
                    }catch(Exception ex4){
                        ex4.printStackTrace();
                    }
                    LOGGER.debug("사용자 ["+userID+"]가 강제종료되었습니다." );
                }
            }
            LOGGER.debug("중복 사용자 강제 종료 끝");
        }catch(Exception ex){
            //ex.printStackTrace();
        }
    }
    
    /**
     * 비중복 사용자 로그아웃 : 중복사용자 로그아웃과 프로세스는 동일  
     * @param userID
     */
    /*
    public void removeSession(String userID){
        LOGGER.debug("로그아웃할 사용자ID:[" + userID+"]");
        Enumeration e = loginSession.keys();
        HttpSession session = null;
        
        try{
            while(e.hasMoreElements()){
                session = (HttpSession)e.nextElement();
                //System.out.println("UsrID: [" +loginSession.get(session) +"]");
                if(loginSession.get(session).equals(userID)){
                    LOGGER.debug("제거될 사용자 ID: " + loginSession.get(session));
                    
                    Enumeration e1 = loginUsers.keys();
                    while(e1.hasMoreElements()){
                        String key = (String)e1.nextElement();
                        if(loginUsers.get(key).equals(userID)){
                            LOGGER.debug("제거될 세션ID: [" + key + "]");
                            /* 개발자 1인당 아이디 부여후 주석 해제
                            try{
                                LOGGER.debug("-----세션 제거 프로세스1 : loginUsers 메모리 제거 시작----");
                                loginUsers.remove(key);
                                LOGGER.debug("loginUsers 메모리 제거 성공종료");
                            }catch(Exception ex1){
                                ex1.printStackTrace();
                            }
                            // 개발자 1인당 아이디 부여후 주석 해제 끝.
                        }
                    }
                    try{
                        LOGGER.debug("-----세션 제거 프로세스2 : loginSession 메모리 제거 시작----");
                        loginSession.remove(session);
                        LOGGER.debug("loginSession 메모리 제거 성공종료");
                    }catch(Exception ex2){
                        ex2.printStackTrace();
                    }
                    try{
                        LOGGER.debug("-----세션 제거 프로세스3 : 세션 invalidate 시작----");
                        session.invalidate();
                        LOGGER.debug("세션 invalidate 성공종료");
                    }catch(java.lang.IllegalStateException ex3){
                    }catch(Exception ex4){
                        ex4.printStackTrace();
                    }
                    LOGGER.debug("사용자 ["+userID+"]이 성공적으로 로그아웃되었습니다." );
                }
            }
            LOGGER.debug("로그아웃 끝");
            //System.out.println(loginUsers.keys());
        }catch(Exception ex){
            //ex.printStackTrace();
        }
    }
    */
    public void valueBound(HttpSessionBindingEvent event){   
        HttpSession session = event.getSession();
        //LData lsession = (LData)session.getAttribute("woasisSession");
        HashMap lsession = (HashMap)session.getAttribute("woasisSession");
        LOGGER.debug("*********로그인    :: "+lsession.get("userId").toString()+"*********");
        LOGGER.debug("*********현재접속자:: " + getUserCount() +"*********");
    }
    
    public void valueUnbound(HttpSessionBindingEvent event){
        loginUsers.remove(event.getSession().getId());
        loginSession.remove(event.getSession());
    }
    
    public int getUserCount(){
        return loginUsers.size();
    }
    
    //중복 로그인 막기 위해 아이디 사용중인지 체크
    /*
     * return 1 : 대리점코드 사용중
     * return 2 : 대리점코드와 아이디 사용중
     * return 0 : 이상없음
     */
    //public LMultiData isUsingCheck(String agenCd, String userID){
    public ArrayList isUsingCheck(String agenCd, String userID, String loginGubun){

        
        //LMultiData resultList = new LMultiData();
    	ArrayList resultList = new ArrayList();
    	//HashMap resultList = new HashMap();
        
        Enumeration e = loginSession.keys();
        
        HttpSession session = null;
        String key = agenCd+":"+userID+":"+loginGubun;
        
        while(e.hasMoreElements()){
            //LData result = new LData();
        	HashMap result = new HashMap();
            session = (HttpSession)e.nextElement();
//            System.out.println("#####UsrID: [" +loginSession.get(session) +"]");
//            System.out.println("#####ID: [" +session.getId() +"]");
//            System.out.println("#####세션데이터: [" + loginUsers.get(key) + "]");
            if(loginSession.get(session).equals(key)){
                /*
            	result.setString("agenCd", agenCd);
                result.setString("userID", userID);
                result.setString("UseSession", session.getId());
                */
            	result.put("agenCd", agenCd);
                result.put("userID", userID);
                result.put("loginGubun", loginGubun);
                result.put("UseSession", session.getId());            	
                //System.out.println("제거해야할 세션 : "+session.getId());
                //session.invalidate();
                
                //resultList.addLData(result);
                resultList.add(result);
            }            
            
        }
        
        return resultList;
    }
    
    /**
     * 중복사용자 강제 종료 
     * @param userID
     */
    //public void removeSessionDupUser(String userID){
    public void removeSession(String agenCd, String userID){
        LOGGER.debug("중복 사용자 강제 종료 시작");
        LOGGER.debug("제거될 사용자ID:[" + agenCd+":"+userID + "]");
        Enumeration e = loginSession.keys();
        HttpSession session = null;
        String loginUser = agenCd+":"+userID;
        
        try{
            while(e.hasMoreElements()){
                session = (HttpSession)e.nextElement();
                //System.out.println("UsrID: [" +loginSession.get(session) +"]");
                if(loginSession.get(session).equals(loginUser)){
                    LOGGER.debug("제거될 사용자 존재함.");
                    LOGGER.debug("제거될 사용자 ID: " + loginSession.get(session));
                    
                    Enumeration e1 = loginUsers.keys();
                    while(e1.hasMoreElements()){
                        String key = (String)e1.nextElement();
                        if(loginUsers.get(key).equals(loginUser)){
                            LOGGER.debug("제거될 세션ID: [" + key + "]");
                            try{
                                LOGGER.debug("------중복사용자 세션 제거 프로세스1 : loginUsers 메모리 제거 시작----");
                                loginUsers.remove(key);
                                LOGGER.debug("중복사용자 loginUsers 메모리 제거 성공종료");
                            }catch(Exception ex1){
                                ex1.printStackTrace();
                            }
                        }
                    }
                    
                    try{
                        LOGGER.debug("------중복사용자 세션 제거 프로세스2 : loginSession 메모리 제거 시작----");
                        loginSession.remove(session);
                        LOGGER.debug("중복사용자 loginSession 메모리 제거 성공종료");
                    }catch(Exception ex2){
                        ex2.printStackTrace();
                    }
                    try{
                        LOGGER.debug("------중복사용자 세션 제거 프로세스3 : invalidate 제거 시작----");
                        session.invalidate();
                        LOGGER.debug("중복사용자 세션 invalidate 제거 성공종료");
                    }catch(java.lang.IllegalStateException ex3){
                    }catch(Exception ex4){
                        ex4.printStackTrace();
                    }
                    LOGGER.debug("사용자 ["+loginUser+"]가 강제종료되었습니다." );
                }
            }
            LOGGER.debug("중복 사용자 강제 종료 끝");
        }catch(Exception ex){
            //ex.printStackTrace();
        }
    }
    
    public void removeSessionID(String agenCd, String userID, String sessionId, String userIP, String loginGubun){
        LOGGER.debug("*********로그인 중복 Session 체크 시작*********");
        LOGGER.debug("**제거할 세션 ID: [" + sessionId + "]");
        
        //LoginBiz loginBiz = new LoginBiz();
        
        Enumeration e = loginSession.keys();
        
        HttpSession session = null;
        String loginUser = agenCd+":"+userID+":"+loginGubun;
        
        try{
            while(e.hasMoreElements()){

                session = (HttpSession)e.nextElement();

                //System.out.println("loginSession 비교 >> "+loginSession.get(session).substring(1)+":"+loginUser);
                if(loginSession.get(session).substring(1).equals(loginUser)){
                    Enumeration e1 = loginUsers.keys();
                    while(e1.hasMoreElements()){
                        String key = (String)e1.nextElement();
                        //System.out.println("loginUsers 비교 >> "+loginUsers.get(key).substring(1)+":"+loginUser);
                        if(loginUsers.get(key).substring(1).equals(loginUser)&&session.getId().equals(sessionId)){
                            LOGGER.debug("제거될 세션ID: [" + key + "]");
                            try{
                                LOGGER.debug("------loginUsers 세션 제거 ---- : "+sessionId);
                                loginUsers.remove(key);
                                /*
                                LData input = new LData();
                                input.setString("agenCd", agenCd);
                                input.setString("userID", userID);
                                input.setString("sessionId", sessionId);
                                input.setString("userIP", userIP); 
                                */
                                HashMap input = new HashMap();
                                input.put("agenCd", agenCd);
                                input.put("userID", userID);
                                input.put("sessionId", sessionId);
                                input.put("loginGubun", loginGubun);
                                input.put("userIP", userIP);
                                
                                LOGGER.debug("################################");
                                LOGGER.debug("agenCd => " + agenCd);
                                LOGGER.debug("userID => " + userID);
                                LOGGER.debug("loginGubun => " + loginGubun);
                                LOGGER.debug("sessionId => " + sessionId);
                                LOGGER.debug("userIP => " + userIP);
                                LOGGER.debug("################################");
                                //if(loginBiz.sessionLog(input)>0){
                                
                                //int logCnt = loginService.sessionLog(input);
                                //if(logCnt>0){
                                /* 아래부분 처리불가, 호출하는 곳에서 처리필요
                                if(loginService.sessionLog(input)>0){
                                    LOGGER.debug("------loginUsers 세션 제거 로그 기록 완료----");
                                }
                                */
                                
                                LOGGER.debug("------loginUsers 세션 제거 완료----");
                            }catch(Exception ex1){
                                ex1.printStackTrace();
                            }
                            try{
                                LOGGER.debug("------loginSession 세션 제거 ----");
                                loginSession.remove(session);
                                LOGGER.debug("------loginSession 세션 제거 완료----");
                            }catch(Exception ex2){
                                ex2.printStackTrace();
                            }
                            try{
                                LOGGER.debug("------invalidate 제거 ----");
                                session.invalidate();
                                LOGGER.debug("------invalidate 제거 완료----");
                            }catch(Exception ex3){
                                LOGGER.debug("------이미 만료된 세션 ("+sessionId+")----");
                            }
                       }
                    }
                }
            }
        }catch(Exception ex){
            //ex.printStackTrace();
        }
    }
    
    public static void removeSessionID(String sessionId){
        LOGGER.debug("*********TimeOut 된 세션 제거*********");
        LOGGER.debug("**제거할 세션 ID: [" + sessionId + "]");
        
        //LoginBiz loginBiz = new LoginBiz();
        
        Enumeration e = loginSession.keys();
        
        HttpSession session = null;

        try{
            while(e.hasMoreElements()){

                session = (HttpSession)e.nextElement();

                Enumeration e1 = loginUsers.keys();
                while(e1.hasMoreElements()){
                    String key = (String)e1.nextElement();
                    if(session.getId().equals(sessionId)){
                        LOGGER.debug("@@@@@ 제거될 세션ID: [" + key + "]");
                        try{
                            LOGGER.debug("------loginUsers 세션 제거 -----"+sessionId);
                            loginUsers.remove(key);
                            LOGGER.debug("------loginUsers 세션 제거 완료 ----");
                            
                        }catch(Exception ex1){
                            ex1.printStackTrace();
                        }
                        try{
                            LOGGER.debug("------loginSession 세션 제거 -----");
                            loginSession.remove(session);
                            LOGGER.debug("------loginSession 세션 제거 완료 -----");
                        }catch(Exception ex2){
                            ex2.printStackTrace();
                        }
                   }
                }
            }
        }catch(Exception ex){
            //ex.printStackTrace();
        }
    }
    
}