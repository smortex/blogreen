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

	<!--
	Replace the context node partial path @uri with the full path of the
	resource.
	-->
	<xsl:template match="res:*/@*[starts-with(name(.), 'uri')]">
		<xsl:attribute name="{name(.)}">
			<xsl:choose>
				<xsl:when test="contains(., '://') or starts-with(., 'mailto:') or starts-with(., '/')">
					<xsl:value-of select="." />
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="..">
						<xsl:call-template name="parent-path" />
					</xsl:for-each>
					<xsl:if test="not(name(.) = 'uri')">
						<xsl:value-of select="../@uri" />
					</xsl:if>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!--
	Return the context node parent's full path.
	-->
	<xsl:template name="parent-path">
		<xsl:for-each select="..">
			<xsl:call-template name="parent-path" />
			<xsl:value-of select="@uri" />
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
