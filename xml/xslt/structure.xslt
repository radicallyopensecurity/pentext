<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://www.radical.sexy"
    exclude-result-prefixes="xs my" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:variable name="c_main">#e2632a</xsl:variable>
    <xsl:variable name="c_support_light">#ededed</xsl:variable>
    <xsl:variable name="c_support_dark">#414241</xsl:variable>

    <xsl:template match="section | appendix | finding | non-finding | annex">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:if test="not(@visibility = 'hidden')">
            <xsl:choose>
                <xsl:when test="$execsummary = true()">
                    <xsl:if test="ancestor-or-self::*[@inexecsummary][1]/@inexecsummary = 'yes'">
                        <fo:block xsl:use-attribute-sets="section">
                            <xsl:if test="self::appendix or self::annex">
                                <xsl:attribute name="break-before">page</xsl:attribute>
                            </xsl:if>
                            <xsl:apply-templates select="@* | node()"/>
                        </fo:block>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="section">
                        <xsl:if test="self::appendix or self::annex">
                            <xsl:attribute name="break-before">page</xsl:attribute>
                        </xsl:if>
                        <xsl:apply-templates select="@* | node()"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="title[not(parent::biblioentry)]">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:variable name="LEVEL">
            <xsl:choose>
                <!-- waivers are special and get a hard-coded level -->
                <xsl:when test="local-name(ancestor::*[2]) = 'waivers'">1</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(ancestor::*) - 1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$LEVEL = 0">
                <xsl:choose>
                    <xsl:when test="$NUMBERING">
                        <fo:list-block xsl:use-attribute-sets="title-0">
                            <xsl:call-template name="titleLogic"/>
                        </fo:list-block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block xsl:use-attribute-sets="title-0">
                            <xsl:call-template name="titleLogic"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$LEVEL = 1">
                <xsl:choose>
                    <xsl:when test="$NUMBERING = true()">
                        <fo:list-block xsl:use-attribute-sets="title-1 numbered-title">
                            <xsl:call-template name="titleLogic"/>
                        </fo:list-block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block xsl:use-attribute-sets="title-1">
                            <xsl:call-template name="titleLogic"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$LEVEL = 2">
                <xsl:choose>
                    <xsl:when test="$NUMBERING">
                        <fo:list-block xsl:use-attribute-sets="title-2 numbered-title">
                            <xsl:call-template name="titleLogic"/>
                        </fo:list-block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block xsl:use-attribute-sets="title-2">
                            <xsl:call-template name="titleLogic"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$LEVEL = 3">
                <xsl:choose>
                    <xsl:when test="$NUMBERING">
                        <fo:list-block xsl:use-attribute-sets="title-3 numbered-title">
                            <xsl:call-template name="titleLogic"/>
                        </fo:list-block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block xsl:use-attribute-sets="title-3">
                            <xsl:call-template name="titleLogic"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$LEVEL = 4">
                <xsl:choose>
                    <xsl:when test="$NUMBERING">
                        <fo:list-block xsl:use-attribute-sets="title-4 numbered-title">
                            <xsl:call-template name="titleLogic"/>
                        </fo:list-block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block xsl:use-attribute-sets="title-4">
                            <xsl:call-template name="titleLogic"/>
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="parent::finding">
            <!-- display meta box after title -->
            <xsl:apply-templates select=".." mode="meta"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="titleLogic">
        <xsl:param name="execsummary" tunnel="yes"/>
        <xsl:param name="AUTO_NUMBERING_FORMAT" tunnel="yes"/>
        <!-- Give somewhat larger separation to Appendix because of the long string; if everything gets 3cm it looks horrible -->
        <xsl:choose>
            <xsl:when test="$NUMBERING">
                <xsl:attribute name="provisional-distance-between-starts">
                    <xsl:choose>
                        <xsl:when test="self::title[parent::appendix]">3.5cm</xsl:when>
                        <xsl:otherwise>1.5cm</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <fo:list-item>
                    <fo:list-item-label end-indent="label-end()">
                        <fo:block line-height="0.7cm">
                            <xsl:if test="../.. = /">
                                <!-- Titles that appear on a section cover need to have a marker attached -->
                                <xsl:call-template name="getTabMarker"/>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="$execsummary = true()">
                                    <xsl:choose>
                                        <xsl:when test="self::title[parent::appendix]">
                                            <fo:inline> Appendix&#160;<xsl:number
                                                  count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                />
                                            </fo:inline>
                                        </xsl:when>
                                        <xsl:when
                                            test="ancestor::appendix and not(self::title[parent::appendix])">
                                            <fo:inline> App&#160;<xsl:number
                                                  count="appendix[not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                  />.<xsl:number
                                                  count="section[ancestor::appendix][not(@visibility = 'hidden')][@inexecsummary = 'yes']"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                />
                                            </fo:inline>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <fo:inline>
                                                  <xsl:number
                                                  count="section[not(@visibility = 'hidden')][ancestor-or-self::*[@inexecsummary][1]/@inexecsummary = 'yes'] | finding | non-finding"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                  />
                                                </fo:inline>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="self::title[parent::appendix]">
                                            <fo:inline> Appendix&#160;<xsl:number
                                                  count="appendix[not(@visibility = 'hidden')]"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                />
                                            </fo:inline>
                                        </xsl:when>
                                        <xsl:when
                                            test="ancestor::appendix and not(self::title[parent::appendix])">
                                            <fo:inline> App&#160;<xsl:number
                                                  count="appendix[not(@visibility = 'hidden')]"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                  />.<xsl:number
                                                  count="section[ancestor::appendix][not(@visibility = 'hidden')]"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                />
                                            </fo:inline>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <fo:inline>
                                                <xsl:number
                                                  count="section[not(@visibility = 'hidden')] | finding | non-finding"
                                                  level="multiple" format="{$AUTO_NUMBERING_FORMAT}"
                                                />
                                            </fo:inline>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="body-start()">
                        <xsl:call-template name="titleContent"/>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="titleContent"/>
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
        <fo:block line-height="0.7cm">
            <xsl:if test="parent::finding or parent::non-finding">
                <xsl:call-template name="prependId"/>
            </xsl:if>
            <!-- some hard waiver logic here (unfortunately): if we're still in the quote, the waiver is an annex and should be numbered as such... -->
            <xsl:if test="local-name(ancestor::*[2]) = 'waivers' and $client = true()">Annex
                    <xsl:value-of select="ancestor::*[2]/@annex_number"/> - </xsl:if>
            <xsl:choose>
                <!-- (...continued) and the waiver title should have capitalized first letters (for all waivers, annexed or standalone) -->
                <xsl:when test="local-name(ancestor::*[2]) = 'waivers'">
                    <xsl:value-of select="$titleText"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <xsl:template name="getTabMarker">
        <fo:marker marker-class-name="tab">
            <xsl:value-of select="text()"/>
        </fo:marker>
    </xsl:template>

</xsl:stylesheet>
