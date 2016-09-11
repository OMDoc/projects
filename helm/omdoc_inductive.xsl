<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:m="http://www.w3.org/1998/Math/MathML"
                              xmlns:helm="http://www.cs.unibo.it/helm"
                              xmlns="http://www.mathweb.org/omdoc">

<!-- Next template modified from proofs.xsl -->
<xsl:template match="APPLY">
 <xsl:choose>
  <xsl:when test="@sort != 'Prop'">
   <xsl:apply-templates mode="pure" select="."/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:variable name="id" select="@id"/>
   <xsl:choose>
    <xsl:when test="CONST[1]">
     <xsl:variable name="uri" select="CONST[1]/@uri"/>
     <xsl:choose>
      <xsl:when test="contains($uri,'_ind.con')">
       <xsl:variable name="ind_uri" 
         select="concat(substring-before($uri,'_ind.con'),'.ind')"/>
       <xsl:variable name="inductive_def" 
     select="document(concat(string($absPath),$ind_uri))/InductiveDefinition"/>
       <!-- check if the corresponding inductive definition actually
            exists -->
       <xsl:choose>
        <xsl:when test="$inductive_def">
         <xsl:variable name="ind_name">
          <xsl:call-template name="name_of_uri">
           <xsl:with-param name="uri" select="$uri"/>
           <xsl:with-param name="ext" select="'_ind.con'"/>
          </xsl:call-template>
         </xsl:variable>
         <xsl:variable name="no_params">
          <xsl:call-template name="get_no_params">
           <xsl:with-param name="first_uri" select="$CICURI"/>
           <xsl:with-param name="second_uri" select="$uri"/>
          </xsl:call-template>
         </xsl:variable>
         <xsl:apply-templates mode="inductive" select=".">
          <xsl:with-param name="inductive_def_principle_uri" 
           select="$uri"/>
          <xsl:with-param name="inductive_def_uri" 
           select="$ind_uri"/>
          <xsl:with-param name="inductive_def" 
           select="$inductive_def"/>
          <xsl:with-param name="section_params" select="$no_params"/>
          <xsl:with-param name="inductive_def_index" select="1"/>
          <xsl:with-param name="inductive_def_name" select="$ind_name"/>
         </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
         <xsl:apply-templates mode="not_inductive" select="."/>
        </xsl:otherwise>
       </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
       <xsl:apply-templates mode="not_inductive" select="."/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
     <xsl:apply-templates mode="not_inductive" select="."/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- Next template modified from inductive.xsl -->
