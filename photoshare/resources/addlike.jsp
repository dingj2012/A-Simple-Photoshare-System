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


  String owneremail;
  if (request.getUserPrincipal() == null) {
    owneremail = "";
  } else {
    owneremail = request.getUserPrincipal().getName();
  }

  int ownerid;
  if (owneremail.equals("")) { 
    ownerid = 2; 
  } else {
    ownerid = commenter.getidFromEmail(owneremail);
  }

  String isthisalike = request.getParameter("like"); 
  CommentDao comment = new CommentDao();
  int photoid;

  String photoidstr = request.getParameter("picid2"); 
  photoid = Integer.parseInt(photoidstr);

  boolean success = comment.create(ownerid, photoid, isthisalike); 
  if (!success) {
        err = "Something went wrong...";
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
