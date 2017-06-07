<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:template match="finding" mode="meta">
        <xsl:variable name="status" select="@status"/>
        <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="table" margin-bottom="{$large-space}">
            <fo:table-column column-width="proportional-column-width(70)"/>
            <fo:table-column column-width="proportional-column-width(30)"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="td">
                        <xsl:if test="not(@status)"><xsl:attribute name="number-columns-spanned">2</xsl:attribute></xsl:if>
                        <fo:block xsl:use-attribute-sets="finding-meta">
                            <fo:inline xsl:use-attribute-sets="bold">Vulnerability ID: </fo:inline>
                            <xsl:apply-templates select="." mode="number"/>
                        </fo:block>
                    </fo:table-cell>
                    <xsl:if test="@status">
            <fo:table-cell xsl:use-attribute-sets="td">
                <fo:block xsl:use-attribute-sets="finding-meta">
                <fo:inline xsl:use-attribute-sets="bold">Retest status: </fo:inline>
                    <xsl:choose>
                        <xsl:when test="@status = 'new' or @status = 'unresolved'">
                            <fo:inline xsl:use-attribute-sets="status-new"><xsl:value-of select="@status"/></fo:inline>
                        </xsl:when>
                        <xsl:when test="@status = 'not-retested'">
                            <fo:inline xsl:use-attribute-sets="status-not-retested"><xsl:value-of select="@status"/></fo:inline>
                        </xsl:when>
                        <xsl:when test="@status = 'resolved'">
                            <fo:inline xsl:use-attribute-sets="status-resolved"><xsl:value-of select="@status"/></fo:inline>
                        </xsl:when>
                    </xsl:choose>
                
            </fo:block>
            </fo:table-cell>
        </xsl:if>
                </fo:table-row>
                <fo:table-row>
                <fo:table-cell xsl:use-attribute-sets="td" number-columns-spanned="2">
                        <fo:block xsl:use-attribute-sets="finding-meta">
                            <fo:inline xsl:use-attribute-sets="bold">Vulnerability type: </fo:inline>
                            <xsl:value-of select="@type"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="td" number-columns-spanned="2">
                        <fo:block xsl:use-attribute-sets="finding-meta">
                            <fo:inline xsl:use-attribute-sets="bold">Threat level: </fo:inline>
                            <xsl:value-of select="@threatLevel"/>
                        </fo:block>
                    </fo:table-cell>

                </fo:table-row>

            </fo:table-body>
        </fo:table>



        
    </xsl:template>

    <!-- ignore summary-table-only elements in the findings -->
    <xsl:template match="description_summary | recommendation_summary"/>

    <xsl:template match="description">
        <fo:block xsl:use-attribute-sets="title-4">Description:</fo:block>
        <fo:block margin-bottom="{$large-space}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="description" mode="summarytable">
        <xsl:if test="img | table">
            <xsl:message>WARNING: description containing img or table may not look very good in the
                finding summary table. Consider using a description_summary element
                instead.</xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>

    <xsl:template match="technicaldescription">
        <fo:block xsl:use-attribute-sets="title-4">Technical description:</fo:block>
        <fo:block margin-bottom="{$large-space}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="impact">
        <fo:block xsl:use-attribute-sets="title-4">Impact:</fo:block>
        <fo:block margin-bottom="{$large-space}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="recommendation">
        <fo:block xsl:use-attribute-sets="title-4">Recommendation:</fo:block>
        <fo:block margin-bottom="{$large-space}">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="recommendation" mode="summarytable">
        <xsl:if test="img | table">
            <xsl:message>WARNING: recommendation containing img or table may not look very good in
                the finding summary table. Consider using a recommendation_summary element
                instead.</xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>

</xsl:stylesheet>
