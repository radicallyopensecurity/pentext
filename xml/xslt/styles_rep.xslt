<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:import href="styles.xslt"/>
    
    <!-- Retest status colors -->
    <xsl:attribute-set name="status-new"><!-- also used by unresolved -->
        <xsl:attribute name="color"><xsl:value-of select="$color_new"/></xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="status-resolved">
        <xsl:attribute name="color"><xsl:value-of select="$color_resolved"/></xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="status-not_retested">
        <xsl:attribute name="color"><xsl:value-of select="$color_notretested"/></xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Status tags -->
    <xsl:attribute-set name="status-tag">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_support_light"/></xsl:attribute>
        <xsl:attribute name="font-size">70%</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Text -->
    <xsl:attribute-set name="p">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$small-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Pages -->
    <xsl:attribute-set name="region-body-cover">
        
    </xsl:attribute-set>
   
    <!-- Findings -->
    <xsl:attribute-set name="findingTable">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_support_light"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_subtlydarkerlight"/></xsl:attribute>
        <xsl:attribute name="margin-bottom" select="$large-space"/>
        <xsl:attribute name="padding-left">-8pt</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-width">1px</xsl:attribute>
        <xsl:attribute name="border-right-width">1px</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1px</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Charts -->
    <xsl:attribute-set name="pieChartTable" use-attribute-sets="indent">
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pieLegendTable">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_support_light"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_subtlydarkerlight"/></xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pieLegendTableCell" use-attribute-sets="indent_reset">
        <xsl:attribute name="padding-left">4pt</xsl:attribute>
    </xsl:attribute-set>
    
</xsl:stylesheet>
