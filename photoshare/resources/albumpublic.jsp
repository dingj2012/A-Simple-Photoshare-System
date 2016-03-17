<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.AlbumBean" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="photoshare.CommentBean" %>
<%@ page import="photoshare.CommentDao" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>

<jsp:useBean id="imageUploadBean" class="photoshare.ImageUploadBean">
<jsp:setProperty name="imageUploadBean" property="*"/>
</jsp:useBean>

<html>
    <head><title>Dynamic album page</title></head>
    <body>

    <% 
        String albumsidstr = request.getParameter("albumid");
        int albumsid = Integer.parseInt(albumsidstr);
    %>

    <a href="browsepublic.jsp">Back</a><br>

<h2>All pictures in the album</h2>
<table>
    

<%
    PictureDao pictureDao = new PictureDao();
    AlbumDao albumdao = new AlbumDao();
    List<Integer> picIdsofAlbum = albumdao.getPicIdsofAlbum(albumsid);
    for (Integer pixid : picIdsofAlbum) {
%>
    <tr>
        <td>
            <a href="picturepublic.jsp?picture_id=<%= pixid %>">
            <img src="/photoshare/img?t=1&picture_id=<%= pixid %>"/>
            <% Picture p = pictureDao.load(pixid); %>
            </a>
        </td>

        <td><%= p.getCaption() %></td>

    </tr>
    <%
        }
    %>

</table>
    </body>
</html>
