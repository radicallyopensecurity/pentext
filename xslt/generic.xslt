<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="@id">
        <!-- copy all ids! -->
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="@break">
        <xsl:choose>
                <!-- section-type elements can have optional breaks -->
                <xsl:when test=".='before'">
                    <xsl:attribute name="break-before">page</xsl:attribute>
                </xsl:when>
                <xsl:when test=".='after'">
                    <xsl:attribute name="break-after">page</xsl:attribute>
                </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="@class">
        <xsl:call-template name="use-att-set">
            <xsl:with-param name="CLASS" select="string(.)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="@*"/>
    <!-- hide any attributes that are not explicitly handled -->
    
</xsl:stylesheet>