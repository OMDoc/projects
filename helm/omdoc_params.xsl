<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns="http://www.mathweb.org/omdoc"
  version="1.0">

<!-- ************************************************ -->
<!--   HELM STUFF COPIED 'AS IT IS' FROM params.xsl   -->
<!-- ************************************************ -->

<xsl:template match="*" mode="counting">
<xsl:param name="noparams" select="0"/>
<xsl:param name="count" select="0"/>
 <xsl:choose>
 <xsl:when test="name(.) = &quot;PROD&quot;">
  <xsl:apply-templates select="target/*[1]" mode="counting">
   <xsl:with-param name="noparams" select="$noparams"/>
   <xsl:with-param name="count" select="$count + 1"/>
  </xsl:apply-templates>
 </xsl:when>
 <xsl:when test="name(.) = &quot;CAST&quot;">
  <xsl:apply-templates select="term/*[1]" mode="counting">
   <xsl:with-param name="noparams" select="$noparams"/>
   <xsl:with-param name="count" select="$count"/>
  </xsl:apply-templates>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="$count - $noparams"/>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="abstparams">
<xsl:param name="noparams" select="0"/>
<xsl:param name="target" select="0"/>
<xsl:param name="binder">PROD</xsl:param>
    <xsl:choose>
    <xsl:when test="($noparams != 0) and ((name(.)=string($binder)) or (name(.)=&quot;CAST&quot;))">
     <xsl:choose>
     <xsl:when test="name(.) = string($binder)">
      <xsl:if test="$target = 0">
       <xsl:choose>
       <xsl:when test="string($binder) = &quot;LAMBDA&quot;">
        <OMV name="{target/@binder}"/>
       </xsl:when>
       <xsl:otherwise>
        <OMATTR>
         <OMATP>
          <OMS cd="coq" name="type"/>
          <xsl:apply-templates mode="pure" select="source"/>
         </OMATP>
         <OMV name="{target/@binder}"/>
        </OMATTR>
       </xsl:otherwise>
       </xsl:choose>
      </xsl:if>
      <xsl:apply-templates select="target/*[1]" mode="abstparams">
       <xsl:with-param name="noparams" select="$noparams - 1"/>
       <xsl:with-param name="target" select="$target"/>
       <xsl:with-param name="binder" select="$binder"/>
      </xsl:apply-templates>
     </xsl:when>
     <xsl:otherwise>
      <xsl:apply-templates select="term/*[1]" mode="abstparams">
       <xsl:with-param name="noparams" select="$noparams"/>
       <xsl:with-param name="target" select="$target"/>
       <xsl:with-param name="binder" select="$binder"/>
      </xsl:apply-templates>
     </xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
     <xsl:choose>
     <xsl:when test="($target = 1) and ($noparams != 0)">
      <!-- OOOOOOPPPS I should have never been here -->
      <m:apply>
      <m:csymbol>app</m:csymbol>
      <xsl:apply-templates select="." mode="pure"/>
      <xsl:call-template name="printparam"><xsl:with-param name="noleft" select="$noparams"/></xsl:call-template>
      </m:apply>
     </xsl:when>
     <xsl:otherwise>
      <xsl:choose>
      <xsl:when test="$noparams != 0">
      <xsl:call-template name="printparam"><xsl:with-param name="noleft" select="$noparams"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
       <xsl:if test="$target = 1">
         <xsl:apply-templates select="."/>
       </xsl:if>
      </xsl:otherwise>
      </xsl:choose>
     </xsl:otherwise>
     </xsl:choose>
    </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="printparam">
