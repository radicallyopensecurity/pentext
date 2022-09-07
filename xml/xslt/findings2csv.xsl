<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:strip-space elements="*"/>
  <xsl:variable name="delimiter">&quot;,&quot;</xsl:variable>
  <xsl:variable name="quote" select="'&quot;'" />
  <xsl:template match="/pentest_report">
    <xsl:apply-templates select="//finding"/>
  </xsl:template>
  <!-- finding -->
  <xsl:template match="finding">
    <xsl:value-of select="$quote"/>
    <xsl:value-of select="concat(/pentest_report/@findingCode,'-',string(format-number(@number,'000')))"/>
    <xsl:value-of select="$delimiter"/>
    <xsl:value-of select="normalize-space(title)"/>
    <xsl:value-of select="$delimiter"/>
    <xsl:value-of select="@type"/>
    <xsl:value-of select="$delimiter"/>
    <xsl:value-of select="@threatLevel"/>
    <xsl:value-of select="$delimiter"/>
    <xsl:value-of select="normalize-space(description)"/>
    <xsl:value-of select="$delimiter"/>
    <xsl:choose>
      <xsl:when test="string-length(recommendation/ul) &gt; 0">
        <xsl:for-each select="recommendation/ul/li">
          <xsl:value-of select="normalize-space(.)"/>
          <xsl:if test="position() &lt; last()">
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="string-length(recommendation/p) &gt; 0">
        <xsl:value-of select="normalize-space(recommendation/p)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(recommendation)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&quot;&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
