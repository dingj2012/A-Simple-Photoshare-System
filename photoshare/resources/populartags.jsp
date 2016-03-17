<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.TagDao" %>
<%@ page import="photoshare.TagBean" %>
<%@ page import="java.util.List" %>

<html>
<head><title>Popular Tags</title></head>


<body>

<h1>Popular Tags</h1>
<a href="index.jsp">Back</a>

<% 
 TagDao tagdao = new TagDao();
 List<TagBean> poptags = tagdao.getPopularTags();
%>

<br></br>
<table> 

  <tr>
  </tr>

 <% 
  for (TagBean tag : poptags ) {
 %>

  <tr> 
  <td><%= tag.getTag() %></td>
  <td>---</td>
  <td><%= tag.getTagcount() %></td>
  <td>photos used this tag</td>
 </tr>
 <%
  }
 %>
 </table>
