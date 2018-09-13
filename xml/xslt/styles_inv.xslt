<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="styles.xslt"/>
        
    <xsl:attribute-set name="PortraitPage">
        <xsl:attribute name="margin-top">0.5cm</xsl:attribute>
        <xsl:attribute name="margin-left">2cm</xsl:attribute>
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
        <xsl:attribute name="page-height">29.7cm</xsl:attribute>
        <xsl:attribute name="page-width">21.0cm</xsl:attribute>
        <xsl:attribute name="line-height">5.5mm</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-body-first">
        <xsl:attribute name="margin-top">3.7cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">2.1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-before-first">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">3.6cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-after-first">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">2cm</xsl:attribute>
        <xsl:attribute name="padding">0</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-body-rest">
        <xsl:attribute name="margin-top">2cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-before-rest">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-after-rest">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">2cm</xsl:attribute>
        <xsl:attribute name="padding">0</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="logo">
        <xsl:attribute name="padding-top">0cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0cm</xsl:attribute>
        <xsl:attribute name="src">url(../graphics/logo_alt.png)</xsl:attribute>
        <xsl:attribute name="width">30mm</xsl:attribute>
        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-1" use-attribute-sets="title">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="color"><xsl:value-of select="$c_main"/></xsl:attribute>
        <xsl:attribute name="padding-top">1cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="border-top">
        <xsl:attribute name="border-before-width">
            <xsl:value-of select="$border-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-before-style">
            <xsl:value-of select="$border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-before-color">
            <xsl:value-of select="$c_support_dark"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="main-color">
        <xsl:attribute name="color"><xsl:value-of select="$c_main"/></xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="td">
        <xsl:attribute name="border-collapse">separate</xsl:attribute>
        <xsl:attribute name="border-spacing">5mm</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="padding-top">
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table-shading">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_support_light"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_subtlydarkerlight"/></xsl:attribute>
        <xsl:attribute name="margin-bottom" select="$large-space"/>
        <xsl:attribute name="padding-left">-8pt</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width">1px</xsl:attribute>
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="text-align-last">center</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header">
        <xsl:attribute name="color"><xsl:value-of select="$c_support_medium"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="padding-top">1cm</xsl:attribute>
        <xsl:attribute name="border-before-width">1px</xsl:attribute>
        <xsl:attribute name="border-before-style">solid</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <!-- need to set margin-right to 0cm to force block to accept padding -->
        <xsl:attribute name="margin-right">0cm</xsl:attribute>
        <xsl:attribute name="padding-right">2cm</xsl:attribute>
    </xsl:attribute-set>
    
</xsl:stylesheet>
