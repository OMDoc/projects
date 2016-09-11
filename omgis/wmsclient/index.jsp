<html>
<head>
<title>OMGeo - Web Map Service</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<LINK href="common/styles/common.css" type=text/css rel=stylesheet>
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

<body style="margin:0px; ">
<table width="139%" height="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="70"><img src="common/images/toplogo.gif" width="154" height="70"></td>
    <td width="1294" height="70"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="349"><img src="common/images/toppic1.gif" width="349" height="70"></td>
        <td bgcolor="#EAEAEA"><img src="common/images/mainpic1.gif" width="272" height="70"></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td width="154" rowspan="2" valign="top" background="common/images/sidebg.gif"><p><img src="common/images/nav1.gif" width="154" height="4"><a href="#"><img src="common/images/btn_main.gif" width="154" height="26" border="0"></a><a href="#"><img src="common/images/btn_overview.gif" width="154" height="26" border="0"></a><a href="#"><img src="common/images/btn_products.gif" width="154" height="26" border="0"></a><a href="#"><img src="common/images/btn_services.gif" width="154" height="26" border="0"></a><a href="#"><img src="common/images/btn_contact.gif" width="154" height="26" border="0"></a></p>
    <p><img src="common/images/sidehdr_latestnews.gif" width="81" height="11">
    <div class="sidecontentdiv">
	-11.04.2005: Website launched</div>
      <br>
    </p></td>
    <td height="134" valign="top" bgcolor="#004684">
	<table width="100%" height="134"  border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="176" align="center" valign="middle"><img src="common/images/map_one.gif" width="169" height="120"></td>
          <td width="173" align="center" valign="middle"><img src="common/images/map_two.gif" width="165" height="120"></td>
          <td align="center"><div align="right">
            <blockquote>
              <p class="style1 style3">OMGeo WMS Client </p>
              <p class="style3">version 1.0</p>
            </blockquote>
          </div></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td valign="top">			
		<div class="headercontentdiv">
	  	<p>&nbsp;</p>
	  	<p><b>OMGeo Upload</b></p>
		</div>
		<div class="maincontentdiv">

		<form action="servlet/OMGeoParserServlet" method="get" enctype="multipart/form-data">			
			<select name="filename">
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/getcapabilities.omdoc">Capabilities Request</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_01.omdoc">OMGeo - Built Areas</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_02.omdoc">OMGeo - Building Lines</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_03.omdoc">OMGeo - Trees</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_04.omdoc">OMGeo - Water channels</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_05.omdoc">OMGeo - Lakes</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_06.omdoc">OMGeo - Trees + Lakes</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_07.omdoc">OMGeo - Trees + Water channels</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_08.omdoc">OMGeo - Complex Map I</option>
				<option value="G:/Tomcat 5.5/webapps/omgeo/omdoc/sample_09.omdoc">OMGeo - Complex Map II</option>
			</select>
			<input type="submit" value="Show Map" />			
		</form>

	  	</div>	  	  		  
    		<p>&nbsp;</p>
	</td>
  </tr>
  <tr>
    <td height="52" colspan="2" class="baseline">&copy; Copyright 2005. Alexandru Chitea.</td>
  </tr>
</table>
</body>
</html>
