package iris.web.stat.rlab.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RlabStatService {

	 /**
     * 통계 > 연도별 시험구분별 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabScnStatList(HashMap<String, Object> input);

	/**
     * 통계 > 연도별 사업부별 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabDzdvStatList(HashMap<String, Object> input);

	/**
     * 통계 > 연도별 시험법별 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabExprStatList(HashMap<String, Object> input);

	/**
     * 통계 > 연도별 담당자별 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabChrgStatList(HashMap<String, Object> input);

	/**
     * 통계 > 연도 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabYyList(HashMap<String, Object> input);

	/**
     * 통계 > 기간별통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabTermStatList(HashMap<String, Object> input);

	/**
     * 통계 > 장비사용통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @return ModelAndView
     * */
	List<Map<String, Object>> retrieveRlabMchnUseStatList(HashMap<String, Object> input);



}
