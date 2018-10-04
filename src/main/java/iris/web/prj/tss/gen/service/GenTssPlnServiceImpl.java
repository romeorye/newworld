package iris.web.prj.tss.gen.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import devonframe.util.NullUtil;
import iris.web.common.util.CommonUtil;
import iris.web.mailBatch.vo.ReplacementVo;
import iris.web.prj.grs.vo.GrsSendMailInfoVo;
import iris.web.prj.mm.mail.service.MmMailService;
/*********************************************************************************
 * NAME : GenTssServiceImpl.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

@Service("genTssPlnService")
public class GenTssPlnServiceImpl implements GenTssPlnService {

    static final Logger LOGGER = LogManager.getLogger(GenTssPlnServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;


    @Resource(name="mmMailService")
    private MmMailService mmMailService;			// MmMail 서비스


    @Resource(name="mailSenderFactory")
    private MailSenderFactory mailSenderFactory;


    //마스터
    @Override
    public Map<String, Object> retrieveGenTssPlnMst(HashMap<String, String> input) {
        return commonDao.select("prj.tss.com.retrieveTssMst", input);
    }

    @Override
    public Map<String, Object> retrieveDupChkWbsCd(HashMap<String, Object> input) {
        return commonDao.select("prj.tss.gen.pln.retrieveDupChkWbsCd", input);
    }

    @Override
    public Map<String, Object> retrieveDupChkPkWbsCd(HashMap<String, Object> input) {
        return commonDao.select("prj.tss.gen.pln.retrieveDupChkPkWbsCd", input);
    }

    @Override
    public int updateGenTssMstWbsCd(HashMap<String, Object> mstDs) {
        return commonDao.update("prj.tss.com.updateTssMstWbsCd", mstDs);
    }

    @Override
    public int insertGenTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs) {
        int mstCnt = commonDao.insert("prj.tss.com.insertTssMst", mstDs);

    	if(mstCnt > 0) {
            smryDs.put("tssCd", mstDs.get("tssCd"));
            commonDao.insert("prj.tss.gen.pln.insertGenTssPlnSmry", smryDs); //개요 생성

            //과제 제안서
            Calendar cal = Calendar.getInstance();
            int mm   = cal.get(Calendar.MONTH) + 1;
           
            smryDs.put("goalY",       mstDs.get("tssStrtDd").toString().substring(0,4));
            smryDs.put("yldItmType", "01");
            smryDs.put("arslYymm",  mstDs.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
            commonDao.update("prj.tss.com.updateTssYld", smryDs);
            
            String pmisDt = CommonUtil.getMonthSearch_1( CommonUtil.replace(mstDs.get("tssFnhDd").toString(), "-", ""));

            //지적재산권 
            smryDs.put("goalY",       mstDs.get("tssFnhDd").toString().substring(0,4));
            smryDs.put("yldItmType", "05");
            smryDs.put("arslYymm",  CommonUtil.getFormattedDate(pmisDt, "-").substring(0, 7));
            commonDao.update("prj.tss.com.updateTssYld", smryDs);
            
            //중단 완료 보고서
            smryDs.put("goalY",       mstDs.get("tssFnhDd").toString().substring(0,4));
            smryDs.put("yldItmType", "03");
            smryDs.put("arslYymm",       mstDs.get("tssFnhDd").toString().substring(0,7));
            commonDao.update("prj.tss.com.updateTssYld", smryDs);
        }

        return 1;
    }

    @Override
    public int updateGenTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd) {
        commonDao.update("prj.tss.com.updateTssMst", mstDs);
        commonDao.update("prj.tss.gen.pln.updateGenTssPlnSmry", smryDs);

      //과제 제안서
        Calendar cal = Calendar.getInstance();
        int mm   = cal.get(Calendar.MONTH) + 1;
       
        smryDs.put("goalY",       mstDs.get("tssStrtDd").toString().substring(0,4));
        smryDs.put("yldItmType", "01");
        smryDs.put("arslYymm",  mstDs.get("tssStrtDd").toString().substring(0,4) + "-" + CommonUtil.getZeroAddition(String.valueOf(mm), 2));
        
        commonDao.update("prj.tss.com.updateTssYld", smryDs);
        
        String pmisDt = CommonUtil.getMonthSearch_1( CommonUtil.replace(mstDs.get("tssFnhDd").toString(), "-", ""));

        //지적재산권 
        smryDs.put("goalY",       mstDs.get("tssFnhDd").toString().substring(0,4));
        smryDs.put("yldItmType", "05");
        smryDs.put("arslYymm",  CommonUtil.getFormattedDate(pmisDt, "-").substring(0, 7));
        commonDao.update("prj.tss.com.updateTssYld", smryDs);
        
        
        //중단 완료 보고서
        smryDs.put("goalY",       mstDs.get("tssFnhDd").toString().substring(0,4));
        smryDs.put("yldItmType", "03");
        smryDs.put("arslYymm",       mstDs.get("tssFnhDd").toString().substring(0,7));
        commonDao.update("prj.tss.com.updateTssYld", smryDs);
        
        return 1;
    }

    @Override
    public int updateGenTssPlnMst(HashMap<String, Object> mstDs) {
        commonDao.update("prj.tss.com.updateTssMst", mstDs);

        return 1;
    }

    @Override
    public void deleteGenTssPlnMst(HashMap<String, String> input) {
        commonDao.update("prj.tss.gen.pln.deleteGenTssPlnMst1", input);
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst2", input);
        commonDao.delete("prj.tss.gen.pln.deleteGenTssPlnMst3", input);
    }



    //개요
    @Override
    public Map<String, Object> retrieveGenTssPlnSmry(HashMap<String, String> input) {
        return commonDao.select("prj.tss.gen.retrieveGenTssSmry", input);
    }

    @Override
    public int insertGenTssPlnSmry(HashMap<String, Object> input) {
        return commonDao.insert("prj.tss.gen.pln.insertGenTssPlnSmry", input);
    }

    @Override
    public int updateGenTssPlnSmry(HashMap<String, Object> input) {
        return commonDao.update("prj.tss.gen.pln.updateGenTssPlnSmry", input);
    }



    //참여연구원
    @Override
    public List<Map<String, Object>> retrieveGenTssPlnPtcRsstMbr(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssPtcRsstMbr", input);
    }

    @Override
    public int updateGenTssPlnPtcRsstMbr(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssPtcRsstMbr", input);
    }

    @Override
    public int deleteGenTssPlnPtcRsstMbr(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssPtcRsstMbr", input);
    }



    //WBS
    @Override
    public List<Map<String, Object>> retrieveGenTssPlnWBS(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.pln.retrieveGenTssPlnWBS", input);
    }

    @Override
    public int updateGenTssPlnWBS(List<Map<String, Object>> ds) {
        String wbsSn = "";
        String maxWbsSn = null;
        Map<String, Object> snMap;
        HashMap<String, Object> dsMap;
        int rtVal = 0;

        for(int i = 0; i < ds.size(); i++) {
            dsMap = (HashMap<String, Object>)ds.get(i);
            wbsSn = (String)dsMap.get("wbsSn");

            //삭제
            if("3".equals(dsMap.get("duistate"))) {
                commonDao.delete("prj.tss.gen.deleteGenTssWBS", dsMap);
            }
            else {
                //신규 wbsSn값이면 max 추출
                if("r".equals(wbsSn.substring(0, 1))) {

                    snMap = commonDao.select("prj.tss.gen.retrieveGenTssWBSMaxSn", dsMap);
                    maxWbsSn = String.valueOf(snMap.get("maxWbsSn"));

                    dsMap.put("wbsSn", maxWbsSn);

                    //하위 depth의 값 변경
                    for(int j = 0; j < ds.size(); j++) {
                        if(wbsSn.equals(ds.get(j).get("pidSn"))) {
                            ds.get(j).put("pidSn", maxWbsSn);
                        }
                    }
                }

                rtVal = commonDao.update("prj.tss.gen.updateGenTssWBS", dsMap);
            }
        }

        return rtVal;
    }

    @Override
    public int deleteGenTssPlnWBS(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.gen.deleteGenTssWBS", input);
    }




    //투입예산
    @Override
    public List<Map<String, Object>> retrieveGenTssPlnTrwiBudg(HashMap<String, String> input) {

        String choiceYm = input.get("choiceYm");
        String tssYy = "";

        String pivotTitle = "[";
        String pivotSum = "ISNULL([";
        String unionTitle = "ROUND([";
        String unionSum = "ROUND(SUM([";

        if("yy".equals(choiceYm)) {
            HashMap<String, String> purYyInput = new HashMap<String, String> ();
            if(input.get("pgsStepCd") != null && "AL".equals(String.valueOf(input.get("pgsStepCd")))) {
                purYyInput.put("tssCd", input.get("alTssCd"));
            }
            else {
                purYyInput.put("tssCd", input.get("tssCd"));
            }
            List<Map<String, Object>> rtList = commonDao.selectList("prj.tss.com.retrieveTssTssYy", purYyInput);

            for(int i = 0; i < rtList.size(); i++) {
                tssYy = (String)rtList.get(i).get("tssYy");

                pivotTitle += tssYy + "],[";
                pivotSum   += tssYy + "],0)+ISNULL([";
                unionTitle += tssYy + "],2) AS '" + tssYy + "',ROUND([";
                unionSum   += tssYy + "]),2),ROUND(SUM([";
            }
        }
        else if("mm".equals(choiceYm)) {
            tssYy = input.get("tssYy");
            String mm = "";

            for(int i = 1; i <= 12; i++) {
                if(i < 10) {
                    mm = "0" + String.valueOf(i);
                } else {
                    mm = String.valueOf(i);
                }

                pivotTitle += tssYy + mm + "],[";
                pivotSum   += tssYy + mm + "],0)+ISNULL([";
                unionTitle += tssYy + mm + "],2) AS '" + mm + "',ROUND([";
                unionSum   += tssYy + mm + "]),2),ROUND(SUM([";
            }

        }

        pivotTitle = pivotTitle.substring(0, pivotTitle.length() - 2);
        pivotSum   = pivotSum.substring(0, pivotSum.length() - 9);
        unionTitle = unionTitle.substring(0, unionTitle.length() - 8);
        unionSum   = unionSum.substring(0, unionSum.length() - 12);

        input.put("pivotTitle", pivotTitle);
        input.put("pivotSum",   pivotSum);
        input.put("unionTitle", unionTitle);
        input.put("unionSum",   unionSum);

        return commonDao.selectList("prj.tss.gen.pln.retrieveGenTssPlnTrwiBudg", input);
    }

    @Override
    public Map<String, Object> getGenTssPlnTrwiBudgInfo(HashMap<String, Object> input) {
        return commonDao.select("prj.tss.gen.pln.getGenTssPlnTrwiBudgInfo", input);
    }

    @Override
    public int insertGenTssPlnTrwiBudg(HashMap<String, Object> input) {

        HashMap<String, Object> rtMap = commonDao.select("prj.tss.gen.pln.insertGenTssPlnTrwiBudg", input);

        //        if("S".equals(rtMap.get("rtVal"))) {
        //            rtMap = ;
        //        }



        return rtMap.size();
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssPlnTrwiBudgMst(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.gen.pln.retrieveGenTssPlnTrwiBudgMst", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssPlnTssYy(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssTssYy", input);
    }

    @Override
    public int updateGenTssPlnTrwiBudgMst(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.gen.pln.updateGenTssPlnTrwiBudgMst", input);
    }

    @Override
    public int deleteGenTssPlnTrwiBudgMst(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.gen.pln.deleteGenTssPlnTrwiBudgMst", input);
    }



    //목표 및 산출물
    @Override
    public List<Map<String, Object>> retrieveGenTssPlnGoal(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssGoal", input);
    }

    @Override
    public int updateGenTssPlnGoal(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssGoal", input);
    }

    @Override
    public int deleteGenTssPlnGoal(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssGoal", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGenTssPlnYld(HashMap<String, String> input) {
        return commonDao.selectList("prj.tss.com.retrieveTssYld", input);
    }

    @Override
    public int updateGenTssPlnYld(List<Map<String, Object>> input) {
        return commonDao.batchUpdate("prj.tss.com.updateTssYld", input);
    }

    @Override
    public int deleteGenTssPlnYld(List<Map<String, Object>> input) {
        return commonDao.batchDelete("prj.tss.com.deleteTssYld", input);
    }



    //품의서
    @Override
    public List<Map<String, Object>> retrieveGenTssPlnBudgGroupYy(HashMap<String, String> input, List<Map<String, Object>> resultTssYy) {
        String tssYy = "";

        String pivotTitle = "[";
        String pivotSum = "ISNULL([";
        String unionTitle = "ROUND([";
        String unionSum = "ROUND(SUM([";

        for(int i = 0; i < resultTssYy.size(); i++) {
            tssYy = (String)resultTssYy.get(i).get("tssYy");

            pivotTitle += tssYy + "],[";
            pivotSum   += tssYy + "],0)+ISNULL([";
            unionTitle += tssYy + "],2) AS '" + tssYy + "',ROUND([";
            unionSum   += tssYy + "]),2),ROUND(SUM([";
        }

        pivotTitle = pivotTitle.substring(0, pivotTitle.length() - 2);
        pivotSum   = pivotSum.substring(0, pivotSum.length() - 9);
        unionTitle = unionTitle.substring(0, unionTitle.length() - 8);
        unionSum   = unionSum.substring(0, unionSum.length() - 12);

        input.put("pivotTitle", pivotTitle);
        input.put("pivotSum",   pivotSum);
        input.put("unionTitle", unionTitle);
        input.put("unionSum",   unionSum);

        return commonDao.selectList("prj.tss.gen.pln.retrieveGenTssPlnBudgGroupYy", input);
    }

    @Override
    public int insertGenTssPlnCsusRq(Map<String, Object> input) {
        //        //과제 상태 변경
        //        this.updateGenTssPlnMstTssSt(input);
        commonDao.insert("prj.tss.com.insertTssCsusRq", input);

        return 0;
    }

    @Override
    public int updateGenTssPlnMstTssSt(Map<String, Object> map) {

        return  commonDao.update("prj.tss.com.updateTssMstTssSt", map);
    }
    //메일발송
    @Override
    public List<Map<String, Object>>  retrieveSendAddrTssGrsPL(HashMap<String, Object> input) {

        return  commonDao.selectList("prj.tss.com.retrieveSendAddrTssGrsPL", input);
    }

    @Override
    public void retrieveSendMail(HashMap<String, Object> input) {

    	MailSender mailSender = mailSenderFactory.createMailSender();
        
    	GrsSendMailInfoVo grsInfoVo = new GrsSendMailInfoVo();
        Map<String, Object>  recMailInfo =  commonDao.select("prj.grs.retrieveGrsMailInfo", input);
       
        String tssPgsNm ="";
        
        if("P1".equals(recMailInfo.get("grsCd").toString().trim())){
            tssPgsNm = "계획";
        }else if("P2".equals(recMailInfo.get("grsCd").toString().trim())){
            tssPgsNm = "완료";
        }else if("D".equals(recMailInfo.get("grsCd").toString().trim())){
            tssPgsNm = "중단";
        }else if("M".equals(recMailInfo.get("grsCd").toString().trim())){
            tssPgsNm = "변경";
        }
        
        mailSender.setFromMailAddress("iris@lghausys.com" ,"관리자");
        mailSender.setToMailAddress((String)recMailInfo.get("saMail"));
        mailSender.setSubject(tssPgsNm+"품의 진행안내");
        grsInfoVo.setGrsStCd(recMailInfo.get("grsCd").toString());
        grsInfoVo.setGrsStNm(recMailInfo.get("grsNm").toString());
        grsInfoVo.setTssPgsNm(tssPgsNm);
       
        mailSender.setHtmlTemplate("mailBatchGrshtml", grsInfoVo);
        
        mailSender.send();
        
        HashMap<String, Object> mailMap = new HashMap<String, Object>();
        mailMap.put("mailTitl", tssPgsNm+"품의 진행안내");
        mailMap.put("adreMail", recMailInfo.get("saMail") );
        mailMap.put("trrMail", "iris@lghausys.com");
        mailMap.put("_userId", input.get("userId").toString());

        commonDao.insert("open.mchnEduAnl.insertMailHis", mailMap);
    }
    
    /**
     * 메일 발송
     * @param input
     * @param vmParm
     * @return
     */
    private boolean mailSend(HashMap<String, Object> input, ReplacementVo replacementVo) {
        boolean rst = false;
        try {
            MailSender mailSender = mailSenderFactory.createMailSender();


            mailSender.setFromMailAddress(NullUtil.nvl(input.get("sendMailAdd").toString(),""), NullUtil.nvl(input.get("sendMailName"),""));
            mailSender.setToMailAddress(NullUtil.nvl(input.get("receMailAdd"),""));
            mailSender.setCcMailAddress(NullUtil.nvl(input.get("ccReceMailAdd"),""));
            mailSender.setSubject(NullUtil.nvl(input.get("title"),""));
            mailSender.setHtmlTemplate(NullUtil.nvl(input.get("mailTemplateName"),""), replacementVo );

            mailSender.send();
            // 메일발송정보리스트
            List<HashMap<String, Object>> sndMailList = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> mailMap = new HashMap<String, Object>();
            mailMap.put("mailTitl", NullUtil.nvl(input.get("title").toString(),""));
            mailMap.put("adreMail", NullUtil.nvl(input.get("receMailAdd"),"") );
            mailMap.put("rfpMail", NullUtil.nvl(input.get("ccReceMailAdd"),"") );

            mailMap.put("trrMail", NullUtil.nvl(input.get("sendMailAdd"),""));
            mailMap.put("_userId", input.get("userId").toString());
            sndMailList.add(mailMap);
            mmMailService.insertMailSndHis(sndMailList);

            rst = true;
        } catch (Exception e) {
            rst = false;
            e.printStackTrace();
        }

        return rst;

    }

    
}