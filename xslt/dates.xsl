<!--
Hardcoded localization for dates in NL, DE and EN (default)
to support internationalized dates according to document $lang
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dt-local="http://www.radical.sexy/schema/dt-local"
    version="2.0"
    exclude-result-prefixes="dt-local">

  <xsl:variable name="month-de">
    <m num="1"  name="Januar"/>
    <m num="2"  name="Februar"/>
    <m num="3"  name="März"/>
    <m num="4"  name="April"/>
    <m num="5"  name="Mai"/>
    <m num="6"  name="Juni"/>
    <m num="7"  name="Juli"/>
    <m num="8"  name="August"/>
    <m num="9"  name="September"/>
    <m num="10" name="Oktober"/>
    <m num="11" name="November"/>
    <m num="12" name="Dezember"/>
  </xsl:variable>

  <xsl:variable name="month-nl">
    <m num="1"  name="januari"/>
    <m num="2"  name="februari"/>
    <m num="3"  name="maart"/>
    <m num="4"  name="april"/>
    <m num="5"  name="mei"/>
    <m num="6"  name="juni"/>
    <m num="7"  name="juli"/>
    <m num="8"  name="augustus"/>
    <m num="9"  name="september"/>
    <m num="10" name="oktober"/>
    <m num="11" name="november"/>
    <m num="12" name="december"/>
  </xsl:variable>

  <xsl:variable name="month-en">
    <m num="1"  name="January"/>
    <m num="2"  name="February"/>
    <m num="3"  name="March"/>
    <m num="4"  name="April"/>
    <m num="5"  name="May"/>
    <m num="6"  name="June"/>
    <m num="7"  name="July"/>
    <m num="8"  name="August"/>
    <m num="9"  name="September"/>
    <m num="10" name="October"/>
    <m num="11" name="November"/>
    <m num="12" name="December"/>
  </xsl:variable>

  <xsl:function name="dt-local:format-date-local" as="xs:string">
    <xsl:param name="d"    as="xs:date"/>
    <xsl:param name="lang" as="xs:string"/>

    <xsl:variable name="day" select="day-from-date($d)"/>
    <xsl:variable name="mon" select="month-from-date($d)"/>
    <xsl:variable name="yr"  select="year-from-date($d)"/>

    <xsl:variable name="mname">
      <xsl:choose>
        <xsl:when test="$lang = 'de'">
          <xsl:value-of select="$month-de/m[@num = $mon]/@name"/>
        </xsl:when>
        <xsl:when test="$lang = 'nl'">
          <xsl:value-of select="$month-nl/m[@num = $mon]/@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$month-en/m[@num = $mon]/@name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <!-- German: "D. Monat YYYY" -->
      <xsl:when test="$lang = 'de'">
        <xsl:sequence select="concat($day, '. ', $mname, ' ', $yr)"/>
      </xsl:when>

      <!-- Dutch: "D maand YYYY" -->
      <xsl:when test="$lang = 'nl'">
        <xsl:sequence select="concat($day, ' ', $mname, ' ', $yr)"/>
      </xsl:when>

      <!-- English (default): "Month D, YYYY" -->
      <xsl:otherwise>
        <xsl:sequence select="concat($mname, ' ', $day, ', ', $yr)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="dt-local:format-dateTime-local" as="xs:string">
    <xsl:param name="d"    as="xs:dateTime"/>
    <xsl:param name="lang" as="xs:string"/>

    <xsl:variable name="d_date" select="xs:date($d)"/>
    <xsl:variable name="d_time" select="xs:time($d)"/>

    <fo:inline>
      <xsl:value-of select="dt-local:format-date-local($d_date, $lang)"/>
      <xsl:value-of select="$d_time"/>
    </fo:inline>
  </xsl:function>

  <xsl:function name="dt-local:format-date-local-tbd" as="xs:string">
    <xsl:param name="d"    as="xs:date?"/>
    <xsl:param name="lang" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="not(exists($d))">TBD</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="_d" select="xs:date($d)"/>
        <xsl:value-of select="dt-local:format-date-local($_d, $lang)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="dt-local:format-dateTime-local-tbd" as="xs:string">
    <xsl:param name="d"    as="xs:dateTime?"/>
    <xsl:param name="lang" as="xs:string"/>

    <xsl:choose>
      <xsl:when test="not(exists($d))">TBD</xsl:when>
      <xsl:otherwise>
        <xsl:variable name="_d" select="xs:dateTime($d)"/>
        <xsl:value-of select="dt-local:format-dateTime-local($_d, $lang)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>