package iris.web.common.view;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.servlet.view.AbstractView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Map;
import java.util.Set;

public class RUIJsonView extends AbstractView {

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		JSONArray responseJson = new JSONArray();

		Set<String> keyset = model.keySet();
		String[] models = new String[keyset.size()];
		keyset.toArray(models);
		for (int inx = 0; inx < models.length; inx++) {
			if (model.get(models[inx]) instanceof Map) {
				Map<String, Object> dataset = (Map<String, Object>) model.get(models[inx]);
				JSONObject dataSetObject = new JSONObject();
				dataSetObject.put("metaData", dataset.get("metaData"));
				dataSetObject.put("records", dataset.get("records"));
				responseJson.put(dataSetObject);
			}
		}
		response.setContentType("text/x-json; charset=euc-kr");
		response.setHeader("Cache-Control", "no-cache");

		PrintWriter out = response.getWriter();
		out.write(responseJson.toString(1));
		out.flush();
	}

}
