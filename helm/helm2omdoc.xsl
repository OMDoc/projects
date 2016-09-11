<?xml version="1.0"?>

<!-- An XSL style sheet for creating OMDoc documents from CIC specifications
     Copyright (c) 2000 Michael Kohlhase, 
     This style sheet is released under the Gnu Public License
     Initial version 2000-07-28 by Michael Kohlhase 
     send bug-reports, patches, suggestions to kohlhase@mathweb.org
-->



<!-- WARNING: document on URI ?????? -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns="http://www.mathweb.org/omdoc"
  version="1.0">

<xsl:include href="file:///projects/helm/omdoc/projects/helm/omdoc_params.xsl"/>
<xsl:include href="file:///projects/helm/omdoc/projects/helm/omdoc_inductive.xsl"/>
<xsl:include href="file:///projects/helm/omdoc/projects/helm/omdoc_proofs.xsl"/>

<xsl:strip-space elements = "*"/> 

<xsl:output method="xml"
            version="1.0"
            indent="yes"
            standalone="yes"/>

<xsl:param name="CICURI" select="''"/>
<xsl:param name="getterURL" select="'http://localhost:8081/'"/>
<xsl:variable name="absPath"><xsl:value-of select="$getterURL"/>getxml?uri=</xsl:variable>
<xsl:variable name="current_cd">
 <xsl:variable name="type_name">
  <xsl:text>/</xsl:text>
  <xsl:call-template name="name_of_uri">
   <xsl:with-param name="uri" select="$CICURI"/>
   <xsl:with-param name="ext" select="concat('.',substring-after($CICURI,'.'))"/>
  </xsl:call-template>
 </xsl:variable>
 <xsl:value-of select="substring-before($CICURI,string($type_name))"/>
</xsl:variable>

<xsl:variable name="InnerTypes" select="document(concat($absPath,$CICURI,'.types'))"/>

<xsl:template match="/">
  <xsl:text>&#xA;&#xA;</xsl:text>
  <xsl:comment>
    This OMDoc file is automatically generated from a CIC specification
  </xsl:comment>
  <xsl:text>&#xA;&#xA;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="Definition[body/*[@sort = 'Prop']]">
  <!-- params ignored -->
  <assertion id="{@name}" type="Theorem">
   <FMP>
    <xsl:apply-templates select="type"/>
   </FMP>
  </assertion>
  <proof id="p-{@name}" for="{@name}">
   <xsl:apply-templates select="body"/>
  </proof>
</xsl:template>

<xsl:template match="Definition">
  <definition id="{@id}">
   <objdef id="{@name}" type="simple" scope="global"> 
    <!-- params ignored -->
    <type system="cic">
      <xsl:apply-templates select="type"/>
    </type>
    <FMP>
      <xsl:apply-templates select="body"/>
    </FMP>
   </objdef>
  </definition>
</xsl:template>

<!-- ERR: the type attribute could be missing, but it could really be of
 type Prop -->
<xsl:template match="Axiom[type/*[@type = 'Prop']]">
  <!-- params ignored -->
  <axiom id="{@name}">
   <FMP>
    <xsl:apply-templates select="type"/>
   </FMP>
  </axiom>
</xsl:template>

<xsl:template match="Axiom">
  <definition id="{@name}-dec">
    <objdef id="{@name}" scope="global" type="declaration">
      <type system="cic">
        <xsl:apply-templates select="type"/>
      </type>
    </objdef>
  </definition>
</xsl:template>

<xsl:template match="CurrentProof">
  <xsl:message>Can't handle CurrentProof yet (due to METAs)</xsl:message>
</xsl:template>

