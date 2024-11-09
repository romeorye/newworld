/********************************************************************************
 * NAME : BatchController.java
 * DESC : 배치 수동 실행
 * PROJ : IRIS+
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2024.07.05 서성일                          최초생성
 *********************************************************************************/

package iris.web.batch.system.controller;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.batch.anl.AnlApprMailBatch;
import iris.web.batch.fxaInfo.FxaInfoIFBatch;
import iris.web.batch.fxaInfo.FxaTrsfIFBactch;
import iris.web.batch.fxaInfo.WbsPjtIFBatch;
import iris.web.batch.genTssStat.GenTssStatBatch;
import iris.web.batch.insa.InsaInfoBatch;
import iris.web.batch.insa.SsoDeptInfoBatch;
import iris.web.batch.insa.SsoUserInfoBatch;
import iris.web.batch.mail.MailBatchArsl;
import iris.web.batch.mail.MailBatchCmTss;
import iris.web.batch.mail.MailBatchGrs;
import iris.web.batch.mail.MailBatchGrsReq;
import iris.web.batch.mail.MailBatchWbsCd;
import iris.web.batch.prj.MmTodoCalBatch;
import iris.web.batch.qas.QasBatch;
import iris.web.batch.rlab.RlabApprMailBatch;
import iris.web.batch.sap.SapBudgSCostInsertBatch;
import iris.web.batch.sap.SapBudgTCostInsertBatch;
import iris.web.batch.space.SpaceApprMailBatch;
import iris.web.batch.space.SpaceEvRnewMailBatch;
import iris.web.batch.tss.PrjTmmrBatch;
import iris.web.batch.tss.TssPgPtcMbrBatch;
import iris.web.batch.tss.TssStCopyBatch;
import iris.web.common.util.StringUtil;
import iris.web.system.base.IrisBaseController;

@Controller
public class BatchController  extends IrisBaseController {

    /** [Batch]과제 상태 반영 배치 */
    @Autowired
    private TssStCopyBatch tssStCopyBatch;

    /** [Mail]GRS심의요청  메일 배치 */
    @Autowired
    private MailBatchGrsReq mailBatchGrsReq;

    /** [SAP]예산 정보 S_COST(실적 집계) 배치  */
    @Autowired
    private SapBudgSCostInsertBatch sapBudgSCostInsertBatch;

    /** [SAP]예산 정보 T_COST(세목별 실적 구조) 배치  */
    @Autowired
    private SapBudgTCostInsertBatch sapBudgTCostInsertBatch;

    /** [Batch]과제 참여연구원 반영  배치  */
    @Autowired
    private TssPgPtcMbrBatch tssPgPtcMbrBatch;

    /** [Mail]분석 결재 메일 발송 배치  */
    @Autowired
    private AnlApprMailBatch anlApprMailBatch;

    /** [Mail]신뢰성 결재 메일 발송 배치  */
    @Autowired
    private RlabApprMailBatch rlabApprMailBatch;

    /** [Mail]공간평가 결재 메일 발송 배치  */
    @Autowired
    private SpaceApprMailBatch spaceApprMailBatch;

    /** [Mail]공간평가 성적서 갱신 메일 발송 배치  */
    @Autowired
    private SpaceEvRnewMailBatch spaceEvRnewMailBatch;

    /** [RFC] WBS PRJ INFO 배치  */
    @Autowired
    private WbsPjtIFBatch wbsPjtIFBatch;

    /** [RFC] 고정자산 배치  */
    @Autowired
    private FxaInfoIFBatch fxaInfoIFBatch;

    /** [Mail]공간평가 성적서 갱신 메일 발송 배치  */
    @Autowired
    private FxaTrsfIFBactch fxaTrsfIFBactch;

    /** [Batch]M/M 입력/마감 To-Do생성 배치  */
    @Autowired
    private MmTodoCalBatch mmTodoCalBatch;

    /** [Stat]신제품 실적 통계 배치  */
    @Autowired
    private GenTssStatBatch genTssStatBatch;

