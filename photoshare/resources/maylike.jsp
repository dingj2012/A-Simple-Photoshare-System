<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.TagDao" %>
<%@ page import="photoshare.TagBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %>

<html>
<head><title>May Like</title></head>



<body>
<% 
	NewUserDao currentuser = new NewUserDao();
	String currentuseremail = request.getUserPrincipal().getName();
	int currentuserid = currentuser.getidFromEmail(currentuseremail);
	
	NewUserDao u = new NewUserDao();
	List<TagBean> tlist = u.mayLike(currentuserid);
%>


<h1>The top 5 tags in your albums:</h1>
<% 
	for (TagBean t: tlist) {
%>
	<a><%= t.getTag() %></a>
	<a>,</a>

<%
}
%>


<table>
<h1>The pictures you may like...</h1>
<% 
	List<Picture> al = new ArrayList<Picture>(); 
	for (TagBean tb : tlist) {
		TagDao t = new TagDao();
        	PictureDao pDao = new PictureDao();
        	List<Picture> searchrs = t.searchTag(tb.getTag());
			for (Picture p : searchrs ){
				Picture q = pDao.load(p.getId());
				al.add(q);
			}
	}
	Set<Picture> hs = new HashSet<Picture>();
	hs.addAll(al);
	al.clear();
	al.addAll(hs);
%>

 <% 
	PictureDao pDao = new PictureDao();
 	for (Picture p : al ) {
 %>
 
  	<tr>
	<td><img src="/photoshare/img?t=1&picture_id=<%= p.getId() %>"/>
        <% Picture q = pDao.load(p.getId()); %>
        </a></td>
        <td><%= q.getCaption() %></td>

  	</tr>
<%
	}
%>
</table>
 

<br></br>
<a href="index.jsp">back</a>.


</body>
</html>
