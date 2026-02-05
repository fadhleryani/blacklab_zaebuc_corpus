<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output encoding="utf-8" method="html" omit-xml-declaration="yes" />

<!-- Hide metadata section completely -->
<xsl:template match="metadata">
    <!-- Don't output anything for metadata -->
</xsl:template>

<!-- Apply text direction based on metadata -->
<xsl:template match="doc">
    <xsl:variable name="textDir" select="metadata/meta[@name='textDirection']"/>
    <div>
        <xsl:if test="$textDir">
            <xsl:attribute name="dir">
                <xsl:value-of select="$textDir"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates />
    </div>
</xsl:template>

<!-- Handle sentences -->
<xsl:template match="sent">
    <p>
        <xsl:apply-templates />
    </p>
</xsl:template>

<!-- Handle words - extract the text content -->
<xsl:template match="word">
    <xsl:value-of select="." />
    <xsl:text> </xsl:text>
</xsl:template>

<!-- Highlight hits -->
<xsl:template match="*[local-name(.)='hl']">
    <span class="hl">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>

<!-- Clean up control characters in text -->
<xsl:template match="text()">
    <xsl:value-of select="replace(., '[&#x007F;-&#x009F;]', ' ')"/>
</xsl:template>

</xsl:stylesheet>