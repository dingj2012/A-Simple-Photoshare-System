<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<html>
<head><title>Add New User</title></head>

<body>

<h2>Register with photoshare</h2>

<form action="adduser.jsp" method="post">
  Email: <input type="text" name="email"/><br>
  Password: <input type="password" name="password1"/><br>
  Re-enter password: <input type="password" name="password2"/><br>
  First Name: <input type="text" name="firstname"/><br>
  Last Name: <input type="text" name="lastname"/><br>
  Date of Birth: <input type="text" name="dob" placeholder="mmddyyyy"/><br> 
  Gender: <input type="checkbox" name="gender_F" value="F">F <input type="checkbox" name="gender_M" value="M"/>M<br> 
  Hometown: <input type="text" name="hometown"/><br>

  <input type="submit" value="Create"/><br/>
</form>

<a href="/photoshare/login.jsp">Back</a>

</body>
</html>
