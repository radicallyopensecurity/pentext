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
        <xsl:attribute name="margin-bottom">2.8cm</xsl:attribute>
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
    <xsl:attribute-set name="title-0" use-attribute-sets="title bg-orange">
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="margin-top">1cm</xsl:attribute>
        <xsl:attribute name="margin-right">0cm</xsl:attribute>
        <xsl:attribute name="padding-right">0.3cm</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-2" use-attribute-sets="title">
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="margin-left">0cm</xsl:attribute>
        <xsl:attribute name="padding-left">0.3cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="border-top">
        <xsl:attribute name="border-before-width">
            <xsl:value-of select="$border-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-before-style">
            <xsl:value-of select="$border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-before-color">
            <xsl:value-of select="$border-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="td">
        <xsl:attribute name="border-collapse">separate</xsl:attribute>
        <xsl:attribute name="border-spacing">5mm</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="padding-top">
        <xsl:attribute name="padding-top">5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table-shading" use-attribute-sets="findingTable">
        <xsl:attribute name="border-left">1px solid #e4e4e4</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="text-align-last">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sidetab"/>
    <xsl:attribute-set name="sidetab-textblock"/>
    <xsl:attribute-set name="for"/>
    <xsl:attribute-set name="coverfooter"/>

</xsl:stylesheet>
