<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="xs" version="2.0">


    <xsl:template name="layout-master-set">
        <!-- Main Page layout structure -->
        <fo:layout-master-set>
            <!-- first page -->
            <fo:simple-page-master master-name="Cover" xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body"/>
                <fo:region-before region-name="region-before" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="region-after" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>
            <!-- all other pages -->
            <fo:simple-page-master master-name="Content" xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body"/>
                <fo:region-before region-name="region-before" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="region-after" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>
            <!-- sequence master -->
            <fo:page-sequence-master master-name="Report">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="Cover"
                        blank-or-not-blank="not-blank" page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="Content"
                        blank-or-not-blank="not-blank"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>
    
    <xsl:template name="layout-master-set-invoice">
        <!-- Main Page layout structure -->
        <fo:layout-master-set>
            <fo:simple-page-master master-name="Content" xsl:use-attribute-sets="PortraitPage">
                <fo:region-body region-name="region-body" xsl:use-attribute-sets="region-body"/>
                <fo:region-before region-name="region-before" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="region-after" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>
            <!-- sequence master -->
            <fo:page-sequence-master master-name="Invoice">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="Content"
                        blank-or-not-blank="not-blank"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>
    
    <xsl:template name="page_header">
        <fo:static-content flow-name="region-before" xsl:use-attribute-sets="HeaderFont">
            <fo:block xsl:use-attribute-sets="header">
                <xsl:value-of select="/pentest_report/meta/classification"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="page_footer">
        <fo:static-content flow-name="region-after" xsl:use-attribute-sets="FooterFont">
            <fo:block xsl:use-attribute-sets="footer">
                <fo:page-number/>/<fo:page-number-citation ref-id="EndOfDoc"/>
                <fo:leader leader-pattern="space"/>
                <fo:inline xsl:use-attribute-sets="TinyFont"><xsl:value-of
                select="*/meta/company/full_name"/> - Chamber of Commerce
                    <xsl:value-of select="*/meta/company/coc"/></fo:inline>
            </fo:block>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="Content">
        <fo:page-sequence master-reference="Report">
            <xsl:call-template name="page_header"/>
            <xsl:call-template name="page_footer"/>
            <fo:flow flow-name="region-body" xsl:use-attribute-sets="DefaultFont">
                <fo:block>
                    <xsl:apply-templates select="pentest_report|offerte|quickscope|generic_document"/>
                </fo:block>
                <fo:block id="EndOfDoc"/>
            </fo:flow>
        </fo:page-sequence>
        
    </xsl:template>
</xsl:stylesheet>
