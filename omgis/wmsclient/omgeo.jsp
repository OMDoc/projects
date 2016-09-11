<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="omgeo.OMGeoLayer" %>
<html>
<head>
<title>OMGeo WMS Client</title>
<LINK href="../common/styles/common.css" type=text/css rel=stylesheet>
<style type="text/css">
<!--
.style1 {
	color: #003300;
	font-weight: bold;
	font-size: 24px;
}
.style3 {color: #FFFFFF}
-->
</style>
</head>

<body style="margin:0px;">

<jsp:useBean id="omgeoBean" class="omgeo.OMGeoBean" scope="request" />
<%	
	String serverReq = "" ;
	StringBuilder sb = new StringBuilder() ;

	StringBuilder strMapLayers = new StringBuilder() ;
	String[] layers = new String[100] ;
	String layersSQL = new String() ;

	String srsSQL = new String() ;

	StringBuilder strLayerStyles = new StringBuilder() ;
	String[] styles = new String[100] ;
	String stylesSQL = new String() ;

	StringBuilder strBB = new StringBuilder() ;
	String[] bbCoord = new String[100] ;
	String bbCoordSQL = new String() ;

	String omgeoUri = omgeoBean.getOmgeoUri() ;
	String omgeoVersion = omgeoBean.getOmgeoVersion() ;
	String omgeoService = omgeoBean.getOmgeoService() ;
	String omgeoReq = omgeoBean.getOmgeoRequest() ;
	String mapWidth = omgeoBean.getMapWidth() ;
	String mapHeight = omgeoBean.getMapHeight() ;
	String mapFormat = omgeoBean.getMapFormat() ;
	String mapExceptions = omgeoBean.getMapExceptions() ;
	OMGeoLayer[] mapLayers = omgeoBean.getMapLayers() ;

	
	sb.append(omgeoUri) ;
	sb.append("VERSION=" + omgeoVersion + "&") ;
	sb.append("SERVICE=" + omgeoService + "&") ;				
%>

<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="70"><img src="../common/images/toplogo.gif" width="154" height="70"></td>
    <td height="70"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="349"><img src="../common/images/toppic1.gif" width="349" height="70"></td>
        <td bgcolor="#EAEAEA"><img src="../common/images/mainpic1.gif" width="272" height="70"></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td width="141" rowspan="2" valign="top" background="../common/images/sidebg.gif"><p><img src="../common/images/nav1.gif" width="154" height="4"><a href="../index.jsp"><img src="../common/images/btn_main.gif" width="154" height="26" border="0"></a><a href="#"><img src="../common/images/btn_overview.gif" width="154" height="26" border="0"></a><a href="#"><img src="../common/images/btn_products.gif" width="154" height="26" border="0"></a><a href="#"><img src="../common/images/btn_services.gif" width="154" height="26" border="0"></a><a href="#"><img src="../common/images/btn_contact.gif" width="154" height="26" border="0"></a></p>
    <p><img src="../common/images/sidehdr_latestnews.gif" width="81" height="11">
    <div class="sidecontentdiv">
	-11.04.2005: Website launched</div>
      <br>
    </p></td>
    <td height="134" valign="top" bgcolor="#004684">
	<table width="100%" height="134"  border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="176" align="center" valign="middle"><img src="../common/images/map_one.gif" width="169" height="120"></td>
          <td width="173" align="center" valign="middle"><img src="../common/images/map_two.gif" width="165" height="120"></td>
          <td align="center"><div align="right">
            <blockquote>
              <p class="style1 style3">OMGeo WMS Client</p>
              <p class="style3">version 1.0</p>
            </blockquote>
          </div></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td valign="top">			
	<%
		if(omgeoReq.equals("GetCapabilities")) {
	%>
		<div class="headercontentdiv">
			<p>&nbsp;</p>
			<p><b>WMS Service Capabilities Request</b></p>
		</div>
		<div class="maincontentdiv">
			<br/>
			
	<%
		sb.append("REQUEST=" + omgeoReq) ;
		serverReq = sb.toString() ;
		out.print("The capabilities file you have requested is ready for download. Please click <a href=" + serverReq + ">here</a>.") ;
	%>
		</div>
	<%		
		}
		else if(omgeoReq.equals("GetMap")) {
	%>
		<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="45%" valign="top">
			<div class="headercontentdiv">
				
				<p><b>OMGeoMap</b></p>
			</div>
			<div class="maincontentdiv">
				<br/>
				Your OMGeo file has been processed by our service and the following geodata has been queryed from our database. 
				If you would like to save your geodata in the pictorial format, please right click the image to the right and press save.
				<br/><br/>
	<%
		
			sb.append("REQUEST=" + omgeoReq + "&") ;
			sb.append("LAYERS=") ;
			serverReq = sb.toString() ;	
		
			int j = 0 ;
			int k = 0 ;
			boolean srsFlag = false ;
			
			srsSQL = mapLayers[0].layerSRS ;
			
			for(int i = 0; i < mapLayers.length; i++)
				if (mapLayers[i] != null) {
				
				/**
				 *  Construct the layer SQL definitions
				 */
				if(mapLayers[i].layerType.equals("topographic") && mapLayers[i].layerResolution.equals("50000")) {
					if(mapLayers[i].layerElement.equals("building")) {
						layers[k++] = "TK50_Gebaeudelinien" ;
					}
					else if(mapLayers[i].layerElement.equals("built_up_area")) {
						layers[k++] = "TK50_Gebaeudeflaechen" ;
					}
					else if(mapLayers[i].layerElement.equals("trees")) {
						layers[k++] = "TK50_Walddecker" ;
					}
					else if(mapLayers[i].layerElement.equals("area_of_complex_channels") || 
								mapLayers[i].layerElement.equals("canal") || mapLayers[i].layerElement.equals("rapids") ||
								mapLayers[i].layerElement.equals("stream") || mapLayers[i].layerElement.equals("watercourse")) 
					{
						layers[k++] = "TK50_Gewaesserlinien" ;
					}
					else if(mapLayers[i].layerElement.equals("bay") || mapLayers[i].layerElement.equals("estuary") || 
								mapLayers[i].layerElement.equals("lake") || mapLayers[i].layerElement.equals("sea_ocean")) 
					{
						layers[k++] = "TK50_Gewaesserdecker" ;
					}
				}				
	
				/**
				 *  Get the default styles for all the elements
				 */
				if(mapLayers[i].layerStyle[1].equals("AdV_Standard")) {
					styles[j++] = "AdV_standard" ;
				}				

				/**
				 *  Construct the BBoxSQL definition
				 */
				for(int b = 0; b < 5; b++)
					bbCoord[b] = mapLayers[i].layerBB[b] ;
			}			

		/**
		 *	Form the layerSQL string and append it to the URI
		 */
		for(int i = 0; i < layers.length; i++)
			if(layers[i] != null)
				strMapLayers.append(layers[i] + ",") ;
			
		layersSQL = strMapLayers.toString() ;
		layersSQL = layersSQL.substring(0,(layersSQL.length() - 1)) ;

		sb.append(layersSQL + "&");
		sb.append("SRS=" + srsSQL + "&") ;
		
		/**
		 *	Form the stylesSQL string and append it to the URI
		 */
		for(int i = 0; i < styles.length; i++)
			if(styles[i] != null)
				strLayerStyles.append(styles[i] + ",") ;
			
		stylesSQL = strLayerStyles.toString() ;
		stylesSQL = stylesSQL.substring(0,(stylesSQL.length() - 1)) ;

		sb.append("STYLES=" + stylesSQL + "&");

		/**
		 *	Form the bbCoordSQL string and append it to the URI
		 */
		for(int i = 0; i < bbCoord.length; i++)
			if(bbCoord[i] != null)
				strBB.append(bbCoord[i] + ",") ;
			
		bbCoordSQL = strBB.toString() ;
		bbCoordSQL = bbCoordSQL.substring(0,(bbCoordSQL.length() - 1)) ;

		sb.append("BBOX=" + bbCoordSQL + "&");
		
		sb.append("WIDTH=" + mapWidth + "&");
		sb.append("HEIGHT=" + mapHeight + "&") ;
		sb.append("FORMAT=" + mapFormat + "&") ;
		sb.append("EXCEPTIONS=" + mapExceptions) ;

		serverReq = sb.toString() ;		
%>
		<b>WMS Client Metadata</b>
		<br>
		<ul>
			<li>Service: <%=  omgeoService %></li>
			<li>Version: <%= omgeoVersion %></li>
			<li>URI: <%= omgeoUri %></li>
		</ul>
		<b>OMGeoMap Metadata</b>
		<br>
		<ul>
			<li>Map Width [pixels]: <%= mapWidth %></li>
			<li>Map Height [pixels]: <%= mapHeight %></li>
			<li>Map Format: <%= mapFormat %></li>
			<li>Bounding Box [W,S,E,N]: 
			<%
				for(int i = 0; i < bbCoord.length; i++)
					if(bbCoord[i] != null)
						out.print(bbCoord[i] + "/") ;
			%>
			</li>
		</ul>
		<b>OMGeoMap Layer Data</b>
		<br><br>
		<%
			for(int i = 0; i < mapLayers.length; i++)
				if (mapLayers[i] != null) {
				out.print("Map Layer " + (i+1));
				out.print("<br>") ;
				out.print("Layer type: " + mapLayers[i].layerType) ;
				out.print("<br>") ;
				out.print("Layer resolution: " + mapLayers[i].layerResolution) ;
				out.print("<br>") ;
				out.print("Layer SRS<sup>*</sup>: " + mapLayers[i].layerSRS) ;
				out.print("<br>") ;
				out.print("Layer element: " + "<a href='http://tlab001.clamv.iu-bremen.de/~achitea/omdoc/projects/omgis/cds/" + mapLayers[i].layerCD + "#" + mapLayers[i].layerElement + "' target='_blank'>" + mapLayers[i].layerElement + "</a>") ;
				out.print("<br>") ; out.print("<br>") ;
				}
		%>
		
		<sup>*</sup>SRS = Spatial Reference System
		<br/>
		</div>
		</td>
		<td width="5%">&nbsp;</td>
		<td width="50%" valign="top">
		<br>
		<img src="<%= serverReq %>" alt="The database could not be accessed. Please retry later." border="1">
		<br/>				
		</td>
		</tr>
		</table>
<%		
	}
%>						
	</td>
  </tr>
  <tr>
    <td height="52" colspan="2" class="baseline">&copy; Copyright 2005. Alexandru Chitea.</td>
  </tr>
</table>
</body>
</html>
