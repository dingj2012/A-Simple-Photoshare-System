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

  int photoid;
  String photoidstring = request.getParameter("picid");
  photoid = Integer.parseInt(photoidstring);
  CommentDao comment = new CommentDao();
  String text = request.getParameter("commenttext");

  if (!text.equals("")) {  
      boolean success = comment.Acreate(text,photoid);
      if (!success) {
        err = "Couldn't add comment";
      }
  } else {
    err = "Must provide a comment...";
  }

%>

<% if (err != null) { %>
<font color=red><b>Error: <%= err %></b></font>
<p> <a href="browsepublic.jsp">Back</a>
<% } else { %>

<h2>Success!</h2>

<% } %>

</body>
</html>
