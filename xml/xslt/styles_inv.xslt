<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="styles.xslt"/>
    
    <!-- variables -->
    
    <xsl:variable name="medium-space">10pt</xsl:variable>
    
    <xsl:attribute-set name="title" use-attribute-sets="bold">
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <!-- letter spacing is dodgy in fop when there are certain characters in the string (e.g. a 'V'); commenting this out until that is fixed -->
        <!-- it's also dodgy in combination with centered text, btw -->
        <!--<xsl:attribute name="letter-spacing.precedence">0</xsl:attribute>
        <xsl:attribute name="letter-spacing.optimum">3mm</xsl:attribute>
        <xsl:attribute name="letter-spacing.minimum">3mm</xsl:attribute>
        <xsl:attribute name="letter-spacing.maximum">3mm</xsl:attribute>-->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="PortraitPage">
        <xsl:attribute name="margin-top">0.5cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.5cm</xsl:attribute>
        <xsl:attribute name="margin-left">1.5cm</xsl:attribute>
        <xsl:attribute name="margin-right">1.5cm</xsl:attribute>
        <xsl:attribute name="page-height">29.7cm</xsl:attribute>
        <xsl:attribute name="page-width">21.0cm</xsl:attribute>
    </xsl:attribute-set>
       <xsl:attribute-set name="region-body-cover">
        <xsl:attribute name="margin-top">3.6cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-before-cover">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">2.7cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-after-cover">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">0.6cm</xsl:attribute>
        <xsl:attribute name="padding">0</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-body-content">
        <xsl:attribute name="margin-top">2cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-before-content">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">0.6cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-after-content">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">0.6cm</xsl:attribute>
        <xsl:attribute name="padding">0</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="logo">
        <xsl:attribute name="padding-top">0cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0cm</xsl:attribute>
        <xsl:attribute name="src">url(../graphics/logo.png)</xsl:attribute>
        <xsl:attribute name="width">30mm</xsl:attribute>
        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-0" use-attribute-sets="title">
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="background-color">#FF5C00</xsl:attribute>
        <xsl:attribute name="margin-top">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-2" use-attribute-sets="title">
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
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
    <xsl:attribute-set name="table-shading">
        <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>
