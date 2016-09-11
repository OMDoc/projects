<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>

<xsl:template match="*">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="m:math">
  <xsl:copy>
    <xsl:if test="count(*) &gt; 1">
      <xsl:comment>************ ERROR: more than one child here!</xsl:comment>
    </xsl:if>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:stylesheet>

<xsl:template match="m:apply[*[1][self::m:max or self::m:min]]">
  <xsl:copy>
    <xsl:if test="not(m:bvar) or not(m:condition)">
      <xsl:message>ERROR: need both m:bvar and m:condition in <xsl:value-of select="name()"/> or none!</xsl:comment>
      <xsl:comment>************ ERROR: need both m:bvar and m:condition or none!</xsl:comment>
    </xsl:if>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="m:apply[*[1][self::m:sum or self::m:product]]">
  <xsl:copy>
    <xsl:if test="not(m:bvar)">
      <xsl:message>ERROR: need both m:bvar in <xsl:value-of select="name()"/></xsl:comment>
      <xsl:comment>************ ERROR: need both m:bvar here</xsl:comment>
    </xsl:if>
    <xsl:if test="not(m:condition or (m:uplimit and m:lowlimit)">
      <xsl:message>ERROR: need both m:condition or m:uplimit and m:lowlimit in <xsl:value-of select="name()"/></xsl:comment>
      <xsl:comment>************ ERROR: need both m:condition or m:uplimit and m:lowlimit here!</xsl:comment>
    </xsl:if>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