<xsl:template match="InductiveDefinition">
  <definition id="{@id}" cd="coq">
    <!-- params are ignored ; do NOT confuse params with params ;-) -->
    <xsl:if test="string(@noParams) != 0">
      <params>
        <xsl:apply-templates select="InductiveType/arity/*[1]" mode="abstparams">
        <xsl:with-param name="noparams" select="@noParams"/>
       </xsl:apply-templates>
      </params>
     </xsl:if>
     <xsl:for-each select="InductiveType">
      <sortdef id="{./@name}" inductive="{./@inductive}" semantics="free">
       <type system="cic">
         <xsl:apply-templates select="./arity/*[1]" mode="abstparams">
          <xsl:with-param name="noparams" select="../@noParams"/>
          <xsl:with-param name="target" select="1"/>
         </xsl:apply-templates>
       </type>
       <xsl:for-each select="./Constructor">
        <constructor id="{./@name}">
         <type system="cic">
          <xsl:apply-templates select="./*[1]" mode="abstparams">
           <xsl:with-param name="noparams" select="../../@noParams"/>
           <xsl:with-param name="target" select="1"/>
          </xsl:apply-templates>
         </type>
        </constructor>
       </xsl:for-each>
      </sortdef>
     </xsl:for-each>
    </definition>
</xsl:template>

<xsl:template match="Variable">
  <OMATTR>
    <OMATP>
      <OMS cd="coq" name="type"/>
      <xsl:apply-templates/>
    </OMATP>
    <OMV name="{@name}"/>
  </OMATTR>
</xsl:template>

<xsl:template match="LAMBDA|PROD" mode="pure">
  <!-- sort ignored -->
  <xsl:choose>
   <xsl:when test="local-name() = 'PROD' and not (target/@binder)">
    <OMA>
     <xsl:choose>
      <xsl:when test="@type = 'Prop'">
       <OMS cd="logic1" name="implies"/>
      </xsl:when>
      <xsl:when test="local-name() = 'PROD' and @type = 'Set'">
       <OMS cd="coq" name="funtype"/>
      </xsl:when>
      <xsl:otherwise>
       <OMS cd="coq" name="arrowtype"/>
      </xsl:otherwise>
     </xsl:choose>
     <xsl:apply-templates select="source" mode="pure"/>
     <xsl:apply-templates select="target" mode="pure"/>
    </OMA>
   </xsl:when>
   <xsl:otherwise>
    <OMBIND id="{@id}">
     <xsl:choose>
      <xsl:when test="local-name() = 'PROD' and @type = 'Prop'">
       <OMS cd="quant1" name="forall"/>
      </xsl:when>
      <xsl:when test="local-name() = 'PROD' and @type = 'Set'">
       <OMS cd="coq" name="set-prodtype"/>
      </xsl:when>
      <xsl:when test="local-name() = 'PROD'">
       <OMS cd="coq" name="type-prodtype"/>
      </xsl:when>
      <xsl:otherwise>
       <OMS cd="coq" name="lambda"/>
      </xsl:otherwise>
     </xsl:choose>
     <OMBVAR>
      <OMATTR>
       <OMATP>
        <OMS cd="coq" name="type"/>
        <xsl:apply-templates select="source" mode="pure"/>
       </OMATP>
       <OMV name="{target/@binder}"/>
      </OMATTR>
     </OMBVAR>
     <xsl:apply-templates select="target" mode="pure"/>
    </OMBIND>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="LETIN" mode="pure">
  <!-- sort ignored -->
  <OMBIND id="{@id}">
    <OMS cd="coq" name="letin"/>
    <OMBVAR>
      <OMATTR>
       <OMATP>
        <OMS cd="coq" name="inlet"/>
        <xsl:apply-templates select="term" mode="pure"/>
       </OMATP>
       <OMV name="{letintarget/@binder}"/>
      </OMATTR>
    </OMBVAR>
    <xsl:apply-templates select="letintarget" mode="pure"/>
  </OMBIND>
</xsl:template>

<xsl:template match="CAST" mode="pure">
  <!-- sort ignored -->
  <OMA id="{@id}">
    <OMS cd="coq" name="cast"/>
    <xsl:apply-templates select="term" mode="pure"/>
    <xsl:apply-templates select="type" mode="pure"/>
  </OMA>
