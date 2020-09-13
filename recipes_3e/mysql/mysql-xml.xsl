<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- mysql-xml.xsl: interpret XML-format output from mysql client -->

<xsl:output method="text"/>

<!-- Process rows in each resultset  -->
<xsl:template match="resultset">
  <xsl:text>Query: </xsl:text>
  <xsl:value-of select="@statement"/>
  <xsl:value-of select="'&#10;'"/>
  <xsl:text>Result set:&#10;</xsl:text>
  <xsl:apply-templates select="row"/>
</xsl:template>

<!-- Process fields in each row  -->
<xsl:template match="row">
  <xsl:apply-templates select="field"/>
</xsl:template>

<!-- Display text content of each field -->
<xsl:template match="field">
  <xsl:value-of select="."/>
  <xsl:choose>
    <xsl:when test="position() != last()">
      <xsl:text>, </xsl:text> <!-- comma after all but last field -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'&#10;'"/> <!-- newline after last field -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
