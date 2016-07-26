<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="INVOICE_NO">00/000</xsl:param>
    <xsl:param name="DATE">
        <xsl:value-of select="format-date(current-date(), '[Y]-[M,2]-[D1]', 'en', (), ())"/>
    </xsl:param>
    
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
            <xsl:attribute name="denomination">
                <xsl:value-of select="/offerte/meta/pentestinfo/fee/@denomination"/>
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
                <service>
                    <description>
                        <xsl:value-of select="/offerte/meta/pentestinfo/duration"
                            />-day&#160;<xsl:value-of select="/offerte/meta/offered_service_short"
                            />&#160;<xsl:value-of
                            select="/offerte/meta/permission_parties/client/short_name"/>
                    </description>
                    <fee>
                        <xsl:value-of select="/offerte/meta/pentestinfo/fee"/>
                    </fee>
                </service>
            </servicesdelivered>
        </invoice>


    </xsl:template>



</xsl:stylesheet>
