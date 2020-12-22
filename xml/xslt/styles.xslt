<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">


    
    <!-- Note: pie chart colors can be customized in functions_params_vars.xslt -->
    
    <!-- variables -->
    <xsl:variable name="border-width">1pt</xsl:variable>
    <xsl:variable name="border-style">solid</xsl:variable>
    <xsl:variable name="tabbed-numbering-tabwidth">20mm</xsl:variable>
    <xsl:variable name="small-space">2mm</xsl:variable>
    <xsl:variable name="medium-space">4mm</xsl:variable>
    <xsl:variable name="large-space">8mm</xsl:variable>
    <xsl:variable name="very-large-space">1.3cm</xsl:variable>

    <!-- User-accessible classes -->
    <xsl:attribute-set name="keep-together">
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Common settings -->
    <xsl:attribute-set name="root-common">
        <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
    </xsl:attribute-set>
    

    <!-- Text -->
    <xsl:attribute-set name="DefaultFont">
        <xsl:attribute name="color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="font-family">LiberationSansNarrow</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="HeaderFont" use-attribute-sets="DefaultFont"/>
    <xsl:attribute-set name="FooterFont" use-attribute-sets="DefaultFont"/>
    <xsl:attribute-set name="TableFont" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="PieFont">
        <xsl:attribute name="font-family">LiberationSansNarrow</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="TinyFont" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="PreFont" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-family">LiberationMono</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="errortext">
        <xsl:attribute name="background-color">black</xsl:attribute>
        <xsl:attribute name="color"><xsl:value-of select="$color_moderate"/></xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="censoredblock" use-attribute-sets="censoredtext"/>
    <xsl:attribute-set name="censoredtext">
        <xsl:attribute name="background-color">black</xsl:attribute>
        <xsl:attribute name="color">white</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="title">
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-family">OpenSans</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="numbered-title">
        <xsl:attribute name="provisional-label-separation">3mm</xsl:attribute>
        <xsl:attribute name="padding-left">2mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-0" use-attribute-sets="title">
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="color"><xsl:value-of select="$c_main_contrast"/></xsl:attribute>
        <xsl:attribute name="margin-top">0.4cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.4cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-1" use-attribute-sets="title">
        <xsl:attribute name="color"><xsl:value-of select="$c_main"/></xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.6cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-2" use-attribute-sets="title">
        <xsl:attribute name="color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.3cm</xsl:attribute>
        <xsl:attribute name="margin-top">0.3cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-3" use-attribute-sets="title">
        <xsl:attribute name="color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-4" use-attribute-sets="title">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-client" use-attribute-sets="title">
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-sub" use-attribute-sets="title">
        <xsl:attribute name="color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.5cm</xsl:attribute>
        <xsl:attribute name="margin-top">0.4cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-toc" use-attribute-sets="title">
        <xsl:attribute name="color"><xsl:value-of select="$c_main"/></xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.7cm</xsl:attribute>
        <xsl:attribute name="font-family">OpenSans</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-waiver" use-attribute-sets="title">
        <xsl:attribute name="color"><xsl:value-of select="$c_main"/></xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
        <xsl:attribute name="text-transform">capitalize</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="img-title">
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="margin-left">1cm</xsl:attribute>
        <xsl:attribute name="margin-right">1cm</xsl:attribute>
        <xsl:attribute name="margin-top">0.5cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title-findingsection" use-attribute-sets="title-4 indent"/>
    <xsl:attribute-set name="section">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$very-large-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h-title">
        <xsl:attribute name="padding-top">3pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="h2" use-attribute-sets="bold h-title">
        <xsl:attribute name="font-size">13pt</xsl:attribute></xsl:attribute-set>
    <xsl:attribute-set name="h3" use-attribute-sets="bold h-title">
        <xsl:attribute name="font-size">12pt</xsl:attribute></xsl:attribute-set>
    <xsl:attribute-set name="h4" use-attribute-sets="bold h-title"></xsl:attribute-set>
    <xsl:attribute-set name="bold">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="italic">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="underline">
        <xsl:attribute name="text-decoration">underline</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="code" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-family">LiberationMono</xsl:attribute>
        <xsl:attribute name="font-size">85%</xsl:attribute>
        <xsl:attribute name="background-color">#eeeeee</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">1pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="code-title" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-family">LiberationMono</xsl:attribute>
        <xsl:attribute name="color">inherit</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-size">85%</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="sup" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-size">60%</xsl:attribute>
        <xsl:attribute name="vertical-align">super</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="sub" use-attribute-sets="DefaultFont">
        <xsl:attribute name="font-size">60%</xsl:attribute>
        <xsl:attribute name="vertical-align">sub</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="link">
        <xsl:attribute name="color"><xsl:value-of select="$c_main"/></xsl:attribute>
    </xsl:attribute-set>
    
    <!-- bibliography -->
    <xsl:attribute-set name="title.book" use-attribute-sets="italic"/>
    <xsl:attribute-set name="title.article"/>
    <xsl:attribute-set name="journal" use-attribute-sets="italic"/>
    <xsl:attribute-set name="website"/>
    <xsl:attribute-set name="info"/>
    <xsl:attribute-set name="publisher"/>
    <xsl:attribute-set name="pubdate"/>
    
    <!-- blocks -->
    <xsl:attribute-set name="indent"/>
    <xsl:attribute-set name="p" use-attribute-sets="indent">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$small-space"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">6mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="blockquote">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_support_light"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_subtlydarkerlight"/></xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width">1pt</xsl:attribute>
        <xsl:attribute name="margin-bottom" select="$medium-space"/>
        <xsl:attribute name="padding">4pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="biblioentry" use-attribute-sets="indent">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$small-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="last">
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$very-large-space"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="pre" use-attribute-sets="PreFont indent">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_support_light"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_subtlydarkerlight"/></xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-width">1pt</xsl:attribute>
        <xsl:attribute name="margin-bottom" select="$medium-space"/>
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="padding">4pt</xsl:attribute>
        <xsl:attribute name="line-height">4mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="finding-meta">
        <xsl:attribute name="margin-bottom" select="$small-space"/>
    </xsl:attribute-set>
    <xsl:attribute-set name="finding-content" use-attribute-sets="p">
        <xsl:attribute name="margin-bottom" select="$large-space"/>
    </xsl:attribute-set>

    <!-- Pages -->
    <xsl:attribute-set name="PortraitPage">
        <xsl:attribute name="margin-top">0cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">0cm</xsl:attribute>
        <xsl:attribute name="margin-left">0cm</xsl:attribute>
        <xsl:attribute name="margin-right">0cm</xsl:attribute>
        <xsl:attribute name="page-height">29.7cm</xsl:attribute>
        <xsl:attribute name="page-width">21.0cm</xsl:attribute>
    </xsl:attribute-set>
    <!-- Front Matter (Cover, Meta, ToC) -->
    <!-- Flow -->
    <xsl:attribute-set name="cover-flow"/>
    
    <!-- Regions -->
    <xsl:attribute-set name="region-before-cover"/>
    <xsl:attribute-set name="region-after-cover"/>
    
    <!-- Content Matter -->
    <!-- Flow -->    
    <!-- Regions -->
    <xsl:attribute-set name="region-body-content">
        <xsl:attribute name="margin-top">2.5cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">2.5cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-body-content-odd" use-attribute-sets="region-body-content">
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
        <xsl:attribute name="margin-left">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-body-content-even" use-attribute-sets="region-body-content">
        <xsl:attribute name="margin-left">2cm</xsl:attribute>
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
    </xsl:attribute-set>    
    <xsl:attribute-set name="region-before-content">
        <xsl:attribute name="precedence">true</xsl:attribute>
        <xsl:attribute name="extent">4.6cm</xsl:attribute><!-- overlaps body since it's empty anyway and we need to push down the tab in region-end -->
    </xsl:attribute-set>
    <xsl:attribute-set name="region-before-content-odd" use-attribute-sets="region-before-content"/>
    <xsl:attribute-set name="region-before-content-even" use-attribute-sets="region-before-content"/>
    <xsl:attribute-set name="region-after-content">
        <xsl:attribute name="extent">2.1cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-start-content-odd">
        <xsl:attribute name="extent">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="region-end-content-even">
        <xsl:attribute name="extent">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="color"><xsl:value-of select="$c_support_medium"/></xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="padding-top">0.7cm</xsl:attribute>
        <xsl:attribute name="border-before-width">1px</xsl:attribute>
        <xsl:attribute name="border-before-style">solid</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header-odd">
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
    <xsl:attribute-set name="footer-odd" use-attribute-sets="footer">
        <!-- need to set margin-right to 0cm to force block to accept padding -->
        <xsl:attribute name="margin-right">0cm</xsl:attribute>
        <xsl:attribute name="padding-right">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer-even" use-attribute-sets="footer">
        <!-- need to set margin-right to 0cm to force block to accept padding -->
        <xsl:attribute name="margin-left">0cm</xsl:attribute>
        <xsl:attribute name="padding-left">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footerlogo">
        <xsl:attribute name="padding-top">23.3cm</xsl:attribute>
        <xsl:attribute name="margin-left">0.2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="frontlogo">
        <xsl:attribute name="margin-left">2cm</xsl:attribute>
        <xsl:attribute name="margin-top">3cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="front-titleblock-container">
        <!-- fo:footnote-body element -->
        <xsl:attribute name="font-family">LiberationSansNarrow</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="front-titleblock">
        <xsl:attribute name="margin-right">2cm</xsl:attribute>
        <xsl:attribute name="margin-left">9cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="frontrows">
        <!-- because block margins are inherited... why? -->
        <xsl:attribute name="margin-left">0cm</xsl:attribute>
        <xsl:attribute name="margin-right">0cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="front-titlerow" use-attribute-sets="frontrows">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_main"/></xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="front-subtitlerow" use-attribute-sets="frontrows">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_main_contrast"/></xsl:attribute>
        <xsl:attribute name="padding-left">0.5cm</xsl:attribute>
        <xsl:attribute name="padding-top">0.7cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.4cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="front-metarow" use-attribute-sets="frontrows">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_main_contrast"/></xsl:attribute>
        <xsl:attribute name="padding-left">0.5cm</xsl:attribute>
        <xsl:attribute name="padding-top">0.5cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">1.2cm</xsl:attribute>
    </xsl:attribute-set>

    <!-- graphics -->
    <xsl:attribute-set name="frontpagetext">
        <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="graphics-block">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <!-- tables -->
    <xsl:attribute-set name="borders">
        <xsl:attribute name="border-color"><xsl:value-of select="$c_support_dark"/></xsl:attribute>
        <xsl:attribute name="border-width">
            <xsl:value-of select="$border-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-style">
            <xsl:value-of select="$border-style"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="th" use-attribute-sets="td  indent_reset">
        <xsl:attribute name="background-color"><xsl:value-of select="$c_main"/></xsl:attribute>
        <xsl:attribute name="color"><xsl:value-of select="$c_main_contrast"/></xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="td" use-attribute-sets="indent_reset">
        <xsl:attribute name="padding-left">4pt</xsl:attribute>
        <xsl:attribute name="padding-right">4pt</xsl:attribute>
        <xsl:attribute name="padding-top">3pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="fwtable">
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table" use-attribute-sets="indent">
        <xsl:attribute name="margin-bottom" select="$small-space"/>
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="th-row">
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- lists -->
    <xsl:attribute-set name="list">
        <xsl:attribute name="provisional-distance-between-starts">0.7cm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">2mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.2cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.5cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list_summarytable" use-attribute-sets="list">                  
        <xsl:attribute name="padding-bottom">0cm</xsl:attribute>
        <xsl:attribute name="padding-top">0cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="li">
        <xsl:attribute name="line-height">6.5mm</xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
    </xsl:attribute-set>
    

    <!-- ToC -->
    <xsl:attribute-set name="index">
        <xsl:attribute name="break-after">page</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="tocCell" use-attribute-sets="indent_reset">
        <xsl:attribute name="padding-bottom">1.5mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section-tocblock">
        <xsl:attribute name="margin-left">8cm</xsl:attribute>
        <xsl:attribute name="background-color">white</xsl:attribute>
        <xsl:attribute name="padding-left">1cm</xsl:attribute>
        <xsl:attribute name="padding-top">0.7cm</xsl:attribute>
        <xsl:attribute name="padding-bottom">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="section-toc-footnote">
        <xsl:attribute name="font-family">LiberationSansNarrow</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <!-- Contact -->
    <xsl:attribute-set name="Contact">
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="margin-left" select="$very-large-space"/>
        <xsl:attribute name="line-height">18pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="coc">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-top">15px</xsl:attribute>
        <xsl:attribute name="color"><xsl:value-of select="$c_support_medium"/></xsl:attribute>
    </xsl:attribute-set>

    <!-- Signature boxes -->
    <xsl:attribute-set name="signaturebox">
        <xsl:attribute name="margin-top" select="$very-large-space"/>
    </xsl:attribute-set>

    <!-- Misc -->
    <xsl:attribute-set name="align-right">
        <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="big-space-below">
        <xsl:attribute name="margin-bottom">8mm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="important">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="margin-top">1cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="indent_reset">
        <xsl:attribute name="start-indent">0</xsl:attribute>
        <xsl:attribute name="end-indent">0</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="breakdowntable" use-attribute-sets="fwtable borders">
        <xsl:attribute name="margin-top">0.5cm</xsl:attribute>
        <xsl:attribute name="margin-bottom">0.2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="totalRow"/>
    <xsl:attribute-set name="totalcell"/>
    
    <!-- Third party waiver / Flimsy styles -->
    <xsl:attribute-set name="PortraitPage_flimsy">
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
        <xsl:attribute name="color">
            <xsl:value-of select="$c_main"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header">
        <xsl:attribute name="color">
            <xsl:value-of select="$c_support_medium"/>
        </xsl:attribute>
        <xsl:attribute name="border-color">
            <xsl:value-of select="$c_support_dark"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">1cm</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <!-- need to set margin-right to 0cm to force block to accept padding -->
        <xsl:attribute name="margin-right">0cm</xsl:attribute>
        <xsl:attribute name="padding-right">2cm</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="signee"/>
    <xsl:attribute-set name="signee_name"/>
    <xsl:attribute-set name="signee_signaturespace"/>
    <xsl:attribute-set name="signee_dottedline"/>
    
</xsl:stylesheet>
