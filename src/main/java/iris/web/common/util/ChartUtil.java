package iris.web.common.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;

import devonframe.util.NullUtil;

public class ChartUtil {
	
	static final Logger LOGGER = LogManager.getLogger(ChartUtil.class);

    public static List<Map<String,Object>> makePieChartScript(List<Map<String,Object>> lmData) {
    	
    	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

    	for(int a=0; a<lmData.size(); a++){
    		
    		HashMap<String, Object> rtnResultMap = new HashMap();		//가공된 결과를 담을 변수
    		HashMap resultMap = (HashMap)lmData.get(a);
    		
    		String scriptLoad = "";
    		String scriptStr = "";
    		String itemStr = "";
    		String divTagStr = "";
    		
    		
			/*
			 *  displayText(문제), pollSn(설문번호), subjectSn(주제번호), questionSn(문제번호), qType(문항유형), qAnswerStr(주관식답)
			 */
    		if(resultMap.get("qType").toString().equals("PIE")||resultMap.get("qType").toString().equals("WORD")){

    			scriptLoad += "google.charts.setOnLoadCallback(draw"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"Chart);  \n";

    			if(resultMap.get("qType").toString().equals("PIE")){		//PIE 차트
        	    	scriptStr += "function draw"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"Chart() {  \n";
        	    	scriptStr += "    var data = new google.visualization.DataTable();  \n";
        	    	scriptStr += "    data.addColumn('string', 'poll"+resultMap.get("pollSn")+"');  \n";
        	    	scriptStr += "    data.addColumn('number', 'subject"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"');  \n";
        	    	scriptStr += "    data.addRows([  \n";
        			for(int b=1; b<=10; b++){
        				if(!NullUtil.isNull(resultMap.get("display"+b))){
            				if(!itemStr.equals("")) itemStr += " ,";
            				itemStr += " ['"+resultMap.get("display"+b)+"', "+resultMap.get("answer"+b)+"] \n";
        				}
        			}
        			scriptStr += itemStr;
        	    	scriptStr += "    ]);  \n";
        	    	scriptStr += "    var options = {title:'"+resultMap.get("displayText")+"', width:400, height:300};  \n";
        	    	scriptStr += "    var chart = new google.visualization.PieChart(document.getElementById('chart_"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"_div'));  \n";
        	    	scriptStr += "    chart.draw(data, options);  \n";
        	    	scriptStr += "}  \n";
    			}else if(resultMap.get("qType").toString().equals("WORD")){		//WORD 차트
    				scriptStr += "function draw"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"Chart() {  \n";
    				scriptStr += "      var data = google.visualization.arrayToDataTable(  \n";
    				scriptStr += "        [ ['poll"+resultMap.get("pollSn")+"'],  \n";
    				
    				String[] answerArray = resultMap.get("qAnswerStr").toString().split(",");
    				for(int i=0; i<answerArray.length; i++){
        				if(!itemStr.equals("")) itemStr += " ,";
        				itemStr += " ['답변분포 "+answerArray[i]+"'] \n";
    				}
        			scriptStr += itemStr;
    				scriptStr += "        ]  \n";
    				scriptStr += "      );  \n";

    				scriptStr += "      var options = {  \n";
    				scriptStr += "        wordtree: {  \n";
    				scriptStr += "          format: 'implicit',  \n";
    				scriptStr += "          word: '답변분포'  \n";
    				scriptStr += "        }  \n";
    				scriptStr += "      };  \n";

    				scriptStr += "      var chart = new google.visualization.WordTree(document.getElementById('chart_"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"_div'));  \n";
    				scriptStr += "      chart.draw(data, options);  \n";
    				scriptStr += "    }  \n";
    				
    			}
    			
    			divTagStr = "<div id=\"chart_"+resultMap.get("subjectSn")+resultMap.get("questionSn")+"_div\" style=\"width: 400px; height: 300px;\"></div>";
        		
    			rtnResultMap.put("load", scriptLoad);
    			rtnResultMap.put("script", scriptStr);
    			rtnResultMap.put("divTag", divTagStr);
    			
    		}else{
    			rtnResultMap.put("load", scriptLoad);
    			rtnResultMap.put("script", scriptStr);
    			rtnResultMap.put("divTag", divTagStr);
    		}
    		list.add(rtnResultMap);
    			
    	}
        return list;
    }    
    
}//:~
