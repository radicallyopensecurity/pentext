<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="generate_targets">
        <xsl:call-template name="generate_targets_xslt"/>
    </xsl:template>

    <xsl:template name="generate_targets_xslt">
        <xsl:param name="Ref" select="@Ref"/>
        <fo:list-block xsl:use-attribute-sets="list" provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm" space-after="12pt" start-indent="1cm">
            <xsl:for-each
                select="/*/meta/targets/target[@Ref = $Ref] | /*/meta/targets/target[not(@Ref)]">
                <fo:list-item>
                    <!-- insert a bullet -->
                    <fo:list-item-label end-indent="label-end()">
                        <fo:block>
                            <fo:inline>&#8226;</fo:inline>
                        </fo:block>
                    </fo:list-item-label>
                    <!-- list text -->
                    <fo:list-item-body start-indent="body-start()">
                        <fo:block>
                            <xsl:value-of select="."/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:for-each>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="generate_findings">
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="status" select="@status"/>
        <fo:block>
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(12)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(22)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(50)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(16)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row xsl:use-attribute-sets="bg-orange borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Description</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Threat level</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:choose>
                        <xsl:when test="@status and @Ref">
                            <!-- Only generate a table for findings in the section with this status AND this Ref -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[@status = $status][ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@status and not(@Ref)">
                            <!-- Only generate a table for findings in the section with this status -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[@status = $status]">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@Ref and not(@status)">
                            <!-- Only generate a table for findings in the section with this Ref -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="/pentest_report/descendant::finding">
                                <xsl:call-template name="findingsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="findingsSummaryContent">
        <fo:table-row xsl:use-attribute-sets="borders TableFont">
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:apply-templates select="." mode="number"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="@type"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:choose>
                        <xsl:when test="description_summary">
                            <xsl:value-of select="description_summary"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="description" mode="summarytable"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="@threatLevel"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="generate_recommendations">
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="status" select="@status"/>
        <fo:block>
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="table borders">
                <xsl:call-template name="checkIfLast"/>
                <fo:table-column column-width="proportional-column-width(12)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(22)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(66)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row xsl:use-attribute-sets="bg-orange borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>ID</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Recommendation</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:choose>
                        <xsl:when test="@status and @Ref">
                            <!-- Only generate a table for findings in the section with this status AND this Ref -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[@status = $status][ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@status and not(@Ref)">
                            <!-- Only generate a table for findings in the section with this status -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[@status = $status]">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="@Ref and not(@status)">
                            <!-- Only generate a table for findings in the section with this Ref -->
                            <xsl:for-each
                                select="/pentest_report/descendant::finding[ancestor::*[@id = $Ref]]">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="/pentest_report/descendant::finding">
                                <xsl:call-template name="recommendationsSummaryContent"/>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="recommendationsSummaryContent">
        <fo:table-row xsl:use-attribute-sets="TableFont borders">
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:apply-templates select="." mode="number"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:value-of select="@type"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block>
                    <xsl:choose>
                        <xsl:when test="recommendation_summary">
                            <xsl:value-of select="recommendation_summary"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="recommendation" mode="summarytable"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>


    <xsl:template match="generate_testteam">
        <fo:block>
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(75)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <xsl:for-each select="/pentest_report/meta/collaborators/approver">
                        <fo:table-row xsl:use-attribute-sets="borders">
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:apply-templates select="name"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:apply-templates select="bio"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                    <xsl:for-each select="/pentest_report/meta/collaborators/pentesters/pentester">
                        <xsl:if
                            test="not(./name = /pentest_report/meta/collaborators/approver/name)">
                            <fo:table-row xsl:use-attribute-sets="borders">
                                <fo:table-cell xsl:use-attribute-sets="td">
                                    <fo:block>
                                        <xsl:apply-templates select="name"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell xsl:use-attribute-sets="td">
                                    <fo:block>
                                        <xsl:apply-templates select="bio"/>
                                    </fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </xsl:if>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template match="generate_offer_signature_box">

        <xsl:call-template name="generateSignatureBox">
            <xsl:with-param name="latestVersionDate" select="$latestVersionDate"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generateSignatureBox">
        <xsl:param name="latestVersionDate"/>
        <fo:block keep-together.within-page="always" xsl:use-attribute-sets="signaturebox">
            <fo:block xsl:use-attribute-sets="title-client">
                <xsl:call-template name="getString">
                            <xsl:with-param name="stringID" select="'signed_dupe'"/>
                        </xsl:call-template></fo:block>
            <fo:block>
                <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-column column-width="proportional-column-width(50)"
                        xsl:use-attribute-sets="borders"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="$latestVersionDate"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="$latestVersionDate"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block><xsl:value-of select="/*/meta/permission_parties/client/city"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block><xsl:value-of
                                                select="/*/meta/company/city"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>&#160;</fo:block>
                                <fo:block>&#160;</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>&#160;</fo:block>
                                <fo:block>&#160;</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of
                                                select="/*/meta/permission_parties/client/legal_rep"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/customer/legal_rep"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of select="/*/meta/company/legal_rep"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/company/legal_rep"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block xsl:use-attribute-sets="bold">
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of
                                                select="/*/meta/permission_parties/client/full_name"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/customer/full_name"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block xsl:use-attribute-sets="bold">
                                    <xsl:choose>
                                        <xsl:when test="/offerte">

                                            <xsl:value-of select="/*/meta/company/full_name"/>

                                        </xsl:when>
                                        <xsl:when test="/quickscope">

                                            <xsl:value-of select="/*/company/full_name"/>

                                        </xsl:when>
                                    </xsl:choose>

                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="generate_permission_parties">
        <xsl:for-each select="/*/meta/permission_parties/client | /*/meta/permission_parties/party">
            <xsl:if test="self::party and not(following-sibling::party)"><xsl:call-template name="getString"><xsl:with-param name="stringID" select="'permission_and'"/></xsl:call-template><xsl:text>&#x20;</xsl:text></xsl:if>
            <xsl:value-of select="full_name"/>
            <xsl:if test="../party[2]">, </xsl:if>
        </xsl:for-each>
    </xsl:template>

    
</xsl:stylesheet>
