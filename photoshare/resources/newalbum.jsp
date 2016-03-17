<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head><title>Create a new Album</title></head>

<!-- the user interface page to create an album -->
<body>

<div id="navigation">
<a href="index.jsp">Go back</a><br>
</div>

<h2>Create a new album</h2>

<form action="addalbum.jsp" method="post">
  Name: <input type="text" name="albumname"/><br>
  <input type="submit" value="Create"/><br/>
</form>


</body>
</html>
