<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:res="http://blogreen.org/TR/Resources" version="1.0">

	<xsl:include href="build-utils.xsl" />

	<xsl:param name="filename" />

	<xsl:template match="/">
		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" method="xml" indent="yes">
			<xsl:apply-templates select="node()|@*|text()" />
		</xsl:document>
	</xsl:template>

	<xsl:template match="*|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*|text()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="res:*/@uri">
		<xsl:attribute name="uri">
			<xsl:call-template name="parent-path" />
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="parent-path">
		<xsl:for-each select="..">
			<xsl:call-template name="parent-path" />
		</xsl:for-each>
		<xsl:value-of select="@uri" />
	</xsl:template>
</xsl:stylesheet>
