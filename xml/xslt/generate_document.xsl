<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"  xmlns:my="http://www.radical.sexy"
    exclude-result-prefixes="my xs" version="2.0">


    <xsl:import href="pages.xslt"/>
    <xsl:import href="meta.xslt"/>
    <xsl:import href="toc.xslt"/>
    <xsl:import href="structure.xslt"/>
    <xsl:import href="att-set.xslt"/>
    <xsl:import href="block.xslt"/>
    <xsl:import href="auto.xslt"/>
    <xsl:import href="table.xslt"/>
    <xsl:import href="lists.xslt"/>
    <xsl:import href="inline.xslt"/>
    <xsl:import href="graphics.xslt"/>
    <xsl:import href="generic.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="localisation.xslt"/>

    <xsl:include href="styles_off.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

    <xsl:include href="functions_params_vars.xslt"/>

    <!-- ROOT -->
    <xsl:template match="/">

        <fo:root xsl:use-attribute-sets="root-common">
            <xsl:call-template name="layout-master-set"/>
            <xsl:call-template name="FrontMatter"/>
            <xsl:call-template name="Content">
                <xsl:with-param name="execsummary" select="'no'" tunnel="yes"/>
            </xsl:call-template>
        </fo:root>
    </xsl:template>

    <!-- OVERRIDES -->
    
    <xsl:template match="meta" mode="frontmatter">
        <xsl:param name="execsummary" tunnel="yes"/>
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
        <xsl:variable name="reporttitle">
            <xsl:value-of select="title"/>
        </xsl:variable>
        <xsl:variable name="words" select="tokenize($reporttitle, '\s')"/>
        
        <fo:block xsl:use-attribute-sets="frontpagetext">
            <fo:block xsl:use-attribute-sets="title-0">
                <xsl:for-each select="$words">
                    <xsl:choose>
                        <xsl:when
                            test="
                            . = 'And' or
                            . = 'and' or
                            . = 'Or' or
                            . = 'or' or
                            . = 'The' or
                            . = 'the' or
                            . = 'Of' or
                            . = 'of' or
                            . = 'A' or
                            . = 'a'">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:otherwise>
                            <fo:block/>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </fo:block>
            <fo:block xsl:use-attribute-sets="frontpagesubtitle">
                <xsl:sequence
                    select="
                    string-join(for $x in tokenize(//subtitle, ' ')
                    return
                    my:titleCase($x), ' ')"
                />
            </fo:block>
            <fo:block xsl:use-attribute-sets="title-date">
                <xsl:value-of select="$latestVersionDate"/>
            </fo:block>
        </fo:block>
    </xsl:template>
    
    <xsl:template name="cover_footer">
        <fo:static-content flow-name="region-after-cover" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer coverfooter">
                <fo:block>
                    <xsl:value-of select="//meta/company/coc"/>
                </fo:block>
            </fo:block>
        </fo:static-content>
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
        <xsl:variable name="authors"
            select="version_history/version/v_author[not(. = ../preceding::version/v_author)]"/>
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
                            <fo:block>Author<xsl:if test="$authors[2]">s</xsl:if></fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:for-each select="$authors">
                                    <xsl:if test="preceding::v_author">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <fo:inline>
                                        <xsl:value-of select="."/>
                                    </fo:inline>
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
    
    <!-- Don't want tabs in generic documents -->
    <xsl:template name="getTabMarker"/>

</xsl:stylesheet>
