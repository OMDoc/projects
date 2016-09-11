<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:m="http://www.w3.org/1998/Math/MathML"
                              xmlns:helm="http://www.cs.unibo.it/helm"
                              xmlns="http://www.mathweb.org/omdoc">

<xsl:template match="REL">
 <xsl:choose>
  <xsl:when test="@sort='Prop'">
   <derive id="{@id}">
    <!-- WARNING: no <FMP> because we can't get to the binder given the REL -->
    <method>
     <OMS cd="coq" name="Exact"/>
    </method>
    <premise href="{@uri}"/>
   </derive>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="CONST">
 <xsl:choose>
  <xsl:when test="@sort='Prop'">
   <derive id="{@id}">
    <FMP>
     <xsl:apply-templates select="document(concat(string($absPath),@uri))/Definition/type/*" mode="pure"/>
    </FMP>
    <method>
     <OMS cd="coq" name="Exact"/>
    </method>
    <premise href="{@uri}"/>
   </derive>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="MUTIND">
 <xsl:choose>
  <xsl:when test="@sort='Prop'">
   <derive id="{@id}">
    <FMP>
     <xsl:variable name="index"><xsl:value-of select="@noType"/></xsl:variable>
     <xsl:apply-templates select="document(concat(string($absPath),@uri))/InductiveDefinition/InductiveType[position()=number($index)+1]/arity/*" mode="pure"/>
    </FMP>
    <method>
     <OMS cd="coq" name="Exact"/>
    </method>
    <premise href="{@uri}!{@noType}"/>
   </derive>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="MUTCONSTRUCT">
 <xsl:choose>
  <xsl:when test="@sort='Prop'">
   <derive id="{@id}">
    <FMP>
     <xsl:variable name="Tindex"><xsl:value-of select="@noType"/></xsl:variable>     <xsl:variable name="Cindex"><xsl:value-of select="@noConstr"/></xsl:variable>
     <xsl:apply-templates select="document(concat(string($absPath),@uri))/InductiveDefinition/InductiveType[position()=number($Tindex)+1]/Constructor[position()=number($Cindex)]/*" mode="pure"/>
    </FMP>
    <method>
     <OMS cd="coq" name="Exact"/>
    </method>
    <premise href="{@uri}!{@noType}!{@noConstr}"/>
   </derive>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="SORT|REL|CONST|MUTIND|MUTCONSTRUCT" mode="ignore_atoms"/>

<xsl:template match="APPLY" mode="not_inductive">
 <xsl:variable name="id" select="@id"/>
   <xsl:apply-templates select="*[@sort = 'Prop']" mode="ignore_atoms"/>
   <derive id="{@id}">
    <FMP>
     <xsl:apply-templates mode="pure" select="$InnerTypes/InnerTypes/TYPE[@of=$id]/*"/>
    </FMP>
    <method>
     <OMS cd="coq" name="Apply"/>
     <xsl:for-each select="*[@sort != 'Prop']">
      <parameter>
       <xsl:apply-templates select="." mode="pure"/>
      </parameter>
     </xsl:for-each>
    </method>
    <xsl:apply-templates mode="premises" select="*"/>
   </derive>
</xsl:template>

<!-- BEGIN: premises -->

<!-- href now holds URI, URI*int, URI*int*int, URL, IDs and binder -->

<xsl:template match="CONST" mode="premises">
 <xsl:if test="@sort='Prop'">
  <premise href="{@uri}"/>
 </xsl:if>
</xsl:template>

<xsl:template match="MUTIND" mode="premises">
 <xsl:if test="@sort='Prop'">
  <premise href="{@uri}!{@noType}"/>
 </xsl:if>
</xsl:template>

<xsl:template match="MUTCONSTRUCT" mode="premises">
 <xsl:if test="@sort='Prop'">
  <premise href="{@uri}!{@noType}!{@noConstr}"/>
 </xsl:if>
</xsl:template>

<xsl:template match="SORT" mode="premises">
 <xsl:if test="@sort='Prop'">
  <premise href="http://www.mathweb.org/src/mathweb/omdoc/projects/helm/coq.omdoc#{@value}"/>
 </xsl:if>
</xsl:template>

<xsl:template match="REL" mode="premises">
 <xsl:if test="@sort='Prop'">
  <premise href="{@binder}"/> <!-- We don't have an IDREF, only a name not unique -->
 </xsl:if>
</xsl:template>

<xsl:template match="APPLY|MUTCASE|FIX|COFIX|LAMBDA|PROD" mode="premises">
 <xsl:if test="@sort='Prop'">
  <premise href="{@id}"/>
 </xsl:if>
</xsl:template>

<!-- END: premises -->

<!-- modified from HELM -->
<!-- LAMBDA has inner type only if it is not nested inside another lambda -->
<xsl:template match="LAMBDA">
 <xsl:variable name="id" select="@id"/>
 <xsl:choose>
  <xsl:when test="@sort='Prop' and name(../..) != 'LAMBDA'">
   <!-- problem: target/@binder is not unique and @id is not REL-reachable -->
   <xsl:apply-templates select="." mode="get_all_hyps_from_lambdas">
    <xsl:with-param name="derive_id" select="@id"/>
   </xsl:apply-templates>
   <xsl:apply-templates select="." mode="get_body_from_lambdas"/>
   <derive id="{@id}">
    <FMP>
     <xsl:apply-templates mode="pure" select="$InnerTypes/InnerTypes/TYPE[@of=$id]/*"/>
    </FMP>
    <method>
     <OMS cd="coq" name="Intros"/>
    </method>
    <xsl:variable name="body_id">
     <xsl:apply-templates select="." mode="get_body_id_from_lambdas"/>
    </xsl:variable>
    <premise href="{$body_id}"/>
   </derive>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- BEGIN: get_all_hyps_from lambdas -->

