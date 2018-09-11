package iris.web.tssbatch;

import devonframe.dataaccess.CommonDao;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.common.util.TestConsole;
import iris.web.prj.grs.service.GrsReqService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.tctm.TctmUrl;
import iris.web.prj.tss.tctm.service.TctmTssService;
import iris.web.system.main.service.MainService;
import org.apache.logging.log4j.LogManager;
import org.codehaus.jackson.map.ObjectMapper;
import org.junit.*;
import org.junit.rules.TestName;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.junit.runners.Parameterized;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(
		locations = {
				"classpath*:/spring/context-datasource.xml"
				, "classpath*:/spring/context-mybatis.xml"
				, "classpath*:/spring/context-common.xml"
				, "classpath*:/spring/context-aop.xml"
				, "classpath*:/spring/context-mailSender.xml"
				, "classpath*:/spring/context-message.xml"
				, "classpath*:/spring/context-paging.xml"
				, "classpath*:/spring/context-scheduler.xml"
				, "classpath*:/spring/context-transaction.xml"
				, "classpath*:/spring/context-validator.xml"
				, "classpath*:/spring/mvc-context-fileupload.xml"
				, "classpath*:/spring/mvc-context-servlet.xml"
		}

)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class 기술팀과제Test {
	static final org.apache.logging.log4j.Logger LOGGER = LogManager.getLogger(기술팀과제Test.class);

	@Rule
	public TestName name = new TestName();

	private String serverAlias = "http://127.0.0.1:8080/iris";

	private String sqlPack = "prj.tss.tctm.test.";

	private static String TSS_CD = "";


	@Autowired
	private ApplicationContext context;

	@Autowired
	private WebApplicationContext wac;

	@Autowired
	private ServletContext servletContext;

	private MockMvc mock;

	@Autowired
	private CommonDao commonDao;

	@Autowired
	private MainService mainService;

	@Autowired
	GenTssService genTssService;

	@Autowired
	private TctmTssService tctmTssService;


	@Autowired
	private GrsReqService grsReqService;


	@Autowired
	private GenTssPlnService genTssPlnService;

	@Autowired
	private TssStCopyBatch tssStCopyBatch;



	@BeforeClass
	public static void setUpBeforeClass() throws Exception {

	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {

	}



	@Before
	public void setUp() throws Exception {
		LOGGER.info("wac: " + wac);
		LOGGER.info("mock: " + mock);

		// 콘트롤러 메소드에게 요청을 보낼 수 있는 mockup 객체 생성
		mock = MockMvcBuilders.webAppContextSetup(wac).build();

		LOGGER.debug("============================="+name.getMethodName()+"시작");
	}

	@After
	public void tearDown() throws Exception {
		Map allCnt = commonDao.select(sqlPack + "allCnt", null);
		TestConsole.showMap(allCnt,"과제 등록건수");
		LOGGER.debug("============================="+name.getMethodName()+"종료");
	}

	@Ignore
	@Test
	public void a메인화면() throws Exception {
		RequestBuilder req = MockMvcRequestBuilders.post("/prj/main.do")
//				.param("username", "admin")
				;
		mock.perform(req)
				.andExpect(status().isOk())
				.andDo(print());		
	}

	@Ignore
	@Test
	public void b기술팀과제목록() throws Exception {
		RequestBuilder req = MockMvcRequestBuilders.post(TctmUrl.doList)
//				.param("username", "admin")
				;
		mock.perform(req)
				.andExpect(status().isOk())
				.andDo(print());

	}
	@Ignore
	@Test
	public void c기술팀과제상세() throws Exception {
		RequestBuilder req = MockMvcRequestBuilders.post(TctmUrl.doView)
//				.param("username", "admin")
				;
		mock.perform(req)
				.andExpect(status().isOk())
				.andDo(print());
	}

	@Test
	public void a기술팀과제초기화() throws Exception {
		commonDao.delete(sqlPack + "delMsg");
		commonDao.delete(sqlPack + "delSMry");
		commonDao.delete(sqlPack + "delYldg");
		commonDao.delete(sqlPack + "delSmryAltr");
		commonDao.delete(sqlPack + "delEv");
		commonDao.delete(sqlPack + "delEvResult");
		commonDao.delete(sqlPack + "delITG");
	}


	@Test
	public void d기술팀과제입력() throws Exception {

		HashMap mstDs = jason2Map("{wbsCd=, deptName=중앙연구소, tssSt=100, prjNm=중앙연구소.코팅PJT, bizDptCd=02, pkWbsCd=, tssSmryTxt=컨셉, ppslMbdCd=02, prjCd=PRJ00062, userId=youngken, pgsStepCd=PL, custSqlt=02, tssRoleType=W, pgsStepNm=, tssScnCd=D, tssCd=, tssFnhDd=2018-08-25, tssType=B, prodG=P02, tssAttrCd=01, duistate=2, rsstSphe=04, saSabunNew=FB0399, saSabunName=조윤혜, tssRoleId=TR01, tssNm=기술팀과제 테스트01, deptCode=50001226, tssStrtDd=2018-08-25}");
		HashMap smryData = jason2Map("{duistate=1, smrGoalTxt=서머리목표, tssCd=, ctyOtPlnM=2018-09, userId=youngken, nprodSalsPlnY=522000000, attcFilId=201805875, smrSmryTxt=서머리개요}");

		// deptCode, prjCd, tssScnCd,
		HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", mstDs);


		if (getWbs == null || getWbs.size() <= 0) {
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
		} else {
			//SEED WBS_CD 생성
			int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
			String seqMaxS = String.valueOf(seqMax + 1);
			mstDs.put("wbsCd", "D" + seqMaxS);
			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>임시 wbsCd");
			LOGGER.debug(mstDs.get("wbsCd"));


//			HashMap<String, Object> smryDecodeDs = (HashMap<String, Object>) ousdCooTssService.decodeNamoEditorMap(input, smryDs); //에디터데이터 디코딩처리
//			smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);



			// TSS CD 생성
			if (mstDs.get("tssCd") == null || mstDs.get("tssCd").equals("")) {
				String newTssCd = tctmTssService.selectNewTssCdt(mstDs);
				mstDs.put("tssCd", newTssCd);
				smryData.put("tssCd", newTssCd);

				LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>tssCD");
				LOGGER.debug(newTssCd);
				TSS_CD = newTssCd;
			}

			// 과제 마스터 등록
			tctmTssService.updateTctmTssInfo(mstDs);
			// 과제 개요 등록
			tctmTssService.updateTctmTssSmryInfo(smryData);
			// 산출물 등록
			tctmTssService.updateTctmTssYld(mstDs);


			List<Object> resultMst = commonDao.selectList(sqlPack + "selectMst", mstDs);
			List<Object> resultSmry = commonDao.selectList(sqlPack + "selectSmry", mstDs);
			List<Object> resultYld = commonDao.selectList(sqlPack + "selectYld", mstDs);

			Assert.assertTrue("마스터 등록개수",resultMst.size()==1);
			Assert.assertTrue("서머리등록개수",resultSmry.size()==1);
			Assert.assertTrue("산출물 등록개수",resultYld.size()==4);

//			TestConsole.showMap(resultMst.get(0),"서머리 저장결과");
//			TestConsole.showMap(resultSmry.get(0),"서머리 저장결과");
//			TestConsole.showMap(resultYld.get(0),"산출물 저장결과");
		}
	}


	@Test
	public void e기술팀과제삭제() throws Exception {
		HashMap<String, String> input = new HashMap<String,String>(){
			{
				put("tssCd", TSS_CD);
			}
		};

		List<Object> resultMst = commonDao.selectList(sqlPack + "selectMst", input);
		List<Object> resultSmry = commonDao.selectList(sqlPack + "selectSmry", input);
		List<Object> resultYld = commonDao.selectList(sqlPack + "selectYld", input);
		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("TSS_CD"+TSS_CD);
		LOGGER.debug("삭제전 마스터"+resultMst.size()+"건");
		LOGGER.debug("삭제전 서머리"+resultSmry.size()+"건");
		LOGGER.debug("삭제전 산출물"+resultYld.size()+"건");

		tctmTssService.deleteTctmTssInfo(input);

		resultMst = commonDao.selectList(sqlPack + "selectMst", input);
		resultSmry = commonDao.selectList(sqlPack + "selectSmry", input);
		resultYld = commonDao.selectList(sqlPack + "selectYld", input);


		Assert.assertTrue("마스터 등록개수",resultMst.size()==0);
		Assert.assertTrue("서머리등록개수",resultSmry.size()==0);
		Assert.assertTrue("산출물 등록개수",resultYld.size()==0);

		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("삭제후 마스터"+resultMst.size()+"건");
		LOGGER.debug("삭제후 서머리"+resultSmry.size()+"건");
		LOGGER.debug("삭제후 산출물"+resultYld.size()+"건");


		d기술팀과제입력();
	}


	@Test
	public void fGRS요청저장_초기() throws Exception {
		HashMap input = jason2Map("{tssSt=101, tssScnCd=D, tssCdSn=, grsEvSt=P1, grsEvSnNm=중앙연구소 GRS P1(초기) 심의 평가표, tssCd=D180010001, prjNm=중앙연구소.코팅PJT, bizDptCd=02, tssAttrCd=01, dlbrCrgrId=digel, grsEvSn=5, reqSabun=FB0399, phNm=초기, dlbrCrgr=FB2154, duistate=2, bizDptNm=AL, itgSrch=, prjCd=PRJ00062, userId=youngken, mailTitl=IRIS GRS심의 요청메일입니다, dlbrParrDt=2018-09-07, pgsStepCd=PL, dlbrCrgrNm=성정식, tssNm=기술팀과제 테스트01, attcFilId=}");
		input.put("tssCd",TSS_CD);

		// tssCdSn가 없으면 insert
		if(isNull(input.get("tssCdSn"))) {
			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("tssCdSn null인경우");


			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("평가표등록");
			commonDao.update("prj.grs.insertGrsEvRslt", input);

			String tssCd = (String) input.get("tssCd");
			String tssCdSn = (String) input.get("tssCdSn");

			input.put("reqNo", tssCd + tssCdSn);

			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("TODO 프로시저 호출");
			commonDao.insert("prj.grs.insertGrsEvRsltTodo", input);

			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("과제 마스터  TSS_ST update : " + input.get("tssSt"));
			int cnt = commonDao.update("prj.tss.com.updateTssMstTssSt", input);

			if (cnt > 0) {
				grsReqService.grsSendMail(input);
				LOGGER.debug("심의 담당자 메일발송(발송인 관리자 > 심의담당자)");
				LOGGER.debug("담당자 : "+input.get("dlbrCrgrId").toString()+"@lghausys.com");
				LOGGER.debug("메일제목 : "+ NullUtil.nvl(input.get("mailTitl").toString(),""));

				LOGGER.debug("insertMailHis 메일 발송내역 등록");
			}
		}else{
			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("tssCdSn 있는경우");
			commonDao.update("prj.grs.updateGrsEvRslt", input);
		}

	}


	@Test
	public void gGRS평가() throws Exception {
		// /prj/grs/insertGrsEvRsltSave.do
		List<Map<String, Object>> dsLst = new ArrayList<>();
		dsLst.add(jason2Map("{wgvl=20, calScr=4, grsEvSeq=1, evSbcTxt=개발 기술의 경쟁사 대비 차별화 수준, grsEvSn=5, evCrtnNm=R&D 경쟁력, useYn=Y, dtlSbcTitl_4=내부 개선 수준, duistate=2, dtlSbcTitl_5=현 수준, dtlSbcTitl_2=국내 최고 수준, grsType=, grsY=, dtlSbcTitl_3=경쟁사 동등 수준, evScr=1, evPrvsNm_2=기술지표, evPrvsNm_1=중앙연구소 GRS P1(초기), evSbcNm=, dtlSbcTitl_1=세계 최고 수준}"));
		dsLst.add(jason2Map("{wgvl=30, calScr=6, grsEvSeq=2, evSbcTxt=현재 혹은 사업화 시점에서의 고객 제공 가치 정도, grsEvSn=5, evCrtnNm=고객 Needs 적합성, useYn=Y, dtlSbcTitl_4=낮음, duistate=2, dtlSbcTitl_5=매우 낮음, dtlSbcTitl_2=높음, grsType=, grsY=, dtlSbcTitl_3=다소 높음, evScr=1, evPrvsNm_2=사업지표, evPrvsNm_1=중앙연구소 GRS P1(초기), evSbcNm=, dtlSbcTitl_1=매우 높음}"));
		dsLst.add(jason2Map("{wgvl=20, calScr=4, grsEvSeq=3, evSbcTxt=신규 시장·용도 확대 가능성, grsEvSn=5, evCrtnNm=사업 Impact, useYn=Y, dtlSbcTitl_4=기존 시장 보완, duistate=2, dtlSbcTitl_5=기존 시장 유지, dtlSbcTitl_2=신규 시장 창출, grsType=, grsY=, dtlSbcTitl_3=기존 시장 용도 확대, evScr=1, evPrvsNm_2=사업지표, evPrvsNm_1=중앙연구소 GRS P1(초기), evSbcNm=, dtlSbcTitl_1=신규 시장 선도}"));
		dsLst.add(jason2Map("{wgvl=20, calScr=4, grsEvSeq=4, evSbcTxt=사업매출/수익성, grsEvSn=5, evCrtnNm=제품 경쟁력, useYn=Y, dtlSbcTitl_4=낮음, duistate=2, dtlSbcTitl_5=매우 낮음, dtlSbcTitl_2=높음, grsType=, grsY=, dtlSbcTitl_3=다소 높음, evScr=1, evPrvsNm_2=사업지표, evPrvsNm_1=중앙연구소 GRS P1(초기), evSbcNm=, dtlSbcTitl_1=매우 높음}"));
		dsLst.add(jason2Map("{wgvl=10, calScr=2, grsEvSeq=5, evSbcTxt=핵심제품/기술로서 사업 경쟁력에 미치는 영향, grsEvSn=5, evCrtnNm=전략 적합성, useYn=Y, dtlSbcTitl_4=낮음, duistate=2, dtlSbcTitl_5=매우 낮음, dtlSbcTitl_2=높음, grsType=, grsY=, dtlSbcTitl_3=다소 높음, evScr=1, evPrvsNm_2=전략지표, evPrvsNm_1=중앙연구소 GRS P1(초기), evSbcNm=, dtlSbcTitl_1=매우 높음}"));


		HashMap input = jason2Map("{tssScnCd=, tssNmSch=, tssCdSn=1, bizDtpCd=, cfrnAtdtCdTxt=FB2154, tssCd=D180010001, grsEvStSch=, cfrnAtdtCdTxtNm=&#37;EC&#37;84&#37;B1&#37;EC&#37;A0&#37;95&#37;EC&#37;8B&#37;9D, dui_datasetdatatype=1, grsEvSn=5, dlbrCrgr=FB2154, evTitl=1111, dui_datasetdata=[{\"metaData\":{\"dataSetId\":\"gridDataSet\",\"count\":5,\"totalCount\":5},\"records\":[{\"duistate\":2,\"grsEvSn\":5,\"grsEvSeq\":1,\"evPrvsNm_1\":\"중앙연구소 GRS P1(초기)\",\"evPrvsNm_2\":\"기술지표\",\"evCrtnNm\":\"R&D 경쟁력\",\"evSbcTxt\":\"개발 기술의 경쟁사 대비 차별화 수준\",\"dtlSbcTitl_1\":\"세계 최고 수준\",\"dtlSbcTitl_2\":\"국내 최고 수준\",\"dtlSbcTitl_3\":\"경쟁사 동등 수준\",\"dtlSbcTitl_4\":\"내부 개선 수준\",\"dtlSbcTitl_5\":\"현 수준\",\"evScr\":1,\"wgvl\":20,\"calScr\":\"4\",\"grsY\":\"\",\"grsType\":\"\",\"evSbcNm\":\"\",\"useYn\":\"Y\"},{\"duistate\":2,\"grsEvSn\":5,\"grsEvSeq\":2,\"evPrvsNm_1\":\"중앙연구소 GRS P1(초기)\",\"evPrvsNm_2\":\"사업지표\",\"evCrtnNm\":\"고객 Needs 적합성\",\"evSbcTxt\":\"현재 혹은 사업화 시점에서의 고객 제공 가치 정도\",\"dtlSbcTitl_1\":\"매우 높음\",\"dtlSbcTitl_2\":\"높음\",\"dtlSbcTitl_3\":\"다소 높음\",\"dtlSbcTitl_4\":\"낮음\",\"dtlSbcTitl_5\":\"매우 낮음\",\"evScr\":1,\"wgvl\":30,\"calScr\":\"6\",\"grsY\":\"\",\"grsType\":\"\",\"evSbcNm\":\"\",\"useYn\":\"Y\"},{\"duistate\":2,\"grsEvSn\":5,\"grsEvSeq\":3,\"evPrvsNm_1\":\"중앙연구소 GRS P1(초기)\",\"evPrvsNm_2\":\"사업지표\",\"evCrtnNm\":\"사업 Impact\",\"evSbcTxt\":\"신규 시장·용도 확대 가능성\",\"dtlSbcTitl_1\":\"신규 시장 선도\",\"dtlSbcTitl_2\":\"신규 시장 창출\",\"dtlSbcTitl_3\":\"기존 시장 용도 확대\",\"dtlSbcTitl_4\":\"기존 시장 보완\",\"dtlSbcTitl_5\":\"기존 시장 유지\",\"evScr\":1,\"wgvl\":20,\"calScr\":\"4\",\"grsY\":\"\",\"grsType\":\"\",\"evSbcNm\":\"\",\"useYn\":\"Y\"},{\"duistate\":2,\"grsEvSn\":5,\"grsEvSeq\":4,\"evPrvsNm_1\":\"중앙연구소 GRS P1(초기)\",\"evPrvsNm_2\":\"사업지표\",\"evCrtnNm\":\"제품 경쟁력\",\"evSbcTxt\":\"사업매출/수익성\",\"dtlSbcTitl_1\":\"매우 높음\",\"dtlSbcTitl_2\":\"높음\",\"dtlSbcTitl_3\":\"다소 높음\",\"dtlSbcTitl_4\":\"낮음\",\"dtlSbcTitl_5\":\"매우 낮음\",\"evScr\":1,\"wgvl\":20,\"calScr\":\"4\",\"grsY\":\"\",\"grsType\":\"\",\"evSbcNm\":\"\",\"useYn\":\"Y\"},{\"duistate\":2,\"grsEvSn\":5,\"grsEvSeq\":5,\"evPrvsNm_1\":\"중앙연구소 GRS P1(초기)\",\"evPrvsNm_2\":\"전략지표\",\"evCrtnNm\":\"전략 적합성\",\"evSbcTxt\":\"핵심제품/기술로서 사업 경쟁력에 미치는 영향\",\"dtlSbcTitl_1\":\"매우 높음\",\"dtlSbcTitl_2\":\"높음\",\"dtlSbcTitl_3\":\"다소 높음\",\"dtlSbcTitl_4\":\"낮음\",\"dtlSbcTitl_5\":\"매우 낮음\",\"evScr\":1,\"wgvl\":10,\"calScr\":\"2\",\"grsY\":\"\",\"grsType\":\"\",\"evSbcNm\":\"\",\"useYn\":\"Y\"}]}], userIds=digel, seq=, commTxt=1111111, dlbrParrDt=2018-09-07, attcFilId=201805883, _userEmail=youngken@lghausys.com, _userJobx=EH0, _userId=youngken, _userGubun=F, _userFunc=, _loginTime=08:32:09, _userFuncName=, _teamDept=II, _userNm=조윤혜, _userDeptName=LG CNS, rowsPerPage=100, sessionID=84132A3BB17C95E202844B21A360EA58, _userSabun=FB0399, _userDept=IC, _userJobxName=책임, _roleId=WORK_IRI_T01, userId=youngken}");
		input.put("tssCd",TSS_CD);

		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("평가정보 저장");
		input.put("userId", input.get("_userId"));

		input.put("cfrnAtdtCdTxt",input.get("cfrnAtdtCdTxt").toString().replaceAll("%2C", ",")); //참석자

		input = StringUtil.toUtf8Input(input);

		grsReqService.insertGrsEvRsltSave(dsLst, input);


		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("과제상태 변경 : 102 GRS완료");
		input.put("tssSt", "102");
		genTssPlnService.updateGenTssPlnMstTssSt(input);


		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("과제 리더  메일 발송");
		genTssPlnService.retrieveSendMail(input); //개발에서 데이터 등록위해 반영위해 주석 1121
	}


	@Test
	public void h품의요청(){
	/*/prj/tss/gen/insertGenTssCsusRq.do*/

//		ds  = RuiConverter.convertToDataSet(request, "dataSet");
		List<Map<String, Object>> ds = new ArrayList<>();
		HashMap input = jason2Map("{tssSt=, affrCd=D180010001, body=<div></div>, tssCd=D180010001, approvalJobtitle=책임, approvalDeptname=LG CNS, approvalProcessdate=, url=, updateDate=, guid=, duistate=1, title=, approvalUserid=youngken, aprdocstate=, userId=youngken, approverProcessdate=, approvalUsername=조윤혜, affrGbn=T}");
		input.put("tssCd",TSS_CD);
		ds.add(input);

		HashMap<String, String> mstMap = new HashMap<String, String>();
		mstMap.put("tssCd", String.valueOf(ds.get(0).get("tssCd")));

		Map<String, Object> resultMst = genTssPlnService.retrieveGenTssPlnMst(mstMap);
		String pgsStepCd = String.valueOf(resultMst.get("pgsStepCd"));
		String tssSt     = String.valueOf(resultMst.get("tssSt"));

		boolean setpYn = true;
		if("DC".equals(pgsStepCd) || "CM".equals(pgsStepCd)) {	//중단, 완료
			if(!"100".equals(tssSt) && !"102".equals(tssSt) && !"500".equals(tssSt)) {	// !진행중 && !GRS완료 && !정산작성중
				setpYn = false;
				LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
				LOGGER.debug("이미 품의가 요청되었습니다.");
			}
		}
		if(setpYn) {
			genTssService.insertGenTssCsusRq(ds.get(0));
			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
			LOGGER.debug("통합결제 등록");
			LOGGER.debug("GUID 키생성(결제고유코드)"+ds.get(0).get("guid"));
		}

	}

	@Test
	public void i품의완료() throws SQLException, ClassNotFoundException {

		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("통합결제완료 프로시져(통합결제 gui가 등록된후 요청상태로 변경 503,103) ");

		final String gui = commonDao.select(sqlPack+"getGui",TSS_CD);
		HashMap<String, Object> input = new HashMap<String,Object>(){
			{
				put("gui",gui);
				put("aprdocstate","A02");
				put("itgRdcsId","");
				put("successFlag","");

			}
		};
		commonDao.select(sqlPack+"ItgSp",input);

		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>");
		LOGGER.debug("결제 배치 A02(최종승인완료) 경우 104로 변경(품의완료) , 과제,서머리 복제");
		tssStCopyBatch.batchProcess();
	}




	/**
	 * JasonString to Map
	 *
	 * @param str
	 * @return
	 * @throws IOException
	 */
	@Parameterized.Parameters
	public static HashMap jason2Map2(String str) throws IOException {
		String result = str;
		result = result.replaceAll("([\\w]+)[ ]*=", "\"$1\" ="); // to quote before = value
		result = result.replaceAll("=[ ]*([\\w@\\d\\.ㄱ-ㅎ가-힣 \\-()]+)", "= \"$1\""); // to quote after = value, add special character as needed to the exclusion list in regex
//		result = result.replaceAll("=[ ]*\"([\\d]+)\"", "= $1"); // to un-quote decimal value
		result = result.replaceAll("=,", "=\"\","); // empty value
		result = result.replaceAll("=}", "=\"\"}"); // empty value
		result = result.replaceAll("\\=", "\\:");
		result = result.replaceAll("\"true\"", "true"); // to un-quote boolean
		result = result.replaceAll("\"false\"", "false"); // to un-quote boolean
		result = result.replaceAll("\\,", "\\,\\\n"); // next line
		result = result.replaceAll("\\{", "\\{\\\n"); // next line
		result = result.replaceAll("\\}", "\\\n\\}"); // next line
		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>Input Dummy Start");
		LOGGER.debug(result);
		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>Input Dummy End");
		return new ObjectMapper().readValue(result, HashMap.class);
	}
	public static HashMap jason2Map(String str){
		HashMap result = new HashMap();
		str = str.replaceAll("\\{","");
		str = str.replaceAll("\\}","");
		String[] list = str.split(", ");
		for (int i=0;i<list.length;i++){
			String[] obj = list[i].split("\\=");
			 if(obj.length==2){
				 result.put(obj[0],obj[1]);
			 }else{
				 result.put(obj[0],"");
			 }
		}
		return result;
	}


	public static boolean isNull(Object obj){
		return (obj==null || obj.equals(""));
	}

}