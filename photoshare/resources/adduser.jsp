<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.NewUserDao" %>

<html>
<head><title>Adding New User</title></head>

<body>

<% 
  String err = null; 
  String firstname = request.getParameter("firstname");
  String lastname = request.getParameter("lastname");
  String email = request.getParameter("email"); 
  String password1 = request.getParameter("password1");
  String password2 = request.getParameter("password2");
  String dob = request.getParameter("dob"); 
  String female = request.getParameter("gender_F");
  String male = request.getParameter("gender_M");
  String hometown = request.getParameter("hometown");


   if (!email.equals("")) { 

     if (!password1.equals(password2)) { 
       err = "Both password strings must match";
     }
     else if (password1.length() < 4) {
       err = "Your password must be at least four characters long";
     } 

    else if (firstname.equals("") || lastname.equals("")) { 
      err = "Please enter your full name";
    }
    else if (dob == null) { 
      err = "please provide your date of birth";
    }

    else if (dob.length() != 8) {
      err = "dob formatted incorrectly";
    }
     else {
       NewUserDao newUserDao = new NewUserDao(); 
       String gender = null;
       if (female != null) { gender = female; } 
       else { gender = male; }
       
       boolean success = newUserDao.create(email, password1, firstname, lastname, dob, gender, hometown); 
       if (!success) {
         err = "Couldn't create user (that email may already be in use)";
       }
     }
   } else {
  err = "You have to provide an email";

   }

%>

<% if (err != null) { %>
<font color=red><b>Error: <%= err %></b></font>
<p> <a href="newuser2.jsp">Go Back</a>
<% }
   else { %>

<h2>Success!</h2>

<p>A new user has been created with email <%= email %>.
You can now return to the <a href="login.jsp">login page</a>.

<% } %>

</body>
</html>
