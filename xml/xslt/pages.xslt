<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">


    <xsl:template name="layout-master-set">
        <!-- Main Page layout structure -->
        <fo:layout-master-set>
            <!-- Cover page -->
            <fo:simple-page-master master-name="Front-Cover" xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="cover-flow" xsl:use-attribute-sets="region-body-cover"
                />
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

    <xsl:template name="meta_footer">
        <fo:static-content flow-name="region-after-meta" xsl:use-attribute-sets="FooterFont">
            <fo:block>&#160;</fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="page_header">
        <fo:static-content flow-name="region-before-content-odd" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="header-odd"><xsl:value-of select="//meta/classification"/>
            </fo:block>
        </fo:static-content>
        
        <fo:static-content flow-name="region-before-content-even" xsl:use-attribute-sets="FooterFont">
            <fo:block>
            </fo:block>
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
                    <xsl:call-template name="generate_pages"/>
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
                    <fo:block id="EndOfDoc"/>
                </xsl:if>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

</xsl:stylesheet>
