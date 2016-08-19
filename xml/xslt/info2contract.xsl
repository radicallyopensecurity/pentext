<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="localisation.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="lang" select="/contract_info/@xml:lang"/>
    <xsl:param name="latestVersionDate"><!-- we're not using versions for contracts, but the contract date will do just fine -->
        <xsl:choose>
            <xsl:when test="normalize-space(/contract_info/work/start_date)">
                <!-- we have a start date element and it contains information -->
                <xsl:value-of
                    select="format-date(/contract_info/work/start_date, '[MNn] [D1], [Y]', 'en', (), ())"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-date(current-date(), '[MNn] [D1], [Y]', 'en', (), ())"/>
                <!-- no start date, using today's date -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <!-- ROOT -->
    <xsl:template match="/">

        <contract xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="../dtd/contract.xsd"
            xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:attribute name="xml:lang" select="/contract_info/@xml:lang"/>
            <meta>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
                <xsl:copy-of select="contract_info/company/following-sibling::node()"/>
            </meta>


            <section>
                <title>
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'contract_title'"/>
                    </xsl:call-template>
                </title>
                <xsl:comment>Whereas section</xsl:comment>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">
                        <xsl:call-template name="docCheck">
                            <xsl:with-param name="fileNamePart">parties</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:element>
                <p>WHEREAS:</p>
                <ol type="A">
                    <xsl:if test="/contract_info/scope/contract_type = 'single_engagement'">
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >wa_companywants</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >wa_companyhasasked</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:call-template name="docCheck">
                                <xsl:with-param name="fileNamePart"
                                    >wa_contractorcan</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:call-template name="docCheck">
                                <xsl:with-param name="fileNamePart"
                                    >wa_noemploymentintention</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </ol>
                <xsl:comment>Agreement section</xsl:comment>
                <section>
                    <title>AGREE AS FOLLOWS</title>
                    <ol type="1">
                        <xsl:if test="/contract_info/scope/contract_type = 'fixed_term'">
                            <xsl:element name="xi:include">
                                <xsl:attribute name="href">
                                    <xsl:call-template name="docCheck">
                                        <xsl:with-param name="fileNamePart"
                                            >ag_period</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_noemployment</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_companyinstructs</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:if test="/contract_info/scope/contract_type = 'single_engagement'">
                            <xsl:element name="xi:include">
                                <xsl:attribute name="href">
                                    <xsl:call-template name="docCheck">
                                        <xsl:with-param name="fileNamePart"
                                            >ag_worktime</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart">ag_ownrisk</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:if test="/contract_info/scope/contract_type = 'fixed_term'">
                            <xsl:element name="xi:include">
                                <xsl:attribute name="href">
                                    <xsl:call-template name="docCheck">
                                        <xsl:with-param name="fileNamePart"
                                            >ag_workinghours</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart">ag_payment</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:if test="/contract_info/scope/contract_type = 'single_engagement'">
                            <xsl:element name="xi:include">
                                <xsl:attribute name="href">
                                    <xsl:call-template name="docCheck">
                                        <xsl:with-param name="fileNamePart"
                                            >ag_biggerscopewarning</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_propertyrights</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_retainrights</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_nondisclosure</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_responsibilities</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_thirdparty</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_liability</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_provisions</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart"
                                        >ag_generaltermsandconditions</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNamePart">ag_law</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                    </ol>
                </section>
                <section>
                    <title>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringID" select="'signed_dupe'"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringID" select="'waiver_signed_on'"/>
                        </xsl:call-template>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$latestVersionDate"/>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringID" select="'waiver_signed_in'"/>
                        </xsl:call-template>
                    </title>
                    <generate_contract_signature_box/>
                </section>
            </section>
        </contract>


    </xsl:template>

    <xsl:template name="docCheck">
        <xsl:param name="fileNamePart" select="'none'"/>
        <xsl:param name="typeSuffix">
            <xsl:value-of select="/contract_info/scope/contract_type"/>
        </xsl:param>
        <xsl:param name="fileNameStandard"
            select="concat('snippets/contract/', $lang, '/', $fileNamePart, '.xml')"/>
        <xsl:param name="fileNameExtended"
            select="concat('snippets/contract/', $lang, '/', $fileNamePart, '_', $typeSuffix, '.xml')"/>
        <xsl:choose>
            <xsl:when test="doc-available(concat('../source/', $fileNameExtended))">
                <xsl:value-of select="$fileNameExtended"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fileNameStandard"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
