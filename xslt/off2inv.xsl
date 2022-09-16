<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs xlink fo" version="2.0">

    <xsl:include href="localisation.xslt"/>

    <xsl:param name="INVOICE_NO">00/000</xsl:param>
    <xsl:param name="DATE">
        <xsl:value-of select="format-date(current-date(), '[Y]-[M,2]-[D,2]', 'en', (), ())"/>
    </xsl:param>
    
    <xsl:variable name="lang" select="/*/@xml:lang"/>
    
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- ROOT -->
    <xsl:template match="/">

        <invoice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="../dtd/invoice.xsd"
            xmlns:xi="http://www.w3.org/2001/XInclude">
            <xsl:attribute name="date">
                <xsl:value-of select="$DATE"/>
            </xsl:attribute>
            <xsl:attribute name="invoice_no">
                <xsl:value-of select="$INVOICE_NO"/>
            </xsl:attribute>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="$lang"/>
            </xsl:attribute>
            <xsl:attribute name="denomination">
                <xsl:value-of select="/offerte/meta/activityinfo/fee/@denomination"/>
            </xsl:attribute>
            <meta>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">client_info.xml</xsl:attribute>
                </xsl:element>
            </meta>
            <servicesdelivered>
                <xsl:comment>Add/delete &lt;service> elements as needed</xsl:comment>
                <service>
                    <description>
                        <xsl:value-of select="/offerte/meta/activityinfo/duration"
                            />-<xsl:call-template name="getString"><xsl:with-param name="stringID" select="'invoice_days'"/></xsl:call-template>&#160;<xsl:value-of select="/offerte/meta/offered_service_short"
                            />&#160;<xsl:value-of
                            select="/offerte/meta/permission_parties/client/short_name"/>
                        <xsl:if test="/offerte/meta/client_reference"><xsl:text>&#32;</xsl:text>(<xsl:value-of
                select="/offerte/meta/client_reference"/>)</xsl:if>
                    </description>
                    <fee vat="yes">
                        <xsl:value-of select="/offerte/meta/activityinfo/fee"/>
                    </fee>
                </service>
            </servicesdelivered>
            <additionalcosts>
                <xsl:comment>Add/delete &lt;cost> elements as needed</xsl:comment>
                <cost>
                    <description>...</description>
                    <fee vat="yes">0</fee>
                </cost>
                <cost>
                    <description>...</description>
                    <fee vat="yes">0</fee>
                </cost>
            </additionalcosts>
        </invoice>


    </xsl:template>



</xsl:stylesheet>
