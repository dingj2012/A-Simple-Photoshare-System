<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="photoshare.AlbumDao" %>
<%@ page import="photoshare.TagDao" %>
<%@ page import="photoshare.TagBean" %>
<%@ page import="photoshare.Picture" %>
<%@ page import="photoshare.PictureDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %>

<html>
<head><title>Recommend tag</title></head>


<body>

<h2> Recommend tags</h2>

<% String recomtag = request.getParameter("recomtag"); %>

<%
  List <Picture> all = new ArrayList<Picture>(); 
  for (String eachS : recomtag.split(" ")) {
	TagDao t = new TagDao();
	List<Picture> searchrs = t.searchTag(eachS);
	all.addAll(searchrs);
  }
  
  List<TagBean> al = new ArrayList<TagBean>();
  for (Picture p : all) {
	PictureDao pDao = new PictureDao();
	al.addAll(pDao.getTagsFromPic(p.getId()));
  }
  
  Map <TagBean, Integer> TagCount = new HashMap<TagBean, Integer>();
  
  for(TagBean t: al){
  	Integer c = TagCount.get(t);
  	if(c == null) c = new Integer(0);
  	c++;
  	TagCount.put(t,c);
  }
   
  Map.Entry<TagBean,Integer> mostRepeated = null;
  for(Map.Entry<TagBean, Integer> e: TagCount.entrySet()){
    if(mostRepeated == null || mostRepeated.getValue()<e.getValue())
        mostRepeated = e;
  }
  
%>        

<h1>Tags recommended for you:</h1>
<tr><%= mostRepeated.getKey().getTag() %></tr>



 
<br></br>
<a href="index.jsp">back</a>


</body>
</html>
