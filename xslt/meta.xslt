<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs my"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:my="http://www.radical.sexy"
    version="2.0">

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

        <fo:block xsl:use-attribute-sets="frontpagetext">
            <fo:block xsl:use-attribute-sets="frontlogo">
                <fo:external-graphic src="../graphics/logo_large.png" width="17cm"
                    content-height="scale-to-fit"/>
            </fo:block>
            <fo:footnote>
                <fo:inline/>
                <fo:footnote-body xsl:use-attribute-sets="front-titleblock-container">
                    <fo:block xsl:use-attribute-sets="front-titleblock">
                        <xsl:call-template name="front"/>
                    </fo:block>
                </fo:footnote-body>
            </fo:footnote>
        </fo:block>

        <xsl:call-template name="DocProperties"/>
        <xsl:call-template name="VersionControl"/>
        <xsl:call-template name="Contact"/>
    </xsl:template>

    <xsl:template name="front">
        <xsl:param name="execsummary" tunnel="yes"/>
        <fo:table table-layout="fixed" width="10cm" border-after-color="black"
            border-after-width="2mm" border-after-style="solid" margin-left="0cm" margin-right="0cm">
            <fo:table-column column-width="10cm"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="front-titlerow">
                        <fo:block xsl:use-attribute-sets="title-0">
                            <xsl:sequence
                                select="
                                    string-join(for $x in tokenize(normalize-space(title), ' ')
                                    return
                                        my:titleCase($x), ' ')"
                            />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="front-subtitlerow">
                        <fo:block xsl:use-attribute-sets="title-client">
                            <xsl:value-of select="//client/full_name"/>
                        </fo:block>
                        <xsl:if test="/offerte">
                            <fo:block xsl:use-attribute-sets="title-sub">
                                <xsl:sequence
                                    select="
                                        string-join(for $x in tokenize(normalize-space(//meta/offered_service_long), ' ')
                                        return
                                            my:titleCase($x), ' ')"
                                />
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="normalize-space(//meta/subtitle) or //meta/subtitle/*">
                            <fo:block xsl:use-attribute-sets="title-sub">
                                <xsl:apply-templates select="subtitle"/>
                            </fo:block>
                        </xsl:if>
                        <xsl:if test="$execsummary = true()">
                            <fo:block xsl:use-attribute-sets="title-sub">
                                <xsl:text>Management Summary</xsl:text>
                            </fo:block>
                        </xsl:if>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="front-metarow">
                        <fo:block>
                            <fo:block>V <xsl:value-of select="$latestVersionNumber"/></fo:block>
                            <fo:block>
                                <xsl:value-of select="//meta/company/city"/>, <xsl:value-of
                                    select="$latestVersionDate"/>
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="//meta/classification"/>
                            </fo:block>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template name="list_targets_recursive">
        <xsl:param name="targets_root" select="/*/meta/targets"/>
        <xsl:if test="$targets_root">
            <fo:list-block xsl:use-attribute-sets="list_summarytable" >
                <xsl:for-each select="$targets_root/target">
                    <fo:list-item xsl:use-attribute-sets="li">
                        <fo:list-item-label end-indent="label-end()">
                            <fo:block>
                                <fo:inline>&#8226;</fo:inline>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                            <fo:block>
                                <xsl:value-of select="text()"/>
                                <xsl:call-template name="list_targets_recursive">
                                    <xsl:with-param name="targets_root" select="./targets" />
                                </xsl:call-template>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="DocProperties">
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
        <xsl:variable name="authors"
            select="version_history/version/v_author[not(. = ../preceding::version/v_author)]"/>
        <fo:block xsl:use-attribute-sets="title-4">Document Properties</fo:block>
        <fo:block margin-bottom="{$very-large-space}">
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                <fo:table-column column-width="proportional-column-width(25)"/>
                <fo:table-column column-width="proportional-column-width(75)"/>
                <fo:table-body>
                    <xsl:if test="not(/generic_document)">
                        <fo:table-row xsl:use-attribute-sets="borders">
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block>Client</fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="//client/full_name"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Title</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <xsl:choose>
                                <xsl:when test="$execsummary = true()">
                                    <fo:block>Penetration Test Report Management Summary</fo:block>
                                </xsl:when>
                                <xsl:otherwise>
                                    <fo:block>
                                        <xsl:sequence
                                            select="
                                                concat(upper-case(substring(title, 1, 1)),
                                                substring(title, 2),
                                                ' '[not(last())]
                                                )
                                                "
                                        />
                                    </fo:block>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:if test="not(/generic_document)">
                        <fo:table-row xsl:use-attribute-sets="borders">
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block>Target<xsl:if test="targets/target[2]">s</xsl:if>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:call-template name="list_targets_recursive" />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Version</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="$latestVersionNumber"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:if test="not(/generic_document)">
                        <fo:table-row xsl:use-attribute-sets="borders">
                            <fo:table-cell xsl:use-attribute-sets="th">
                                <fo:block>Pentester<xsl:if
                                        test="collaborators/pentesters/pentester[2]"
                                    >s</xsl:if></fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:for-each select="collaborators/pentesters/pentester">
                                        <fo:inline>
                                            <xsl:value-of select="name"/>
                                        </fo:inline>
                                        <xsl:if test="following-sibling::pentester">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:if>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="th">
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
                        <fo:table-cell xsl:use-attribute-sets="th">
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
                        <fo:table-cell xsl:use-attribute-sets="th">
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

    <xsl:template name="VersionControl">
        <xsl:variable name="versions" select="version_history/version"/>
        <fo:block xsl:use-attribute-sets="title-4">Version control</fo:block>
        <fo:block margin-bottom="{$very-large-space}">
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-column column-width="proportional-column-width(25)"
                    xsl:use-attribute-sets="borders"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Version</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Date</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Author</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Description</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <xsl:for-each select="$versions">
                        <!-- todo: guard date format in schema -->
                        <xsl:sort select="xs:dateTime(@date)" order="ascending"/>
                        <fo:table-row>
                            <xsl:if test="position() mod 2 != 0">
                                <xsl:attribute name="background-color">#ededed</xsl:attribute>
                            </xsl:if>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:call-template name="VersionNumber">
                                        <xsl:with-param name="number" select="@number"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of
                                        select="format-dateTime(@date, '[MNn] [D1o], [Y]', 'en', (), ())"
                                    />
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:for-each select="v_author">
                                        <fo:inline>
                                            <xsl:value-of select="."/>
                                        </fo:inline>
                                        <xsl:if test="following-sibling::v_author">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="td">
                                <fo:block>
                                    <xsl:value-of select="v_description"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
        </fo:block>
    </xsl:template>

    <xsl:template name="VersionNumber">
        <xsl:param name="number" select="@number"/>
        <xsl:choose>
            <!-- if value is auto, do some autonumbering magic -->
            <xsl:when test="string(@number) = 'auto'"> 0.<xsl:number count="version"
                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                <!-- this is really unrobust :D - todo: follow fixed numbering if provided -->
            </xsl:when>
            <xsl:otherwise>
                <!-- just plop down the value -->
                <!-- todo: guard numbering format in schema -->
                <xsl:value-of select="@number"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Contact">
        <fo:block xsl:use-attribute-sets="title-4">Contact</fo:block>
        <fo:block xsl:use-attribute-sets="p" margin-left="0">For more information about this
            document and its contents please contact <xsl:value-of select="company/full_name"/>
            <xsl:if test="not(company/full_name[ends-with(., '.')])"
            ><xsl:text>.</xsl:text></xsl:if></fo:block>
        <fo:block>
            <fo:table width="100%" table-layout="fixed" xsl:use-attribute-sets="borders">
                <fo:table-column column-width="proportional-column-width(25)"/>
                <fo:table-column column-width="proportional-column-width(75)"/>
                <fo:table-body xsl:use-attribute-sets="borders">
                    <fo:table-row>
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Name</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="company/poc1"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Address</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:apply-templates select="company/address"/>
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="company/postal_code"/>&#160;<xsl:value-of
                                    select="company/city"/>
                            </fo:block>
                            <fo:block>
                                <xsl:value-of select="company/country"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Phone</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="company/phone"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row xsl:use-attribute-sets="borders">
                        <fo:table-cell xsl:use-attribute-sets="th">
                            <fo:block>Email</fo:block>
                        </fo:table-cell>
                        <fo:table-cell xsl:use-attribute-sets="td">
                            <fo:block>
                                <xsl:value-of select="company/email"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:block>
        <fo:block xsl:use-attribute-sets="coc" break-after="page">
            <xsl:value-of select="company/full_name"/> is registered at the trade register of the
            Dutch chamber of commerce under number <xsl:value-of select="company/coc"/>. </fo:block>
    </xsl:template>

    <xsl:template name="ImageAttribution">
        <fo:block xsl:use-attribute-sets="coc">
            <xsl:call-template name="select_frontpage_graphic_attribution">
                <xsl:with-param name="doctype" select="local-name(/*)"/>
                <xsl:with-param name="current_second" select="$current_second"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

    <xsl:template match="subtitle">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="select_frontpage_graphic_attribution">
        <xsl:param name="doctype" select="'generic'"/>
        <xsl:param name="current_second" select="1"/>
        <xsl:variable name="graphicsdoc"
            select="document('../graphics/frontpage_graphics.xml')/frontpage_graphics/doctype[@name = $doctype]"/>
        <xsl:variable name="available_frontpage_graphics" select="count($graphicsdoc/file)"/>

        <!-- taking the current second as a 'random number generator' -->
        <xsl:variable name="selected_graphic"
            select="ceiling(number($available_frontpage_graphics div 60 * $current_second))"/>
        <xsl:variable name="frontpage_graphic_attribution"
            select="$graphicsdoc/file[$selected_graphic]/attribution"/>
        <xsl:value-of select="$frontpage_graphic_attribution"/>
    </xsl:template>

</xsl:stylesheet>
