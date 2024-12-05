<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:my="http://www.radical.sexy" exclude-result-prefixes="my xs" version="2.0">


    <xsl:template name="layout-master-set">
        <!-- Main Page layout structure -->
        <fo:layout-master-set>
            <!-- Cover page -->
            <fo:simple-page-master master-name="Front-Cover" xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="cover-flow" xsl:use-attribute-sets="region-body-cover">
                    <xsl:call-template name="select_frontpage_graphic">
                        <xsl:with-param name="doctype" select="local-name(/*)"/>
                        <xsl:with-param name="current_second" select="$current_second"/>
                    </xsl:call-template>
                </fo:region-body>
            </fo:simple-page-master>
            <!-- FrontMatter Content Pages (Odd) -->
            <fo:simple-page-master master-name="Front-Content-odd"
                xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="cover-flow"
                    xsl:use-attribute-sets="region-body-content-odd"/>
                <fo:region-before region-name="region-before-cover"
                    xsl:use-attribute-sets="region-before-content"/>
                <fo:region-after region-name="region-after-meta"
                    xsl:use-attribute-sets="region-after-content"/>
            </fo:simple-page-master>
            <!-- FrontMatter Content Pages (Even) -->
            <fo:simple-page-master master-name="Front-Content-even"
                xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="cover-flow"
                    xsl:use-attribute-sets="region-body-content-even"/>
                <fo:region-before region-name="region-before-cover"
                    xsl:use-attribute-sets="region-before-content"/>
                <fo:region-after region-name="region-after-meta"
                    xsl:use-attribute-sets="region-after-content"/>
            </fo:simple-page-master>
            <!-- Section Content Pages (Odd) -->
            <fo:simple-page-master master-name="Section-Content-odd"
                xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="region-body"
                    xsl:use-attribute-sets="region-body-content-odd"/>
                <fo:region-before region-name="region-before-content-odd"
                    xsl:use-attribute-sets="region-before-content-odd"/>
                <fo:region-after region-name="region-after-content-odd"
                    xsl:use-attribute-sets="region-after-content"/>
                <fo:region-start region-name="region-start-content-odd"
                    xsl:use-attribute-sets="region-start-content-odd"/>
            </fo:simple-page-master>
            <!-- Section Content Pages (Even) (just a change in the margins and footer) -->
            <fo:simple-page-master master-name="Section-Content-even"
                xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="region-body"
                    xsl:use-attribute-sets="region-body-content-even"/>
                <fo:region-before region-name="region-before-content-even"
                    xsl:use-attribute-sets="region-before-content-even"/>
                <fo:region-after region-name="region-after-content-even"
                    xsl:use-attribute-sets="region-after-content"/>
                <fo:region-end region-name="region-end-content-even"
                    xsl:use-attribute-sets="region-end-content-even"/>
            </fo:simple-page-master>
            <!-- sequence master -->
            <fo:page-sequence-master master-name="Cover">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="Front-Cover"
                        page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="Front-Content-odd"
                        page-position="any" odd-or-even="odd"/>
                    <fo:conditional-page-master-reference master-reference="Front-Content-even"
                        page-position="any" odd-or-even="even"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
            <fo:page-sequence-master master-name="Sections">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="Section-Content-odd"
                        page-position="any" odd-or-even="odd"/>
                    <fo:conditional-page-master-reference master-reference="Section-Content-even"
                        page-position="any" odd-or-even="even"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>

    <xsl:template name="layout-master-set-flimsy">
        <!-- Invoices, Ratecards and Contracts need their own page layout; quite different from other docs so just create a different set -->
        <fo:layout-master-set>
            <!-- first page -->
            <fo:simple-page-master master-name="Flimsy-First"
                xsl:use-attribute-sets="PortraitPage_flimsy">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body-first"/>
                <fo:region-before region-name="region-before-first"
                    xsl:use-attribute-sets="region-before-first"/>
                <fo:region-after region-name="region-after-first"
                    xsl:use-attribute-sets="region-after-first"/>
            </fo:simple-page-master>
            <!-- all other pages -->
            <fo:simple-page-master master-name="Flimsy-Rest"
                xsl:use-attribute-sets="PortraitPage_flimsy">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body-rest"/>
                <fo:region-before region-name="region-before-rest"
                    xsl:use-attribute-sets="region-before-rest"/>
                <fo:region-after region-name="region-after-rest"
                    xsl:use-attribute-sets="region-after-rest"/>
            </fo:simple-page-master>
            <!-- sequence master -->
            <fo:page-sequence-master master-name="Flimsy">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="Flimsy-First"
                        blank-or-not-blank="not-blank" page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="Flimsy-Rest"
                        blank-or-not-blank="not-blank"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>
    
    <xsl:template name="select_frontpage_graphic">
        <xsl:param name="doctype" select="'generic'"/>
        <xsl:param name="current_second" select="1"/>
        <xsl:variable name="graphicsdoc"
            select="document('../graphics/frontpage_graphics.xml')/frontpage_graphics/doctype[@name = $doctype]"/>
        <xsl:variable name="available_frontpage_graphics" select="count($graphicsdoc/file)"/>
        <!-- taking the current second as a 'random number generator' -->
        <xsl:variable name="selected_graphic"
            select="ceiling(number($available_frontpage_graphics div 60 *
                    $current_second))"/>
        <xsl:choose>
          <xsl:when test="not($graphicsdoc/file[$selected_graphic]/@name)">
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="frontpage_graphic" select="$graphicsdoc/file[$selected_graphic]/@name"/>
            <xsl:attribute name="background-image">url(../graphics/<xsl:value-of
            select="$frontpage_graphic"/>)</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="page_footer">
        <fo:static-content flow-name="region-after-content-odd" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer-odd">
                <fo:retrieve-marker retrieve-class-name="tab"/>
                <fo:leader leader-pattern="space"/>
                <fo:inline>
                    <fo:page-number/>
                </fo:inline>
            </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-after-content-even" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer-even">
                <fo:inline>
                    <fo:page-number/>
                </fo:inline>
                <fo:leader leader-pattern="space"/>
                <xsl:value-of select="//meta/company/full_name"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="page_footer_flimsy">
        <fo:static-content flow-name="region-after-first" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <xsl:value-of select="//meta/company/full_name"/>
                <fo:leader leader-pattern="space"/>
                <fo:inline>
                    <fo:page-number/>
                </fo:inline>
                </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-after-rest" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <fo:inline>
                    <fo:page-number/>
                </fo:inline>
                <fo:leader leader-pattern="space"/>
                <xsl:value-of select="//meta/company/full_name"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="meta_footer">
        <fo:static-content flow-name="region-after-meta" xsl:use-attribute-sets="FooterFont">
            <fo:block>&#160;</fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="page_header">
        <fo:static-content flow-name="region-before-content-odd" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="header-odd">
                <xsl:value-of select="//meta/classification"/>
            </fo:block>
        </fo:static-content>

        <fo:static-content flow-name="region-before-content-even"
            xsl:use-attribute-sets="FooterFont">
            <fo:block> </fo:block>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="page_header_flimsy">
        <fo:static-content flow-name="region-before-first" xsl:use-attribute-sets="HeaderFont">
            <fo:block>
                <fo:table width="100%" table-layout="fixed">
                    <fo:table-column column-width="proportional-column-width(40)"/>
                    <fo:table-column column-width="proportional-column-width(20)"/>
                    <fo:table-column column-width="proportional-column-width(40)"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell text-align="right" display-align="after"
                                padding-bottom="5mm">
                                <fo:block xsl:use-attribute-sets="TinyFont">
                                    <fo:block xsl:use-attribute-sets="bold main-color">
                                        <xsl:value-of select="/*/meta/company/full_name"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:value-of select="/*/meta/company/address"/>
                                    </fo:block>
                                    <fo:block><xsl:value-of select="/*/meta/company/postal_code"
                                    />&#160;<xsl:value-of select="/*/meta/company/city"
                                    /></fo:block>
                                    <fo:block>
                                        <xsl:value-of select="/*/meta/company/country"/>
                                    </fo:block>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="center">
                                <fo:block>
                                    <fo:external-graphic xsl:use-attribute-sets="logo"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="after" padding-bottom="5mm">
                                <fo:block xsl:use-attribute-sets="TinyFont">
                                    <fo:block xsl:use-attribute-sets="bold main-color">
                                        <xsl:value-of select="/*/meta/company/website"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:value-of select="/*/meta/company/email"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:call-template name="getString">
                                            <xsl:with-param name="stringID" select="'page_kvk'"/>
                                        </xsl:call-template>
                                        <xsl:text>&#160;</xsl:text>
                                        <xsl:value-of select="/*/meta/company/coc"/>
                                    </fo:block>
                                    <fo:block>
                                        <xsl:call-template name="getString">
                                            <xsl:with-param name="stringID" select="'invoice_vatno'"
                                            />
                                        </xsl:call-template>
                                        <xsl:text>&#160;</xsl:text>
                                        <xsl:value-of select="/*/meta/company/vat_no"/>
                                    </fo:block>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="region-before-rest" xsl:use-attribute-sets="HeaderFont">
            <fo:block xsl:use-attribute-sets="header"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="footerlogo">
        <fo:static-content flow-name="region-start-content-odd">
            <fo:block>
                <fo:block-container xsl:use-attribute-sets="footerlogo">
                    <fo:block>
                        <fo:external-graphic src="../graphics/logo_footer.png"/>
                    </fo:block>
                </fo:block-container>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="FrontMatter">
        <xsl:param name="execsummary" tunnel="yes"/>
        <fo:page-sequence master-reference="Cover">
            <xsl:call-template name="page_header"/>
            <xsl:call-template name="meta_footer"/>
            <fo:flow flow-name="cover-flow" xsl:use-attribute-sets="DefaultFont">
                <fo:block>
                    <xsl:apply-templates select="/*/meta" mode="frontmatter"/>
                    <xsl:apply-templates select="/*/generate_index"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template name="Content">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="$execsummary = true()">
                <xsl:for-each
                    select="/*/section[@inexecsummary = 'yes'] | /*/appendix[@inexecsummary = 'yes']">
                    <xsl:call-template name="generate_pages"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="/*/section | /*/appendix">
                    <xsl:if test="not(./@visibility = 'hidden')">
                        <xsl:call-template name="generate_pages"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="generate_pages">
        <xsl:param name="execsummary" tunnel="yes"/>
        <fo:page-sequence master-reference="Sections">
            <xsl:call-template name="page_header"/>
            <xsl:call-template name="page_footer"/>
            <xsl:call-template name="footerlogo"/>
            <fo:flow flow-name="region-body" xsl:use-attribute-sets="DefaultFont">
                <fo:block>
                    <xsl:apply-templates select="."/>
                </fo:block>
                <xsl:if test="not(following-sibling::*)">
                    <fo:block id="EndOfDoc">
                        <fo:footnote>
                            <fo:inline/>
                            <fo:footnote-body>
                                <xsl:call-template name="ImageAttribution"/>
                            </fo:footnote-body>
                        </fo:footnote>
                    </fo:block>
                </xsl:if>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

</xsl:stylesheet>
