<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head><title>Photoshare Login</title></head>


<body>

<h2>Log in</h2>

<form method="POST" action="j_security_check">
    <table>
        <tr><th>Email</th><td><input type="text" name="j_username"></td></tr>
        <tr><th>Password</th><td><input type="password" name="j_password"></td></tr>
        <tr><td colspan="2" align="right"><input type="submit" value="Login"/></td></tr>
    </table>
</form>

<br></br>
<h2>Search users</h2>
<form action="searchuser.jsp" method="post">
    <table>
        <tr><th>Enter the name</th><td><input type="text" name="searchname"></td></tr>
        <tr><td colspan="2" align="right"><input type="submit" value="Search"/></td></tr>
    </table>
</form>

<div id="navigation">
 <br></br>
 <a href="browsepublic.jsp">Visitor </a>|
 <a href="activity.jsp">Top 10 active user </a>|
 <a href="newuser2.jsp">Register </a>
</div>




</body>
</html>
