<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet generates the main stylesheet in charge of
	generating all pages.

	Input: mapping.xml

	Parameters:
	- filename[='']    TODO: Set some decent default value
	  Name of the stylesheet to generate.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns:map="http://blogreen.org/TR/Mapping" version="1.0">
	<xsl:output method="xml" indent="yes" />

	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

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
			<xsl:comment>
				DO NOT EDIT
				XXX: Add some doc
			</xsl:comment>
			<axsl:stylesheet version="1.0" xmlns:res="http://blogreen.org/TR/Resources">

			<!-- XXX import headers -->

			<!-- import templates -->
			<xsl:for-each select="//map:map">
				<xsl:variable name="template" select="@template" />
				<xsl:if test="count(preceding::map:map[@template=$template]) + count(ancestor::map:map[@template = $template]) = 0">
					<!--
					FIXME: Static reference to '/templates/'.
					-->
					<axsl:include href="{concat($OBJDIR, '/templates/', @template, '.xsl')}" />
				</xsl:if>
			</xsl:for-each>

			<!--
			FIXME: Maybe we can avoid loading all views.
			For now, it's not really a problem since we also load all data
			and all templates.
			-->
			<axsl:include href="{$SRCDIR}/views.xsl" />

			<axsl:include href="{$BLOGREEN}/build-utils.xsl" />
			<axsl:include href="{$BLOGREEN}/resource-utils.xsl" />
			<axsl:include href="{$BLOGREEN}/string-utils.xsl" />

			<axsl:template match="res:ref" mode="copy">
				<axsl:call-template name="resource-ref-by-id">
					<axsl:with-param name="resource-id" select="@resource" />
				</axsl:call-template>
			</axsl:template>

				<xsl:apply-templates />

				<axsl:template match="*|text()">
				</axsl:template>

		</axsl:stylesheet>
	</xsl:document>
	</xsl:template>

	<xsl:template match="map:map">
		<axsl:template match="{@resource}">
			<axsl:variable name="filename">
				<axsl:value-of select="concat($OBJDIR, @uri, '/index.html')" />
			</axsl:variable>
			<axsl:call-template name="progress">
				<axsl:with-param name="filename" select="$filename" />
			</axsl:call-template>
			<axsl:document href="{{$filename}}">
				<axsl:call-template name="{@template}">
					<xsl:if test="@context">
						<axsl:with-param name="context">
							<xsl:value-of select="@context" />
						</axsl:with-param>
					</xsl:if>
				</axsl:call-template>
			</axsl:document>
			<axsl:apply-templates select="res:*" />
		</axsl:template>
		<xsl:apply-templates />
	</xsl:template>
</xsl:stylesheet>