<xsl:template mode="inductive" match="APPLY">
 <xsl:param name="inductive_def_uri" select="''"/>
 <xsl:param name="inductive_def_principle_uri" select="''"/>
 <xsl:param name="inductive_def" select="/.."/>
 <xsl:param name="inductive_def_index" select="1"/>
 <xsl:param name="inductive_def_name" select="''"/>
 <xsl:param name="section_params" select="0"/>
 <xsl:variable name="id" select="@id"/>
 <!-- expected_args_type contains the types of the arguments expected by
      the induction principle -->
 <xsl:variable name="expected_args_types" 
        select="document(concat(string($absPath),*[1]/@uri))/Definition/type//PROD[not(ancestor::source)]/source/*[1]"/>
 <xsl:variable name="no_expected_args" select="count($expected_args_types)"/>
 <xsl:variable name="actual_arguments" select="*[position()>(1+$section_params)]"/>
 <!-- First check that the induction principle is applied to the
      expected number of arguments -->
 <xsl:choose>
  <xsl:when test="$no_expected_args = count($actual_arguments)">
   <!-- Now check that each actual argument starts with the
        expected number of lambda abstractions -->
   <xsl:variable name="argsOK">
    <xsl:call-template name="check_args">
     <xsl:with-param name="arg_types" select="$expected_args_types"/>
     <xsl:with-param name="actual_args" select="$actual_arguments"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:choose>
    <!-- il semplice test $argsOK non funziona -->
    <xsl:when test="string($argsOK) = 'true'">
     <!-- arguments are in the expected form: we create a
          "by_induction" content element -->
     <!-- no_params is the number of paramters in square brackets -->
     <xsl:variable name="no_params" 
      select="$inductive_def/@noParams"/>
     <!-- the inductive property is the first argument following
          the parameters  -->
     <xsl:variable name="inductive_property" 
               select="$actual_arguments[1 + $no_params]"/>
     <xsl:variable name="tail_args" 
      select="$actual_arguments[position()> (1 + $no_params)]"/>
     <!-- inductive_type contains the right inductive type in the
          mutual inductive definition -->
     <xsl:variable name="inductive_type" 
      select="$inductive_def/InductiveType[position()=$inductive_def_index]"/>
     <xsl:variable name="no_constructors" 
      select="count($inductive_type/Constructor)"/>
     <!-- each case has a single argument -->
     <xsl:variable name="args_for_cases" 
      select="$tail_args[($no_constructors + 1) > position()]"/>
     <!-- extra_args contains the remaining arguments; the LAST one
          of them is the argument we are inductively arguing on -->
     <xsl:variable name="extra_args" 
      select="$tail_args[position()> $no_constructors]"/>
     <!-- principle is the URI of the induction principle -->
     <induction id="{@id}" idt="{$inductive_def_uri}" principle="{$inductive_def_principle_uri}">
      <!-- property is the generalized inductive property (a type!) -->
      <property>
       <xsl:apply-templates mode="pure" select="$inductive_property"/>
      </property>
      <cases>
       <xsl:for-each select="$inductive_type/Constructor">
        <xsl:variable name="pos" select="position()"/>
        <xsl:variable name="current_arg" 
                      select="$args_for_cases[position()=$pos]"/>
        <case id="c-{$id}-{@name}">
         <not-inductive-hypotheses id="{@name}">
          <!-- next template makes a list of <arguments/> -->
          <xsl:call-template name="get_constructor_args">
           <xsl:with-param name="no_params" 
                select="$no_params"/>
           <xsl:with-param name="constructor_arity" 
                select="*[1]"/>
           <xsl:with-param name="actual_arg" 
                select="$current_arg"/>
           <xsl:with-param name="inductive_def_name" 
                select="$inductive_def_name"/>
           <xsl:with-param name="discharging_point" 
                select="$id"/>
          </xsl:call-template>
         </not-inductive-hypotheses>
         <induction-hypotheses>
          <!-- next template make a list of <hypothesis/> -->
          <xsl:call-template name="get_induction_hypothesis">
           <xsl:with-param name="no_params" 
                select="$no_params"/>
           <xsl:with-param name="constructor_arity" 
                select="*[1]"/>
           <xsl:with-param name="actual_arg" 
                select="$current_arg"/>
           <xsl:with-param name="inductive_def_name" 
                select="$inductive_def_name"/>
           <xsl:with-param name="discharging_point" 
                select="$id"/>
          </xsl:call-template>
         </induction-hypotheses>
         <!-- next template insert an optional <FMP> -->
         <xsl:call-template name="get_body_inner_type">
          <xsl:with-param name="no_params" 
                select="$no_params"/>
          <xsl:with-param name="constructor_arity" 
                select="*[1]"/>
          <xsl:with-param name="actual_arg" select="$current_arg"/>
          <xsl:with-param name="inductive_def_name" 
                select="$inductive_def_name"/>
         </xsl:call-template>
         <proof id="p-{$id}-{@name}" for="c-{$id}-{@name}">
          <xsl:call-template name="get_body">
           <xsl:with-param name="no_params" 
                 select="$no_params"/>
           <xsl:with-param name="constructor_arity" 
                 select="*[1]"/>
           <xsl:with-param name="actual_arg" select="$current_arg"/>
           <xsl:with-param name="inductive_def_name" 
                 select="$inductive_def_name"/>
          </xsl:call-template>
         </proof>
        </case>
       </xsl:for-each>
      </cases>
      <!-- to be got rid of... if possible ;-) -->
      <extra-args>
       <xsl:apply-templates mode="pure" select="$extra_args"/>
      </extra-args>
     </induction>
    </xsl:when>
    <xsl:otherwise>
     <xsl:apply-templates mode="not_inductive" select="."/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates mode="not_inductive" select="."/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- check_args checks that the number of lambda abstractions
     of each actual parameter is GREATER OR EQUAL to the number
     or products of the corresponding formal parameter of the
     induction principles. That is, that each argument is 
     sufficiently eta-expanded.
     If this is not the case, not good rendering looks possible.
     Check_args returns a boolean. 
   -->
