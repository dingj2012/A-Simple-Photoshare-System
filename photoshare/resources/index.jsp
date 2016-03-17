<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.AlbumBean" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="imageUploadBean" class="photoshare.ImageUploadBean">
<jsp:setProperty name="imageUploadBean" property="*"/>
</jsp:useBean>

<html>
    <head><title>Photoshare</title></head>

<body>
<h1>Photoshare</h1>

<% 
    NewUserDao person = new NewUserDao();
    String usersemail = request.getUserPrincipal().getName();
    int usersid = person.getidFromEmail(usersemail);
    String name = person.getFullNameFromId(usersid);
%>

Welcome <b><code><%= name  %></code></b>


<h2>Your Pictures</h2>
<table>
    <tr>
    </tr>
    <%
        PictureDao pictureDao = new PictureDao();
        List<Integer> usersPicIds = pictureDao.yourPictureIds(usersid); 
        for (Integer usersPicId : usersPicIds) {
    %>
    <tr>
        <td><a href="picture.jsp?picture_id=<%= usersPicId %>">
            <img src="/photoshare/img?t=1&picture_id=<%= usersPicId %>"/>
            <% Picture q = pictureDao.load(usersPicId); %>
        </a></td>
        <td><%= q.getCaption() %></td>
        <% 
            if (request.getParameter("action") != null && request.getParameter("action").equals("deleteyourpicture")) {
                int picsId = Integer.parseInt(request.getParameter("picturesID"));
                pictureDao.delete(picsId); 
            }
        %>
        <td>
             <form action="index.jsp" method="post">
                <input type="hidden" name="action" value="deleteyourpicture"/> 
                <input type="hidden" name="picturesID" value="<%= q.getId() %>"/>
                <input type="submit" value="Delete"/> <!-- the button you see that says delete -->
            </form>
        </td>
    </tr>
    <%
        }
    %>
</table>


<h2>Your Photo albums</h2>


    <% 
        AlbumDao albumDao = new AlbumDao(); 
        List<AlbumBean> albumIds = albumDao.loadUsersAlbums(usersid); 
     %>

<table>
    <tr>
    </tr>

    <% 
        for (AlbumBean album : albumIds) {
    %>


    <tr> 
        <td><a href="album.jsp?albumid=<%= album.getAlbumid() %>"><%= album.getName() %></a></td>
        <td><%= album.getDateofcreation() %></td>
     
        <td> 
            <form action="index.jsp" method="post">
                <input type="hidden" name="action" value="deletealbum"/> 
                <input type="hidden" name="albumid" value="<%= album.getAlbumid() %>"/>
                <input type="submit" value="Delete"/> 
            </form>

        </td>

    </tr>
    <%
        }
    %>
</table>

<% 
    if (request.getParameter("action") != null && request.getParameter("action").equals("deletealbum")) { 
        Integer albumid = Integer.parseInt(request.getParameter("albumid"));
        albumDao.deleteAlbum(albumid); 
    }
%>

<div id="navigation">
<br></br>
<a href="browse.jsp">Browse </a>|
<a href="newalbum.jsp">Create album </a>|
<a href="activity.jsp">Top active users </a>|
<a href="populartags.jsp">Popular tags </a>|
<a href="maylike.jsp">You may also like... </a>|
<a href="findfriends.jsp">Find friends </a>|
<a href="logout.jsp">Log out</a>

</div>


</body>
</html>
