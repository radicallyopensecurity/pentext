<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://www.radical.sexy"
  xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  exclude-result-prefixes="xs my map"
  version="2.0"
>
  <xsl:import href="numbering.xslt" />
  <xsl:import href="localisation.xslt" />
  <xsl:import href="md_placeholders.xslt" />
  <!-- Includes functions calculatePersonDays, generateTargets
       Includes template VersionNumber -->
  <xsl:import href="md_auto.xslt" />
  <!-- Includes Markdown formatting -->
  <xsl:import href="md_formatting.xslt" />  
  <xsl:include href="functions_params_vars.xslt" />

  <xsl:preserve-space elements="pre code" />
  <xsl:strip-space elements="*" />
  <xsl:output method="text" encoding="UTF-8" indent="no" />

  <xsl:param name="NUMBERING" select="true()" />

  <!-- Dynamically skip identifiers from the report -->
  <xsl:variable
    name="skip-ids"
    select="
        if (unparsed-text-available('../exclude-ids.txt'))
        then tokenize(unparsed-text('../exclude-ids.txt'), '\s*,\s*|\s+')
        else ()
    "
  />

  <!-- Text node normalization -->
  <xsl:template match="text()[normalize-space()][not(ancestor::pre)]">
    <xsl:value-of select="normalize-space(.)" />
    <xsl:if test="following-sibling::text()[normalize-space()][1]">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Root -->
  <xsl:template match="/">
    <xsl:apply-templates select="/*/section | /*/appendix" />
  </xsl:template>

  <!-- Sections/Appendices -->
  <xsl:template match="section | appendix">
    <xsl:if test="not(@id = $skip-ids)">
      <xsl:apply-templates select="node()" />
    </xsl:if>
  </xsl:template>

  <!-- Findings -->
  <xsl:template match="finding">
    <xsl:text>&#10;### </xsl:text>
    <xsl:value-of select="@number" />
    <xsl:text> - </xsl:text>
    <xsl:value-of select="title" />
    <xsl:text>&#10;&#10;</xsl:text>

    <xsl:variable
      name="info"
      select="map {
            'Type': normalize-space(@type),
            'Identifier': @id,
            'Threat Level': @threatLevel
        }"
    />
    <xsl:for-each select="map:keys($info)">
      <xsl:call-template name="finding-section">
        <xsl:with-param name="label" select="." />
        <xsl:with-param name="value" select="$info(.)" />
      </xsl:call-template>
    </xsl:for-each>

    <xsl:variable
      name="sectionLabels"
      select="map {
            'description': 'Description',
            'technicaldescription': 'Technical Description',
            'update': 'Update',
            'impact': 'Impact',
            'recommendation': 'Recommendation'
        }"
    />
    <xsl:for-each
      select="description|technicaldescription|update|impact|recommendation"
    >
      <xsl:text>&#10;#### </xsl:text>
      <xsl:value-of select="$sectionLabels(local-name())" />
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="finding-section">
    <xsl:param name="label" />
    <xsl:param name="value" />
    <xsl:text>&#10;#### </xsl:text>
    <xsl:value-of select="$label" />
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$value" />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
