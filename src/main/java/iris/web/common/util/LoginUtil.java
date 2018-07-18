package iris.web.common.util;


public class LoginUtil extends CommonUtil{

    private String spCharArray[] = {"!","@","#","$","%","^","&","*","?","_","~"};  //특수문자 배열
    private String charArray[] = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
            "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}; //허용문자 배열
    private String numArray[] = {"1","2","3","4","5","6","7","8","9","0"};  //허용숫자 배열

    /**
     * input param : id, pwd
     * id와 pwd를 입력받아 동일한 값이면 false, 아니면 true를 리턴
     * 패스워드 변경시 아이디와 동일한 패스워드를 지정했는지 채크 할때 사용
     * 사용예) matchProbability("master", "12345")
     * 결과)  true
     */
    public boolean matchProbability(String id, String pwd) {
        
        boolean result = true;
        
        id = nullToString(id);
        pwd = nullToString(pwd);

        if (pwd.contains(id)){
            result = false;
        }else{
            result = true;
        }
        return result;
    }
    
    /**
     * input param : pwd
     * pwd를 입력받아 문자, 숫자, 특수문자를 모두 포함하고 있으면 true, 아니면 false
     * 사용예) checkPassword("12345")
     * 결과)  false
     */
    public boolean checkPassword(String pwd){
        
        boolean result = false;
        
        int spCharCnt = 0; //특수문자개수
        int charCnt = 0; //문자개수
        int numCnt = 0; //숫자개수
        
        int checkValue = 0;
        
        //특수문자 채크
        for(int i=0; i<spCharArray.length; i++){
            if(pwd.contains(spCharArray[i])) spCharCnt++;
        }
        
        //문자 채크
        for(int i=0; i<charArray.length; i++){
            if(pwd.contains(charArray[i])) charCnt++;
        }
        
        //숫자 채크
        for(int i=0; i<numArray.length; i++){
            if(pwd.contains(numArray[i])) numCnt++;
        }
        
        checkValue = spCharCnt * charCnt * numCnt;
        if(checkValue>0){
            result = true;
        }else{
            result = false;
        }
        
//        System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@ : "+pwd.contains(aa));
//        System.out.println("!!!!!!!!!!!!!!!!!!!!!!!!! : "+aa.compareTo(pwd.substring(0)));
        return result;
    }
    
    /**
     * input param : pwd
     * pwd를 입력받아 지정된 길이 pwLength(10자리) 이상이면 true, 아니면 false
     * 사용예) checkPasswordLength("12345", 10)
     * 결과)  false
     */
    public boolean checkPasswordLength(String pwd, int pwLength){
        
        boolean result = false;
        
        if(pwd.length()>=pwLength){
            result = true;
        }
        
        return result;
    }
    
    /**
     * input param : pwd
     * 사용예) checkContinuationPassword("12345")
     */
    public boolean[] checkContinuationPassword(String pwd){
        
        boolean result[] = {false,false};
        
        int contiueCnt  = 0; //문자 순차 or 역순 연속 개수
        int sameCharCnt = 0; //동일 문자 연속 개수
        
        char ch_pw0,ch_pw1,ch_pw2;
        
        //패스워드 전체를 체크
        for(int i=0; i<pwd.length(); i++){
            ch_pw0 = pwd.charAt(i);
            
            if(i<pwd.length()-2){
                ch_pw1 = pwd.charAt(i+1);
                ch_pw2 = pwd.charAt(i+2);
                
                if(ch_pw0==ch_pw1 && ch_pw0==ch_pw2){ //세자리 연속 같은 문자인 경우
                    sameCharCnt++;
                    //System.out.println("동일 문자 0:"+ch_pw0+", 1:"+ch_pw1+", 2:"+ch_pw2);
                }
                
                //문자열 순차 or 역순 연속 채크
                if(Character.toString(ch_pw2).codePointAt(0)-Character.toString(ch_pw1).codePointAt(0)==1 
                        && Character.toString(ch_pw1).codePointAt(0)-Character.toString(ch_pw0).codePointAt(0)==1) {
                    contiueCnt++;
                    //System.out.println("연속 채크 0:"+ch_pw0+", 1:"+ch_pw1+", 2:"+ch_pw2);
                }
                
            }
        }
        
        if(sameCharCnt==0){
            result[0] = true;
        }else{
            result[0] = false;
        }
        if(contiueCnt==0){
            result[1] = true;
        }else{
            result[1] = false;
        }
        
        return result;
    }
    
}