    /** [Batch]과제 Qgate I/F 배치  */
    @Autowired
    private QasBatch qasBatch;

    /** [SSO]SSO USER IF 배치  */
    @Autowired
    private SsoUserInfoBatch ssoUserInfoBatch;

    /** [SSO]SSO DEPT IF 배치  */
    @Autowired
    private SsoDeptInfoBatch ssoDeptInfoBatch;

    /** [Batch]월 과제 진척도 입력 요청 메일 배치  */
    @Autowired
    private MailBatchArsl mailBatchArsl;

    /** [Batch]완료예정 과제의 산출물 등록 및 진행 절차 안내 메일 배치  */
    @Autowired
    private MailBatchCmTss mailBatchCmTss;

    /** [Mail]품의 진행 안내 메일 배치  */
    @Autowired
    private MailBatchGrs mailBatchGrs;

    /** [Mail]WBS 코드 생성의 件 안내 메일 배치  */
    @Autowired
    private MailBatchWbsCd mailBatchWbsCd;

    /** [Batch]퇴사,부서이동한 경우 프로젝트 참여연구원 반영 배치  */
    @Autowired
    private PrjTmmrBatch prjTmmrBatch;

    /** [Batch]프로젝트연구팀 마스터 - 프로젝트명, 부서명 업데이트 반영 배치  */
    @Autowired
    private InsaInfoBatch insaInfoBatch;

    static final Logger LOGGER = LogManager.getLogger(BatchController.class);

