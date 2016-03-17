<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.CommentBean" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.CommentDao" %>
<%@ page import="java.sql.Date" %>

<html>
<head><title>Adding a New Comment</title></head>

<body>

<%

  NewUserDao commenter = new NewUserDao();
  String err = null;
  String owneremail = request.getUserPrincipal().getName();
  int ownerid = commenter.getidFromEmail(owneremail);
  CommentDao comment = new CommentDao();
  int photoid;
  String photoidstring = request.getParameter("picid"); 
  photoid = Integer.parseInt(photoidstring);
  String text = request.getParameter("commenttext");

  if (!text.equals("")) {  
      boolean success = comment.create(ownerid, photoid, text);
      if (!success) {
        err = "Couldn't add comment";
      }
  } else {
    err = "Must provide a comment...";
  }

%>

<% if (err != null) { %>
<font color=red><b>Error: <%= err %></b></font>
<p> <a href="browsealbums.jsp">Go Back to browse albums</a>
<% } else { %>

<h2>Success!</h2>

You can now return to <a href="picture.jsp?picture_id=<%= photoid %>">the picture</a>.

<% } %>

</body>
</html>
