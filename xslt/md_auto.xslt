<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://www.radical.sexy"
  exclude-result-prefixes="xs my"
  version="2.0"
>

  <!-- Calculates person-days from min/max durations -->
  <xsl:function name="my:calculatePersonDays" as="xs:string">
    <xsl:param name="context" as="element()" />
    <xsl:variable
      name="durations"
      select="$context//entry[@type='service']/dh"
    />
    <xsl:variable name="min" select="sum($durations/min)" />
    <xsl:variable name="max" select="sum($durations/max)" />
    <xsl:if test="$min != $max">
      <xsl:value-of select="$min div 8" />
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$max div 8" />
    </xsl:if>
    <xsl:if test="$min = $max">
      <xsl:value-of select="$min div 8" />
    </xsl:if>
  </xsl:function>

  <!-- Generates target list -->
  <xsl:function name="my:generateTargets" as="xs:string">
    <xsl:param name="context" as="element()" />
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="$context//targets/target">
      <xsl:text>- </xsl:text>
      <xsl:apply-templates select="." />
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:function>

  <!-- Generates version number (auto or explicit) -->
  <xsl:template name="VersionNumber">
    <xsl:param name="number" select="@number" />
    <xsl:choose>
      <!-- if value is auto, do some autonumbering magic -->
      <xsl:when test="string(@number) = 'auto'">
        0.
        <xsl:number
          count="version"
          level="multiple"
          format="{$AUTO_NUMBERING_FORMAT}"
        />
        <!-- this is really unrobust :D - todo: follow fixed numbering if provided -->
      </xsl:when>
      <xsl:otherwise>
        <!-- just plop down the value -->
        <!-- todo: guard numbering format in schema -->
        <xsl:value-of select="@number" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
