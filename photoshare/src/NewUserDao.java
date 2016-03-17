package photoshare;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class NewUserDao {
    
    private static final String CHECK_EMAIL_STMT = "SELECT " +
        "COUNT(*) FROM Users WHERE email = ?";
    
    private static final String NEW_USER_STMT = "INSERT INTO " +
        "Users (email, password, firstname, lastname, dob, gender, hometown) VALUES (?, ?, ?, ?, ?, ?, ?)";
    
    public boolean create(String email, String password, String firstname, String lastname, String dob, String gender, String hometown) {
        PreparedStatement stmt = null; 
        Connection conn = null; 
        ResultSet rs = null; 
        try {
            conn = DbConnection.getConnection(); 
            stmt = conn.prepareStatement(CHECK_EMAIL_STMT); 
            stmt.setString(1, email); 
            rs = stmt.executeQuery(); 
            if (!rs.next()) {
                return false;
            }
            int result = rs.getInt(1); 
            if (result > 0) {
                return false; 
            }
            
            try { stmt.close(); }
            catch (Exception e) { }
            
            stmt = conn.prepareStatement(NEW_USER_STMT);
            stmt.setString(1, email);
            stmt.setString(2, password);
            stmt.setString(3, firstname);
            stmt.setString(4, lastname);
            stmt.setString(5, dob);
            stmt.setString(6, gender);
            stmt.setString(7, hometown);
            
            stmt.executeUpdate();
            
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            if (rs != null) {
                try { rs.close(); }
                catch (SQLException e) { ; }
                rs = null;
            }
            
            if (stmt != null) {
                try { stmt.close(); }
                catch (SQLException e) { ; }
                stmt = null;
            }
            
            if (conn != null) {
                try { conn.close(); }
                catch (SQLException e) { ; }
                conn = null;
            }
        }
    }
    
    private static final String GET_LIKERS_STMT = "SELECT " +
        "ownerid FROM Comments WHERE text='liketoken' AND photoid = ?";
    
    public List<Integer> getLikersIds(int pictureid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            
            PreparedStatement stmt = conn.prepareStatement(GET_LIKERS_STMT);
            stmt.setInt(1, pictureid);
            ResultSet rs = stmt.executeQuery();
            
            List<Integer> likers = new ArrayList<Integer>();
            while (rs.next()) {
                likers.add(rs.getInt(1));
            }
            
            stmt.close();
            rs.close();
            conn.close();
            
            return likers; 
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String SEARCH_USER_STMT = "SELECT " +
        "user_id FROM Users "+
        "WHERE firstname = ? OR lastname = ?"; 
    
    
    public List<NewUserBean> searchUserIds(String searchname) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            
            PreparedStatement stmt = conn.prepareStatement(SEARCH_USER_STMT);
            stmt.setString(1, searchname);
            stmt.setString(2, searchname);
            ResultSet rs = stmt.executeQuery();
            
            List<NewUserBean> buffer = new ArrayList<NewUserBean>();
            while (rs.next()) {
                NewUserBean a = new NewUserBean();
                a.setUserid(rs.getInt(1));
                buffer.add(a);
            }
            
            stmt.close();
            rs.close();
            conn.close();
            
            return buffer;
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    
    private static final String GET_TOP_ACTIVE_STMT = "SELECT "+
        "ownerid, activity FROM "+
        "(SELECT temp1.ownerid, coalesce(ccount,0)+coalesce(pcount,0) "+
        "AS activity FROM "+
        "(SELECT buffer.ownerid, COUNT(commentid) as ccount "+
        "FROM Comments buffer group by buffer.ownerid) "+
        "AS temp1 FULL OUTER JOIN (select p.ownerid, count(picture_id)" +
        "AS pcount from pictures AS p GROUP BY p.ownerid) "+
        "AS temp2 ON temp1.ownerid = temp2.ownerid) "+
        "AS temp ORDER BY activity DESC";
    
    public List<NewUserBean> getTopActive() throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            
            PreparedStatement stmt = conn.prepareStatement(GET_TOP_ACTIVE_STMT);
            ResultSet rs = stmt.executeQuery();
            
            List<NewUserBean> topcontribs = new ArrayList<NewUserBean>();
            
            int i = 0;
            while (rs.next() && i < 10) {
                NewUserBean a = new NewUserBean();  
                a.setUserid(rs.getInt(1));
                a.setActivity(rs.getInt(2));
                
                topcontribs.add(a);
                i++;
            }
            
            stmt.close();
            rs.close();
            conn.close();
            
            return topcontribs; 
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String MAY_LIKE = "SELECT t.tag "+ 
        "FROM (SELECT picture_id FROM Pictures WHERE ownerid = ?) AS ptemp, Tags AS t "+
        "WHERE ptemp.picture_id = t.pictureid " +
        "GROUP BY t.tag " + 
        "ORDER BY COUNT(*) DESC";
    
    public List<TagBean> mayLike(int user_id) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(MAY_LIKE);
            stmt.setInt(1,user_id);
            ResultSet rs = stmt.executeQuery();
            
            List<TagBean> buffer = new ArrayList<TagBean>();
            
            int i = 0;
            while (rs.next() && i < 5) {
                TagBean a = new TagBean();
                a.setTag(rs.getString(1));
                
                buffer.add(a);
            }
            
            stmt.close();
            rs.close();
            conn.close();
            
            return buffer;
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String GET_NAME_STMT = "SELECT "+
        "firstname, lastname FROM Users WHERE user_id = ?";
    
    public String getFullNameFromId(int userid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_NAME_STMT);
            stmt.setInt(1, userid);
            
            ResultSet rs = stmt.executeQuery(); 
            
            rs.next();
            String fname = rs.getString(1);
            String lname = rs.getString(2);
            
            String fullname = fname + " " + lname;
            
            rs.close(); 
            stmt.close(); 
            conn.close(); 
            
            return fullname; 
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    
    private static final String GET_ID_FROM_EMAIL_STMT = "SELECT user_id FROM users WHERE email = ?";
    
    public int getidFromEmail(String useremail) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_ID_FROM_EMAIL_STMT);
            stmt.setString(1, useremail);
            
            ResultSet rs = stmt.executeQuery(); 
            
            rs.next();
            int userid = rs.getInt(1);
            
            rs.close(); 
            stmt.close(); 
            conn.close();
            
            return userid;  
            
        } catch (SQLException e) { 
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String GET_EMAIL_FROM_ID_STMT = "SELECT email FROM users WHERE user_id = ?";
    
    public String getEmailFromId(int user_id) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_EMAIL_FROM_ID_STMT);
            stmt.setInt(1, user_id);
            
            ResultSet rs = stmt.executeQuery();
            
            rs.next();
            String email = rs.getString(1);
            
            rs.close();
            stmt.close();
            conn.close();
            
            return email;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    
    
    private static final String GET_USERS_FRIENDS = "SELECT user2 FROM Friends WHERE user1 = ?";
    
    private static final String GET_FRIEND_INFO = "SELECT firstname, lastname, email FROM Users where user_id = ?";
    
    public List<NewUserBean> loadUsersFriends(int userid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_USERS_FRIENDS);
            stmt.setInt(1, userid);
            
            ResultSet rs = stmt.executeQuery(); 
            
            
            List<NewUserBean> buffer = new ArrayList<NewUserBean>();
            
            while (rs.next()) { 
                PreparedStatement s2 = conn.prepareStatement(GET_FRIEND_INFO); 
                s2.setInt(1, rs.getInt(1));  
                ResultSet friendsinfo = s2.executeQuery(); 
                
                while (friendsinfo.next()) { 
                    NewUserBean a = new NewUserBean();
                    a.setFirstname(friendsinfo.getString(1)); 
                    a.setLastname(friendsinfo.getString(2)); 
                    a.setEmail(friendsinfo.getString(3)); 
                    
                    buffer.add(a); 
                }
            }
            rs.close();  
            stmt.close();  
            conn.close(); 
            
            return buffer; 
            
        } catch (SQLException e) { 
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String DISPLAY_ALL_USERS = "SELECT firstname, lastname, email, user_id FROM Users";
    
    public List<NewUserBean> loadAllUsers(int userid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(DISPLAY_ALL_USERS);
            ResultSet rs = stmt.executeQuery();
            
            List<NewUserBean> buffer = new ArrayList<NewUserBean>();
            
            while (rs.next()) {
                if (rs.getInt(4) != userid) {
                    NewUserBean a = new NewUserBean();
                    a.setFirstname(rs.getString(1));
                    a.setLastname(rs.getString(2));
                    a.setEmail(rs.getString(3));
                    
                    buffer.add(a);
                }
                
            }
            
            rs.close();
            stmt.close();
            conn.close();
            return buffer;
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String DELETE_FRIEND = "DELETE FROM Friends WHERE user1 = ? AND user2 = ?";
    
    public void deleteFriend(int userid, int friendid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(DELETE_FRIEND);
            stmt.setInt(1, userid);
            stmt.setInt(2, friendid);
            
            stmt.executeUpdate();
            
            stmt.close();
            conn.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    
    private static final String ADD_FRIEND = "INSERT INTO Friends (user1, user2) VALUES (?, ?)";
    
    public void addFriend(int userid, int friendid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(ADD_FRIEND);
            stmt.setInt(1, userid);
            stmt.setInt(2, friendid);
            
            stmt.executeUpdate();
            
            stmt.close();
            conn.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
}
