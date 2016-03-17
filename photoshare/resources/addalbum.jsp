<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.NewUserDao" %>


<html>
<head><title>Adding a New Album</title></head>

<body>

<% 
  String err = null; 
  String albumname = request.getParameter("albumname");
  String useremail = request.getUserPrincipal().getName();
  if (!albumname.equals("")) { 
     AlbumDao albumdao = new AlbumDao(); 
     NewUserDao user = new NewUserDao();
 
     int ownerid = user.getidFromEmail(useremail);
     boolean success = albumdao.create(ownerid, albumname);
     if (!success) {
        err = "Couldn't create album";
     }

 } else {
  err = "You have to provide an album name";
 }

%>

<% if (err != null) { %> 
<font color=red><b>Error: <%= err %></b></font>
<p> <a href="newalbum.jsp">Go Back</a>
<% } else { %>

<h2>Success!</h2>

<p>Album created.</p>
<a href="index.jsp">back</a>.

<% } %>

</body>
</html>
