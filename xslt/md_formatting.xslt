<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://www.radical.sexy"
  exclude-result-prefixes="xs my"
  version="2.0"
>

  <!-- Adds a space before punctuation or at end of text -->
  <xsl:function name="my:addSpaceIfNeeded" as="xs:string">
    <xsl:param name="node" as="element()" />
    <xsl:variable
      name="next"
      select="
            $node/following-sibling::node()
            [not(self::comment() or self::processing-instruction())]
            [normalize-space()][1]
        "
    />
    <xsl:sequence
      select="
            if (empty($next)) then ''
            else if ($next[self::text()][matches(., '^[,.\)]')]) then ''
            else ' '
        "
    />
  </xsl:function>

  <!-- Adds a space before an element if not preceded by (, [, <, or whitespace -->
  <xsl:function name="my:addSpaceBeforeIfNeeded" as="xs:string">
    <xsl:param name="node" as="element()" />
    <xsl:variable
      name="prev"
      select="
            $node/preceding-sibling::node()
            [not(self::comment() or self::processing-instruction())]
            [normalize-space()][1]
        "
    />
    <xsl:sequence
      select="
            if (empty($prev)) then ''
            else if ($prev[self::text()][matches(., '(\s|[(\[{])$')]) then ''
            else ' '
        "
    />
  </xsl:function>
  
  <!-- Headings -->
  <xsl:template match="title">
    <xsl:variable
      name="level"
      select="count(ancestor::section | ancestor::appendix) + 1"
    />
    <xsl:if test="count(preceding::title) &gt; 0">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:text>#</xsl:text>
    <xsl:for-each select="1 to $level - 1">
      <xsl:text>#</xsl:text>
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <xsl:value-of select="." />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Inline elements -->
  <xsl:template match="br">
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>
  <xsl:template match="p">
    <xsl:apply-templates />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="a">
    <xsl:value-of select="my:addSpaceBeforeIfNeeded(.)" />
    <xsl:text>[</xsl:text>
    <xsl:apply-templates />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@href" />
    <xsl:text>)</xsl:text>
    <xsl:value-of select="my:addSpaceIfNeeded(.)" />
  </xsl:template>

  <xsl:template match="img">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>![</xsl:text>
    <xsl:value-of select="@alt" />
    <xsl:text>](</xsl:text>
    <xsl:value-of select="@src" />
    <xsl:text>)</xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="my:addSpaceIfNeeded(.)" />
  </xsl:template>

  <xsl:template match="strong|b">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates />
    <xsl:text>**</xsl:text>
    <xsl:value-of select="my:addSpaceIfNeeded(.)" />
  </xsl:template>

  <xsl:template match="em|i">
    <xsl:value-of select="my:addSpaceBeforeIfNeeded(.)" />
    <xsl:text>*</xsl:text>
    <xsl:value-of select="normalize-space(.)" />
    <xsl:text>*</xsl:text>
    <xsl:value-of select="my:addSpaceIfNeeded(.)" />
  </xsl:template>

  <xsl:template match="pre">
    <xsl:text>&#10;&#96;&#96;&#96;&#10;</xsl:text>
    <xsl:apply-templates select="node()" mode="codeblock" />
    <xsl:text>&#10;&#96;&#96;&#96;&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="code" mode="codeblock">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <xsl:template match="code">
    <xsl:text>`</xsl:text>
    <xsl:apply-templates select="node()" />
    <xsl:text>`</xsl:text>
    <xsl:value-of select="my:addSpaceIfNeeded(.)" />
  </xsl:template>

  <!-- Lists -->
  <xsl:template match="ul">
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates select="li" />
  </xsl:template>

  <xsl:template match="li">
    <xsl:text>- </xsl:text>
    <xsl:apply-templates />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