<xsl:template name="check_args">
 <xsl:param name="arg_types" select="/.."/>
 <xsl:param name="actual_args" select="/.."/>
 <xsl:param name="bool_var" select="true()"/>
 <xsl:choose>
  <xsl:when test="count($arg_types) = 0">
    <xsl:value-of select="$bool_var"/>
  </xsl:when>
  <xsl:otherwise>
   <xsl:variable name="no_expected_arg_of_arg">
    <xsl:apply-templates mode="count_arity" select="$arg_types[1]">
     <xsl:with-param name="what" select="'PROD'"/>
    </xsl:apply-templates>
   </xsl:variable>
   <xsl:variable name="no_actual_abst_of_arg">
    <xsl:apply-templates mode="count_arity" select="$actual_args[1]">
     <xsl:with-param name="what" select="'LAMBDA'"/>
    </xsl:apply-templates>
   </xsl:variable>
   <!-- REPLACE WITH EQUALITY ???? -->
   <xsl:variable name="test_arg" 
    select="$no_actual_abst_of_arg >= $no_expected_arg_of_arg"/>
   <xsl:call-template name="check_args">
    <xsl:with-param name="arg_types" select="$arg_types[position()>1]"/>
    <xsl:with-param name="actual_args" select="$actual_args[position()>1]"/>
    <xsl:with-param name="bool_var" select="($bool_var and $test_arg)"/>
   </xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- count_arity counts the number of head lambda (or prod) -->
<xsl:template mode="count_arity" match="*">
 <xsl:param name="what" select="'LAMBDA'"/>
 <xsl:param name="num" select="0"/>
 <!-- MANCANO I CAST ??? -->
 <xsl:choose>
  <xsl:when test="name(.) = $what">
   <xsl:apply-templates mode="count_arity" select="target/*[1]">
    <xsl:with-param name="what" select="$what"/>
    <xsl:with-param name="num" select="$num+1"/>
   </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$num"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- The following three functions are essentially identical
     in their recursive structure.
     The problem is that of decomposing an actual argument for
     a case in three parts: 
     * constructor variables
     * induction hypothesis
     * body
     To this aim we must proceed in parallel with the type of
     the constructor: if the type contains a prod, then the 
     the corresponding lambda of the argument provides the 
     constructor variable. Moreover, if the source type of the
     prod contains a reference to the inductive type, it is a
     recursive argument and the NEXT lambda of the argument 
     provides an induction hypothesis.
     Unfortunately the three functions cannot be merged into a
     single one without a conversion from document tree fragments
     to node-sets. 
