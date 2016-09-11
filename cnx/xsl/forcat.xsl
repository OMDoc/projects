<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:omdoc="http://www.mathweb.org/omdoc"
  version="1.0">

  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
      ## A list of theory names in this file put them into the 
      ## put them into the catalogue as
      ## &lt;loc theory="theoryname" omdoc="module-id"/&gt;
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <!-- the default action is to do nothing on OMDoc elements -->
  <xsl:template match="omdoc:*"/>
  <!-- except on these, which may contain 'presentation', 'omstyle', 
       or 'ref' elements, which we must take into consideration -->
  <xsl:template match="omdoc:omdoc|omdoc:omgroup|omdoc:theory">
    <xsl:apply-templates/>
  </xsl:template>


  <xsl:template match="omdoc:theory">
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="@id"/>
  </xsl:template>

</xsl:stylesheet>
