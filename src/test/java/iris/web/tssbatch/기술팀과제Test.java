package iris.web.tssbatch;

import devonframe.dataaccess.CommonDao;
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
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
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

	private String TSS_CD = "";


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

		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>"+name.getMethodName()+"시작");
	}

	@After
	public void tearDown() throws Exception {
		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>"+name.getMethodName()+"종료");
	}

	@Test
	public void a메인화면() throws Exception {
		RequestBuilder req = MockMvcRequestBuilders.post("/prj/main.do")
//				.param("username", "admin")
				;
		mock.perform(req)
				.andExpect(status().isOk())
				.andDo(print());		
	}

	@Test
	public void b기술팀과제목록() throws Exception {
		RequestBuilder req = MockMvcRequestBuilders.post(TctmUrl.doList)
//				.param("username", "admin")
				;
		mock.perform(req)
				.andExpect(status().isOk())
				.andDo(print());

	}

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
	public void d기술팀과제입력() throws Exception {

		HashMap mstDs = jaon2Map("{wbsCd=, deptName=중앙연구소, tssSt=100, prjNm=중앙연구소.코팅PJT, bizDptCd=02, pkWbsCd=, tssSmryTxt=컨셉, ppslMbdCd=02, prjCd=PRJ00062, userId=youngken, pgsStepCd=PL, custSqlt=02, tssRoleType=W, pgsStepNm=, tssScnCd=D, tssCd=, tssFnhDd=2018-08-25, tssType=B, prodG=P02, tssAttrCd=01, duistate=2, rsstSphe=04, saSabunNew=FB0399, saSabunName=조윤혜, tssRoleId=TR01, tssNm=기술팀과제 테스트01, deptCode=50001226, tssStrtDd=2018-08-25}");
		HashMap smryData = jaon2Map("{duistate=1, smrGoalTxt=서머리목표, tssCd=, ctyOtPlnM=2018-09, userId=youngken, nprodSalsPlnY=522000000, attcFilId=201805875, smrSmryTxt=서머리개요}");

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
			Assert.assertTrue("산출물 등록개수",resultYld.size()==3);

//			TestConsole.showMap(resultMst.get(0),"서머리 저장결과");
//			TestConsole.showMap(resultSmry.get(0),"서머리 저장결과");
//			TestConsole.showMap(resultYld.get(0),"산출물 저장결과");
		}
	}


	/**
	 * JasonString to Map
	 *
	 * @param str
	 * @return
	 * @throws IOException
	 */
	@Parameterized.Parameters
	public static HashMap jaon2Map(String str) throws IOException {
		String result = str;
		result = result.replaceAll("([\\w]+)[ ]*=", "\"$1\" ="); // to quote before = value
		result = result.replaceAll("=[ ]*([\\w@\\d\\.ㄱ-ㅎ가-힣 -]+)", "= \"$1\""); // to quote after = value, add special character as needed to the exclusion list in regex
//		result = result.replaceAll("=[ ]*\"([\\d]+)\"", "= $1"); // to un-quote decimal value
		result = result.replaceAll("=,", "=\"\","); // to un-quote boolean
		result = result.replaceAll("\\=", "\\:"); // to un-quote boolean
		result = result.replaceAll("\"true\"", "true"); // to un-quote boolean
		result = result.replaceAll("\"false\"", "false"); // to un-quote boolean
		result = result.replaceAll("\\,", "\\,\\\n"); // to un-quote boolean
		result = result.replaceAll("\\{", "\\{\\\n"); // to un-quote boolean
		result = result.replaceAll("\\}", "\\\n\\}"); // to un-quote boolean
		LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>Input Dummy");
		LOGGER.debug(result);
		return new ObjectMapper().readValue(result, HashMap.class);
	}

}