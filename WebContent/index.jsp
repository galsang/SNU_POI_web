<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="project.dbConnection" %>
<%@ page import="java.util.*" %>

<% 
	int mode = 0; //0: no input, 1: input valid, output valid, 2: input valid, but no output, 3: input invalid
	int validLocation = 0; //0: invalid(no result), 1: valid
	String searchText = "";
	String searchTextWithoutSpace = "";
	
	//parameter로 searchText가 들어왔는가에 따라 mode 결정
	if(request.getParameter("searchText")!=null){
		searchText = request.getParameter("searchText");		
		if(searchText=="") mode = 3; 
		else {
			mode = 1;
			
			for(int i=0;i<searchText.length();i++){
				if(searchText.charAt(i)!=' ') searchTextWithoutSpace += String.valueOf(searchText.charAt(i));
			}
		}
	}
	
	String lat = "";
	String lng = "";
	ArrayList<String> tweets = new ArrayList<String>();
	ArrayList<String> photos = new ArrayList<String>();
	
	if (mode==1) { 
		dbConnection db = new dbConnection();
		db.connect();
		if(db.getLocation(searchTextWithoutSpace).size()>0) {
			validLocation = 1;
			lat = db.getLocation(searchTextWithoutSpace).get("lat");
			lng = db.getLocation(searchTextWithoutSpace).get("lng");
		}
		
		tweets = db.getTweets(searchTextWithoutSpace);
		photos = db.getPhotos(searchTextWithoutSpace);
		
		db.disconnect();
		
		if(tweets.size()>0 || photos.size()>0 || validLocation==1) mode = 1; else mode = 2;
	}
	
	//ArrayList<String> tweets = new ArrayList<String>();
	//tweets.add("싫어하는 음료 3대장은요? — 1. 덴드요 벚꽃 크랜베리 2. 스타벅스 딸기 딜라이트 3. 씨그램 탄산수 http://ask.fm/a/c8glea0c");
	//tweets.add("뮤지컬<유린타운> 퇴근길장소를 알려드립니다. 홍익대대학로아트센터 1층 로비에서 이루어집니다. (스타벅스있는로비에요) ♬(^0^)~♪");
	
	//ArrayList<String> photos = new ArrayList<String>();
	//photos.add("http://upload.wikimedia.org/wikipedia/commons/5/5b/Ultraviolet_image_of_the_Cygnus_Loop_Nebula_crop.jpg");
	//photos.add("http://t2.gstatic.com/images?q=tbn:ANd9GcToZGEWvIBFgCiona6d74FtVthl4lkdJg3d61SGy-UCf4qFuDLD");
%>

