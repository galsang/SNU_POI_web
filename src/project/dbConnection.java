package project;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class dbConnection {

	Connection conn = null;
	
	public void connect() throws Exception {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/snu_poi?useUnicode=true&characterEncoding=utf8","snu","2154");
			//conn = DriverManager.getConnection("jdbc:mysql://114.108.167.117:3306/snu_poi?useUnicode=true&characterEncoding=utf8","snu","2154");
			
			System.out.println("db connection opening...");
		} catch (Exception e) {
			System.out.println("db connection failed!");
			e.printStackTrace();
		}
	}
	
	public void disconnect() {
		try {
			System.out.println("db connection closing...");
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public HashMap<String,String> getLocation(String searchText) throws Exception {
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HashMap<String,String> result = new HashMap<String, String>();
		
		try {
			String sql = "select * from poi_location where poi_id in (select id from poi_info where name like '"+searchText+"%') limit 1";
			pstmt = conn.prepareStatement(sql);
			//pstmt.setString(1,searchText);

			rs = pstmt.executeQuery();
			if(rs.next()) {
				result.put("lat", rs.getString("geo_x"));
				result.put("lng", rs.getString("geo_y"));
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close(); 
		}
		
		return result;
	}
	
	public ArrayList<HashMap<String,String>> getTweets(String searchText) throws Exception {
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<HashMap<String,String>> result = new ArrayList<HashMap<String,String>>();
		
		try {
			String sql = "";
			sql += "select U.screen_name, U.profile_url, T.text from tweet_info T join user_info U on T.user_id = U.id ";
			sql += "join poi_tweet on T.id = poi_tweet.tweet_id ";
			sql += "join poi_info on poi_tweet.poi_id = poi_info.id ";
			sql += "where poi_info.name_nospace like '"+searchText+"%'";
							
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				HashMap<String,String> temp = new HashMap<String,String>();
				
				temp.put("text", rs.getString("text"));
				temp.put("profile_url", rs.getString("profile_url"));
				temp.put("screen_name", rs.getString("screen_name"));
				
				result.add(temp);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close(); 
		}
		
		return result;
	}

	public ArrayList<String> getPhotos(String searchText) throws Exception {
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> result = new ArrayList<String>();
		
		try {
			String sql = "";
			sql += "select url from photo_info where id in ";
			sql += "(select photo_id from poi_photo where poi_id in ";
			sql += "(select id from poi_info where name_nospace like '"+searchText+"%'))";
			
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				result.add(rs.getString("url"));
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close(); 
		}
		
		return result;
	}
	
	public ArrayList<String> getReviews(String searchText) throws Exception {
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> result = new ArrayList<String>();
		
		try {
			String sql = "";
			sql += "select review from review_info where id in ";
			sql += "(select review_id from poi_review where poi_id in ";
			sql += "(select id from poi_info where name_nospace like '"+searchText+"%'))";
			
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			while(rs.next()) {
				result.add(rs.getString("review"));
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close(); 
		}
		
		return result;
	}
}
