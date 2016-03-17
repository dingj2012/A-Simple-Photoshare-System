package photoshare;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class PictureDao {
    
    private static final String SAVE_PICTURE_STMT = "INSERT INTO " +
        "Pictures (\"caption\", \"imgdata\", \"thumbdata\", \"size\", \"content_type\", \"ownerid\") VALUES (?, ?, ?, ?, ?, ?) RETURNING picture_id";
    
    private static final String SAVE_ALBUMHAS_STMT = "INSERT INTO AlbumHas (albumid, pictureid) VALUES (?, ?)";
    
    public void save(Picture picture, int albumid, int ownerid) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int picid = 0; 
        
        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(SAVE_PICTURE_STMT);
            stmt.setString(1, picture.getCaption());
            stmt.setBytes(2, picture.getData());
            stmt.setBytes(3, picture.getThumbdata());
            stmt.setLong(4, picture.getSize());
            stmt.setString(5, picture.getContentType());
            stmt.setInt(6, ownerid);
            rs = stmt.executeQuery();
            while (rs.next()) {
                picid = rs.getInt(1);
            }
            
            stmt.close();
            stmt = null;
            
            stmt = conn.prepareStatement(SAVE_ALBUMHAS_STMT);
            stmt.setInt(1, albumid);
            stmt.setInt(2, picid); 
            stmt.executeUpdate();
            
            stmt.close();
            stmt = null;
            
            conn.close();
            conn = null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } 
        finally {
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException e) { ; }
                stmt = null;
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { ; }
                conn = null;
            }
        }
    }
    
    private static final String DELETE_FROM_PICTURES_STMT = "DELETE FROM Pictures WHERE picture_id = ?";
    private static final String DELETE_FROM_ALBUMHAS_STMT = "DELETE FROM AlbumHas WHERE pictureid = ?";
    private static final String DELETE_FROM_COMMENTS_STMT = "DELETE FROM Comments WHERE photoid = ?";
    
    public void delete(int picid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            
            PreparedStatement s0 = conn.prepareStatement(DELETE_FROM_COMMENTS_STMT);
            s0.setInt(1, picid);
            s0.executeUpdate();
            s0.close();
            
            PreparedStatement s2 = conn.prepareStatement(DELETE_FROM_ALBUMHAS_STMT);
            s2.setInt(1, picid);
            s2.executeUpdate();
            s2.close();
            
            PreparedStatement stmt = conn.prepareStatement(DELETE_FROM_PICTURES_STMT);
            stmt.setInt(1, picid);
            stmt.executeUpdate();
            stmt.close();
            
            conn.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String LOAD_PICTURE_STMT = "SELECT " +
        "\"caption\", \"imgdata\", \"thumbdata\", \"size\", \"content_type\" FROM Pictures WHERE \"picture_id\" = ?";
    
    public Picture load(int id) {
        PreparedStatement stmt = null;
        Connection conn = null;
        ResultSet rs = null;
        Picture picture = null;
        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(LOAD_PICTURE_STMT);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();
            if (rs.next()) {
                picture = new Picture();
                picture.setId(id);
                picture.setCaption(rs.getString(1));
                picture.setData(rs.getBytes(2));
                picture.setThumbdata(rs.getBytes(3));
                picture.setSize(rs.getLong(4));
                picture.setContentType(rs.getString(5));
            }
            
            rs.close();
            rs = null;
            
            stmt.close();
            stmt = null;
            
            conn.close();
            conn = null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) { ; }
                rs = null;
            }
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException e) { ; }
                stmt = null;
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { ; }
                conn = null;
            }
        }
        
        return picture;
    }

    
 private static final String GET_TAGS_FROM_PIC_STMT = "SELECT "+
  "tag FROM Tags WHERE pictureid = ? ";
 
 public List<TagBean> getTagsFromPic(int pid) throws SQLException {
  try {
   Connection conn = DbConnection.getConnection();
              PreparedStatement stmt = conn.prepareStatement(GET_TAGS_FROM_PIC_STMT);
              stmt.setInt(1, pid);
              ResultSet rs = stmt.executeQuery();
   
   List<TagBean> buffer = new ArrayList<TagBean>();
   
   while (rs.next()) {
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



    
    
    private static final String USERS_PICTURE_IDS_STMT = "SELECT picture_id FROM Pictures WHERE ownerid = ?";

    public List<Integer> yourPictureIds(int userid) throws SQLException {
        
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(USERS_PICTURE_IDS_STMT);
            stmt.setInt(1, userid);
            ResultSet rs = stmt.executeQuery();
            
            List<Integer> picturesIds = new ArrayList<Integer>();
            
            while (rs.next()) {
                picturesIds.add(rs.getInt(1));
            }
            
            rs.close();
            conn.close();
            stmt.close();
            
            return picturesIds;
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        
    }
    
    private static final String ALL_PICTURE_IDS_STMT = "SELECT \"picture_id\" FROM Pictures ORDER BY \"picture_id\" DESC";
    
    public List<Integer> allPicturesIds() { 
        PreparedStatement stmt = null;
        Connection conn = null;
        ResultSet rs = null;
        
        List<Integer> picturesIds = new ArrayList<Integer>();
        try {
            conn = DbConnection.getConnection();
            stmt = conn.prepareStatement(ALL_PICTURE_IDS_STMT);  
            rs = stmt.executeQuery();
            while (rs.next()) {
                picturesIds.add(rs.getInt(1));
            }
            
            rs.close();
            rs = null;
            
            stmt.close();
            stmt = null;
            
            conn.close();
            conn = null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) { ; }
                rs = null;
            }
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException e) { ; }
                stmt = null;
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { ; }
                conn = null;
            }
        }
        return picturesIds;
    }
}
