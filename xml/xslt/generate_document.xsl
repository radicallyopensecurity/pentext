<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="meta.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="findings.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="localisation.xslt"/>
    
    <xsl:include href="styles_rep.xslt"/>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>


    <!-- ****** AUTO_NUMBERING_FORMAT:	value of the <xsl:number> element used for auto numbering -->
    <xsl:param name="AUTO_NUMBERING_FORMAT" select="'1.1.1'"/>

    <xsl:key name="rosid" match="section|appendix" use="@id"/>
    <xsl:key name="biblioid" match="biblioentry" use="@id"/>
    
    <xsl:variable name="CLASSES" select="document('../xslt/styles_doc.xslt')/*/xsl:attribute-set"/>
    <xsl:variable name="lang" select="/*/@xml:lang"/>
    
    <xsl:variable name="latestVersionDate">
            <xsl:for-each select="/*/meta/version_history/version">
                <xsl:sort select="xs:dateTime(@date)" order="descending"/>
                <xsl:if test="position() = 1">
                    <xsl:value-of select="format-dateTime(@date, '[MNn] [D1o], [Y]', 'en', (), ())"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
    
<!-- ROOT -->
    <xsl:template match="/">

        <fo:root xsl:use-attribute-sets="root-common">

            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="Content"/>

        </fo:root>
    </xsl:template>

<!-- OVERRIDES -->
    <!-- meta -->
    <xsl:template match="meta">
        <xsl:variable name="latestVersionNumber">
            <xsl:for-each select="version_history/version">
                <xsl:sort select="xs:dateTime(@date)" order="descending"/>
                <xsl:if test="position() = 1">
                    <xsl:call-template name="VersionNumber">
                        <xsl:with-param name="number" select="@number"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <fo:block xsl:use-attribute-sets="graphics-block">
            <fo:external-graphic xsl:use-attribute-sets="logo"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="title-0">
            <xsl:if test="not(subtitle)">
                <xsl:attribute name="margin-bottom">7cm</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="upper-case(title)"/>
        </fo:block>
        <xsl:if test="subtitle">
            <fo:block xsl:use-attribute-sets="title-client">
                <xsl:value-of select="subtitle"/>
            </fo:block>
        </xsl:if>
        <fo:block break-after="page">
            <fo:table width="100%" table-layout="fixed">
                <fo:table-column column-width="proportional-column-width(66)"/>
                <fo:table-column column-width="proportional-column-width(33)"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block/>
                        </fo:table-cell>
                        <fo:table-cell text-align="left">
                            <fo:block> V<xsl:value-of select="$latestVersionNumber"/>
                            </fo:block>
                            <fo:block>
                                <xsl:text>Amsterdam</xsl:text>
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="$latestVersionDate"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
        <xsl:call-template name="DocProperties"/>
        <xsl:call-template name="VersionControl"/>
        <xsl:call-template name="Contact"/>
    </xsl:template>
    
    <xsl:template name="DocProperties">
        <xsl:variable name="latestVersionNumber">
            <xsl:for-each select="version_history/version">
                <xsl:sort select="xs:dateTime(@date)" order="descending"/>
                <xsl:if test="position() = 1">
                    <xsl:call-template name="VersionNumber">
                        <xsl:with-param name="number" select="@number"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="authors" select="version_history/version/v_author[not(.=../preceding::version/v_author)]" />   
        <fo:block xsl:use-attribute-sets="title-4">Document Properties</fo:block>
        <fo:block margin-bottom="{$very-large-space}">
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="bg-orange borders"/>
                <fo:table-column column-width="proportional-column-width(75)"/>
                <fo:table-body>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Title</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="title"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Version</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="$latestVersionNumber"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Author<xsl:if test="$authors[2]"
                                    >s</xsl:if></fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:for-each select="$authors">
                                    <xsl:if test="preceding::v_author">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <fo:inline><xsl:value-of select="."/></fo:inline>
                                </xsl:for-each>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Reviewed by</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:for-each select="collaborators/reviewers/reviewer">
                                    <fo:block>
                                        <xsl:value-of select="."/>
                                    </fo:block>
                                </xsl:for-each>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>Approved by</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="collaborators/approver/name"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>
    
</xsl:stylesheet>
