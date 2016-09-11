/*
 * Created on Apr 23, 2005
 *
 * A class used as a storage class for the individual layers
 * characteristics.
 * 
 */
package omgeo;

/**
 * @author Alexandru CHITEA
 *
 * @version 1.0
 */
public class OMGeoLayer {
	
	/** A string that holds the type of a map layer. */
	public String layerType ;
	
	/** A string that holds the resolution of a map layer. */
	public String layerResolution ;
	
	/** A string that holds the Spatial Reference System of a map layer. */
	public String layerSRS ;
	
	/** A string array that holds the bounding box coordinates of a map layer. */
	public String[] layerBB = new String[4];
	
	/** A string array that holds the styles of a map layer. */
	public String[] layerStyle = new String[3];
	
	/** A string that holds the element contained by a map layer. */
	public String layerElement ;
	
	/** A string that holds the Content Dictionary of a map layer. */
	public String layerCD ;
	
	/** Default constructor initializes variables. */
	public OMGeoLayer() {
		layerType = new String() ;
		layerResolution = new String() ;
		layerSRS = new String() ;		
		layerElement = new String() ;
		layerCD = new String() ;
	} // end OMGeoLayer()		
}