</xsl:template>

<xsl:template match="SORT" mode="pure">
  <OMS id="{@id}" cd="coq" name="{@value}"/>
</xsl:template>

<xsl:template match="REL" mode="pure">
  <!-- sort ignored -->
  <!-- value is the DeBrujin index ==> ignored -->
  <OMV id="{@id}" name="{@binder}"/>
</xsl:template>

<xsl:template match="APPLY" mode="pure">
  <!-- sort ignored -->
  <OMA id="{@id}">
    <xsl:apply-templates mode="pure"/>
  </OMA>
</xsl:template>

<xsl:template match="VAR" mode="pure">
  <!-- sort ignored -->
  <!-- ERROR: relURI format is something as "A,2" -->
  <OMV id="{@id}" name="{@relUri}"/>
</xsl:template>

<xsl:template match="META" mode="pure">
  <xsl:message>Can't handle META yet</xsl:message>
</xsl:template>

<xsl:template match="IMPLICIT" mode="pure">
  <xsl:message>Can't handle IMPLICIT yet</xsl:message>
</xsl:template>

<xsl:template match="CONST" mode="pure">
  <!-- ERROR: document can't be applied on URIs -->
  <!-- sort not considered -->
  <xsl:variable name="name">
   <xsl:call-template name="name_of_uri">
    <xsl:with-param name="uri" select="@uri"/>
    <xsl:with-param name="ext" select="'.con'"/>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cd">
   <xsl:value-of select="substring-before(@uri,concat('/',string($name)))"/>
  </xsl:variable>
  <OMS id="{@id}" cd="{$cd}" name="{$name}"/>
</xsl:template>

<xsl:template match="MUTIND" mode="pure">
  <!-- sort not considered -->
  <xsl:variable name="name">
   <xsl:call-template name="mutind-name-of-uri">
    <xsl:with-param name="uri" select="@uri"/>
    <xsl:with-param name="noType" select="@noType"/>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cd">
   <xsl:value-of select="substring-before(@uri,concat('/',string($name)))"/>
  </xsl:variable>
  <OMS id="{@id}" cd="{$cd}" name="{$name}"/>
</xsl:template>

<xsl:template match="MUTCONSTRUCT" mode="pure">
  <!-- sort not considered -->
  <xsl:variable name="name">
   <xsl:call-template name="mutconstruct-name-of-uri">
    <xsl:with-param name="uri" select="@uri"/>
    <xsl:with-param name="noType" select="@noType"/>
    <xsl:with-param name="noConstr" select="@noConstr"/>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="type_name">
   <xsl:call-template name="mutind-name-of-uri">
    <xsl:with-param name="uri" select="@uri"/>
    <xsl:with-param name="noType" select="@noType"/>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cd">
   <xsl:value-of select="substring-before(@uri,concat('/',string($type_name)))"/>
  </xsl:variable>
  <OMS id="{@id}" cd="{$cd}" name="{$name}"/>
</xsl:template>

