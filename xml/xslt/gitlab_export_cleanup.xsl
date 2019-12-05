<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- remove all spans; they are not used in pentext -->
    <xsl:template match="span">
            <xsl:apply-templates/>
    </xsl:template>
    
    <!-- remove all divs; they are not used in findings -->
    <xsl:template match="div">
            <xsl:apply-templates/>
    </xsl:template>
    
    <!-- convert <pre><code> to <pre> -->
    <xsl:template match="pre/code">
            <xsl:apply-templates/>
    </xsl:template>
    
    <!-- remove @class from pre -->
    <xsl:template match="pre/@class"/>
    
    <!-- remove @class from a -->
    <xsl:template match="a/@class"/>
    
    <!-- remove @alt from img -->
    <xsl:template match="img/@alt"/>
    
    <!-- TODO: change <img src="/uploads/ac943b3c98d3630f7b1d787c00aa9417/file.png"/> to 
    <img src="../screenshots/file.png"/> -->
    
    <!-- get rid of superfluous breaks before images or h3 tags -->
    <!-- (not perfect, ideally post-process result later to flatten img or h3 out of p -->
    <xsl:template match="br[following-sibling::img] | br[following-sibling::h3] | br[following-sibling::p]">
    </xsl:template>
    
    <!-- insert default img width to nudge pentesters :) -->
    <xsl:template match="img[not(@height) and not(@width)]">
        <xsl:copy><xsl:attribute name="width">17</xsl:attribute>
        <xsl:apply-templates select="@* | node()"/></xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