    /*******************************************************/
    //[20240707]
    //[Batch] 과제 상태 반영 배치
    @RequestMapping(value="/system/batch/tssStCopyBatch.do")
    public ModelAndView TssStCopyBatch(
              @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        //devonframe.refresh.controller.BeanRefreshController 소스 참고
        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - tssStCopyBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            tssStCopyBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail] GRS심의요청  메일 배치
    @RequestMapping(value="/system/batch/mailBatchGrsReq.do")
    public ModelAndView MailBatchGrsReq(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - mailBatchGrsReq 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            mailBatchGrsReq.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[SAP]예산 정보 S_COST(실적 집계) 배치
    @RequestMapping(value="/system/batch/sapBudgSCostInsertBatch.do")
    public ModelAndView SapBudgSCostInsertBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - sapBudgSCostInsertBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            sapBudgSCostInsertBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[SAP]예산 정보 T_COST(세목별 실적 구조) 배치
    @RequestMapping(value="/system/batch/sapBudgTCostInsertBatch.do")
    public ModelAndView SapBudgTCostInsertBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - sapBudgTCostInsertBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            sapBudgTCostInsertBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]과제 참여연구원 반영 배치
    @RequestMapping(value="/system/batch/tssPgPtcMbrBatch.do")
    public ModelAndView TssPgPtcMbrBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - tssPgPtcMbrBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            tssPgPtcMbrBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]분석 결재 메일 발송 배치
    @RequestMapping(value="/system/batch/anlApprMailBatch.do")
    public ModelAndView AnlApprMailBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - anlApprMailBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            anlApprMailBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]신뢰성 결재 메일 발송 배치
    @RequestMapping(value="/system/batch/rlabApprMailBatch.do")
    public ModelAndView RlabApprMailBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - rlabApprMailBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            rlabApprMailBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]공간평가 결재 메일 발송 배치
    @RequestMapping(value="/system/batch/spaceApprMailBatch.do")
    public ModelAndView SpaceApprMailBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - spaceApprMailBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            spaceApprMailBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]공간평가 성적서 갱신 메일 발송 배치
    @RequestMapping(value="/system/batch/spaceEvRnewMailBatch.do")
    public ModelAndView SpaceEvRnewMailBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - spaceEvRnewMailBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            spaceEvRnewMailBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[RFC]WBS PRJ INFO 배치
    @RequestMapping(value="/system/batch/WbsPjtIFBatch.do")
    public ModelAndView WbsPjtIFBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - wbsPjtIFBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            wbsPjtIFBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[RFC]고정자산 배치
    @RequestMapping(value="/system/batch/FxaInfoIFBatch.do")
    public ModelAndView FxaInfoIFBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - fxaInfoIFBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            fxaInfoIFBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]공간평가 성적서 갱신 메일 발송 배치
    @RequestMapping(value="/system/batch/fxaTrsfIFBactch.do")
    public ModelAndView FxaTrsfIFBactch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - fxaTrsfIFBactch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            fxaTrsfIFBactch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]M/M 입력/마감 To-Do생성 배치
    @RequestMapping(value="/system/batch/mmTodoCalBatch.do")
    public ModelAndView MmTodoCalBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - mmTodoCalBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            mmTodoCalBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Stat]신제품 실적 통계 배치
    @RequestMapping(value="/system/batch/genTssStatBatch.do")
    public ModelAndView GenTssStatBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - genTssStatBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            genTssStatBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]과제 Qgate I/F 배치
    @RequestMapping(value="/system/batch/qasBatch.do")
    public ModelAndView QasBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - qasBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            qasBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[SSO]SSO USER IF 배치
    @RequestMapping(value="/system/batch/SsoUserInfoBatch.do")
    public ModelAndView SsoUserInfoBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - ssoUserInfoBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            ssoUserInfoBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[SSO]SSO DEPT IF 배치
    @RequestMapping(value="/system/batch/SsoDeptInfoBatch.do")
    public ModelAndView SsoDeptInfoBatch(
            @RequestParam HashMap<String, Object> input
          , HttpServletRequest request
          , HttpSession session
          , ModelMap model
          , HttpServletResponse response
          ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - ssoDeptInfoBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            ssoDeptInfoBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]월 과제 진척도 입력 요청 메일 배치
    @RequestMapping(value="/system/batch/mailBatchArsl.do")
    public ModelAndView MailBatchArsl(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - mailBatchArsl 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            mailBatchArsl.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]완료예정 과제의 산출물 등록 및 진행 절차 안내 메일 배치
    @RequestMapping(value="/system/batch/mailBatchCmTss.do")
    public ModelAndView MailBatchCmTss(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - mailBatchCmTss 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            mailBatchCmTss.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]품의 진행 안내 메일 배치
    @RequestMapping(value="/system/batch/mailBatchGrs.do")
    public ModelAndView MailBatchGrs(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - mailBatchGrs 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            mailBatchGrs.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Mail]WBS 코드 생성의 件 안내 메일 배치
    @RequestMapping(value="/system/batch/mailBatchWbsCd.do")
    public ModelAndView MailBatchWbsCd(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - mailBatchWbsCd 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            mailBatchWbsCd.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]퇴사,부서이동한 경우 프로젝트 참여연구원 반영 배치
    @RequestMapping(value="/system/batch/prjTmmrBatch.do")
    public ModelAndView PrjTmmrBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - prjTmmrBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            prjTmmrBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //[Batch]프로젝트연구팀 마스터 - 프로젝트명, 부서명 업데이트 반영 배치
    @RequestMapping(value="/system/batch/insaInfoBatch.do")
    public ModelAndView InsaInfoBatch(
            @RequestParam HashMap<String, Object> input
            , HttpServletRequest request
            , HttpSession session
            , ModelMap model
            , HttpServletResponse response
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        try {
            ByteArrayOutputStream errorStream = new ByteArrayOutputStream();

            LOGGER.debug("###########################################################");
            LOGGER.debug("BatchController - insaInfoBatch 수동 실행");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");

            insaInfoBatch.batchProcess();

            if(errorStream.size() == 0)
                response.getWriter().write("REFRESH PROTOCOL 200\n");
            else
                response.getWriter().write((new StringBuilder("REFRESH PROTOCOL 300\n")).append(new String(errorStream.toByteArray())).toString());
        } catch(Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}