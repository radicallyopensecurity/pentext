<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" />
	<xsl:strip-space elements="*"/>
	<xsl:variable name="delimiter">;</xsl:variable>

	<xsl:template match="/pentest_report">
		<xsl:apply-templates select="//finding"/>
	</xsl:template>

	<!-- finding -->
	<xsl:template match="finding">
		<xsl:value-of select="concat(/pentest_report/@findingCode,'-',string(format-number(position(),'000')))"/><xsl:value-of select="$delimiter"/>
		<xsl:value-of select="@type"/><xsl:value-of select="$delimiter"/>
		<xsl:value-of select="@threatLevel"/><xsl:value-of select="$delimiter"/>
		<xsl:value-of select="translate(description/p,$delimiter,',')"/><xsl:value-of select="$delimiter"/>
		<xsl:choose>
			<xsl:when test="string-length(recommendation/ul) &gt; 0">
				<xsl:for-each select="recommendation/ul/li">
					<xsl:value-of select="translate(.,$delimiter,',')"/>
					<xsl:if test="position() &lt; last()">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="string-length(recommendation/p) &gt; 0">
				<xsl:value-of select="translate(recommendation/p,$delimiter,',')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(recommendation,$delimiter,',')"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>
</xsl:text>
	</xsl:template>
</xsl:stylesheet>