<xsl:param name="noleft" select="0"/>
<xsl:param name="number" select="1"/>
    <xsl:if test="$noleft != 0">
     <m:ci>$<xsl:value-of select="$number"/></m:ci>
     <xsl:call-template name="printparam"><xsl:with-param name="noleft" select="$noleft - 1"/><xsl:with-param name="number" select="$number + 1"/></xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="common_prefix">
 <xsl:param name="first_uri" select="&quot;&quot;"/>
 <xsl:param name="second_uri" select="&quot;&quot;"/>
 <xsl:choose>
  <xsl:when test="(substring-before($first_uri,&quot;/&quot;) = 
                substring-before($second_uri,&quot;/&quot;) and 
                substring-after($second_uri,&quot;/&quot;) != &quot;&quot;)">
   <xsl:call-template name="common_prefix">
    <xsl:with-param 
        name="first_uri" select="substring-after($first_uri,&quot;/&quot;)"/>
    <xsl:with-param 
        name="second_uri" select="substring-after($second_uri,&quot;/&quot;)"/>    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:call-template name="slash_counting">
    <xsl:with-param name="uri" select="$second_uri"/>
    <xsl:with-param name="counter" select="0"/>
   </xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="slash_counting">
 <xsl:param name="uri" select="&quot;&quot;"/>
 <xsl:param name="counter" select="0"/>
 <xsl:choose>
  <xsl:when test="(substring-after($uri,&quot;/&quot;) != &quot;&quot;)">
   <xsl:call-template name="slash_counting">
    <xsl:with-param 
        name="uri" select="substring-after($uri,&quot;/&quot;)"/>
    <xsl:with-param
        name="counter" select="$counter +1"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$counter"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="blank_counting">
 <xsl:param name="string" select="&quot;&quot;"/>
 <xsl:param name="counter" select="0"/>
 <xsl:choose>
  <xsl:when test="(substring-after($string,&quot; &quot;) != &quot;&quot;)">
   <xsl:call-template name="blank_counting">
    <xsl:with-param 
        name="string" select="substring-after($string,&quot; &quot;)"/>
    <xsl:with-param 
        name="counter" select="$counter +1"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$counter + 1"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="double_point_counting">
 <xsl:param name="string" select="&quot;&quot;"/>
 <xsl:param name="counter" select="0"/>
 <xsl:choose>
  <xsl:when test="(substring-after($string,&quot;:&quot;) != &quot;&quot;)">
   <xsl:call-template name="double_point_counting">
    <xsl:with-param 
        name="string" select="substring-after($string,&quot;:&quot;)"/>
    <xsl:with-param 
        name="counter" select="$counter +1"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$counter"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="min">
 <xsl:param name="string" select="&quot;&quot;"/>
 <xsl:param name="counter" select="0"/>
 <xsl:choose>
  <xsl:when test="contains($string,concat($counter,&quot;:&quot;))
         or (0 > $counter)">
  <xsl:value-of select="$counter"/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:call-template name="min">
    <xsl:with-param 
        name="string" select="$string"/>
    <xsl:with-param 
        name="counter" select="$counter -1"/>
   </xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="get_no_params">
    <xsl:param name="first_uri" select="&quot;&quot;"/>
    <xsl:param name="second_uri" select="&quot;&quot;"/>
     <xsl:variable name="offset">
      <xsl:call-template name="common_prefix">
       <xsl:with-param name="first_uri" select="$first_uri"/>
       <xsl:with-param name="second_uri" select="$second_uri"/>
      </xsl:call-template>
     </xsl:variable>
     <xsl:choose>
      <xsl:when test="$offset > 0">
       <xsl:variable name="params">
        <xsl:value-of 
            select="document(concat(string($absPath),$second_uri))/*/@params"/>
       </xsl:variable>
       <xsl:variable name="minimum">
        <xsl:call-template name="min">
         <xsl:with-param name="string" select="$params"/>
         <xsl:with-param name="counter" select="$offset - 1"/>
        </xsl:call-template>
       </xsl:variable>
       <xsl:choose>
        <xsl:when test="0 > $minimum">
         0
        </xsl:when>
        <xsl:otherwise>
         <xsl:variable name="relevant_params">
          <!-- the blank after : in the next line is essential -->
          <xsl:value-of 
            select="substring-after($params,concat($minimum,&quot;: &quot;))"/>
         </xsl:variable>
         <xsl:variable name="tokens">
          <xsl:call-template name="blank_counting">
           <xsl:with-param name="string" select="$relevant_params"/>
           <xsl:with-param name="counter" select="0"/>
          </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="separators">
          <xsl:call-template name="double_point_counting">
           <xsl:with-param name="string" select="$relevant_params"/>
           <xsl:with-param name="counter" select="0"/>
          </xsl:call-template>
         </xsl:variable>
         <xsl:value-of select="$tokens - $separators"/>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
      0
      </xsl:otherwise>
     </xsl:choose>
</xsl:template>


<!-- Next template generalized -->
<xsl:template name="name_of_uri">
 <xsl:param name="uri" select="''"/>
 <xsl:param name="ext" select="''"/>
 <xsl:variable name="suffix" select="substring-after($uri, &quot;/&quot;)"/>
 <xsl:choose>
  <xsl:when test="$suffix = &quot;&quot;">
   <!-- CSC: PROBLEMA: .con PUO' APPARIRE ALL'INTERNO DELLE URI ===>
     SCRIVERE UNA FUNZIONE RICORSIVA CHE RISOLVA -->
   <xsl:value-of select="substring-before($uri,$ext)"/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:call-template name="name_of_uri">
    <xsl:with-param name="uri" select="$suffix"/>
    <xsl:with-param name="ext" select="$ext"/>
   </xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- Next templates are not in HELM -->

<xsl:template name="mutind-name-of-uri">
 <xsl:param name="uri" select="''"/>
 <xsl:param name="noType" select="''"/>
 <!-- next line ''copied'' from MUTIND template in content.xsl -->
 <xsl:value-of select="document(concat(string($absPath),$uri))/InductiveDefinition/InductiveType[position()=number($noType)+1]/@name"/>
</xsl:template>

<xsl:template name="mutconstruct-name-of-uri">
 <xsl:param name="uri" select="''"/>
 <xsl:param name="noType" select="''"/>
 <xsl:param name="noConstr" select="''"/>
 <!-- next line ''copied'' from MUTCONSTRUCT template in content.xsl -->
 <xsl:value-of select="document(concat(string($absPath),$uri))/InductiveDefinition/InductiveType[position()=number($noType)+1]/Constructor[position()=number($noConstr)]/@name"/>
</xsl:template>

</xsl:stylesheet>
