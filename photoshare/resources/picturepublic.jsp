<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.AlbumBean" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="photoshare.CommentBean" %>
<%@ page import="photoshare.CommentDao" %>
<%@ page import="photoshare.TagBean" %>
<%@ page import="photoshare.TagDao" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Date" %>

<html>
 <head><title>Dynamic picture page</title></head>
 <body>
    <% 
        String picidstr = request.getParameter("picture_id");
        int picid = Integer.parseInt(picidstr);
        NewUserDao person = new NewUserDao();

        String usersemail;
        int usersid;
        if (request.getUserPrincipal() == null) {
            usersemail = "";
            usersid = 2;
        } else {
            usersemail = request.getUserPrincipal().getName();
            usersid = person.getidFromEmail(usersemail);
        }
	
    %>
    <a href="index.jsp">Back</a>
    <h1>

	<%
	PictureDao pictureDao = new PictureDao();
        Picture p = pictureDao.load(picid);
        CommentDao commentdao = new CommentDao();
	%>
	<p><%= p.getCaption() %><br></p>
    </h1>

    <img src="/photoshare/img?t=1&picture_id=<%= picid %>"/>
    
    <br></br>
    <p>


<form action="addAcomment.jsp" method="post">
<input type="hidden" name="picid" value='<%= picid %>'/>
Add a comment:<input type="text" name="commenttext" />
<input type="submit" value="Add Comment"/><br>
</form>
	
    <br>
    <table id="tags">
    <p>
    Tags:
    <%
        TagDao tagdao = new TagDao();
        List<String> photostags = tagdao.getTagsOfPicid(picid);

        for (String phototag : photostags) {

    %>
    	<span><a href="searchtag.jsp?searchtag=<%= phototag %>"><%= phototag %></a></span>,
    <% } %>

        <form action="searchtag.jsp" method="post">
	Tag search:<input type="text" name="searchtag" />
	<input type="submit" value="Search"/><br>
	</form>
    
    
    </p>
    </table>

<br></br>
<a>Likes:</a> <%= commentdao.countLikes(picid) %></a>

    <table id="likes">
	<%
	List<Integer> likers = person.getLikersIds(picid);
        
	for (Integer likerid : likers) {
	%>
	<table>
	<a>People who likes this picture: </a>
    	<tr>
	    	<a><%= person.getFullNameFromId(likerid) %></a>
		<a>,</a>
	    </tr>
	</table>
	<%
		}
	%>
    </table>

<br>
    <table id="commentsection">
	<td>Comments:</td>
	<tr>
	        <td>commentar</td>
                <td>|</td>
                <td>date</td>
                <td>|</td>
                <td>text</td>
	</tr>
        <%
            NewUserDao commenter = new NewUserDao();
            List<CommentBean> cmtbeans = commentdao.getCommentsofPicture(picid);
            for (CommentBean cmt : cmtbeans) {
        %>

        <tr>
            <td><%= commenter.getFullNameFromId(cmt.getOwnerid()) %></td>
		<td>|</td>
            <td><%= cmt.getDateofcomment() %></td>
		<td>|</td>
            <td><%= cmt.getText() %></td>
        </tr>
        <%
            }
        %>
    </table>
 </body>
</html>
