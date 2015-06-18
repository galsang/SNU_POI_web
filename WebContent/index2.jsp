<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="snu.poi.*" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.shineware.util.common.model.Pair" %>
<%@ page import="edu.stanford.nlp.util.Quadruple" %>
<%
	int mode = 0; //0: 입력 전, 1: 입력 결과 있을 때, 2: 입력 결과 없을 때
	int searchCount = 0;
	String searchText = "";
	String searchTextFiltered = "";
	
	//parameter로 searchText가 들어왔는가에 따라 mode 결정
	request.setCharacterEncoding("UTF-8");
	if(request.getParameter("searchText")!=null){
		searchText = request.getParameter("searchText");
		System.out.println("searchText: "+ searchText);
		mode = 1;
		
		ResourcePath.path = "/usr/local/tomcat8/webapps/SNU_POI_web";
		//ResourcePath.path = "/Users/galsang/Documents/eclipse/project/WebContent";
		
		List<Pair<String,Character>> results = POIFinder.getInstance().findPOI(searchText);
		List<Quadruple<Integer,Integer,String,Character>> positions = POIFinder.getInstance().findPosition(results, searchText);
		Collections.sort(positions);
		
		//System.out.println("searchText: "+ searchText);
		//System.out.println("result : " + results.size() + results);
		//System.out.println("position : " + positions.size());
		
		searchCount = positions.size();
		if(searchCount == 0) mode = 2;
		int beforeEnd = 0;
		for(int i=0;i<searchCount;i++){
			int start = positions.get(i).first();
			int end = positions.get(i).second();
			System.out.println(String.valueOf(start)+" "+String.valueOf(end));
			String className = "poi_" + positions.get(i).fourth();
			
			if(beforeEnd <= start) {
				searchTextFiltered += searchText.substring(beforeEnd, start);
				searchTextFiltered += "<span class='poi "+className+"'>";
				searchTextFiltered += searchText.substring(start,end);
				searchTextFiltered += "</span>";
				
				beforeEnd = end;
			}
		}
		if(beforeEnd < searchText.length()) searchTextFiltered += searchText.substring(beforeEnd);
	}
%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>POI명 분석기</title>
		
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
		<!-- Optional theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
		<!-- jquery -->
		<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
		<!-- Latest compiled and minified JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
		
		<!-- jquery qtip plugin -->
		<script src="http://cdnjs.cloudflare.com/ajax/libs/qtip2/2.2.1/jquery.qtip.min.js"></script>
		<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/qtip2/2.2.1/jquery.qtip.min.css">
		
		<script type="text/javascript">
			$(document).ready(function(){
				$('.poi_A').qtip({
					content: {text: "Arts & Entertainment"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_C').qtip({
					content: {text: "College & University"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_E').qtip({
					content: {text: "Event"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_F').qtip({
					content: {text: "Food"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_N').qtip({
					content: {text: "Nightlife Spot"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_O').qtip({
					content: {text: "Outdoors & Recreation"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_P').qtip({
					content: {text: "Nightlife Spot"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_R').qtip({
					content: {text: "Residence"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_S').qtip({
					content: {text: "Shop & Service"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_T').qtip({
					content: {text: "Travel & Transport"},
					style: {classes: 'qtip-bootstrap'}
				});
				
				$('.poi_U').qtip({
					content: {text: "Unknown"},
					style: {classes: 'qtip-bootstrap'}
				});				
			});
		</script>
		<style>
			.poi {background-color: #F8E232}
		</style>
	</head>
	<body>
		<header style="height:100px"></header>
		<div class="col-md-10 col-md-offset-1 text-center">
			<div>
				<span style="font-size:30px;">문장을 입력하세요! POI를 찾아드립니다.</span>
			</div>
			<form id="searchForm" action="index2.jsp?" method="POST">
				<div style="margin-top:30px;">
					<textarea name="searchText" rows="10" class="form-control" placeholder="문장을 입력하세요."><%= searchText %></textarea>
					<button class="btn btn-info" aria-hidden="true" style="width: 30%; margin-top:20px;">Find!</button>
				</div>
			</form>	
		</div>
		<div class="col-md-10 col-md-offset-1" style="margin-top:30px;">
			<div>
				<% if(mode==1) { %>
				<div class="alert alert-success" role="alert">
  					"<span><%= searchCount %></span>"개의 POI를 발견하였습니다!
				</div>
				<% } else if (mode==2) { %>
				<div class="alert alert-danger" role="alert">
					POI를 발견하지 못했습니다. 적합한 문장을 입력해 주세요.
				</div>
				<% } %>
			</div>
			<% if(mode==1) { %>
			<div class="panel panel-default">
				<div class="panel-heading">
 					<h3 class="panel-title">분석 결과</h3>
				</div>
				<div class="panel-body">
					<%= searchTextFiltered %>
				</div>
			</div>
			<% } %>
		</div>
	</body>
</html>