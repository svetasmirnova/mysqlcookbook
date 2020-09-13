<?xml version="1.0" encoding="ISO-8859-1" standalone="yes" ?>

<!-- Convert change log document to HTML -->

<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Do not produce XML header -->

<xsl:output method="html" omit-xml-declaration="yes"/>

<!-- Catch-all template to make us aware of any errors -->

<xsl:template match="*">
  <xsl:message>
    <xsl:value-of select="name(.)"/>
    <xsl:text> encountered, but no template matches.</xsl:text>
  </xsl:message>
</xsl:template>

<!-- root element -->

<xsl:template match="changelog">
	<html>
	<head>
	<title>
		<xsl:text>Change log for </xsl:text>
		<xsl:value-of select="distribution-name"/>
		<xsl:text> distribution (</xsl:text>
		<xsl:value-of select="book"/>
		<xsl:text>)</xsl:text>
	</title>
	</head>
	<body>
	<h2>
		<xsl:text>Change log for </xsl:text>
		<xsl:value-of select="distribution-name"/>
		<xsl:text> distribution (</xsl:text>
		<xsl:value-of select="book"/>
		<xsl:text>)</xsl:text>
	</h2>
    <p>
		<xsl:text>This file lists changes to the </xsl:text>
		<xsl:value-of select="distribution-name"/>
		<xsl:text> distribution that accompanies </xsl:text>
		<xsl:value-of select="book"/>
		<xsl:text>. Changes are listed in reverse chronological order.</xsl:text>
    </p>
    <p>
		<xsl:text>Downloads are available at: </xsl:text>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="downloads"/>
			</xsl:attribute>
			<xsl:value-of select="downloads"/>
		</a>
    </p>
	<xsl:apply-templates select="changeset"/>
	</body>
	</html>
</xsl:template>

<xsl:template match="changeset">
	<p>
	<strong>
		<xsl:text>Version </xsl:text>
		<xsl:value-of select="version"/>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="date"/>
		<xsl:text>)</xsl:text>
	</strong>
	</p>
	<xsl:apply-templates select="items"/>
</xsl:template>

<xsl:template match="items">
	<ul>
		<xsl:apply-templates select="item"/>
	</ul>
</xsl:template>

<!-- <item> may contain text or other <items> elements -->

<xsl:template match="item">
	<li>
		<xsl:apply-templates/>
	</li>
</xsl:template>

</xsl:stylesheet>
