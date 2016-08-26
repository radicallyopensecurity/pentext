<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:import href="styles.xslt"/>
    
    <!-- variables -->
    
    <xsl:variable name="medium-space">8pt</xsl:variable>
    
    
    
    
    <!-- Text -->
 
    <xsl:attribute-set name="title">
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-0" use-attribute-sets="title">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">2cm</xsl:attribute>
        <xsl:attribute name="background-color">orange</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-1" use-attribute-sets="title">
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
        <xsl:attribute name="background-color">orange</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-2" use-attribute-sets="title">
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.8cm</xsl:attribute>
        <xsl:attribute name="background-color">silver</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-3" use-attribute-sets="title">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.8cm</xsl:attribute>
        <xsl:attribute name="background-color">silver</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-4" use-attribute-sets="title">
        <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-client" use-attribute-sets="title-0">
        <xsl:attribute name="background-color">silver</xsl:attribute>
        <xsl:attribute name="margin-bottom">6cm</xsl:attribute>
        <xsl:attribute name="text-transform">capitalize</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="for">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="p">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$small-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="toc-block">
        <xsl:attribute name="background-color">orange</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="logo">
        <xsl:attribute name="padding-top">2cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">3cm</xsl:attribute>
        <xsl:attribute name="src">url(../graphics/logo.png)</xsl:attribute>
        <xsl:attribute name="width">70mm</xsl:attribute>
        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
    </xsl:attribute-set>
    
    
    <!-- colors -->
    <xsl:attribute-set name="bg-orange">
        <xsl:attribute name="background-color">orange</xsl:attribute>
    </xsl:attribute-set>
    
   
    
   
    
    
</xsl:stylesheet>