<xsl:template match="LAMBDA" mode="get_all_hyps_from_lambdas">
 <xsl:param name="derive_id" select="''"/>
 <hypothesis id="{target/@binder}" discharged-in="{$derive_id}">
  <OMOBJ>
   <xsl:apply-templates mode="pure" select="source"/>
  </OMOBJ>
 </hypothesis>
 <xsl:apply-templates select="target/*[1]" mode="get_all_hyps_from_lambdas">
  <xsl:with-param name="derive_id" select="$derive_id"/>
 </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="get_all_hyps_from_lambdas"/>

<!-- END: get_all_hyps_from lambdas -->

<!-- BEGIN: get_body_from lambdas -->

<xsl:template match="LAMBDA" mode="get_body_from_lambdas">
 <xsl:apply-templates select="target/*[1]" mode="get_body_from_lambdas"/>
</xsl:template>
   
<xsl:template match="*" mode="get_body_from_lambdas">
 <xsl:apply-templates select="."/>
</xsl:template>

<!-- END: get_body_from lambdas -->

<!-- BEGIN: get_body_id_from lambdas -->

<xsl:template match="LAMBDA" mode="get_body_id_from_lambdas">
 <xsl:apply-templates select="target/*[1]" mode="get_body_id_from_lambdas"/>
</xsl:template>
   
<xsl:template match="*" mode="get_body_id_from_lambdas">
 <xsl:value-of select="@id"/>
</xsl:template>

<!-- END: get_body_id_from lambdas -->

<xsl:template match="FIX|COFIX">
 <xsl:variable name="id" select="@id"/>
 <xsl:choose>
  <xsl:when test="@sort='Prop'">
   <ldt id="ldt-{@id}" recursive="yes">
    <xsl:for-each select="*">
     <xsl:choose>
      <xsl:when test="local-name() = 'FixFunction' and body/*/@sort = 'Prop'">
       <local-lemma id="{@name}" recIndex="{@recIndex}">
        <FMP>
         <xsl:apply-templates select="type" mode="pure"/>
        </FMP>
       </local-lemma>
       <proof for="{@name}" id="p-{@name}">
        <xsl:apply-templates select="body"/>
       </proof>
      </xsl:when>
      <xsl:when test="local-name() = 'FixFunction'">
       <local-def id="{@name}" recIndex="{@recIndex}">
        <type system="cic">
         <xsl:apply-templates select="type" mode="pure"/>
        </type>
        <xsl:apply-templates select="body" mode="pure"/>
       </local-def>
      </xsl:when>
      <xsl:when test="body/*/@sort = 'Prop'">
       <local-lemma id="{@name}">
        <FMP>
         <xsl:apply-templates select="type" mode="pure"/>
        </FMP>
       </local-lemma>
       <proof for="{@name}" id="p-{@name}">
        <xsl:apply-templates select="body"/>
       </proof>
      </xsl:when>
      <xsl:otherwise>
       <local-def id="{@name}">
        <type system="cic">
         <xsl:apply-templates select="type" mode="pure"/>
        </type>
        <xsl:apply-templates select="body" mode="pure"/>
       </local-def>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:for-each>
   </ldt>
   <derive id="{@id}">
    <FMP>
     <xsl:apply-templates mode="pure" select="$InnerTypes/InnerTypes/TYPE[@of=$id]/*"/>
    </FMP>
    <method>
     <OMS cd="coq" name="Exact-{local-name()}"/>
     <parameter><OMI><xsl:value-of select="@noFun"/></OMI></parameter>
    </method>
    <premise href="ldt-{@id}"/>
   </derive>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="LETIN">
 <xsl:variable name="term_id" select="term/*/@id"/>
 <xsl:choose>
  <xsl:when test="@sort='Prop'">
   <ldt id="ldt-{@id}">
    <xsl:choose>
     <xsl:when test="term/*/@sort = 'Prop'">
      <local-lemma id="{letintarget/@binder}">
       <FMP>
        <xsl:apply-templates mode="pure" select="$InnerTypes/InnerTypes/TYPE[@of=$term_id]/*"/>
       </FMP>
      </local-lemma>
      <proof for="{letintarget/@binder}" id="p-{letintarget/@binder}">
       <xsl:apply-templates select="term"/>
      </proof>
     </xsl:when>
     <xsl:otherwise>
      <local-def id="{letintarget/@binder}">
       <xsl:apply-templates select="term" mode="pure"/>
      </local-def>
     </xsl:otherwise>
    </xsl:choose>
   </ldt>
   <xsl:apply-templates select="letintarget/*"/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates select="." mode="pure"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="MUTCASE">
 <!-- STILL TO BE DONE (LAST ONE) -->
 <xsl:apply-templates select="." mode="pure"/>
</xsl:template>

<xsl:template match="SORT|PROD">
 <xsl:apply-templates select="." mode="pure"/>
</xsl:template>

</xsl:stylesheet>
