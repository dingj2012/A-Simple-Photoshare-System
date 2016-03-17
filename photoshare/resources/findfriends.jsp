<%@ page import="photoshare.NewUserDao" %>
<%@ page import="photoshare.NewUserBean" %>

<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head><title>Find Friends</title></head>

<div><a href="index.jsp">back</a></div>


<body>

<h1>Your Friends</h1>

<% 
	NewUserDao person = new NewUserDao();
	String usersemail = request.getUserPrincipal().getName();
	int usersid = person.getidFromEmail(usersemail);
	List<NewUserBean> yourfriends = person.loadUsersFriends(usersid); 
%>

<table>

    <% 
        for (NewUserBean yourfriend : yourfriends) { 
    %>
        <tr> 
        <td><%= yourfriend.getFirstname() %></td> 
        <td><%= yourfriend.getEmail() %></td>
        
        <td> 
            <form action="findfriends.jsp" method="post">
                <input type="hidden" name="action" value="deletefriend"/> 
                <input type="hidden" name="email" value="<%= yourfriend.getEmail() %>"/>
                <input type="submit" value="Delete"/> 
            </form>

        </td>
    </tr>
    <%
        }
    %>
</table>

<% 
    if (request.getParameter("action") != null && request.getParameter("action").equals("deletefriend")) { 
        NewUserDao f = new NewUserDao();
        String friendsEmail = request.getParameter("email");
        int frienduserid = f.getidFromEmail(friendsEmail);
        person.deleteFriend(usersid, frienduserid); 
    }
%>


<h2>Showing all users</h2>


<% 
 NewUserDao currentuser = new NewUserDao();
 String currentuseremail = request.getUserPrincipal().getName();
 int currentuserid = currentuser.getidFromEmail(currentuseremail);
 List<NewUserBean> allusers = currentuser.loadAllUsers(currentuserid);
%>

<table> 

 <% 
  for (NewUserBean eachuser : allusers) {

 %>

  <tr>
  <td><%= eachuser.getFirstname() %></td> 
  <td><%= eachuser.getEmail() %></td>
 
  <td> 
            <form action="findfriends.jsp" method="post">
                <input type="hidden" name="action" value="add"/> 
		<input type="hidden" name="email" value="<%= eachuser.getEmail() %>" />
                <input type="submit" value="Add"/>
            </form>

        </td>
 </tr>
 <%
  }
 %>
 
 <% 
    if (request.getParameter("action") != null && request.getParameter("action").equals("add")) {
     NewUserDao f2 = new NewUserDao();
     String friendemail = request.getParameter("email");
     int friendid = f2.getidFromEmail(friendemail);
     currentuser.addFriend(currentuserid, friendid); 
    }
  %>
</table>

</body>
</html>
