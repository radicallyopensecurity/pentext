<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xlink fo" version="2.0">

    <xsl:import href="localisation.xslt"/>
    <xsl:import href="snippets.xslt"/>

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="lang" select="/contract_info/@xml:lang"/>
    <xsl:param name="snippetBase" select="'contract'"/>
    <xsl:variable name="snippetSelectionRoot"
        select="document('../source/snippets/snippetselection.xml')/snippet_selection/document[@type = $docType]"/>

    <xsl:variable name="docType" select="'contract'"/>
    <xsl:variable name="docSubType" select="/contract_info/scope/contract_type"/>
    
    <xsl:param name="latestVersionDate"
        select="format-date(/contract_info/work/start_date, '[MNn] [D1], [Y]', 'en', (), ())"/>
    <!-- we're not using versions for contracts, but the contract date will do just fine -->


    <!-- ROOT -->
    <xsl:template match="/">

        <contract xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="../dtd/contract.xsd"
            xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:attribute name="xml:lang" select="$lang"/>
            <meta>
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">snippets/company_info.xml</xsl:attribute>
                </xsl:element>
                <xsl:copy-of select="contract_info/company/following-sibling::node()" copy-namespaces="no"/>
            </meta>


            <section>
                <title>
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'contract_title'"/>
                    </xsl:call-template>
                </title>
                <xsl:for-each
                    select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[@set = 'parties']/snippet">
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href">
                            <xsl:call-template name="docCheck">
                                <xsl:with-param name="fileNameBase" select="."/>
                                <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
                <p><xsl:call-template name="getString">
                        <xsl:with-param name="stringID" select="'contract_whereas'"/>
                        <xsl:with-param name="caps" select="'all'"/>
                    </xsl:call-template>:</p>
                <ol type="A">
                    <xsl:for-each
                        select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[@set = 'considering']/snippet">
                        <xsl:element name="xi:include">
                            <xsl:attribute name="href">
                                <xsl:call-template name="docCheck">
                                    <xsl:with-param name="fileNameBase" select="."/>
                                <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </ol>
                <xsl:comment>Agreement section</xsl:comment>
                <section>
                    <title>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringID" select="'contract_agree'"/>
                        </xsl:call-template>
                    </title>
                    <xsl:for-each select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[contains(@set, 'clause')]">
                        <xsl:variable name="clauseNo" select="concat(count(preceding-sibling::snippet_group[contains(@set, 'content')]) + 1, '.')"/>
                        <xsl:choose>
                            <xsl:when test="contains(@set, 'title')">
                                <xsl:for-each select="snippet">
                                    <xsl:element name="xi:include">
                                        <xsl:attribute name="href">
                                            <xsl:call-template name="docCheck">
                                                <xsl:with-param name="fileNameBase" select="."/>
                                                <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <ol type="1.1" labelprefix="{$clauseNo}">
                                <xsl:for-each select="snippet">
                                    <xsl:element name="xi:include">
                                    <xsl:attribute name="href">
                                    <xsl:call-template name="docCheck">
                                        <xsl:with-param name="fileNameBase" select="."/>
                                        <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:for-each>
                                </ol>
                            </xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>
                    
                        <!-- need to isolate this snippet to insert some logic: not all contracts define working hours -->
                        <!--<xsl:if test="/contract_info/work/planning">
                            <xsl:for-each
                            select="$snippetSelectionRoot/selection[@subtype = $docSubType]/snippet_group[@set = 'workinghours']/snippet">
                            <xsl:element name="xi:include">
                                <xsl:attribute name="href">
                                    <xsl:call-template name="docCheck">
                                        <xsl:with-param name="fileNameBase" select="."/>
                                <xsl:with-param name="snippetDirectory" select="$snippetBase"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>
                        -->
                      
                </section>
                <section>
                    <title>
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringID" select="'contract_signed_dupe'"/>
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

    
</xsl:stylesheet>