-->
<!-- ERROR: if not of sort Prop they are NOT hypothesis!!! -->
<!-- Note: everywhere an hypothesis could now be of sort Set or Type ;-( -->
<xsl:template name="get_constructor_args">
 <xsl:param name="no_params" select="0"/>
 <xsl:param name="constructor_arity" select="/.."/>
 <xsl:param name="actual_arg" select="/.."/>
 <xsl:param name="inductive_def_name" select="''"/>
 <xsl:param name="discharging_point" select="''"/>
 <xsl:choose>
  <xsl:when test="$no_params = 0">
   <xsl:if test="name($constructor_arity)='PROD'">
    <hypothesis id="c-{$discharging_point}-{$actual_arg/target/@binder}" discharged-in="{$discharging_point}">
     <type system="coq">
      <xsl:apply-templates mode="pure" select="$actual_arg/source/*[1]"/>
     </type>
    </hypothesis>
    <xsl:choose>
     <xsl:when test="$constructor_arity/source//REL[@binder=$inductive_def_name]">    <xsl:call-template name="get_constructor_args">
       <xsl:with-param name="constructor_arity" 
           select="$constructor_arity/target/*[1]"/>
       <xsl:with-param name="actual_arg" 
           select="$actual_arg/target/LAMBDA/target/*[1]"/>
       <xsl:with-param name="inductive_def_name" 
                  select="$inductive_def_name"/>
       <xsl:with-param name="discharging_point" 
                  select="$discharging_point"/>
      </xsl:call-template>
     </xsl:when>
     <xsl:otherwise>
      <xsl:call-template name="get_constructor_args">
       <xsl:with-param name="constructor_arity" 
           select="$constructor_arity/target/*[1]"/>
       <xsl:with-param name="actual_arg" 
           select="$actual_arg/target/*[1]"/>
       <xsl:with-param name="inductive_def_name" 
           select="$inductive_def_name"/>
       <xsl:with-param name="discharging_point" 
                  select="$discharging_point"/>
      </xsl:call-template>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:if>
  </xsl:when>
  <xsl:otherwise>
   <xsl:call-template name="get_constructor_args">
    <xsl:with-param name="no_params" select="$no_params - 1"/>
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    <xsl:with-param name="discharging_point" 
               select="$discharging_point"/>
   </xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="get_induction_hypothesis">
 <xsl:param name="no_params" select="0"/>
 <xsl:param name="constructor_arity" select="/.."/>
 <xsl:param name="actual_arg" select="/.."/>
 <xsl:param name="inductive_def_name" select="''"/>
 <xsl:param name="discharging_point" select="''"/>
 <xsl:choose>
 <xsl:when test="$no_params = 0">
 <xsl:if test="name($constructor_arity)='PROD'">
  <xsl:choose>
   <xsl:when test="$constructor_arity/source//REL[@binder=$inductive_def_name]">
    <hypothesis id="c-{$discharging_point}-{$actual_arg/target/LAMBDA/target/@binder}" discharged-in="{$discharging_point}">
     <type system="coq">
      <xsl:apply-templates mode="pure" select="$actual_arg/target/LAMBDA/source/*[1]"/>
     </type>
    </hypothesis>
    <xsl:call-template name="get_induction_hypothesis">
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg/target/LAMBDA/target/*[1]"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    <xsl:with-param name="discharging_point" 
               select="$discharging_point"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="get_induction_hypothesis">
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg/target/*[1]"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    <xsl:with-param name="discharging_point" 
               select="$discharging_point"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:if>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="get_induction_hypothesis">
    <xsl:with-param name="no_params" select="$no_params - 1"/>
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    <xsl:with-param name="discharging_point" 
               select="$discharging_point"/>
    </xsl:call-template>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="get_body">
 <xsl:param name="no_params" select="0"/>
 <xsl:param name="constructor_arity" select="/.."/>
 <xsl:param name="actual_arg" select="/.."/>
 <xsl:param name="inductive_def_name" select="''"/>
 <xsl:choose>
 <xsl:when test="$no_params = 0">
 <xsl:choose>
 <xsl:when test="name($constructor_arity)='PROD'">
  <xsl:choose>
   <xsl:when test="$constructor_arity/source//REL[@binder=$inductive_def_name]">    <xsl:call-template name="get_body">
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg/target/LAMBDA/target/*[1]"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="get_body">
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg/target/*[1]"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="$actual_arg"/>
 </xsl:otherwise>
 </xsl:choose>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="get_body">
    <xsl:with-param name="no_params" select="$no_params - 1"/>
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    </xsl:call-template>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="get_body_inner_type">
 <xsl:param name="no_params" select="0"/>
 <xsl:param name="constructor_arity" select="/.."/>
 <xsl:param name="actual_arg" select="/.."/>
 <xsl:param name="inductive_def_name" select="''"/>
 <xsl:choose>
 <xsl:when test="$no_params = 0">
 <xsl:choose>
 <xsl:when test="name($constructor_arity)='PROD'">
  <xsl:choose>
   <xsl:when test="$constructor_arity/source//REL[@binder=$inductive_def_name]">    <xsl:call-template name="get_body_inner_type">
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg/target/LAMBDA/target/*[1]"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="get_body_inner_type">
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg/target/*[1]"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 <xsl:otherwise>
  <xsl:if test="$InnerTypes/InnerTypes/TYPE[@of=$actual_arg/@id]/*">
   <FMP>
    <xsl:apply-templates select="$InnerTypes/InnerTypes/TYPE[@of=$actual_arg/@id]/*"/>
   </FMP>
  </xsl:if>
 </xsl:otherwise>
 </xsl:choose>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="get_body_inner_type">
    <xsl:with-param name="no_params" select="$no_params - 1"/>
    <xsl:with-param name="constructor_arity" 
        select="$constructor_arity/target/*[1]"/>
    <xsl:with-param name="actual_arg" 
        select="$actual_arg"/>
    <xsl:with-param name="inductive_def_name" 
               select="$inductive_def_name"/>
    </xsl:call-template>
 </xsl:otherwise>
 </xsl:choose>
</xsl:template>

</xsl:stylesheet>
