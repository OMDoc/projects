/*
 * Created on Apr 18, 2005
 *
 * A class that acts as a Servlet and parses a given OMDOC style
 * document.
 */

package omgeo;

import java.io.*;

import javax.servlet.* ;
import javax.servlet.http.* ;

/**
 * @author Alexandru CHITEA
 *
 * @version 1.0
 * 
 */
public class OMGeoParserServlet extends HttpServlet {
	
	public OMGeoBean omgeoBean = new OMGeoBean() ;

	public void doGet(HttpServletRequest req, HttpServletResponse res)
		throws ServletException, IOException {

		res.setContentType("text/html") ;
		PrintWriter out = res.getWriter() ;

		String fileName = req.getParameter("filename") ;
				
		try {				    	
	    	OMGeoParser parser = new OMGeoParser();	    		    		    		    		    	
	    	omgeoBean = parser.parseOMGeo(fileName) ;
	    	
	    	req.setAttribute("omgeoBean",omgeoBean);
			getServletConfig().getServletContext().getRequestDispatcher
	                      ("/omgeo.jsp").forward(req, res);
	    }	    	    
	    catch (IOException e) {
	    	System.out.println("I/O error: " + e);
	    }		    
	} 
		
	public String getServletInfo() {

		return "Parser Servlet" ;
	}	
}
