/*
 * Created on Apr 23, 2005
 *
 * A class used for parsing purposes. Given a file 
 * it returns a parsed output. 
 */
package omgeo ;


import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.xpath.XPathAPI;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * @author Alexandru CHITEA
 *
 * @version 1.0
 */
public class OMGeoParser {
	
	  public OMGeoBean dataBean = new OMGeoBean() ;
			
	  public OMGeoBean parseOMGeo(String fileName) {
	  		  			  	
		  	File docFile = new File(fileName);
		  	Document doc = null;
		  	OMGeoLayer []  layers = new OMGeoLayer[100];
		  	
	    
		  	// Parse the file
		  	try {
		  		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		  		DocumentBuilder db = dbf.newDocumentBuilder();
		  		doc = db.parse(docFile);
		  	} 
		  	catch (Exception e) {
		  		System.out.print("Problem parsing the file [" + fileName + "].\n" );
		  	}
		  	
		  	// Get the Document's root element	  	
		  	Element root = doc.getDocumentElement();	  	
	    
		  	try {		  		
		  		
		  		dataBean.setOmgeoUri(findValue(root,"/omdoc/theory/omgeoMap/omgeoURI")) ;
		  		
		  		dataBean.setOmgeoVersion(findValue(root,"/omdoc/theory/omgeoMap/omgeoVersion"));
		  		
		  		dataBean.setOmgeoService(findValue(root,"/omdoc/theory/omgeoMap/omgeoService"));
		  		
		  		dataBean.setOmgeoRequest(findValue(root,"/omdoc/theory/omgeoMap/omgeoRequest"));
		  		
		  		dataBean.setMapWidth(findValue(root,"/omdoc/theory/omgeoMap/mapWidth"));
		  		
		  		dataBean.setMapHeight(findValue(root,"/omdoc/theory/omgeoMap/mapHeight"));
		  		
		  		dataBean.setMapFormat(findValue(root,"/omdoc/theory/omgeoMap/mapFormat"));
		  		
		  		dataBean.setMapExceptions(findValue(root,"/omdoc/theory/omgeoMap/mapExceptions"));
		  		
		  		NodeList nlLayer = XPathAPI.selectNodeList(root,"/omdoc/theory/type/OMOBJ/OMA/OMA");	  		
		  		NodeList nlOMS = XPathAPI.selectNodeList(root,"/omdoc/theory/type/OMOBJ/OMA/OMA/OMS/@name");
		  		NodeList nlOMSCD = XPathAPI.selectNodeList(root,"/omdoc/theory/type/OMOBJ/OMA/OMA/OMS/@cd");
		  		NodeList nlOMI = XPathAPI.selectNodeList(root,"/omdoc/theory/type/OMOBJ/OMA/OMA/OMA/OMI");
		  		NodeList nlOMSTR = XPathAPI.selectNodeList(root,"/omdoc/theory/type/OMOBJ/OMA/OMA/OMA/OMSTR");
		  		NodeList nlOMF = XPathAPI.selectNodeList(root,"/omdoc/theory/type/OMOBJ/OMA/OMA/OMA/OMF/@dec");
		  		
		  		for(int i = 0; i < nlLayer.getLength() ; i++) 
		  			layers[i] = new OMGeoLayer() ;		  				  				  		
		  		
		  		int counter = 0 ;	  			  			  		
		  		
		  		for(int i = 0; i < nlLayer.getLength(); i++) {	  			
		  			layers[i].layerType = getTextContents(nlOMS.item(counter++));	  			
		  			layers[i].layerElement = getTextContents(nlOMS.item(counter++));
		  		}
		  		counter = 0 ;
		  		
		  		for(int i = 0; i < nlLayer.getLength(); i++) {
		  			layers[i].layerResolution = getTextContents(nlOMI.item(counter)) ;
		  			counter = counter + 4 ;
		  		}
		  		counter = 0;	  		
		  		
		  		for(int i = 0; i < nlLayer.getLength(); i++) {
		  			String[] tempStyle = new String[4];	  			
		  			layers[i].layerSRS = getTextContents(nlOMSTR.item(counter++)) ;
		  			tempStyle[1] = getTextContents(nlOMSTR.item(counter++)) ;
		  			tempStyle[2] = getTextContents(nlOMSTR.item(counter++)) ;
		  			tempStyle[3] = getTextContents(nlOMSTR.item(counter++)) ;
		  			layers[i].layerStyle = tempStyle ;
		  		}
		  		counter = 0;
		  		
		  		for(int i = 0; i < nlLayer.getLength(); i++) {
		  			String[] tempBB = new String[5];
		  			counter = counter + 4 ;
		  			tempBB[1] = getTextContents(nlOMF.item(counter++)) ;
		  			tempBB[2] = getTextContents(nlOMF.item(counter++)) ;
		  			tempBB[3] = getTextContents(nlOMF.item(counter++)) ;
		  			tempBB[4] = getTextContents(nlOMF.item(counter++)) ;
		  			layers[i].layerBB = tempBB ;
		  		}
		  		
		  		counter = 0 ;
		  		
		  		for(int i = 0; i < nlLayer.getLength(); i++) {	  			
		  			counter++ ;	  			
		  			layers[i].layerCD = getTextContents(nlOMSCD.item(counter++)) ;
		  		}
		  		
		  		counter = 0 ;
		  		dataBean.setMapLayers(layers) ;		  		
		  	} 
		  	catch (Exception e) {
		  		System.out.println( "Exception: " + e );
		  	}
	  		  		  	
	  	return dataBean ;
	  }
  
	/**
	   * Returns the contents of all immediate child text nodes, can strip whitespace
	   * <p>
	   * Takes a node as input and merges all its immediate text nodes into a
	   * string.  If the strip whitespace flag is set, whitespace at the beggining
	   * and end of each merged text node will be removed
	   *
	   * @param node                     node to extract text contents of
	   * @param b_strip_whitespace    flag to set whitespace removal
	   * @return                        string containing text contents of the node 
	   **/
	  public static String getTextContents (Node node) {
	  	
	    NodeList childNodes;
	    StringBuffer contents = new StringBuffer();
	    
	    childNodes =  node.getChildNodes();
	    
	    for(int i=0; i < childNodes.getLength(); i++ )    	
	      if( childNodes.item(i).getNodeType() == Node.TEXT_NODE )
	      	contents.append(childNodes.item(i).getNodeValue());    
	    
	    return contents.toString();
	    
	  } //end getTextContents(Node)

	  /**
	   * Returns the text contents of the first node mathcing an XPath expression 
	   * <p>
	   * Takes a context node and an xpath expression and finds a matching
	   * node. The text contents of this node are returned as a string
	   *
	   * @param node    context node at which to eval xpath                  
	   * @param xql   XPath expression  
	   * @return       Text contents of matching node
	   **/
	  public static String findValue(Node node, String xql) 
	  	throws Exception {

	  	if( (xql == null) || (xql.length() == 0) ) {
	      throw new Exception("findValue called with empty xql statement");
	    }

	    if(node == null) {
	      throw new Exception("findValue called with null node");
	    }        
	            
	    return getTextContents(XPathAPI.selectSingleNode(node,xql)) ;
	    
	  } //end findValue(Node,String)	  	  
	  
	  public static void main(String args[]) {
	  	//TODO: Add extrainitialization here
	  }	  	    
}