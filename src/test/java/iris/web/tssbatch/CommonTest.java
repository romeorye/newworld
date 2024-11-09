package iris.web.tssbatch;

import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;

import org.apache.logging.log4j.LogManager;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.FixMethodOrder;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TestName;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;

import devonframe.dataaccess.CommonDao;
import iris.web.batch.tss.TssStCopyBatch;
import iris.web.batch.tss.service.TssStCopyService;
import iris.web.prj.grs.service.GrsReqService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.tctm.service.TctmTssService;
import iris.web.system.main.service.MainService;

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
public class CommonTest {
	static final org.apache.logging.log4j.Logger LOGGER = LogManager.getLogger(CommonTest.class);

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

	@Autowired
	private TssStCopyService tssStCopyService;



	@BeforeClass
	public static void setUpBeforeClass() throws Exception {

	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {

	}



	@Before
	public void setUp() throws Exception {
//		LOGGER.info("wac: " + wac);
//		LOGGER.info("mock: " + mock);
//
//		// 콘트롤러 메소드에게 요청을 보낼 수 있는 mockup 객체 생성
//		mock = MockMvcBuilders.webAppContextSetup(wac).build();
//
//		LOGGER.debug("============================="+name.getMethodName()+"시작");
	}

	@After
	public void tearDown() throws Exception {
//		Map allCnt = commonDao.select(sqlPack + "allCnt", null);
//		TestConsole.showMap(allCnt,"과제 등록건수");
//		LOGGER.debug("============================="+name.getMethodName()+"종료");
	}

//	@Ignore
//	@Test
//	public void testSubstring() throws Exception {
//		String result = "D180010001".substring( 0,9) + (java.lang.Integer.parseInt("D180010001".substring( 9,10))+1);
//		Assert.assertEquals("D180010002",result);
//	}

	@Test
	public void testWbsCd() throws Exception {
		List<HashMap<String,Object>> prjList = commonDao.selectList(sqlPack + "prjList");
		for (int i=0;i<prjList.size();i++){
			HashMap<String, Object> row = prjList.get(i);
			row.put("tssScnCd", "G");
//			row.put("tssScnCd", "D");
			String wbsCd = tssStCopyService.createWbsCd(row);

			LOGGER.debug("== "+row.get("prjCd") + row.get("prjNm") + "/"+row.get("deptCode")+"/"+row.get("wbsCdA")+" ==");
			LOGGER.debug("== "+wbsCd+" ==");
		}
	}

}