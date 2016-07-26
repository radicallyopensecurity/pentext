<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    
    <xsl:import href="styles.xslt"/>
    
    <!-- variables -->
    
    <xsl:variable name="medium-space">10pt</xsl:variable>
    <xsl:variable name="large-space">1.5cm</xsl:variable>
    
   
    
    <!-- Text -->

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
    <xsl:attribute-set name="title-0" use-attribute-sets="title">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
        <xsl:attribute name="background-color">#FF5C00</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-1" use-attribute-sets="title">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
        <xsl:attribute name="background-color">#FF5C00</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-2" use-attribute-sets="title">
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.8cm</xsl:attribute>
        <xsl:attribute name="background-color">#999999</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-3" use-attribute-sets="title">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.8cm</xsl:attribute>
        <xsl:attribute name="background-color">#999999</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-4" use-attribute-sets="title">
        <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-client" use-attribute-sets="title-0">
        <xsl:attribute name="background-color">#999999</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="for">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="p">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$medium-space"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="indent">
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$large-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list" use-attribute-sets="p"/>
    <xsl:attribute-set name="indented-list">
        <xsl:attribute name="provisional-distance-between-starts">0.75cm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">2.5mm</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="start-indent">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="last">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$very-large-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pre" use-attribute-sets="borders TableFont">
        <xsl:attribute name="border-style">double</xsl:attribute>
        <xsl:attribute name="border-width">2pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$medium-space"/>
        </xsl:attribute>
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="code" use-attribute-sets="borders pre">
        <xsl:attribute name="font-family">LiberationMono</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="finding-meta">
        <xsl:attribute name="margin-bottom" select="$small-space"/>
    </xsl:attribute-set>
    
    <!-- Pages -->
    <xsl:attribute-set name="PortraitPage">
        <xsl:attribute name="margin-top">1.5cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.8cm</xsl:attribute>
        <xsl:attribute name="margin-left">2cm</xsl:attribute>
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
        <xsl:attribute name="page-height">29.7cm</xsl:attribute>
        <xsl:attribute name="page-width">21.0cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-body">
        <xsl:attribute name="margin-top">1cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-before">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">0.6cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-after">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">0.6cm</xsl:attribute>
        <xsl:attribute name="padding">0</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- colors -->
    <xsl:attribute-set name="bg-orange">
        <xsl:attribute name="background-color">#FF5C00</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- graphics -->
    <xsl:attribute-set name="graphics-block">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-bottom" select="$small-space"/>
    </xsl:attribute-set>
    <xsl:attribute-set name="logo">
        <xsl:attribute name="padding-top">0cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.5cm</xsl:attribute>
        <xsl:attribute name="src">url(../graphics/logo.png)</xsl:attribute>
        <xsl:attribute name="width">45mm</xsl:attribute>
        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- tables -->
    <xsl:attribute-set name="borders">
        <xsl:attribute name="border-width">
            <xsl:value-of select="$border-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-style">
            <xsl:value-of select="$border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-color">
            <xsl:value-of select="$border-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="th" use-attribute-sets="td bg-orange"/>
    <xsl:attribute-set name="td">
        <xsl:attribute name="padding">2pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table">
        <xsl:attribute name="margin-bottom" select="$small-space"/>
    </xsl:attribute-set>
    
    <!-- lists -->
    <xsl:attribute-set name="li">
        <xsl:attribute name="margin-bottom" select="$small-space"/>
    </xsl:attribute-set>
    
    <!-- ToC -->
    <xsl:attribute-set name="index" use-attribute-sets="break-after"/>
    
    <xsl:attribute-set name="toc-block" use-attribute-sets="bg-orange">
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        <xsl:attribute name="padding-right">3pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Breaks -->
    <xsl:attribute-set name="break-before">
        <xsl:attribute name="break-before">page</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="break-after">
        <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>