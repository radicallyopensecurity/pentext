<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="waivers">
        <xsl:for-each
            select="/offerte/meta/permission_parties/client | /offerte/meta/permission_parties/party">
            
            
            
            <xsl:choose>
                <xsl:when test="local-name() = 'client'">
                    <fo:block margin-bottom="1.5cm">
            <!--only if it's the first (2nd and more go each in their own file) -->
            <xsl:attribute name="break-before">page</xsl:attribute>
            <!-- choose waiver -->
            <!-- need to get these params here so they resolve correctly when generating waivers out of context -->
            <xsl:call-template name="chooseWaiver">
                <xsl:with-param name="signee_long" tunnel="yes"><xsl:value-of select="full_name"/></xsl:with-param>
                <xsl:with-param name="signee_short" tunnel="yes"><xsl:value-of select="short_name"/></xsl:with-param>
            <xsl:with-param name="signee_waiver_rep" tunnel="yes"><xsl:value-of select="waiver_rep"/></xsl:with-param>
            <xsl:with-param name="signee_street" tunnel="yes"><xsl:value-of select="address"/></xsl:with-param>
            <xsl:with-param name="signee_city" tunnel="yes"><xsl:value-of select="city"/></xsl:with-param>
            <xsl:with-param name="signee_country" tunnel="yes"><xsl:value-of select="country"/>
            </xsl:with-param>
                <xsl:with-param name="client" tunnel="yes">
                    <xsl:choose>
                        <xsl:when test="local-name() = 'client'"><xsl:value-of select="true()"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            </fo:block>
                </xsl:when>
                <xsl:when test="local-name() = 'party'">
                    <!-- create an additional .fo file for every party that needs to sign -->
                    <xsl:variable name="cname_file">
                        <xsl:value-of select="translate(short_name, ' ', '')"/>
                    </xsl:variable>
                    <xsl:variable name="filename">
                        <xsl:value-of select="concat('../target/waiver_', $cname_file, '.fo')"/>
                    </xsl:variable>
                    <xsl:result-document href="{$filename}">
                        <fo:root>
                            <xsl:call-template name="layout-master-set"/>
                            <fo:page-sequence master-reference="Report">
                                <xsl:call-template name="page_header"/>
                                <xsl:call-template name="page_footer"/>
                                <fo:flow flow-name="region-body"
                                    xsl:use-attribute-sets="DefaultFont">
                                    <fo:block>
                                        <fo:block margin-bottom="1.5cm">
                                            <!-- choose waiver -->
            <!-- need to get these params here so they resolve correctly when generating waivers out of context -->
            <xsl:call-template name="chooseWaiver">
                <xsl:with-param name="signee_long" tunnel="yes"><xsl:value-of select="full_name"/></xsl:with-param>
                <xsl:with-param name="signee_short" tunnel="yes"><xsl:value-of select="short_name"/></xsl:with-param>
            <xsl:with-param name="signee_waiver_rep" tunnel="yes"><xsl:value-of select="waiver_rep"/></xsl:with-param>
            <xsl:with-param name="signee_street" tunnel="yes"><xsl:value-of select="address"/></xsl:with-param>
            <xsl:with-param name="signee_city" tunnel="yes"><xsl:value-of select="city"/></xsl:with-param>
            <xsl:with-param name="signee_country" tunnel="yes"><xsl:value-of select="country"/>
            </xsl:with-param>
                <xsl:with-param name="client" tunnel="yes">
                    <xsl:choose>
                        <xsl:when test="local-name() = 'client'"><xsl:value-of select="true()"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="false()"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
                                        </fo:block>
                                    </fo:block>
                                    <fo:block id="EndOfDoc"/>
                                </fo:flow>
                            </fo:page-sequence>

                        </fo:root>
                    </xsl:result-document>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="chooseWaiver">
        <!-- Still in client/party context here -->
        <xsl:variable name="signeeID" select="./@id"/>
        <xsl:choose>
            <xsl:when test="/offerte/waivers/alternative_waiver[@Ref=$signeeID]">
                <xsl:apply-templates select="/offerte/waivers/alternative_waiver[@Ref=$signeeID]" mode="apply"/>
                    
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="/offerte/waivers/standard_waiver" mode="apply"/>
                   
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- waivers should only be generated on call, not when they appear in the doc -->
    <xsl:template match="alternative_waiver | standard_waiver"/>
    
    <xsl:template match="alternative_waiver | standard_waiver" mode="apply">
        <xsl:param name="client" tunnel="yes"/>
            <!-- WAIVER TITLE -->
            <fo:block xsl:use-attribute-sets="title-1">
                <xsl:if test="$client = true()">
                    <xsl:text>ANNEX 2</xsl:text>
                    <fo:block/>
                </xsl:if>
            </fo:block>
            <xsl:apply-templates/>
    </xsl:template>


    <xsl:template name="generate_waiver_signature_box">
        <fo:block keep-together.within-page="always" xsl:use-attribute-sets="signaturebox">
            <fo:table width="100%" table-layout="fixed">
                <fo:table-column column-width="proportional-column-width(10)"/>
                <fo:table-column column-width="proportional-column-width(90)"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="td" number-rows-spanned="4">
                            <fo:block>
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringID" select="'waiver_signed'"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block xsl:use-attribute-sets="p"><xsl:call-template name="getString">
                                    <xsl:with-param name="stringID" select="'waiver_signed_on'"/>
                                </xsl:call-template> &#160;&#160;&#160;<xsl:value-of
                                    select="$latestVersionDate"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block xsl:use-attribute-sets="p"><xsl:call-template name="getString">
                                    <xsl:with-param name="stringID" select="'waiver_signed_in'"/>
                                </xsl:call-template> &#160;&#160;&#160; <xsl:value-of select="city"
                                /></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <xsl:choose>
                                <xsl:when test="waiver_rep">
                                    <fo:block xsl:use-attribute-sets="p"><xsl:call-template
                                            name="getString">
                                            <xsl:with-param name="stringID"
                                                select="'waiver_signed_by'"/>
                                        </xsl:call-template> &#160;&#160;&#160;<xsl:value-of
                                            select="waiver_rep"/></fo:block>
                                </xsl:when>
                                <xsl:otherwise>
                                    <fo:block xsl:use-attribute-sets="p"><xsl:call-template
                                            name="getString">
                                            <xsl:with-param name="stringID"
                                                select="'waiver_signed_by'"/>
                                        </xsl:call-template>
                                        &#160;&#160;&#160;__________________________________</fo:block>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block xsl:use-attribute-sets="p"><xsl:call-template name="getString">
                                    <xsl:with-param name="stringID" select="'waiver_signed_for'"/>
                                </xsl:call-template> &#160;&#160;&#160;<xsl:value-of
                                    select="full_name"/></fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
    
    <!-- special waiver placeholders -->
    <!-- (tunnel ftw ;) -->
    <xsl:template match="signee_long">
        <xsl:param name="signee_long" tunnel="yes"/>
        <xsl:value-of select="$signee_long"/>
    </xsl:template>
    
    <xsl:template match="signee_short">
        <xsl:param name="signee_short" tunnel="yes"/>
        <xsl:value-of select="$signee_short"/>
    </xsl:template>
    
    <xsl:template match="signee_street">
        <xsl:param name="signee_street" tunnel="yes"/>
        <xsl:value-of select="$signee_street"/>
    </xsl:template>
    
    <xsl:template match="signee_city">
        <xsl:param name="signee_city" tunnel="yes"/>
        <xsl:value-of select="$signee_city"/>
    </xsl:template>
    
    <xsl:template match="signee_country">
        <xsl:param name="signee_country" tunnel="yes"/>
        <xsl:value-of select="$signee_country"/>
    </xsl:template>
    
    <xsl:template match="signee_waiver_rep">
        <xsl:param name="signee_waiver_rep" tunnel="yes"/>
        <xsl:value-of select="$signee_waiver_rep"/>
    </xsl:template>
</xsl:stylesheet>