<xsl:template match="MUTCASE" mode="pure">
 <!-- WARNING: share all the MUTCASE stuff with HELM -->
 <!-- sort not considered -->
 <xsl:variable name="Tindex"><xsl:value-of select="@noType"/></xsl:variable>
 <xsl:variable name="Turi"><xsl:value-of select="@uriType"/></xsl:variable>
 <!-- next code replicated at the beginning. Is there a way to abstract it? -->
 <xsl:variable name="type_name">
  <xsl:text>/</xsl:text>
  <xsl:call-template name="name_of_uri">
   <xsl:with-param name="uri" select="$Turi"/>
   <xsl:with-param name="ext" select="'.ind'"/>
  </xsl:call-template>
 </xsl:variable>
 <OMATTR>
  <OMATP>
   <OMS cd="coq" name="patternsType"/>
   <xsl:apply-templates select="patternsType" mode="pure"/>
   <OMS cd="coq" name="termType"/>
   <xsl:variable name="termType">
    <xsl:call-template name="mutind-name-of-uri">
     <xsl:with-param name="uri" select="@uriType"/>
     <xsl:with-param name="noType" select="@noType"/>
    </xsl:call-template>
   </xsl:variable>
   <OMS cd="{substring-before($Turi,string($type_name))}" name="{$termType}"/>
  </OMATP>
  <OMA id="{@id}">
   <OMS cd="coq" name="cases"/>
   <xsl:apply-templates select="inductiveTerm" mode="pure"/>
   <xsl:variable name="nop"><xsl:value-of select="document(concat(string($absPath),$Turi))/InductiveDefinition/@noParams"/></xsl:variable>
   <xsl:for-each select="pattern">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="nopar"><xsl:apply-templates select="document(concat(string($absPath),$Turi))/InductiveDefinition/InductiveType[position()=number($Tindex)+1]/Constructor[position()=number($pos)]/*[1]" mode="counting"><xsl:with-param name="noparams" select="$nop"/></xsl:apply-templates></xsl:variable>
    <xsl:variable name="o_name">
     <xsl:value-of select="document(concat(string($absPath),$Turi))/InductiveDefinition/InductiveType[position()=number($Tindex)+1]/Constructor[position()=number($pos)]/@name"/>
    </xsl:variable>
    <xsl:variable name="o_body">
     <xsl:apply-templates select="./*[1]" mode="abstparams"><xsl:with-param name="noparams" select="$nopar"/><xsl:with-param name="target" select="1"/><xsl:with-param name="binder">LAMBDA</xsl:with-param></xsl:apply-templates>
    </xsl:variable>
    <OMA>
     <OMS cd="coq" name="case"/>
     <OMS cd="{substring-before($Turi,string($type_name))}" name="{$o_name}"/>
     <xsl:choose>
      <xsl:when test="$nopar = 0">
       <xsl:copy-of select="$o_body"/>
      </xsl:when>
      <xsl:otherwise>
       <OMBIND>
        <OMS cd="coq" name="case-lambda"/>
        <OMBVAR>
         <xsl:apply-templates mode="abstparams"><xsl:with-param name="noparams" select="$nopar"/><xsl:with-param name="binder">LAMBDA</xsl:with-param></xsl:apply-templates>
        </OMBVAR>
        <xsl:copy-of select="$o_body"/>
       </OMBIND>
      </xsl:otherwise>
     </xsl:choose>
    </OMA>
   </xsl:for-each>
  </OMA>
 </OMATTR>
</xsl:template>

<xsl:template match="FIX|COFIX" mode="pure">
 <!-- sort not considered -->
 <OMA id="{@id}">
  <OMS cd="coq" name="{local-name()}"/>
  <OMI><xsl:value-of select="@noFun"/></OMI>
   <OMBIND>
    <OMS cd="coq" name="mutual-{local-name()}-definition"/>
    <xsl:for-each select="*">
     <OMATTR>
      <OMATP>
       <OMS cd="coq" name="type"/>
       <xsl:apply-templates select="type" mode="pure"/>
       <xsl:if test="local-name() = 'FIX'">
        <OMS cd="coq" name="recIndex"/>
        <OMI><xsl:value-of select="@recIndex"/></OMI>
       </xsl:if>
      </OMATP>
      <OMV name="{@name}"/>
     </OMATTR>
    </xsl:for-each>
    <OMA>
     <OMS cd="logic1" name="and"/>
     <xsl:apply-templates mode="pure"/>
    </OMA>
   </OMBIND>
 </OMA>
</xsl:template>

<xsl:template match="FixFunction|CofixFunction" mode="pure">
 <OMA>
  <OMS cd="relations1" name="eq"/>
  <OMV name="{@name}"/>
  <xsl:apply-templates select="body" mode="pure"/>
 </OMA>
</xsl:template>

</xsl:stylesheet>
<!-- todo: 
     - what are the params in InductiveDefinition? 
     - what is @inductive in InductiveDefinition? the same as our semantics?
  -->
