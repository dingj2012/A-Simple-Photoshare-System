<%@ page import="photoshare.AlbumBean" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="photoshare.CommentDao" %>
<%@ page import="photoshare.CommentBean" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %> 
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head><title>Browse</title></head>

<body>

<h2>Photoshare Browsing</h2>
<h3>Albums</h3>

<% 
 AlbumDao dao = new AlbumDao(); 
 List<AlbumBean> albums = dao.loadAllAlbums(); 
%>

<table> 

<% 
 for (AlbumBean album : albums) { 
%>

  <tr> 
  <td><a href="albumpublic.jsp?albumid=<%= album.getAlbumid() %>"><%= album.getName() %></a></td>
  <td><%= album.getDateofcreation() %></td>
 </tr>

<% 
 } 
%>

</table>

<br></br>
<h3>Photos</h3>
<table>
    <center><tr>
        
<%
 PictureDao pictureDao = new PictureDao();
    List<Integer> pictureIds = pictureDao.allPicturesIds(); 
    for (Integer pictureId : pictureIds) {
%>
    <tr>
        <td>
            <a href="picture.jsp?picture_id=<%= pictureId %>">
            <img src="/photoshare/img?t=1&picture_id=<%= pictureId %>"/>
            <% Picture p = pictureDao.load(pictureId); %>
            </a>
        </td>
        <td><%= p.getCaption() %></td>
    <%
        }
    %>

</table>

<div id="navigation">
<br></br>
<a href="index.jsp">Back</a>
</div>


</body>
</html>
