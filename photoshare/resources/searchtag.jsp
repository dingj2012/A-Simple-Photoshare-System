<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.TagDao" %>
<%@ page import="photoshare.TagBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="java.util.List" %>

<html>
<head><title>Search tag</title></head>



<body>

<h2> Search Tags </h2>

<% String searchname = request.getParameter("searchtag"); %>
<h1>Search Result For:<%= searchname%><h1>

<%
  for (String eachS : searchname.split(" ")) {
	TagDao t = new TagDao();
	PictureDao pDao = new PictureDao();
	List<Picture> searchrs = t.searchTag(eachS);
%>

<table>

 <% 
 	for (Picture p : searchrs ) {
 %>
 
  	<tr>
	<img src="/photoshare/img?t=1&picture_id=<%= p.getId() %>"/>
        <% Picture q = pDao.load(p.getId()); %>
        </a></td>
        <td><%= q.getCaption() %></td>

  	</tr>
<%
	}
%>
<%
	}
%>
</table>
 

<br></br>
<a href="index.jsp">back</a>.


</body>
</html>