<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>POI명 검색기</title>
		
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
		<!-- Optional theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.min.css">
		<!-- jquery -->
		<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
		<!-- Latest compiled and minified JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
		
		<!-- galleria -->
		<script src="galleria/galleria-1.4.2.min.js"></script>
		
		<!-- naver map open api -->
		<!-- script src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=a4ef876ffe15ebf2304f6f7fee7ddfc4"></script-->
		<script src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=deade06ff1708cac35d1de66d33e63c6"></script>
		
		<script type="text/javascript">
			$(document).ready(function(){
				$('#searchBtn').click(function(){
					$('#searchForm').submit();
				});	
			});
		</script>
		<!--  
		<style>
			@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
		</style>
		-->	
	</head>
	<body>
		<header style="height:100px"></header>
		<div class="col-md-8 col-md-offset-2 text-center">
			<div>
				<span style="font-size:30px;">당신의 POI를 찾아보세요!</span>
			</div>
			<form id="searchForm" class="form-inline" style="margin-top: 30px;" action="?" method="GET">
				<div class="form-group">
					<input id="searchText" name="searchText" type="text" class="form-control" placeholder="검색어를 입력하세요." style="width:600px" value="<%= searchText %>">
					<button id="searchBtn" type="button" class="btn btn-info glyphicon glyphicon-search" aria-hidden="true" style="top:0; padding:6px 18px;"></button>
				</div>	
			</form>
		</div>
		<div id="result" class="col-md-10 col-md-offset-1" style="margin-top: 30px;">
			<div class="col-md-12">
				<% if(mode==1) { %>
				<div class="alert alert-success" role="alert">
  					검색하신 POI명 "<span><%= searchText %></span>"의 검색 결과가 존재합니다!
				</div>
				<% } else if (mode==2) { %>
				<div class="alert alert-danger" role="alert">
					죄송합니다. 검색하신 POI명 "<span><%= searchText %></span>"의 검색 결과가 존재하지 않습니다.
				</div>
				<% } else if (mode==3) { %>
				<div class="alert alert-warning" role="alert">
					POI명을 정확히 입력해 주세요!
				</div>
				<% } %>
			</div>
			<% if (mode==1) { %>
			<div class="col-md-6">
				<div class="panel panel-default">
  					<div class="panel-heading">
    					<h3 class="panel-title">위치 정보</h3>
  					</div>
  					<div class="panel-body">
  						<% if (validLocation==1) {%>
  						<div id="map" style="height:400px; padding: 5px 0 0 5px;"></div>
  						<% } else { %>
  						<div>
  							죄송합니다. 위치 정보가 존재하지 않습니다.
  						</div>
  						<% } %>
  					</div>
				</div>
				<div class="panel panel-default">
  					<div class="panel-heading">
    					<h3 class="panel-title">사진</h3>
  					</div>
  					<div class="panel-body">
  						<% if(photos.size()>0) { %>
  						<div class="galleria" style="height: 400px;">
  							<% for(int i=0;i<photos.size();i++){ %>
								<img src="<%= photos.get(i) %>"/>
							<% } %>
						</div>
  						<% } else { %>
  						<div>
							죄송합니다. 사진이 존재하지 않습니다.
						</div>
						<% } %>
  					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="panel panel-default">
  					<div class="panel-heading">
    					<h3 class="panel-title">트윗글</h3>
  					</div>
  					<div class="panel-body">
  						<% if(tweets.size()>0) { %>
	  						<% for(int i=0;i<tweets.size();i++) { %>
	  						<div class="panel panel-default" style="padding: 5%">
	  							<p><%= tweets.get(i) %></p>
	  						</div>
	  						<% } %>
  						<% } else { %>
	  						<div>
	  							죄송합니다. 트윗글이 존재하지 않습니다.
	  						</div>
  						<% } %>
	  				</div>
				</div>
			</div>
			<% } %>
		</div>
		
		<% if (mode==1 && validLocation==1) { %>
		<script type="text/javascript">
			var oPoint = new nhn.api.map.LatLng(<%= lat %>, <%=lng %>);
			nhn.api.map.setDefaultPoint('LatLng');
			oMap = new nhn.api.map.Map('map', {
        		point : oPoint,
    			zoom : 10,
             	enableWheelZoom : true,
        		enableDragPan : true,
   	        	enableDblClickZoom : false,
   	   	    	mapMode : 0,
   	        	activateTrafficMap : false,
   	       	 	activateBicycleMap : false,
    		    minMaxLevel : [ 1, 14 ],
      	     	size : new nhn.api.map.Size($('#testMap').width(),$('#testMap').height())
			});
			
			var mapZoom = new nhn.api.map.ZoomControl(); // - 줌 컨트롤 선언
            mapZoom.setPosition({left:20, bottom:10}); // - 줌 컨트롤 위치 지정
            oMap.addControl(mapZoom); // - 줌 컨트롤 추가.
            
            var oSize = new nhn.api.map.Size(28, 37);
            var oOffset = new nhn.api.map.Size(14, 37);
            var oIcon = new nhn.api.map.Icon('http://static.naver.com/maps2/icons/pin_spot2.png', oSize, oOffset);
            
            var oMarker = new nhn.api.map.Marker(oIcon, {point: oPoint, title: "<%= searchText %>"});
			oMap.addOverlay(oMarker);
			
            var oLabel = new nhn.api.map.MarkerLabel(); // - 마커 라벨 선언.
            oMap.addOverlay(oLabel); // - 마커 라벨 지도에 추가. 기본은 라벨이 보이지 않는 상태로 추가됨.
            oLabel.setVisible(true, oMarker);
		</script>
		<% } %>
		<% if(mode==1 && photos.size()>0) { %>
		<script type="text/javascript">
			Galleria.loadTheme('galleria/themes/classic/galleria.classic.min.js');
        	Galleria.run('.galleria');
		</script>
		<% } %>		
	</body>
</html>