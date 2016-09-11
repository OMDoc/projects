<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns="http://www.mathweb.org/omdoc"
  xmlns:omdoc="http://www.mathweb.org/omdoc"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cnx="http://cnx.rice.edu/cnxml/0.4"
  xmlns:func="http://exslt.org/functions" 
  xmlns:set="http://exslt.org/sets"
  xmlns:md="http://cnx.rice.edu/mdml/0.4"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="cnx md omdoc func set m"
  extension-element-prefixes="func set"
  version="1.0">

  <xsl:include href="../../../xsl/cmml2om.xsl"/>

  <xsl:template match="m:math" mode="in-ex">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <xsl:output method="xml" version="1.0" indent="yes" cdata-section-elements="data"/>
  <xsl:strip-space elements="*"/> 
  <!-- the URI of the CNX module registry -->
  <xsl:param name="CNX" select="'http://cnx.rice.edu'"/>
  <!-- for debugging -->

  <xsl:template match="*">
    <xsl:message>
      <xsl:text>cannot deal with element </xsl:text>
      <xsl:value-of select="local-name()"/>
      <xsl:text> yet!</xsl:text>
    </xsl:message>
  </xsl:template>
  
  <xsl:template match="/">
    <xsl:comment>
      <xsl:text>&#xA; This OMDoc file  is automatically generated from an CNXML file</xsl:text>
      <xsl:text>,&#xA;     DO NOT EDIT!&#xA;</xsl:text>
    </xsl:comment>
    <xsl:text disable-output-escaping="yes">
      &lt;!DOCTYPE omdoc PUBLIC "-//OMDoc//DTD OMDoc V1.1//EN" "../../../dtd/omdoc.dtd" 
        [&lt;!ENTITY % otheromgrouptype "|float"&gt;
         &lt;!ELEMENT md:version ANY&gt;&lt;!ATTLIST md:version xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:objectives ANY&gt;&lt;!ATTLIST md:objectives xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:maintainerlist ANY&gt;&lt;!ATTLIST md:maintainerlist xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:keywordlist ANY&gt;&lt;!ATTLIST md:keywordlist xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:maintainer ANY&gt;
         &lt;!ATTLIST md:maintainer xmlns:md CDATA #IMPLIED id CDATA #IMPLIED homepage CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:keyword ANY&gt;&lt;!ATTLIST md:keyword xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:othername ANY&gt;&lt;!ATTLIST md:othername xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:email ANY&gt;&lt;!ATTLIST md:email xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:honorific ANY&gt;&lt;!ATTLIST md:honorific xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:firstname ANY&gt;&lt;!ATTLIST md:firstname xmlns:md CDATA #IMPLIED&gt;
         &lt;!ELEMENT md:surname ANY&gt;&lt;!ATTLIST md:surname xmlns:md CDATA #IMPLIED&gt;
         &lt;!ATTLIST omdoc xmlns:omdoc CDATA #IMPLIED &gt;]&gt;
    </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="cnx:module">
    <omdoc id="{@id}" 
      xmlns:md="http://cnx.rice.edu/mdml/0.4" 
      catalogue="../../../examples/omstd/catalogue.omdoc">
      <metadata xmlns:md="http://cnx.rice.edu/mdml/0.4">
        <dc:title><xsl:value-of select="cnx:name"/></dc:title>
        <xsl:apply-templates select="cnx:metadata/*" mode="dclike"/>
        <dc:source>
          This module is automatically translated from the module <xsl:value-of select="@id"/> 
          of the Connexions Project.
          See http://cnx.rice.edu/content/<xsl:value-of select="@id"/>/latest/
          The original version is licensed under the Creative Commons Attribuitions License
          See http://creativecommons.org/licenses/by/1.0
        </dc:source>
        <dc:rights>
          This module is licensed under the Creative Commons Attribuitions License
          See http://creativecommons.org/licenses/by/1.0
        </dc:rights>
        <xsl:apply-templates select="cnx:metadata/*" mode="extra"/>
      </metadata>
      <xsl:apply-templates select="cnx:content"/>
      <xsl:apply-templates mode="delayed"/>
    </omdoc>
  </xsl:template>

  <xsl:template match="*" mode="delayed"/>

  <xsl:template match="md:version" mode="dclike"/>
  <xsl:template match="md:version" mode="extra">
    <md:version>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:version>
  </xsl:template>
  
  <xsl:template match="md:created" mode="extra"/>
  <xsl:template match="md:created" mode="dclike">
    <dc:date action="created"><xsl:apply-templates/></dc:date>
  </xsl:template>
  
  <xsl:template match="md:revised" mode="extra"/>
  <xsl:template match="md:revised" mode="dclike">
    <dc:date action="revised"><xsl:apply-templates/></dc:date>
  </xsl:template>
  
  <xsl:template match="md:authorlist" mode="extra"/>
  <xsl:template match="md:authorlist" mode="dclike">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="md:author">
    <dc:creator role="aut">
      <xsl:copy-of select="@id"/><xsl:apply-templates/>
    </dc:creator>
  </xsl:template>
  
  <xsl:template match="md:firstname|md:surname|md:othername|md:honorific|md:lineage|md:email">
    <with class="{local-name()}"><xsl:apply-templates/></with>
  </xsl:template>
  
  <xsl:template match="md:maintainerlist" mode="dclike"/>
  <xsl:template match="md:maintainerlist" mode="extra">
    <md:maintainerlist>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:maintainerlist>
  </xsl:template>
  
  <xsl:template match="md:maintainer" mode="extra">
    <md:maintainer>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:maintainer>
  </xsl:template>

  <xsl:template match="md:firstname" mode="extra">
    <md:firstname>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:firstname>
  </xsl:template>

  <xsl:template match="md:surname" mode="extra">
    <md:surname>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:surname>
  </xsl:template>

  <xsl:template match="md:othername" mode="extra">
    <md:othername>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:othername>
  </xsl:template>

  <xsl:template match="md:email" mode="extra">
    <md:email>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:email>
  </xsl:template>

  <xsl:template match="md:keyword" mode="extra">
    <md:keyword>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:keyword>
  </xsl:template>

  <xsl:template match="md:keywordlist" mode="dclike"/>
  <xsl:template match="md:keywordlist" mode="extra">
    <md:keywordlist>
      <xsl:copy-of select="@*"/>  
      <xsl:apply-templates mode="extra"/>
    </md:keywordlist>
  </xsl:template>
  
  <xsl:template match="md:objectives" mode="dclike"/>
  <xsl:template match="md:objectives" mode="extra">
    <md:objectives><xsl:apply-templates/></md:objectives>
  </xsl:template>

  <xsl:template match="md:abstract" mode="dclike">
    <dc:description><xsl:apply-templates/></dc:description>
  </xsl:template>
  <xsl:template match="md:abstract" mode="extra"/>
  
  <xsl:template match="cnx:content"><xsl:apply-templates/></xsl:template>
  
  <!-- ***** lost cnx:name **** -->  
  <xsl:template match="cnx:list[@type='enumerated']" mode="in-ex">
    <ol id="{@id}">
      <xsl:apply-templates select="*[local-name()!='name']" mode="in-ex"/>
    </ol>
  </xsl:template>

  <xsl:template name="name-metadata">
    <xsl:if test="cnx:name">
      <metadata>
        <dc:title><xsl:value-of select="cnx:name"/></dc:title>
      </metadata>
    </xsl:if>
  </xsl:template>

  <xsl:template name="with-name-metadata">
    <xsl:call-template name="name-metadata"/>
    <xsl:apply-templates select="*[local-name()!='name']"/>
  </xsl:template>

  <xsl:template match="cnx:list[@type='enumerated']">
    <omgroup id="{@id}" type="enumeration">
      <xsl:call-template name="with-name-metadata"/>
    </omgroup>
  </xsl:template>

  <xsl:template match="cnx:list[@type='bulleted']" mode="in-pf">
    <derive id="{@id}" type="enumeration">
      <xsl:call-template name="with-name-metadata"/>
      <CMP>
        <ul id="{@id}">
          <xsl:apply-templates select="*[local-name()!='name']" mode="in-ex"/>
        </ul>
      </CMP>
    </derive>
  </xsl:template>

  <xsl:template match="cnx:list[@type='enumerated']" mode="in-pf">
    <derive id="{@id}" type="enumeration">
      <xsl:call-template name="with-name-metadata"/>
      <CMP>
        <ol id="{@id}">
          <xsl:apply-templates select="*[local-name()!='name']" mode="in-ex"/>
        </ol>
      </CMP>
    </derive>
  </xsl:template>

  <!-- ***** lost cnx:name **** -->  
  <xsl:template match="cnx:list[@type='bulleted']" mode="in-ex">
    <ul id="{@id}">
      <xsl:apply-templates select="*[local-name()!='name']" mode="in-ex"/>
    </ul>
  </xsl:template>

  <xsl:template match="cnx:list[@type='bulleted']">
    <omgroup id="{@id}" type="itemize">
      <xsl:call-template name="with-name-metadata"/>
    </omgroup>
  </xsl:template>

  <xsl:template match="cnx:item" mode="in-ex">
    <li>
      <xsl:if test="@id"><xsl:copy-of select="@id"/></xsl:if>
      <xsl:apply-templates mode="in-ex"/>
    </li>
  </xsl:template>

  <xsl:template match="cnx:item">
    <xsl:call-template name="collect-textlike">
      <xsl:with-param name="nodes" select="child::node()|child::text()"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="cnx:section">
    <omgroup id="{@id}" type="sectioning">
      <xsl:call-template name="with-name-metadata"/>
    </omgroup>
  </xsl:template>
  
  <xsl:template match="cnx:name"><xsl:apply-templates/></xsl:template>
  
  <xsl:template match="cnx:codeline">
    <with class="codeline"><xsl:apply-templates/></with>
  </xsl:template>

  <xsl:template match="cnx:cite">
    <with class="citation"><xsl:apply-templates/></with>
  </xsl:template>

  <xsl:template match="cnx:definition">
    <omtext id="{@id}" type="definition">
      <metadata><dc:title><xsl:apply-templates select="cnx:term"/></dc:title></metadata>
      <CMP>
        <xsl:call-template name="collect-textlike-in-ex">
          <xsl:with-param name="nodes" select="*[local-name()!='example' and local-name()!='term']|child::text()"/>
        </xsl:call-template>
      </CMP>
    </omtext>
    <xsl:apply-templates select="cnx:example"/>
  </xsl:template>

  <xsl:template match="cnx:rule">
    <assertion id="{@id}">
      <xsl:attribute name="type">
        <xsl:choose>
          <xsl:when test="@type='theorem' or @type='lemma' or @type='corollary' or
            @type='conjecture' or @type='false-conjecture' or 
            @type='obligation' or @type='postulate' or @type='formula' or  
            @type='assumption' or @type='proposition'">
            <xsl:value-of select="@type"/>
          </xsl:when>
          <xsl:otherwise><xsl:text>rule</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:apply-templates select="cnx:statement/*" mode="in-ex"/></CMP>
    </assertion>
    <xsl:apply-templates select="cnx:proof|cnx:example">
      <xsl:with-param name="for" select="@id"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="cnx:rule" mode="in-pf">
    <derive id="{@id}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:apply-templates select="cnx:statement/*" mode="in-ex"/></CMP>
      <xsl:apply-templates select="cnx:proof"/>
      <xsl:if test="cnx:example">
        <xsl:message>WARNING: omitting example in rule in proof</xsl:message>
      </xsl:if>
    </derive>
  </xsl:template>

  <xsl:template match="cnx:example">
    <xsl:param name="for" select="generate-id()"/>
    <example id="{@id}" for="{$for}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:apply-templates select="*[local-name()!='name']" mode="in-ex"/></CMP>
    </example>
  </xsl:template>

  <xsl:template match="cnx:proof">
    <xsl:param name="for" select="generate-id()"/>
    <proof for="{$for}">
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:call-template name="name-metadata"/>
      <xsl:apply-templates select="*[local-name()!='name']" mode="in-pf"/>
      <conclude id="{concat(generate-id(),'-concl')}"/>
    </proof>
  </xsl:template>

  <xsl:template match="cnx:para" mode="in-pf">
    <derive id="{@id}">
      <CMP>
        <xsl:call-template name="collect-textlike-in-ex">
          <xsl:with-param name="nodes" select="child::node()|child::text()"/>
        </xsl:call-template>
      </CMP>
    </derive>
  </xsl:template>

  <xsl:template match="cnx:exercise">
    <exercise id="{@id}">
      <CMP><xsl:apply-templates select="cnx:problem"/></CMP>
      <xsl:apply-templates select="cnx:solution"/>
    </exercise>
  </xsl:template>

  <xsl:template match="cnx:problem"><xsl:apply-templates mode="in-ex"/></xsl:template>
  
  <xsl:template match="cnx:solution">
    <solution><CMP><xsl:apply-templates mode="in-ex"/></CMP></solution>
  </xsl:template>

  <xsl:template match="cnx:codeblock">
    <omtext>
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <CMP><omlet type="code" action="display" data="{generate-id()}"/></CMP>
    </omtext>
  </xsl:template>

  <xsl:template match="cnx:codeblock" mode="in-ex">
    <omlet type="code" action="display" data="{generate-id()}"/>
  </xsl:template>
  
  <xsl:template match="cnx:codeblock" mode="delayed">
    <code id="{generate-id()}">
      <data format="dummy"><xsl:apply-templates/></data>
    </code>
  </xsl:template>

  <xsl:template match="cnx:media">
    <omlet type="code" action="display" data="{generate-id()}"/>
  </xsl:template>

  <xsl:template match="cnx:media" mode="in-ex">
    <omlet type="code" action="display" data="{generate-id()}"/>
  </xsl:template>

  <xsl:template match="cnx:media" mode="delayed">
    <private id="{generate-id()}"><data format="{@type}" href="{@src}"/></private>
  </xsl:template>

  <xsl:template match="cnx:link">
    <link href="{@src}"><xsl:apply-templates/></link>
  </xsl:template>

  <xsl:template match="cnx:note">
    <xsl:choose>
      <xsl:when test="contains(@type,' ')">
        <omtext id="{generate-id()}">
          <metadata><dc:title><xsl:value-of select="@type"/></dc:title></metadata>
          <CMP><xsl:apply-templates/></CMP>
        </omtext>
      </xsl:when>
      <xsl:when test="@type='quotation' or @type='Quotation' or @type='quote' or @type='Quote'">
        <omtext id="{generate-id()}" type="quote">
          <CMP><xsl:apply-templates/></CMP>
        </omtext>
      </xsl:when>
      <xsl:when test="@type='hint' or @type='Hint'">
        <hint id="{generate-id()}"><CMP><xsl:apply-templates/></CMP></hint>
      </xsl:when>
      <xsl:when test="@type='todo'">
        <ignore type="ednote" comment="todo"><xsl:apply-templates/></ignore>
      </xsl:when>
      <xsl:when test="not(@note) or @type='note' or @type='Note'">
        <note id="{generate-id()}" type="note"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:when test="@type='footnote' or @type='Footnote'">
        <note id="{generate-id()}" type="footnote"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:when test="@type='aside' or @type='Aside'">
        <note id="{generate-id()}" type="aside"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:when test="@type='warning' or @type='Warning'">
        <note id="{generate-id()}" type="warning"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:when test="@type='rule' or @type='Rule'">
        <note id="{generate-id()}" type="rule"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:when test="@type='question' or @type='Question'">
        <note id="{generate-id()}" type="quesiotn"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:when test="@type='recall' or @type='Recall'">
        <note id="{generate-id()}" type="quesiotn"><xsl:apply-templates/></note>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>unknown type of note "<xsl:value-of select="@type"/>"; continuing ...</xsl:message>
        <note id="{generate-id()}" type="{@type}"><xsl:apply-templates/></note>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- **** do something here *** -->
  <xsl:template match="cnx:term">
    <with class="term"><xsl:apply-templates/></with>
  </xsl:template>

  <xsl:template match="cnx:emphasis">
    <highlight><xsl:apply-templates/></highlight>
  </xsl:template>
  
  <xsl:template match="cnx:cnxn">
    <link>
      <xsl:attribute name="href">
        <xsl:value-of select="$CNX"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="@module"/>
        <xsl:if test="@target">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="@target"/>
        </xsl:if>
      </xsl:attribute>        
      <xsl:apply-templates/>
    </link>
  </xsl:template>

  <xsl:template name="fig-body">
    <xsl:choose>
      <xsl:when test="cnx:subfigure">
        <table index="{generate-id()}">
          <tr>
            <xsl:for-each select="cnx:subfigure">
              <td><xsl:apply-templates mode="in-ex"/></td>
            </xsl:for-each>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <p index="{generate-id()}">
          <xsl:apply-templates select="*[local-name()!='name' and local-name()!='caption']" mode="in-ex"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ********** think about a float/figure tag in OMDoc RT ******* --> 
  <xsl:template match="cnx:figure" mode="in-ex">
    <xsl:call-template name="fig-body"/>
    <xsl:if test="cnx:caption">
      <p class="caption" index="{generate-id()}-caption">
        <xsl:apply-templates select="cnx:caption"/>
      </p>      
    </xsl:if>
  </xsl:template>

  <xsl:template match="cnx:figure[cnx:caption]">
    <omgroup id="{@id}" type="float">
      <xsl:call-template name="name-metadata"/>
      <omtext id="{@id}-text">
        <CMP><xsl:call-template name="fig-body"/></CMP>
      </omtext>
      <omtext id="{@id}-caption">
        <CMP><xsl:apply-templates select="cnx:caption"/></CMP>
      </omtext>
    </omgroup>
  </xsl:template>
  
  <!-- no caption case -->
  <xsl:template match="cnx:figure">
    <omtext id="{@id}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:call-template name="fig-body"/></CMP>
    </omtext>
  </xsl:template>

  <xsl:template match="cnx:figure[cnx:caption]" mode="in-pf">
    <omtext id="{@id}">
      <xsl:call-template name="name-metadata"/>
      <CMP>
        <p id="{@id}-text"><xsl:call-template name="fig-body"/></p>
        <p id="{@id}-caption"><xsl:apply-templates select="cnx:caption"/></p>
      </CMP>
    </omtext>
  </xsl:template>
  
  <!-- no caption case -->
  <xsl:template match="cnx:figure" mode="in-pf">
    <omtext id="{@id}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:call-template name="fig-body"/></CMP>
    </omtext>
  </xsl:template>

  <xsl:template match="cnx:caption"><xsl:apply-templates/></xsl:template>


  <xsl:template match="cnx:table">
    <omtext id="{generate-id()}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:apply-templates select="*[local-name()!='name']"/></CMP>
    </omtext>
  </xsl:template>

  <!-- ******* dropping information ***** -->
  <xsl:template match="cnx:colspec"/>

  <!-- **** no place for table metadata **** -->
  <xsl:template match="cnx:table" mode="in-ex">
    <xsl:apply-templates select="*[local-name()!='name']"/>
  </xsl:template>
  <xsl:template match="cnx:tgroup"><table><xsl:apply-templates/></table></xsl:template>
  <xsl:template match="cnx:thead"><xsl:apply-templates mode="head"/></xsl:template>
  <xsl:template match="cnx:tbody"><xsl:apply-templates/></xsl:template>

  <xsl:template match="cnx:row" mode="head">
    <tr><xsl:apply-templates mode="head"/></tr>
  </xsl:template>
  <xsl:template match="cnx:row">
    <tr><xsl:apply-templates/></tr>
  </xsl:template>

  <xsl:template match="cnx:entry" mode="head">
    <th><xsl:apply-templates mode="in-ex"/></th>
  </xsl:template>
  <xsl:template match="cnx:entry">
    <td><xsl:apply-templates mode="in-ex"/></td>
  </xsl:template>

  <xsl:template match="cnx:equation" mode="in-ex">
    <!-- ***** no place for metadata here ***** -->
    <p id="{@id}" class="equation">
      <xsl:apply-templates select="*[local-name()!='name']"/>
    </p>
  </xsl:template>

  <xsl:template match="cnx:equation">
    <omtext id="{@id}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:apply-templates select="*[local-name()!='name']"/></CMP>
    </omtext>
  </xsl:template>

  <xsl:template match="cnx:equation" mode="in-pf">
    <derive id="{@id}">
      <xsl:call-template name="name-metadata"/>
      <CMP><xsl:apply-templates select="*[local-name()!='name']"/></CMP>
    </derive>
  </xsl:template>

  <xsl:template match="cnx:para">
    <xsl:call-template name="collect-textlike">
      <xsl:with-param name="nodes" select="child::node()|child::text()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="cnx:example/cnx:para|
                       cnx:exercise/cnx:para|
                       cnx:problem/cnx:para|
                       cnx:solution/cnx:para">
    <xsl:call-template name="collect-textlike-in-ex">
      <xsl:with-param name="nodes" select="child::node()|child::text()"/>
    </xsl:call-template>
  </xsl:template>

<xsl:template name="collect-textlike-in-ex">
  <xsl:param name="nodes"/>
  <xsl:if test="$nodes">
    <xsl:variable name="blocklike" select="$nodes[omdoc:blocklike()]"/>
    <xsl:variable name="textlike">
      <xsl:choose>
        <xsl:when test="$blocklike">
          <xsl:apply-templates select="set:leading($nodes,$blocklike)" mode="in-ex"/>
        </xsl:when>
        <xsl:otherwise><xsl:apply-templates select="$nodes" mode="in-ex"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$textlike!=''"><p><xsl:copy-of select="$textlike"/></p></xsl:if>
    <xsl:apply-templates select="$blocklike[1]" mode="in-ex"/>
    <xsl:if test="$blocklike">
      <xsl:call-template name="collect-textlike-in-ex">
        <xsl:with-param name="nodes" select="set:trailing($nodes,$blocklike)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="collect-textlike">
  <xsl:param name="nodes"/>
  <xsl:if test="$nodes">
    <xsl:variable name="blocklike" select="$nodes[omdoc:blocklike()]"/>
    <xsl:variable name="textlike">
      <xsl:choose>
        <xsl:when test="$blocklike">
          <xsl:apply-templates select="set:leading($nodes,$blocklike)"/>
        </xsl:when>
        <xsl:otherwise><xsl:apply-templates select="$nodes"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$textlike!=''">
      <omtext>
        <xsl:attribute name="id">
          <xsl:choose>
            <xsl:when test="@id"><xsl:value-of select="concat(@id,'-',count($nodes))"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="concat(generate-id(),'-',count($nodes))"/></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <CMP><xsl:copy-of select="$textlike"/></CMP>
      </omtext>
    </xsl:if>
    <xsl:apply-templates select="$blocklike[1]"/>
    <xsl:if test="$blocklike">
      <xsl:call-template name="collect-textlike">
        <xsl:with-param name="nodes" select="set:trailing($nodes,$blocklike)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- this predicate decides whether an element is treated as a block element in xhtml
     (and must therefore be put in parallel to the <p> elements  -->
<func:function name="omdoc:blocklike">
  <xsl:choose>
    <xsl:when test="local-name()='equation' or 
                    local-name()='table' or
                    local-name()='figure' or
                    local-name()='list' or
                    local-name()='rule' or
                    local-name()='definition' or
                    local-name()='codeblock'"><func:result select="true()"/></xsl:when>
    <xsl:when test="local-name()='note' and 
                    (contains(@type,' ') or 
                     @type='quotation' or @type='Quotation' or @type='quote' or @type='Quote' or
                     @type='hint' or @type='Hint')"><func:result select="true()"/></xsl:when>
    <xsl:when test="@style and contains(@style,'display:block')"><func:result select="true()"/></xsl:when>
    <xsl:when test="@class and @class='displaymath'"><func:result select="true()"/></xsl:when>
    <xsl:otherwise><func:result select="false()"/></xsl:otherwise>
  </xsl:choose>
</func:function>

<!-- *******************   CNX specials here ************* -->
<xsl:template match="m:csymbol">
  <OMS cd="{omdoc:strip-prefix(@definitionURL)}" 
       name="{substring-after(@definitionURL,'#')}"/>
</xsl:template>

<xsl:template match="m:apply[m:csymbol and m:bvar]">
  <OMBIND>
  <OMS cd="{omdoc:strip-prefix(@definitionURL)}" 
       name="{substring-after(@definitionURL,'#')}"/>
  <OMBVAR><xsl:apply-templates select="m:bvar/*"/></OMBVAR>
  <xsl:apply-templates select="*[position() &gt; 1 and local-name()!='bvar']"/>
</OMBIND>
</xsl:template>

<xsl:template match="m:apply[m:csymbol[contains(@definitionURL,'argmax') or contains(@definitionURL,'argmin')]]">
  <xsl:variable name="head">
    <OMS cd="{omdoc:strip-prefix(@definitionURL)}" 
         name="{substring-after(@definitionURL,'#')}"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="m:bvar">
      <OMA>
        <xsl:copy-of select="$head"/>
        <OMA>
          <OMS cd="set1" name="suchthat"/>
          <OMS cd="missing" name="dummyset"/>
          <OMBIND>
            <OMS cd="fns1" name="lambda"/>
            <OMBVAR><xsl:apply-templates select="m:bvar/*"/></OMBVAR>
            <xsl:apply-templates select="m:condition/*"/>
          </OMBIND>
          <xsl:apply-templates select="*[position() &gt; 1]"/>
        </OMA>
      </OMA>
    </xsl:when>
    <xsl:when test="not(m:bvar or m:condition)">
      <OMA>
        <OMS cd="minmax1" name="{local-name(*[1])}"/>
        <OMA>
          <OMS cd="set1" name="set"/>
          <xsl:apply-templates select="*[position()&gt;1]"/>
        </OMA>
      </OMA>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>m:min and m:max must have both m:bvar and m:condition</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- this function strips off the path prefix and only leaves the file name -->
<func:function name="omdoc:strip-prefix">
 <xsl:param name="uri"/>
 <xsl:choose>
  <xsl:when test="contains($uri,'/')">
   <func:result select="omdoc:strip-prefix(substring-after($uri,'/'))"/>
  </xsl:when>
  <xsl:otherwise>
   <func:result select="$uri"/>
  </xsl:otherwise>
 </xsl:choose>
</func:function>

</xsl:stylesheet>
