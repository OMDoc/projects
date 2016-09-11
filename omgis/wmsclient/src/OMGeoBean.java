/*
 * Created on Apr 19, 2005
 *
 * A bean class used by the OMGeoParserServlet class to manipulate
 * the data parsed from the OMDOC file.
 */
package omgeo;

/**
 * @author Alexandru CHITEA
 *
 * @version 1.0
 */
public class OMGeoBean {
	
	/** A String which holds the uri of the desired WMS (Web Map Service) service.*/
	public String omgeoUri ;
	
	/** A String which holds the version of the desired WMS (Web Map Service) service.*/
	public String omgeoVersion ;
	
	/** A String which holds the service type of the desired WMS (Web Map Service) 
	 * service. */
	public String omgeoService ;
	
	/** A String which holds the request of the desired WMS (Web Map Service) 
	 * service.*/
	public String omgeoRequest ;
	
	/** A String which holds the width of the desired map.*/	 
	public String mapWidth ;
	
	/** A String which holds the heigth of the desired map.*/
	public String mapHeight ;
	
	/** A String which holds the heigth of the desired map.*/
	public String mapFormat ;
	
	/** A String which holds the exceptions that apply to the desired map.*/
	public String mapExceptions ;
		
	/** An OMGeoLayer object array that holds the layers of a map */   
	public OMGeoLayer[]  mapLayers = new OMGeoLayer[100] ;		
	
	//
	// Constructors
	//
	
	/** Default constructor initializes all variables with default values.*/
	public OMGeoBean() {		
		omgeoUri = "" ;
		omgeoVersion = "" ;
		omgeoService = "" ;
		omgeoRequest = "GetCapabilities" ;
		mapWidth = "400" ;
		mapHeight = "400" ;
		mapFormat = "image/jpeg" ;
		mapExceptions = "application/vnd.ogc.se_inimage" ;
	} // end OMGeoBean()
	
	//
	// Public methods
	//			
	
	/** A method that sets a new value for omgeoUri.*/
	public void setOmgeoUri(String newURI) {
		omgeoUri = newURI ;
	} // end setOmgeoUri()
	
	/** A method that gets the value of omgeoUri.*/
	public String getOmgeoUri() {
		return omgeoUri ;			
	} //end getOmgeoUri()
	
	/** A method that sets the value of omgeoVersion.*/
	public void setOmgeoVersion(String newVersion) {
		omgeoVersion = newVersion ;
	} // end setOmgeoVersion()
	
	/** A method that gets the value of omgeoVersion.*/
	public String getOmgeoVersion() {
		return omgeoVersion ;			
	} // end getOmgeoVersion()
	
	/** A method that sets the value of omgeoService.*/
	public void setOmgeoService(String newService) {
		omgeoService = newService ;
	} // end setOmgeoService()
	
	/** A method that gets the value of omgeoService.*/
	public String getOmgeoService() {
		return omgeoService ;			
	} // end getOmgeoService()
	
	/** A method that sets the value of omgeoRequest.*/
	public void setOmgeoRequest(String newRequest) {
		omgeoRequest = newRequest ;
	} // end setOmgeoRequest()
	
	/** A method that gets the value of omgeoService.*/
	public String getOmgeoRequest() {
		return omgeoRequest ;			
	} // end getOmgeoRequest()
	
	/** A method that sets the value of mapWidth.*/
	public void setMapWidth(String newWidth) {
		mapWidth = newWidth ;
	} // end setMapWidth()
	
	/** A method that gets the value of mapWidth.*/
	public String getMapWidth() {
		return mapWidth ;
	} // end getMapWidth()
	
	/** A method that sets the value of mapHeight.*/
	public void setMapHeight(String newHeight) {
		mapHeight = newHeight ;
	} // end setMapHeight()
	
	/** A method that gets the value of mapHeight.*/
	public String getMapHeight() {
		return mapHeight ;
	} // end getMapHeight()
	
	/** A method that sets the value of mapFormat.*/
	public void setMapFormat(String newFormat) {
		mapFormat = newFormat ;
	} // end setMapFormat()
	
	/** A method that gets the value of mapFormat.*/
	public String getMapFormat() {
		return mapFormat ;
	} // end getMapFormat()
	
	/** A method that sets the value of mapExceptions.*/
	public void setMapExceptions(String newExceptions) {
		mapExceptions = newExceptions ;
	} // end setMapExceptions()
	
	/** A method that gets the value of mapExceptions.*/
	public String getMapExceptions() {
		return mapExceptions ;
	} // end getMapExceptions()
	
	/** A method that sets the value of mapLayers.*/
	public void setMapLayers(OMGeoLayer[] newMapLayers) {
		mapLayers = newMapLayers ;
	} //end setMapLayers(OMGeoLayer[])
	
	/** A method that gets the value of mapLayers.*/
	public OMGeoLayer[] getMapLayers() {
		return mapLayers ;
	} //end getMapLayers()
}