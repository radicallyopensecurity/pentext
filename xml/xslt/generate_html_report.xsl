<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:my="http://www.radical.sexy" xmlns:svg="http://www.w3.org/2000/svg"
    exclude-result-prefixes="xs my" version="2.0">


    <xsl:import href="html_inline.xslt"/>
    <xsl:import href="html_piecharts.xslt"/>
    <xsl:import href="html_placeholders.xslt"/>
    <xsl:import href="html_secrets.xslt"/>
    <xsl:import href="localisation.xslt"/>
    <xsl:import href="numbering.xslt"/>
    <xsl:import href="css.xslt"/>
    <xsl:include href="functions_params_vars.xslt"/>

    <!-- numbered titles or not? -->
    <xsl:param name="NUMBERING" select="true()"/>

    <xsl:output method="html" indent="no"/>


    <!-- ROOT -->
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <meta name="description" content="{//meta/title}"/>
                <meta name="author" content="{//meta/company/full_name}"/>
                <style>
                    <xsl:call-template name="css"/>
                </style>
                <title>
                    <xsl:sequence
                        select="
                            string-join(for $x in tokenize(normalize-space(//meta/title), ' ')
                            return
                                my:titleCase($x), ' ')"
                    />
                </title>
            </head>
            <body>
                <xsl:apply-templates select="/*/meta" mode="frontmatter"/>
                <xsl:apply-templates select="/*/generate_index"/>
                <div class="container contents">
                    <xsl:for-each select="/*/section | /*/appendix">
                        <xsl:apply-templates select="."/>
                    </xsl:for-each>
                </div>
                <hr class="endOfDoc"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="meta" mode="frontmatter">
        <div class="section">
            <div class="container">
                <div class="row">
                    <div class="offset-by-two columns">
                        <img src="../graphics/logo.png" class="logo"/>
                    </div>
                </div>
                <div class="row">
                    <div class="u-full-width">
                        <h1>
                            <xsl:sequence
                                select="
                                    string-join(for $x in tokenize(normalize-space(title), ' ')
                                    return
                                        my:titleCase($x), ' ')"
                            />
                        </h1>

                        <div class="title-client">
                            <xsl:value-of select="//client/full_name"/>
                        </div>
                        <xsl:if test="normalize-space(//meta/subtitle) or //meta/subtitle/*">
                            <div class="title-sub">
                                <xsl:apply-templates select="subtitle"/>
                            </div>
                        </xsl:if>
                    </div>
                </div>
            </div>
        </div>

        <div class="section">
            <xsl:call-template name="DocProperties"/>
        </div>
        <div class="section">
            <xsl:call-template name="Contact"/>
        </div>
        <div class="section">
            <xsl:call-template name="VersionControl"/>
        </div>


    </xsl:template>

    <xsl:template name="DocProperties">
        <xsl:variable name="authors"
            select="version_history/version/v_author[not(. = ../preceding::version/v_author)]"/>
        <div class="container">
            <h4>Document Properties</h4>
            <xsl:if test="not(/generic_document)">
                <div class="row">
                    <div class="two columns">
                        <strong>Client</strong>
                    </div>
                    <div class="ten columns">
                        <xsl:value-of select="//client/full_name"/>
                    </div>
                </div>
            </xsl:if>
            <div class="row">
                <div class="two columns">
                    <strong>Title</strong>
                </div>
                <div class="ten columns">
                    <xsl:sequence
                        select="
                            concat(upper-case(substring(title, 1, 1)),
                            substring(title, 2),
                            ' '[not(last())]
                            )
                            "
                    />
                </div>
            </div>
            <xsl:if test="not(/generic_document)">
                <div class="row">
                    <div class="two columns">
                        <strong>Target<xsl:if test="targets/target[2]">s</xsl:if></strong>
                    </div>
                    <div class="ten columns">
                        <xsl:choose>
                            <xsl:when test="targets/target[2]">
                                <!-- more than one target -->
                                <ul>
                                    <xsl:for-each select="targets/target">
                                        <li>
                                            <xsl:value-of select="."/>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                                <!-- end list -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- just the one -->
                                <xsl:value-of select="targets/target"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:if>
            <div class="row">
                <div class="two columns">
                    <strong>Version</strong>
                </div>
                <div class="ten columns">
                    <xsl:value-of select="$latestVersionNumber"/>
                </div>
            </div>
            <xsl:if test="not(/generic_document)">
                <div class="row">
                    <div class="two columns">
                        <strong>Pentester<xsl:if test="collaborators/pentesters/pentester[2]"
                                >s</xsl:if></strong>
                    </div>
                    <div class="ten columns">
                        <xsl:for-each select="collaborators/pentesters/pentester">
                            <xsl:value-of select="name"/>
                            <xsl:if test="following-sibling::pentester">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:if>
            <div class="row">
                <div class="two columns">
                    <strong>Author<xsl:if test="$authors[2]">s</xsl:if></strong>
                </div>
                <div class="ten columns">
                    <xsl:for-each select="$authors">
                        <xsl:if test="preceding::v_author">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </div>
            </div>
            <div class="row">
                <div class="two columns">
                    <strong>Reviewed by</strong>
                </div>
                <div class="ten columns">
                    <xsl:for-each select="collaborators/reviewers/reviewer">
                        <div>
                            <xsl:value-of select="."/>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
            <div class="row">
                <div class="two columns">
                    <strong>Approved by</strong>
                </div>
                <div class="ten columns">
                    <xsl:value-of select="collaborators/approver/name"/>
                </div>
            </div>



        </div>
    </xsl:template>

    <xsl:template name="VersionControl">
        <xsl:variable name="versions" select="version_history/version"/>
        <div class="container">
            <h4>Version control</h4>
            <table class="borders u-full-width">
                <thead>
                    <tr>
                        <th>Version </th>
                        <th>Date </th>
                        <th>Author </th>
                        <th>Description </th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$versions">
                        <!-- todo: guard date format in schema -->
                        <xsl:sort select="xs:dateTime(@date)" order="ascending"/>
                        <tr>
                            <xsl:if test="position() mod 2 != 0">
                                <xsl:attribute name="class">light-grey</xsl:attribute>
                            </xsl:if>
                            <td>
                                <xsl:call-template name="VersionNumber">
                                    <xsl:with-param name="number" select="@number"/>
                                </xsl:call-template>
                            </td>
                            <td>
                                <xsl:value-of
                                    select="format-dateTime(@date, '[MNn] [D1o], [Y]', 'en', (), ())"
                                />
                            </td>
                            <td>
                                <xsl:for-each select="v_author">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="following-sibling::v_author">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </td>
                            <td>
                                <xsl:value-of select="v_description"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
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
        <div class="container">
            <h4>Contact</h4>
            <p>For more information about this document and its contents please contact
                    <xsl:value-of select="company/full_name"/>
                <xsl:if test="not(company/full_name[ends-with(., '.')])"
                    ><xsl:text>.</xsl:text></xsl:if></p>
            <div class="row">
                <div class="two columns">
                    <strong>Name</strong>
                </div>
                <div class="ten columns">
                    <xsl:value-of select="company/poc1"/>
                </div>
            </div>
            <div class="row">
                <div class="two columns">
                    <strong>Address</strong>
                </div>
                <div class="ten columns">
                    <div>
                        <xsl:apply-templates select="company/address"/>
                    </div>
                    <div>
                        <xsl:value-of select="company/postal_code"/>&#160;<xsl:value-of
                            select="company/city"/>
                    </div>
                    <div>
                        <xsl:value-of select="company/country"/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="two columns">
                    <strong>Phone</strong>
                </div>
                <div class="ten columns">
                    <xsl:value-of select="company/phone"/>
                </div>
            </div>
            <div class="row">
                <div class="two columns">
                    <strong>Email</strong>
                </div>
                <div class="ten columns">
                    <xsl:value-of select="company/email"/>
                </div>
            </div>
            <div class="coc">
                <xsl:value-of select="company/full_name"/> is registered at the trade register of
                the Dutch chamber of commerce under number <xsl:value-of select="company/coc"/>.
            </div>
        </div>
    </xsl:template>

    <xsl:template match="generate_index">
        <div class="section">
            <div class="container">
                <h2>Table of Contents</h2>
                <xsl:apply-templates select="/" mode="toc"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="meta | *[ancestor-or-self::*/@visibility = 'hidden']" mode="toc"/>

    <!-- meta, hidden things and children of hidden things not indexed -->

    <xsl:template
        match="section[not(@visibility = 'hidden')] | finding | appendix[not(@visibility = 'hidden')] | non-finding"
        mode="toc">
        <xsl:call-template name="ToC"/>
    </xsl:template>

    <xsl:template name="ToC">
        <div class="row">
            <div class="one column">
                <a>
                    <xsl:if test="parent::pentest_report or parent::generic_document">
                        <!-- We're in a top-level section, so add some extra styling -->
                        <xsl:call-template name="topLevelToCEntry"/>
                    </xsl:if>
                    <xsl:call-template name="getHref"/>
                    <xsl:call-template name="tocContent_Numbering"/>
                </a>
            </div>
            <div class="eleven columns">
                <a>
                    <xsl:if test="parent::pentest_report or parent::generic_document">
                        <!-- We're in a top-level section, so add some extra styling -->
                        <xsl:call-template name="topLevelToCEntry"/>
                    </xsl:if>
                    <xsl:call-template name="getHref"/>
                    <xsl:call-template name="tocContent_Title"/>
                </a>
            </div>
        </div>
        <xsl:apply-templates
            select="section[not(@visibility = 'hidden')][not(../@visibility = 'hidden')] | finding[not(../@visibility = 'hidden')] | non-finding[not(../@visibility = 'hidden')]"
            mode="toc"/>
    </xsl:template>

    <xsl:template name="getHref">
        <xsl:attribute name="href">
            <xsl:value-of select="concat('#', @id)"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="topLevelToCEntry">
        <xsl:attribute name="class">topLevelToCEntry</xsl:attribute>
    </xsl:template>


    <xsl:template name="tocContent_Title">
        <xsl:apply-templates select="title" mode="toc"/>
    </xsl:template>

    <xsl:template match="title" mode="toc">
        <xsl:call-template name="prependId"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="finding" mode="number">
        <!-- Output finding display number (context is finding) -->
        <xsl:variable name="sectionNumber">
            <xsl:if test="/pentest_report/@findingNumberingBase = 'Section'">
                <xsl:value-of
                    select="count(ancestor::section[last()]/preceding-sibling::section) + 1"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="findingNumber" select="count(preceding::finding) + 1"/>
        <xsl:variable name="numFormat">
            <xsl:choose>
                <xsl:when test="/pentest_report/@findingNumberingBase = 'Section'">00</xsl:when>
                <xsl:otherwise>000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of
            select="concat(ancestor::*[@findingCode][1]/@findingCode, '-', $sectionNumber, string(format-number($findingNumber, $numFormat)))"
        />
    </xsl:template>

    <xsl:template match="non-finding" mode="number">
        <!-- Output finding display number (context is finding) -->
        <xsl:variable name="nonFindingNumber" select="count(preceding::non-finding) + 1"/>
        <xsl:variable name="numFormat" select="'000'"/>
        <xsl:value-of select="concat('NF-', string(format-number($nonFindingNumber, $numFormat)))"/>
    </xsl:template>

    <xsl:template
        match="section[not(@visibility = 'hidden')] | appendix[not(@visibility = 'hidden')]"
        mode="number">
        <xsl:choose>
            <xsl:when test="self::appendix"> Appendix&#160;<xsl:number
                    count="appendix[not(@visibility = 'hidden')]" level="multiple"
                    format="{$AUTO_NUMBERING_FORMAT}"/>
            </xsl:when>
            <xsl:when test="ancestor::appendix"> App&#160;<xsl:number count="appendix"
                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                    count="section[ancestor::appendix][not(@visibility = 'hidden')]"
                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number count="section[not(@visibility = 'hidden')] | finding | non-finding"
                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="prependId">
        <!-- COMMON WITH FO -->
        <xsl:choose>
            <xsl:when test="parent::finding or parent::non-finding">
                <!-- prepend finding id (XXX-NNN) -->
                <xsl:apply-templates select=".." mode="number"/>
                <xsl:text> &#8212; </xsl:text>
            </xsl:when>
            <xsl:when test="parent::non-finding">
                <!-- prepend non-finding id (NF-NNN) -->
                <xsl:apply-templates select=".." mode="number"/>
                <xsl:text> &#8212; </xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="tocContent_Numbering">
        <xsl:choose>
            <xsl:when test="self::appendix[not(@visibility = 'hidden')]">
                <span> Appendix&#160;<xsl:number count="appendix[not(@visibility = 'hidden')]"
                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/></span>
            </xsl:when>
            <xsl:when test="ancestor::appendix[not(@visibility = 'hidden')]">
                <span> App&#160;<xsl:number count="appendix[not(@visibility = 'hidden')]"
                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                        count="section[not(@visibility = 'hidden')][ancestor::appendix[not(@visibility = 'hidden')]]"
                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:number count="section[not(@visibility = 'hidden')] | finding | non-finding"
                        level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="section | appendix | finding | non-finding | annex">
        <xsl:if test="not(@visibility = 'hidden')">
            <div class="section">
                <xsl:apply-templates select="@* | node()"/>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="title[not(parent::biblioentry)]">
        <xsl:variable name="LEVEL">
            <xsl:value-of select="count(ancestor::*)"/>
        </xsl:variable>
        <xsl:element name="{concat('h', $LEVEL)}">
            <xsl:call-template name="titleLogic"/>
        </xsl:element>
        <xsl:if test="parent::finding">
            <!-- display meta box after title -->
            <xsl:apply-templates select=".." mode="meta"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="titleLogic">
        <xsl:param name="AUTO_NUMBERING_FORMAT" tunnel="yes"/>
        <!-- Give somewhat larger separation to Appendix because of the long string; if everything gets 3cm it looks horrible -->
        <xsl:choose>
            <xsl:when test="$NUMBERING">
                <span class="title">
                    <xsl:choose>
                        <xsl:when test="self::title[parent::appendix]">
                            <span class="titlenumber"> Appendix&#160;<xsl:number
                                    count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                    format="{$AUTO_NUMBERING_FORMAT}"/>
                            </span>
                        </xsl:when>
                        <xsl:when test="ancestor::appendix and not(self::title[parent::appendix])">
                            <span class="titlenumber"> App&#160;<xsl:number
                                    count="appendix[not(@visibility = 'hidden')]" level="multiple"
                                    format="{$AUTO_NUMBERING_FORMAT}"/>.<xsl:number
                                    count="section[ancestor::appendix][not(@visibility = 'hidden')]"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="titlenumber">
                                <xsl:number
                                    count="section[not(@visibility = 'hidden')] | finding | non-finding"
                                    level="multiple" format="{$AUTO_NUMBERING_FORMAT}"/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>&#160;</xsl:text>
                    <xsl:call-template name="titleContent"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="title">
                    <xsl:call-template name="titleContent"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="titleContent">
        <xsl:param name="client" tunnel="yes"/>
        <xsl:variable name="titleText_raw">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="titleText">
            <xsl:sequence
                select="
                    string-join(for $x in tokenize(normalize-space($titleText_raw), ' ')
                    return
                        my:titleCase($x), ' ')"
            />
        </xsl:variable>
        <xsl:if test="parent::finding">
            <xsl:call-template name="prependId"/>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>


    <!-- hide any attributes that are not explicitly handled -->
    <xsl:template match="@*"/>

    <xsl:template match="@id | @src | @alt">
        <!-- copy these! -->
        <xsl:copy/>
    </xsl:template>


    <xsl:template match="company/address">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="finding" mode="meta">
        <xsl:variable name="status" select="@status"/>
        <xsl:variable name="prettyStatus">
            <xsl:sequence
                select="
                    string-join(for $x in tokenize($status, '_')
                    return
                        my:titleCase($x), ' ')"
            />
        </xsl:variable>
        <div class="findingMetaBox">
            <xsl:attribute name="style">
                <xsl:text>border-top: 4px solid </xsl:text>
                <xsl:call-template name="selectColor">
                    <xsl:with-param name="label" select="@threatLevel"/>
                </xsl:call-template>
                <xsl:text>;</xsl:text>
            </xsl:attribute>
            <div class="row">
                <div class="six columns">
                    <span class="findingMetaBoxLabel">Vulnerability ID: </span>
                    <xsl:apply-templates select="." mode="number"/>
                </div>
                <xsl:if test="@status">
                    <div class="six columns">
                        <span class="findingMetaBoxLabel">Retest status: </span>
                        <xsl:choose>
                            <xsl:when test="@status = 'new' or @status = 'unresolved'">
                                <span class="status-new">
                                    <xsl:value-of select="$prettyStatus"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="@status = 'not_retested'">
                                <span class="status-not_retested">
                                    <xsl:value-of select="$prettyStatus"/>
                                </span>
                            </xsl:when>
                            <xsl:when test="@status = 'resolved'">
                                <span class="status-resolved">
                                    <xsl:value-of select="$prettyStatus"/>
                                </span>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </xsl:if>
            </div>
            <div class="row">
                <div>
                    <span class="findingMetaBoxLabel">Vulnerability type: </span>
                    <xsl:value-of select="@type"/>
                </div>
            </div>
            <div class="row">
                <div>
                    <span class="findingMetaBoxLabel">Threat level: </span>
                    <xsl:value-of select="@threatLevel"/>
                </div>
            </div>
        </div>




    </xsl:template>

    <!-- ignore summary-table-only elements in the findings -->
    <xsl:template match="description_summary | recommendation_summary"/>

    <xsl:template match="description">
        <h5 class="title-findingsection">Description:</h5>
        <div class="finding-content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="description" mode="summarytable">
        <xsl:if test="img | table">
            <xsl:message>WARNING: description containing img or table may not look very good in the
                finding summary table. Consider using a description_summary element
                instead.</xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>

    <xsl:template match="technicaldescription">
        <h5 class="title-findingsection">Technical description:</h5>
        <div class="finding-content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="impact">
        <h5 class="title-findingsection">Impact:</h5>
        <div class="finding-content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="recommendation">
        <h5 class="title-findingsection">Recommendation:</h5>
        <div class="finding-content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="recommendation" mode="summarytable">
        <xsl:if test="img | table">
            <xsl:message>WARNING: recommendation containing img or table may not look very good in
                the finding summary table. Consider using a recommendation_summary element
                instead.</xsl:message>
        </xsl:if>
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>
    
    <xsl:template match="update">
        <h5 class="title-findingsection">Update
            <xsl:if test="@date">
                <xsl:text> </xsl:text>
                <span class="status-tag small">
                    <xsl:value-of select="@date"/>                            
                </span>
            </xsl:if>
            <xsl:if test="@version">
                <xsl:text> </xsl:text>
                <span class="status-tag small">
                    <xsl:value-of select="@version"/>                            
                </span>
            </xsl:if>
            <xsl:text>:</xsl:text>
        </h5>
        <div class="finding-content">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="recommendation_summary" mode="summarytable">
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>
    <xsl:template match="description_summary" mode="summarytable">
        <xsl:apply-templates mode="summarytable"/>
    </xsl:template>

    <xsl:template match="generate_targets">
        <xsl:call-template name="generate_targets_html"/>
    </xsl:template>

    <xsl:template name="generate_targets_html">
        <xsl:param name="Ref" select="@Ref"/>
        <ul class="list">
            <xsl:for-each
                select="/*/meta/targets/target[@Ref = $Ref] | /*/meta/targets/target[not(@Ref)]">
                <li class="li">
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="generate_teammembers">
        <xsl:call-template name="generate_teammembers_fo"/>
    </xsl:template>

    <xsl:template name="generate_teammembers_fo">
        <ul class="list" provisional-distance-between-starts="0.75cm"
            provisional-label-separation="2.5mm" space-after="12pt" start-indent="1cm">
            <xsl:for-each select="//activityinfo//team/member">
                <li>
                    <span class="bold"><xsl:apply-templates select="name"/>: </span>
                    <xsl:apply-templates select="expertise"/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="generate_findings">
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="statusSequence" as="item()*">
            <xsl:for-each select="@status">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <table class="fwtable table borders u-full-width">
            <colgroup>
                <col style="width:10%"/>
                <col style="width:15%"/>
                <col style="width:65%"/>
                <col style="width:10%"/>
            </colgroup>
            <thead>
                <tr>
                    <th>
                        <div>ID</div>
                    </th>
                    <th>
                        <div>Type</div>
                    </th>
                    <th>
                        <div>Description</div>
                    </th>
                    <th>
                        <div>Threat level</div>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="@status and @Ref">
                        <!-- Only generate a table for findings in the section with this status AND this Ref -->
                        <xsl:for-each
                            select="$findingSummaryTable/findingEntry[@status = $statusSequence][ancestor::*[@id = $Ref]]">
                            <xsl:call-template name="findingsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@status and not(@Ref)">
                        <!-- Only generate a table for findings in the section with this status -->
                        <xsl:for-each
                            select="$findingSummaryTable/findingEntry[@status = $statusSequence]">
                            <xsl:call-template name="findingsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@Ref and not(@status)">
                        <!-- Only generate a table for findings in the section with this Ref -->
                        <xsl:for-each
                            select="$findingSummaryTable/findingEntry[ancestor::*[@id = $Ref]]">
                            <xsl:call-template name="findingsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$findingSummaryTable/findingEntry">
                            <xsl:call-template name="findingsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template name="findingsSummaryContent">
        <tr class="TableFont">
            <!--<xsl:if test="position() mod 2 != 0">
                        <xsl:attribute name="background-color">#ededed</xsl:attribute>
                    </xsl:if>-->
            <td>
                <div>
                    <!-- attach id to first finding of each threatLevel so pie charts can link to it -->
                    <xsl:if test="@id">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                    </xsl:if>
                    <a class="link">
                        <xsl:attribute name="href">
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="@findingId"/>
                        </xsl:attribute>
                        <xsl:value-of select="findingNumber"/>
                    </a>
                </div>
            </td>
            <td>
                <div>
                    <xsl:value-of select="findingType"/>
                </div>
            </td>
            <td>
                <div>
                    <xsl:value-of select="findingDescription"/>
                </div>
            </td>
            <td>
                <div>
                    <xsl:value-of select="findingThreatLevel"/>
                </div>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="generate_recommendations">
        <xsl:variable name="Ref" select="@Ref"/>
        <xsl:variable name="statusSequence" as="item()*">
            <xsl:for-each select="@status">
                <xsl:for-each select="tokenize(., ' ')">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <table class="fwtable table borders u-full-width">
            <colgroup>
                <col style="width:10%"/>
                <col style="width:15%"/>
                <col style="width:75%"/>
            </colgroup>
            <thead>
                <tr>
                    <th>
                        <div>ID</div>
                    </th>
                    <th>
                        <div>Type</div>
                    </th>
                    <th>
                        <div>Recommendation</div>
                    </th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                    <xsl:when test="@status and @Ref">
                        <!-- Only generate a table for findings in the section with this status AND this Ref -->
                        <xsl:for-each
                            select="/pentest_report/descendant::finding[@status = $statusSequence][ancestor::*[@id = $Ref]]">
                            <xsl:call-template name="recommendationsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@status and not(@Ref)">
                        <!-- Only generate a table for findings in the section with this status -->
                        <xsl:for-each
                            select="/pentest_report/descendant::finding[@status = $statusSequence]">
                            <xsl:call-template name="recommendationsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="@Ref and not(@status)">
                        <!-- Only generate a table for findings in the section with this Ref -->
                        <xsl:for-each
                            select="/pentest_report/descendant::finding[ancestor::*[@id = $Ref]]">
                            <xsl:call-template name="recommendationsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="/pentest_report/descendant::finding">
                            <xsl:call-template name="recommendationsSummaryContent"/>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template name="recommendationsSummaryContent">
        <tr class="TableFont">
            <!--<xsl:if test="position() mod 2 != 0">
                <xsl:attribute name="background-color">#ededed</xsl:attribute>
            </xsl:if>-->
            <td>
                <div>
                    <a class="link">
                        <xsl:attribute name="href">
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="." mode="number"/>
                    </a>
                </div>
            </td>
            <td>
                <div>
                    <xsl:value-of select="@type"/>
                </div>
            </td>
            <td>
                <div>
                    <xsl:choose>
                        <xsl:when test="recommendation_summary">
                            <xsl:apply-templates select="recommendation_summary" mode="summarytable"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="recommendation" mode="summarytable"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="generate_testteam">
        <xsl:for-each select="/pentest_report/meta/collaborators/pentesters/pentester">
            <xsl:if test="not(./name = /pentest_report/meta/collaborators/approver/name)">
                <div class="row">
                    <div class="two columns">
                        <xsl:apply-templates select="name"/>
                    </div>
                    <div class="ten columns">
                        <xsl:apply-templates select="bio"/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="/pentest_report/meta/collaborators/approver">
            <div class="row">
                <div class="two columns">
                    <xsl:apply-templates select="name"/>
                </div>
                <div class="ten columns">
                    <xsl:apply-templates select="bio"/>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="generate_service_breakdown">
        <xsl:choose>
            <xsl:when test="@format = 'list'">
                <ul>
                    <xsl:for-each select="$serviceNodeSet/entry[@type = 'service']">
                        <xsl:if test="d">
                            <li>
                                <xsl:value-of select="desc"/>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="d"/>
                            </li>
                        </xsl:if>
                    </xsl:for-each>
                    <li>
                        <b>
                            <xsl:text>Total effort: </xsl:text>
                            <xsl:call-template name="calculatePersonDays"/>
                            <xsl:text> days</xsl:text>
                        </b>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="@format = 'table'">
                <div>
                    <table class="fwtable table borders u-full-width">
                        <colgroup>
                            <col style="width:40%"/>
                            <col style="width:12%"/>
                            <col style="width:20%"/>
                            <col style="width:28%"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th> Description </th>
                                <th> Effort </th>
                                <th> Hourly rate </th>
                                <th> Fee </th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="$serviceNodeSet/entry">
                                <tr>
                                    <xsl:if test="position() mod 2 != 0">
                                        <xsl:attribute name="background-color"
                                            >#ededed</xsl:attribute>
                                    </xsl:if>
                                    <td>
                                        <xsl:if
                                            test="not(normalize-space(d)) and not(normalize-space(h))">
                                            <xsl:attribute name="number-columns-spanned"
                                                >3</xsl:attribute>
                                        </xsl:if>
                                        
                                            <xsl:value-of select="desc"/>
                                        
                                    </td>
                                    <xsl:if test="d">
                                        <td>
                                            
                                                <xsl:value-of select="d"/>
                                            
                                        </td>
                                        <xsl:choose>
                                            <xsl:when test="normalize-space(h)">
                                                <td>
                                                  <div align="right">
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                  </xsl:call-template>
                                                  <xsl:call-template name="prettyMissingDecimal">
                                                  <xsl:with-param name="n" select="h"/>
                                                  </xsl:call-template>
                                                  <xsl:text> excl. VAT</xsl:text>
                                                  </div>
                                                </td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td>
                                                  <div align="right">-</div>
                                                </td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <td>
                                        <div align="right">
                                            <xsl:choose>
                                                <xsl:when test="not(f/min = f/max)">
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                  </xsl:call-template>
                                                  <xsl:number value="f/min" grouping-separator=","
                                                  grouping-size="3"/>
                                                  <xsl:text> - </xsl:text>
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                  </xsl:call-template>
                                                  <xsl:call-template name="prettyMissingDecimal">
                                                  <xsl:with-param name="n" select="f/max"/>
                                                  </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:call-template name="getDenomination">
                                                  <xsl:with-param name="placeholderElement"
                                                  select="."/>
                                                  </xsl:call-template>
                                                  <xsl:call-template name="prettyMissingDecimal">
                                                  <xsl:with-param name="n" select="f/min"/>
                                                  </xsl:call-template>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:text> excl. VAT</xsl:text>
                                            <xsl:if test="@estimate = true()">*</xsl:if>
                                        </div>
                                    </td>
                                </tr>
                            </xsl:for-each>
                            <tr>
                                <td colspan="4">
                                    <b>
                                        <span>
                                            <xsl:text>Total</xsl:text>
                                            <xsl:if test="$serviceNodeSet/entry/@estimate = true()">
                                                (estimate)</xsl:if>
                                            <xsl:text>:</xsl:text>
                                        </span>
                                        <span>
                                            <xsl:call-template name="calculateTotal"/>
                                            <xsl:text> excl. VAT</xsl:text>
                                        </span>
                                    </b>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>


                <xsl:if test="$serviceNodeSet/entry/@estimate = true()">
                    <div align="right">
                        <xsl:text>* Estimate</xsl:text>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">ERROR: unknown service breakdown format (use
                        'list' or 'table')</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="checkDenomination">
        <xsl:param name="allDenominationsAreEqual"/>
        <xsl:param name="denoms"/>
        <xsl:choose>
            <xsl:when test="$allDenominationsAreEqual">
                <xsl:call-template name="getDenomination">
                    <xsl:with-param name="placeholderElement" select="$denoms/denom"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="displayErrorText">
                    <xsl:with-param name="string">Cannot print denomination: not all fees in
                        service_breakdown have an equal denomination (tip: if most services are in
                        eur but one is in usd, add the usd fee to the description for that service
                        and use an estimated eur for the hourly rate or fee).</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="calculatePersonDays">
        <xsl:variable name="totalMinDurations"
            select="sum($serviceNodeSet/entry[@type = 'service']/dh/min)"/>
        <xsl:variable name="totalMaxDurations"
            select="sum($serviceNodeSet/entry[@type = 'service']/dh/max)"/>
        <xsl:choose>
            <xsl:when test="not($totalMinDurations = $totalMaxDurations)">
                <xsl:value-of select="sum($totalMinDurations) div 8"/>
                <xsl:text> - </xsl:text>
                <xsl:value-of select="sum($totalMaxDurations) div 8"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="sum($totalMinDurations) div 8"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="prettyMissingDecimal">
        <xsl:param name="n"/>
        <xsl:if test="floor($n) = $n">
            <xsl:number value="$n" grouping-separator="," grouping-size="3"/>
            <xsl:text>.-</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="calculateTotal">
        <xsl:param name="denoms" tunnel="yes">
            <xsl:for-each-group select="$serviceNodeSet/entry" group-by="@denomination">
                <denom denomination="{current-grouping-key()}"/>
            </xsl:for-each-group>
        </xsl:param>
        <xsl:variable name="allDenominationsAreEqual" select="count($denoms/denom) = 1"/>
        <xsl:variable name="minmaxesPresent"
            select="boolean($serviceNodeSet/entry/f/min and $serviceNodeSet/entry/f/max)"/>
        <xsl:variable name="estimatePresent" select="$serviceNodeSet/entry/@estimate"/>
        <xsl:variable name="totalMinFees" select="sum($serviceNodeSet/entry/f/min)"/>
        <xsl:variable name="totalMaxFees" select="sum($serviceNodeSet/entry/f/max)"/>
        <xsl:choose>
            <xsl:when test="not($totalMinFees = $totalMaxFees)">
                <!-- We have different min and max fees, print range -->
                <xsl:call-template name="checkDenomination">
                    <xsl:with-param name="allDenominationsAreEqual"
                        select="$allDenominationsAreEqual"/>
                    <xsl:with-param name="denoms" select="$denoms"/>
                </xsl:call-template>
                <xsl:number value="$totalMinFees" grouping-separator="," grouping-size="3"/>
                <xsl:text> - </xsl:text>
                <xsl:call-template name="checkDenomination">
                    <xsl:with-param name="allDenominationsAreEqual"
                        select="$allDenominationsAreEqual"/>
                    <xsl:with-param name="denoms" select="$denoms"/>
                </xsl:call-template>
                <xsl:call-template name="prettyMissingDecimal">
                    <xsl:with-param name="n" select="$totalMaxFees"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Min and max are equal; print single price -->
                <xsl:call-template name="checkDenomination">
                    <xsl:with-param name="allDenominationsAreEqual"
                        select="$allDenominationsAreEqual"/>
                    <xsl:with-param name="denoms" select="$denoms"/>
                </xsl:call-template>
                <xsl:call-template name="prettyMissingDecimal">
                    <xsl:with-param name="n" select="$totalMinFees"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
