<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	int mode = 0; //0: 입력 전, 1: 입력 결과 있을 때, 2: 입력 결과 없을 때
	int searchCount = 1;
	String searchText = "";

	//parameter로 searchText가 들어왔는가에 따라 mode 결정
	if(request.getParameter("searchText")!=null){
		searchText = request.getParameter("searchText");
		mode = 1;
	}

	if(searchCount == 0) mode = 2;
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
				$('.test').qtip({
					content: {
						text: "카테고리: 음식점"
					},
					style: {
						classes: 'qtip-bootstrap'
					}
				});
			});
		</script>
	</head>
	<body>
		<header style="height:100px"></header>
		<div class="col-md-10 col-md-offset-1 text-center">
			<div>
				<span style="font-size:30px;">문장을 입력하세요! POI를 찾아드립니다.</span>
			</div>
			<form id="searchForm" action="index2.jsp?" method="GET">
				<div style="margin-top:30px;">
					<textarea name="searchText" rows="10" class="form-control" placeholder="문장을 입력하세요."></textarea>
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
					<%= searchText %>
 					무서운 게, <span class="test" style="background-color: #F8E232">스타벅스</span> 로고는 진짜 저렇게 생겼다는 거죠.
					양손에 들고 있는 저게 세이렌의 두갈래 꼬리 맞습니다...90년대 <span class="test" style="background-color: #F8E232">스벅</span> 로고를 검색해보세요...
				</div>
			</div>
			<% } %>
		</div>
	</body>
</html>