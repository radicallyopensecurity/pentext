<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

	<xsl:template name="string-replace">
		<xsl:param name="string"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="contains($string, $replace)">
				<xsl:value-of select="substring-before($string, $replace)"/>
				<xsl:value-of select="$by"/>
				<xsl:call-template name="string-replace">
					<xsl:with-param name="string" select="substring-after($string, $replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="value-escape">
		<xsl:param name="value"/>
		<xsl:variable name="replace1">"</xsl:variable>
		<xsl:variable name="by1">\"</xsl:variable>
		<xsl:variable name="replace2"><xsl:text>
</xsl:text></xsl:variable>
		<xsl:variable name="by2">\n</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($value, $replace1)">
				<xsl:value-of select="substring-before($value, $replace1)"/>
				<xsl:value-of select="$by1"/>
				<xsl:call-template name="string-replace">
					<xsl:with-param name="value" select="substring-after($value, $replace1)"/>
					<xsl:with-param name="replace" select="$replace1"/>
					<xsl:with-param name="by" select="$by1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains($value, $replace2)">
						<xsl:value-of select="substring-before($value, $replace2)"/>
						<xsl:value-of select="$by2"/>
						<xsl:call-template name="string-replace">
							<xsl:with-param name="value" select="substring-after($value, $replace2)"/>
							<xsl:with-param name="replace" select="$replace2"/>
							<xsl:with-param name="by" select="$by2"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/pentest_report">{
    "projects": [
	"key": "&lt;KEY&gt;",
	"issues": [
<xsl:apply-templates select="//finding"/>	]
    ]
}
</xsl:template>

	<!-- finding -->
	<xsl:template match="finding">	    {
		"status": "To Do",
		"reporter": "ROS",
		"externalId": "<xsl:value-of select="concat(/pentest_report/@findingCode,'-',string(format-number(@number,'000')))"/>",
		"issueType": "<xsl:value-of select="@type"/>",
		"priority": "<xsl:value-of select="@threatLevel"/>",
		"summary": "<xsl:call-template name="value-escape"><xsl:with-param name="value" select="description"/></xsl:call-template>",
		"description": "<xsl:call-template name="value-escape"><xsl:with-param name="value" select="description"/></xsl:call-template>\n\n\nTechnical description:\n\n<xsl:call-template name="value-escape"><xsl:with-param name="value" select="technicaldescription"/></xsl:call-template>\n\n\nImpact:\n\n<xsl:call-template name="value-escape"><xsl:with-param name="value" select="impact"/></xsl:call-template>\n\n\nRecommendation:\n\n<xsl:choose><xsl:when test="string-length(recommendation/ul) &gt; 0"><xsl:for-each select="recommendation/ul/li"> * <xsl:call-template name="value-escape"><xsl:with-param name="value" select="."/></xsl:call-template>\n</xsl:for-each></xsl:when><xsl:otherwise><xsl:call-template name="value-escape"><xsl:with-param name="value" select="recommendation"/></xsl:call-template></xsl:otherwise></xsl:choose>"
	    },
</xsl:template>
</xsl:stylesheet>
