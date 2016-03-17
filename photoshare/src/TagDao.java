package photoshare;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date; 
import java.util.Arrays;


public class TagDao {
    private static final String CREATE_TAG = "INSERT INTO Tags (pictureid, tag) VALUES (?, ?)";
    
    public boolean createTag(int picid, String tag) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(CREATE_TAG);
            
            List<String> tokens = Arrays.asList(tag.split("\\stmt*,\\stmt*")); 
            
            for (String onetag : tokens) { 
                stmt.setInt(1, picid);
                stmt.setString(2, tag);
                stmt.executeUpdate();
            }
            
            stmt.close();
            conn.close();
            
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    
    private static final String GET_MOST_POPULAR_TAGS = "SELECT " +
        "tag, COUNT(pictureid) AS tagcount FROM Tags GROUP BY tag ORDER BY tagcount DESC";
    
    public List<TagBean> getPopularTags() throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_MOST_POPULAR_TAGS);
            ResultSet rs = stmt.executeQuery();
            
            List<TagBean> buffer = new ArrayList<TagBean>();
            while (rs.next()) {
                TagBean a = new TagBean();
                a.setTag(rs.getString(1));
                a.setTagcount(rs.getInt(2));
                buffer.add(a);
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
            return buffer; 
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    private static final String SEARCH_TAG_STMT = "SELECT "+
        "pictureid FROM Tags WHERE tag =?";
    
    
    public List<Picture> searchTag(String tag) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(SEARCH_TAG_STMT);
            stmt.setString(1, tag);
            ResultSet rs = stmt.executeQuery();
            
            List<Picture> buffer = new ArrayList<Picture>();
            while (rs.next()) {
                Picture a = new Picture();
                a.setId(rs.getInt(1));
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
    
    
    
    
    private static final String GET_TAGS_OF_PIC = "SELECT tag FROM Tags WHERE pictureid = ?";
    
    public List<String> getTagsOfPicid(int picid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_TAGS_OF_PIC);
            stmt.setInt(1, picid);
            ResultSet rs = stmt.executeQuery();
            
            List<String> buffer = new ArrayList<String>();
            while (rs.next()) {
                if (rs.getString(1) != null) { 
                    buffer.add(rs.getString(1));
                }
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
            return buffer; 
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    
} // end
