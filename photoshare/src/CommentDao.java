package photoshare;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

public class CommentDao {
    private static final String ADD_COMMENT_STMT = "INSERT " +
        "INTO Comments (ownerid, photoid, text, dateofcomment) VALUES (?, ?, ?, now())";
    
    public boolean create(int ownerid, int photoid, String text) {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(ADD_COMMENT_STMT); 
            stmt.setInt(1, ownerid); 
            stmt.setInt(2, photoid);
            stmt.setString(3, text);
            
            stmt.executeUpdate();
            
            stmt.close();
            conn.close();
            
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    private static final String ANON_COMMENT_STMT = "INSERT " +
        "INTO Comments (text, photoid, ownername, ownerid, dateofcomment) VALUES (?,?, 'Anonymous', 2, now())";

    public boolean Acreate(String text, int photoid) {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(ANON_COMMENT_STMT);
            stmt.setString(1, text);
     stmt.setInt(2, photoid);

            stmt.executeUpdate();

            stmt.close();
            conn.close();

            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    
    private static final String COUNT_LIKES = "SELECT " +
        "COUNT(text) FROM Comments "+
        "WHERE text='liketoken' AND photoid = ?";
    
    public int countLikes(int photoid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection(); 
            PreparedStatement stmt = conn.prepareStatement(COUNT_LIKES); 
            
            stmt.setInt(1, photoid);
            ResultSet rs = stmt.executeQuery();
            rs.next();
            
            int numLikes = rs.getInt(1);
            
            stmt.close();
            conn.close();
            
            return numLikes;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    private static final String LOAD_COMMENTS_STMT = "SELECT "+
        "ownerid, text, dateofcomment FROM Comments WHERE photoid = ?";
    
    public List<CommentBean> getCommentsofPicture(int photoid) {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(LOAD_COMMENTS_STMT);
            stmt.setInt(1, photoid);
            ResultSet rs = stmt.executeQuery();
            
            List<CommentBean> ret = new ArrayList<CommentBean>();
            while (rs.next()) {
                CommentBean a = new CommentBean();
                if (!rs.getString(2).equals("liketoken")) { 
                    a.setOwnerid(rs.getInt(1));
                    a.setText(rs.getString(2));
                    a.setDateofcomment(rs.getDate(3));
                    
                    ret.add(a);
                }
            }
            rs.close();
            stmt.close();
            conn.close();
            
            return ret; 
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
} // end
