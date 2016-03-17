<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.AlbumBean" %>
<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head><title>Top active</title></head>
    
<body>
 <a href="index.jsp">Back</a><br>
 <h1>Top active users</h1>

<% 
 NewUserDao user = new NewUserDao();
 List<NewUserBean> contribs = user.getTopActive();
%>

<table> 

  <tr>
   <td>Name</td>
   <td>|</td>
   <td>Activity</td>
  </tr>

 <% 
  for (NewUserBean c : contribs ) {
  int userid = c.getUserid();
 %>

  <tr>
  <% 
     if (userid != 2) {
  %> 
  <td><%= user.getFullNameFromId( c.getUserid() ) %></td> 
  <td>|</td>
  <td><%= c.getActivity() %></td>
  <%
   }
   %>
  </tr>

 <%
  }
 %>
 </table>

</body>
</html>
