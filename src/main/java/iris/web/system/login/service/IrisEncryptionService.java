package iris.web.system.login.service;

import java.security.MessageDigest;

import sun.misc.BASE64Encoder;

public interface IrisEncryptionService {
    
    static MessageDigest md = null;
    static BASE64Encoder encoder = new BASE64Encoder();

    public String getMDBase64Password(String unEncryptedPassword) throws Exception;
    

    public boolean isMatchingMDBase64Password(String encryptedPassword, String unEncryptedPassword) throws Exception;
    
    /*
     * 암호화방식 추가 SHA-512
     */
    public String getSHA512Password(String unEncryptedPassword) throws Exception;
    
    /*
     * 암호화방식 추가 SHA-512
     */
    public boolean isMatchingSHA512Password(String encryptedPassword, String unEncryptedPassword) throws Exception;
    


    /*
     * AES-128 암호화
     */
    public String encryptAES(String s, String key) throws Exception;
     

    /*
     * AES-128 복호화
     */
    public String decryptAES(String s, String key) throws Exception;
    
    public byte[] hexToByteArray(String s);
     
    public String byteArrayToHex(byte buf[]);
    
    
    
}
