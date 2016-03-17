package photoshare;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.ArrayList;
import java.sql.Date;


public class AlbumDao {
    
    private static final String NEW_ALBUM_STMT = "INSERT " +
        "INTO Albums (ownerid, name, dateofcreation) VALUES (?, ?, now())";
    
    public boolean create(int ownerid, String name) { 
        PreparedStatement stmt = null; 
        Connection conn = null; 
        try {
            conn = DbConnection.getConnection(); 
            stmt = conn.prepareStatement(NEW_ALBUM_STMT); 
            stmt.setInt(1, ownerid); 
            stmt.setString(2, name);
            
            stmt.executeUpdate(); 
            
            stmt.close();
            conn.close();
            
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
    
    private static final String GET_PICS_OF_ALBUM_STMT = "SELECT "+
        "pictureid FROM AlbumHas WHERE albumid = ?";
    
    public List<Integer> getPicIdsofAlbum(int albumid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(GET_PICS_OF_ALBUM_STMT);
            stmt.setInt(1, albumid); 
            ResultSet rs = stmt.executeQuery(); 
            
            List<Integer> buffer = new ArrayList<Integer>();
            while (rs.next()) {
                buffer.add(rs.getInt(1));
            }
            
            rs.close();stmt.close();conn.close();
            
            return buffer;
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String LOAD_USERS_ALBUMS_STMT = "SELECT " + 
        "\"albumid\", \"ownerid\", \"name\", \"dateofcreation\" " +
        "FROM Albums WHERE \"ownerid\" = ?";
    
    public List<AlbumBean> loadUsersAlbums(int ownerid) throws SQLException {
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(LOAD_USERS_ALBUMS_STMT);
            stmt.setInt(1, ownerid); 
            ResultSet rs = stmt.executeQuery(); 
            List<AlbumBean> buffer = new ArrayList<AlbumBean>();
            
            while (rs.next()) {
                AlbumBean a = new AlbumBean();
                a.setAlbumid(rs.getInt(1));
                a.setOwnerid(rs.getInt(2));
                a.setName(rs.getString(3));
                a.setDateofcreation(rs.getDate(4));
                
                buffer.add(a);
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
    
    private static final String DELETE_FROM_ALBUMHAS_STMT = "DELETE FROM AlbumHas WHERE albumid = ?";
    private static final String DELETE_FROM_ALBUM_STMT = "DELETE FROM Albums WHERE albumid = ?";
    private static final String DELETE_FROM_PICTURES_STMT = "DELETE FROM Pictures WHERE picture_id = ?";
    private static final String DELETE_FROM_COMMENTS_STMT = "DELETE FROM Comments WHERE photoid = ?";
    
    public void deleteAlbum(Integer albumid) throws SQLException {
        try {
            
            Connection conn = DbConnection.getConnection();
            
            List<Integer> picidsinalbum = new ArrayList<Integer>();
            picidsinalbum = getPicIdsofAlbum(albumid); 
            
            PreparedStatement h = conn.prepareStatement(DELETE_FROM_ALBUMHAS_STMT);
            h.setInt(1, albumid);
            h.executeUpdate();
            h.close();
            
            PreparedStatement m = conn.prepareStatement(DELETE_FROM_COMMENTS_STMT);
            PreparedStatement g = conn.prepareStatement(DELETE_FROM_PICTURES_STMT);
            for (Integer picid : picidsinalbum) {
                m.setInt(1, picid);
                m.executeUpdate();
                g.setInt(1, picid); 
                g.executeUpdate();
            }
            m.close();
            g.close();
            
            PreparedStatement stmt = conn.prepareStatement(DELETE_FROM_ALBUM_STMT);
            stmt.setInt(1, albumid);
            stmt.executeUpdate();
            stmt.close(); 
            
            conn.close();
        }
        catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    
    private static final String LOAD_ALL_ALBUMS_STMT = "SELECT "+
        "\"albumid\", \"ownerid\", \"name\", \"dateofcreation\" "+
        "FROM Albums ORDER BY \"dateofcreation\" DESC";
    
    public List<AlbumBean> loadAllAlbums() throws SQLException { 
        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(LOAD_ALL_ALBUMS_STMT);
            ResultSet rs = stmt.executeQuery(); 
            
            List<AlbumBean> buffer = new ArrayList<AlbumBean>(); 
            while (rs.next()) { 
                AlbumBean a = new AlbumBean(); 
                a.setAlbumid(rs.getInt(1));
                a.setOwnerid(rs.getInt(2)); 
                a.setName(rs.getString(3));
                a.setDateofcreation(rs.getDate(4));
                
                buffer.add(a); 
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
    
    
} // end