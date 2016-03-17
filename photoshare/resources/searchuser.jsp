<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>
<%@ page import="java.util.List" %>

<html>
<head><title>Search user</title></head>



<body>

<h2> Search users </h2>

<% 
  String searchname = request.getParameter("searchname");
  NewUserDao user = new NewUserDao();
  List<NewUserBean> searchrs = user.searchUserIds(searchname);
%>

<table>

 <% 
 	for (NewUserBean userid : searchrs ) {
 %>
 
  	<tr>
  	<td><%= userid.getUserid() %></td>
	<td>|</td>
  	<td><%= user.getFullNameFromId( userid.getUserid() ) %></td>
	<td>|</td>
	<td><%= user.getEmailFromId( userid.getUserid() ) %></td>
  	</tr>
<%
	}
%>
</table>
 

<br></br>
<a href="login.jsp">back</a>.


</body>
</html>
