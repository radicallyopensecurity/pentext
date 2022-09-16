<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

   
    <xsl:output indent="yes" method="xml"  suppress-indentation="pre"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- remove all of the following elements; they are not used in pentext -->
    <!-- keep spans in pre; they are used for code highlighting -->
    <xsl:template match="span[not(ancestor::pre)] | div | font | hr">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- convert <pre><code> to <pre> -->
    <xsl:template match="pre/code">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- convert <li><p> to <li> -->
    <xsl:template match="li/p">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- remove selected attributes from selected elements -->
    <xsl:template match="pre/@class | a/@class | tr/@class | img/@alt"/>

    <!-- change em to i -->
    <xsl:template match="em">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <!-- change strong to b -->
    <xsl:template match="strong">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <!-- remove h*, make bold paragraph -->
    <xsl:template match="h2 | h3 | h4 | h5">
        <p>
            <b>
                <xsl:apply-templates/>
            </b>
        </p>
    </xsl:template>

    <!-- add .. to <img src="/uploads/[long code]/file.png"/> -->
    <xsl:template match="img/@src">
        <xsl:choose>
            <xsl:when test="starts-with(., '/uploads/')">
                <xsl:attribute name="src" select="concat('..', .)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- get rid of superfluous breaks before images or h3 tags -->
    <!-- (not perfect, ideally post-process result later to flatten img or h3 out of p -->
    <xsl:template
        match="br[following-sibling::img] | br[following-sibling::h3] | br[following-sibling::p]"> </xsl:template>

    <!-- insert default img width to familiarize pentesters with the concept of image size :) -->
    <xsl:template match="img[not(@height) and not(@width)]">
        <xsl:copy>
            <xsl:attribute name="width">17</xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!--if a description or an impact tag contains only a p, remove the p (unless it has element children).-->
    <xsl:template
        match="description/p[not(preceding-sibling::*)][not(following-sibling::*)][not(*)] | impact/p[not(preceding-sibling::*)][not(following-sibling::*)][not(*)]">
        <xsl:apply-templates/>
    </xsl:template>

    

</xsl:stylesheet>
