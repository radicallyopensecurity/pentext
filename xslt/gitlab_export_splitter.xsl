<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <xsl:output indent="yes" method="xml"  suppress-indentation="pre"/>



    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <!--<xsl:template match="p[child::img[not(preceding-sibling::*)][not(following-sibling::*)]]">
        <xsl:copy-of select="img"/>
    </xsl:template>-->
    
    <!-- find p with only img children & free the children -->
    <xsl:template match="p[not(text()) and * and not(*[not(self::img)])]" priority="10">
        <xsl:copy-of select="*"/>
    </xsl:template>
    
    <!-- find p with intro text and single or double img and move img out of p -->
    <xsl:template match="
        p[node()[1][self::text()] and node()[2][self::img] and 
        (not(node()[3]) 
        or 
        (node()[3][self::img] and not(node()[4])))
        ]" priority="5">
        <p><xsl:copy-of select="node()[1]"/></p>
        <xsl:copy-of select="*"/>
    </xsl:template>

<!-- find p where last element is img and move img out of p (picking up some stragglers this way) -->
<xsl:template match="
        p[node()[last()][self::img]]" priority="1">
        <p><xsl:copy-of select="node()[position() &lt; last()]"/></p>
        <xsl:copy-of select="node()[last()]"/>
    </xsl:template>
</xsl:stylesheet>
