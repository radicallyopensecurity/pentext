<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:import href="styles.xslt"/>

    <!-- variables -->

    <!-- Text -->
    <xsl:attribute-set name="p">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$small-space"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="title-2" use-attribute-sets="title">
        <xsl:attribute name="color">black</xsl:attribute>
        <!--
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.3cm</xsl:attribute>
        <xsl:attribute name="margin-top">0.3cm</xsl:attribute>-->
    </xsl:attribute-set>

    <!-- Pages -->
    <xsl:attribute-set name="region-body-cover"> </xsl:attribute-set>

    <!-- service breakdown -->
    <xsl:attribute-set name="totalcell">
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="totalRow">
        <xsl:attribute name="border-top">1px solid black</xsl:attribute>
    </xsl:attribute-set>

    <!-- Signature box -->
    <xsl:attribute-set name="signee">
        <xsl:attribute name="height">2.85cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="signee_name">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="margin-right">0.75cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="signee_signaturespace">
        <xsl:attribute name="margin-top">1.75cm</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.2px</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="signee_dottedline">
        <xsl:attribute name="leader-pattern">dots</xsl:attribute>
        <xsl:attribute name="leader-pattern-width">1mm</xsl:attribute>
    </xsl:attribute-set>
    
   
    
</xsl:stylesheet>
