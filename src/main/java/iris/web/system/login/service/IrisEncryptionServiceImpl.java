/*------------------------------------------------------------------------------
 * NAME : EncryptionBiz.java
 * DESC : 
 * VER  : V1.0
 * PROJ : LG CNS 창호완성창시스템 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010/03/30  kcw                  
 *------------------------------------------------------------------------------*/
package iris.web.system.login.service;

import java.security.MessageDigest;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;

import sun.misc.BASE64Encoder;


@Service("irisEncryptionService")
public class IrisEncryptionServiceImpl  implements IrisEncryptionService {
    
    static MessageDigest md = null;
    static BASE64Encoder encoder = new BASE64Encoder();

    public String getMDBase64Password(String unEncryptedPassword) throws Exception{
        String encryptedPassword = null;
        try {
            
            if(md != null) {md = null;}
            //if (md ==null) {
                md = MessageDigest.getInstance("MD5");
            //}
                
            // ��� ���
            md.reset();
            md.update(unEncryptedPassword.getBytes());
            
            byte[] raw = md.digest();
            
            // base64�� ���� ���� DB�����
            encryptedPassword = encoder.encode(raw);
            
              //<------------------------------------------------------
        } catch (Exception se){
            encryptedPassword = "error";
            return encryptedPassword; 
        }
        return encryptedPassword;     
    }
    

    public boolean isMatchingMDBase64Password(String encryptedPassword, String unEncryptedPassword)  throws Exception{
        String comparedPassword = null;
        try {
            if(md != null) {
                md = null;
            }
            
            //if (md==null) 
                md = MessageDigest.getInstance("MD5");
            
            // ��� ���
            md.reset();
            md.update(unEncryptedPassword.getBytes());
            
            byte[] raw = md.digest();
            
            // base64�� ���� ���� DB�����
            System.out.println("isMatchingMDBase64Password Start");
            comparedPassword = encoder.encode(raw);
            System.out.println("isMatchingMDBase64Password End");
            //<------------------------------------------------------
                

        } catch (Exception se){
          throw new Exception("woasis.err.com.isMtPwd", se);
        }
System.out.println("====================EncryptionBiz.isMatchingMDBase64Password=================");       
System.out.println("encryptedPassword------->" + encryptedPassword );        
System.out.println("comparedPassword-------->" + comparedPassword );  
System.out.println("encryptedPassword hashcode------->" + encryptedPassword.hashCode() ); 
System.out.println("comparedPassword hashcode-------->" + comparedPassword.hashCode() );  
System.out.println("return ------>" + encryptedPassword.equals(comparedPassword));
System.out.println("====================EncryptionBiz.isMatchingMDBase64Password=================");   

        return encryptedPassword.equals(comparedPassword);
    }
    
    /*
     * 암호화방식 추가 SHA-512
     */
    public String getSHA512Password(String unEncryptedPassword)  throws Exception
    {
        String encryptedPassword = "";
        try {
            if (md != null){ md = null;}
            md= MessageDigest.getInstance("SHA-512");
     
            md.update(unEncryptedPassword.getBytes());
            byte[] mb = md.digest();
            for (int i = 0; i < mb.length; i++) {
                byte temp = mb[i];
                String s = Integer.toHexString(new Byte(temp));
                while (s.length() < 2) {
                    s = "0" + s;
                }
                s = s.substring(s.length() - 2);
                encryptedPassword += s;
            }
            
        } catch (Exception se){
            throw new Exception("woasis.err.com.getMdPwd", se);
        }
        return encryptedPassword;
    }
    
    /*
     * 암호화방식 추가 SHA-512
     */
    public boolean isMatchingSHA512Password(String encryptedPassword, String unEncryptedPassword)  throws Exception{
        String comparedPassword = "";
        try {
            if (md != null){ md = null;}
            md= MessageDigest.getInstance("SHA-512");
     
            md.update(unEncryptedPassword.getBytes());
            byte[] mb = md.digest();
            for (int i = 0; i < mb.length; i++) {
                byte temp = mb[i];
                String s = Integer.toHexString(new Byte(temp));
                while (s.length() < 2) {
                    s = "0" + s;
                }
                s = s.substring(s.length() - 2);
                comparedPassword += s;
            }
        } catch (Exception se){
          throw new Exception("woasis.err.com.isMtPwd", se);
        }
        return encryptedPassword.equals(comparedPassword);
    }
    


    /*
     * AES-128 암호화
     */
    public String encryptAES(String s, String key) throws Exception {
        String encrypted = null;
        try {
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), "AES");
             
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
             
            encrypted = byteArrayToHex(cipher.doFinal(s.getBytes()));
            return encrypted;
        } catch (Exception se) {
            throw new Exception("woasis.err.com.getMdPwd", se);
        }
    }
     

    /*
     * AES-128 복호화
     */
    public String decryptAES(String s, String key) throws Exception {
        String decrypted = null;
        try {
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), "AES");
             
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec);
            decrypted = new String(cipher.doFinal(hexToByteArray(s)));
            return decrypted;
        } catch (Exception se) {
            throw new Exception("woasis.err.com.getMdPwd", se);
        }
    }
    
    public byte[] hexToByteArray(String s) {
        byte[] retValue = null;
        if (s != null && s.length() != 0) {
            retValue = new byte[s.length() / 2];
            for (int i = 0; i < retValue.length; i++) {
                retValue[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);
            }
        }
        return retValue;
    }
     
    public String byteArrayToHex(byte buf[]) {
        StringBuffer strbuf = new StringBuffer(buf.length * 2);
        for (int i = 0; i < buf.length; i++) {
            if (((int) buf[i] & 0xff) < 0x10) {
                strbuf.append("0");
            }
            strbuf.append(Long.toString((int) buf[i] & 0xff, 16));
        }
         
        return strbuf.toString();
    }
    
    
    
}
