<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="placeholders.xslt"/>
    
    <xsl:template name="displayErrorText">
        <xsl:param name="string" select="'XXXXXXXXXX'"/>
        <fo:inline xsl:use-attribute-sets="errortext"><xsl:value-of select="$string"/></fo:inline>
    </xsl:template>

    <xsl:template name="generate_activities">
        <fo:list-block xsl:use-attribute-sets="list">
            <xsl:for-each select="/contract/meta/work/activities/activity">
                <fo:list-item>
                    <!-- insert a bullet -->
                    <fo:list-item-label end-indent="label-end()">
                        <fo:block>
                            <fo:inline>&#8226;</fo:inline>
                        </fo:block>
                    </fo:list-item-label>
                    <!-- list text -->
                    <fo:list-item-body start-indent="body-start()">
                        <fo:block>
                            <xsl:value-of select="."/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>
    
</xsl:stylesheet>