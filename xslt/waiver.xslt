<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="waivers">
        <xsl:for-each
            select="/offerte/meta/permission_parties/client | /offerte/meta/permission_parties/party">
            <xsl:choose>
                <xsl:when test="local-name() = 'client'">
                    <!--only if it's the first (2nd and more go each in their own file) -->
                    <fo:block margin-bottom="1.5cm" break-before="page">
                        <!-- choose waiver -->
                        <!-- need to get these params here so they resolve correctly when generating waivers out of context -->
                        <xsl:call-template name="chooseWaiver">
                            <xsl:with-param name="signee_long" tunnel="yes">
                                <xsl:value-of select="full_name"/>
                            </xsl:with-param>
                            <xsl:with-param name="signee_short" tunnel="yes">
                                <xsl:value-of select="short_name"/>
                            </xsl:with-param>
                            <xsl:with-param name="signee_waiver_rep" tunnel="yes">
                                <xsl:value-of select="waiver_rep"/>
                            </xsl:with-param>
                            <xsl:with-param name="signee_street" tunnel="yes">
                                <xsl:value-of select="address"/>
                            </xsl:with-param>
                            <xsl:with-param name="signee_pc" tunnel="yes">
                                <xsl:value-of select="postal_code"/>
                            </xsl:with-param>
                            <xsl:with-param name="signee_city" tunnel="yes">
                                <xsl:value-of select="city"/>
                            </xsl:with-param>
                            <xsl:with-param name="signee_country" tunnel="yes">
                                <xsl:value-of select="country"/>
                            </xsl:with-param>
                            <xsl:with-param name="client" tunnel="yes">
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'client'">
                                        <xsl:value-of select="true()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="false()"/>
                                    </xsl:otherwise>
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
                            <xsl:call-template name="layout-master-set-flimsy"/>
                            <fo:page-sequence master-reference="Flimsy">
                                <xsl:call-template name="page_header_flimsy"/>
                                <xsl:call-template name="page_footer_flimsy"/>
                                <fo:flow flow-name="region-body"
                                    xsl:use-attribute-sets="DefaultFont">
                                    <fo:block>
                                        <fo:block margin-bottom="1.5cm">
                                            <!-- choose waiver -->
                                            <!-- need to get these params here so they resolve correctly when generating waivers out of context -->
                                            <xsl:call-template name="chooseWaiver">
                                                <xsl:with-param name="signee_long" tunnel="yes">
                                                  <xsl:value-of select="full_name"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="signee_short" tunnel="yes">
                                                  <xsl:value-of select="short_name"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="signee_waiver_rep"
                                                  tunnel="yes">
                                                  <xsl:value-of select="waiver_rep"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="signee_street" tunnel="yes">
                                                  <xsl:value-of select="address"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="signee_pc" tunnel="yes">
                                                  <xsl:value-of select="postal_code"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="signee_city" tunnel="yes">
                                                  <xsl:value-of select="city"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="signee_country" tunnel="yes">
                                                  <xsl:value-of select="country"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="client" tunnel="yes">
                                                  <xsl:choose>
                                                  <xsl:when test="local-name() = 'client'">
                                                  <xsl:value-of select="true()"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="false()"/>
                                                  </xsl:otherwise>
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
            <xsl:when test="/offerte/waivers/alternative_waiver[@Ref = $signeeID]">
                <xsl:apply-templates select="/offerte/waivers/alternative_waiver[@Ref = $signeeID]"
                    mode="apply"/>
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
        <xsl:apply-templates/>
        <xsl:call-template name="generate_waiver_signature_box"/>
    </xsl:template>

    <xsl:template name="generate_waiver_signature_box">
        <xsl:param name="signee_long" tunnel="yes"/>
        <xsl:param name="signee_waiver_rep" tunnel="yes"/>
        <xsl:param name="signee_city" tunnel="yes"/>

        <fo:block keep-together.within-page="always" xsl:use-attribute-sets="signaturebox">
            <fo:block xsl:use-attribute-sets="title-client">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringID" select="'signed'"/>
                </xsl:call-template>
            </fo:block>
            <fo:block>
                <fo:table xsl:use-attribute-sets="fwtable borders">
                    <fo:table-column column-width="proportional-column-width(50)"/>
                    <fo:table-column column-width="proportional-column-width(50)"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>For <fo:inline xsl:use-attribute-sets="bold"><xsl:value-of
                                            select="$signee_long"/></fo:inline></fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block/>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <xsl:choose>
                                    <xsl:when test="not($signee_waiver_rep = '')">
                                        <!-- we have a name for the signee -->
                                        <fo:block-container xsl:use-attribute-sets="signee">
                                            <fo:block xsl:use-attribute-sets="signee_signaturespace">
                                                <fo:leader
                                                  xsl:use-attribute-sets="signee_dottedline"
                                                  leader-length="8cm"/>
                                            </fo:block>
                                            <fo:block xsl:use-attribute-sets="signee_name">
                                                <xsl:value-of select="$signee_waiver_rep"/>
                                            </fo:block>
                                        </fo:block-container>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <fo:block-container xsl:use-attribute-sets="signee">
                                            <fo:block xsl:use-attribute-sets="signee_signaturespace">
                                                <fo:leader
                                                  xsl:use-attribute-sets="signee_dottedline"
                                                  leader-length="8cm"/>
                                            </fo:block>
                                            <fo:block margin-top="0.2cm" margin-bottom="0.2cm"
                                                  >Name:<fo:leader
                                                  xsl:use-attribute-sets="signee_dottedline"
                                                  leader-length="7.2cm"/></fo:block>
                                        </fo:block-container>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block/>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block/>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block> Date: <fo:leader
                                        xsl:use-attribute-sets="signee_dottedline"
                                        leader-length="7.32cm"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block/>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>

    <!-- deprecated element; ignore if still there -->
    <xsl:template match="generate_waiver_signature_box"/>

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

    <xsl:template match="signee_postal_code">
        <xsl:param name="signee_pc" tunnel="yes"/>
        <xsl:value-of select="$signee_pc"/>
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
        <xsl:choose>
            <xsl:when test="not($signee_waiver_rep = '')">
                <!-- we have a name for the signee -->

                <xsl:value-of select="$signee_waiver_rep"/>
            </xsl:when>
            <xsl:otherwise> (Name:) <fo:leader xsl:use-attribute-sets="signee_dottedline"
                    leader-length="7cm"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
