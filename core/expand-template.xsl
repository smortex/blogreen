<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:bat="http://blogreen.org/TR/AggregatedTemplate" version="1.0">
	<xsl:output type="xml" indent="yes" />

	<!--
	<xsl:include href="do-not-edit.xsl" />
	-->

	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>


	<xsl:include href="build-utils.xsl" />
	<xsl:param name="filename" />

	<!--
	The last template is the one referenced by the others so we only
	need ot proccess this one.
	-->
	<xsl:template match="/bat:templates/bat:template[position()=last()]/xhtml:html">

		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" method="xml" indent="yes">
			<axsl:stylesheet version="1.0">

				<!--
				<xsl:call-template name="do-not-edit" />
				-->

				<axsl:import href="{$BLOGREEN}/template-utils.xsl" />
				<!--
				XXX: Plugins
				-->
				<axsl:import href="{$BLOGREEN}/../plugins/breadcrumbs.xsl" />
				<axsl:import href="{$BLOGREEN}/../plugins/prices.xsl" />
				<axsl:import href="{$BLOGREEN}/../plugins/main-navigation.xsl" />

				<axsl:import href="{$BLOGREEN}/../plugins/lightbox2.xsl" />

				<axsl:param name="output-language">en</axsl:param>

				<axsl:template name="{/bat:templates/bat:template[position()=1]/xhtml:html/xhtml:head/xhtml:title}">
					<axsl:param name="context" />

					<axsl:element name="html" namespace="http://www.w3.org/1999/xhtml">
						<axsl:attribute name="xml:lang"><axsl:value-of select="$output-language" /></axsl:attribute>

						<!--
						TODO: Generate <head>…</head> contents.
						-->
						<head>
							<title>
								<axsl:apply-templates select="." mode="title">
									<axsl:with-param name="context">
										<axsl:value-of select="$context" />
									</axsl:with-param>
								</axsl:apply-templates>
							</title>

							<link rel="stylesheet" type="text/css" media="all" href="/css/blogreen.css" />
							<link rel="stylesheet" type="text/css" media="screen" href="/css/screen.css" />
							<link rel="stylesheet" type="text/css" media="print" href="/css/print.css" />
							<bgn:page-css />

							<bgn:page-javascript />
						</head>

						<xsl:apply-templates select="xhtml:body" mode="copy" />

					</axsl:element>
				</axsl:template>

			</axsl:stylesheet>
		</xsl:document>
	</xsl:template>

	<!--
	Try to fill-in placeholders with partials
	-->
	<xsl:template match="bgn:placeholder[@name]" mode="copy">
		<xsl:variable name="name">
			<xsl:value-of select="@name" />
		</xsl:variable>
		<xsl:element name="div" namespace="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="id">
				<xsl:value-of select="@name" />
			</xsl:attribute>
			<xsl:attribute name="class">drop-if-empty</xsl:attribute>
		<xsl:choose>
			<xsl:when test="//bgn:content[@placeholder=$name]">
				<!--
				The aggregated templates contains the contents of the
				placeholder.  Add it.
				-->
				<xsl:apply-templates select="//bgn:content[@placeholder=$name]/node()" mode="copy" />
			</xsl:when>
			<xsl:otherwise>
				<!--
				The aggregated templates does not contains the contents of the
				placeholder.  It will be computer when redering individual
				pages, so copy it.  Some XSLT will replace it later.
				-->
				<!--
				FIXME: Generate low-priority 'default' templates.
				The current code will copy the text() value of the current
				node without any warning.  Instead, we should produce some
				informational information on what's did not match any template
				(i.e. how to fix it) and produce some diagnostic on the
				console.
				-->
				<axsl:apply-templates select="." mode="{$name}" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	</xsl:template>

	<xsl:template match="bgn:plugin[@name]" mode="copy">
		<axsl:apply-templates select="." mode="plugin-{@name}">
			<axsl:with-param name="context">
				<axsl:value-of select="$context" />
			</axsl:with-param>
			<xsl:apply-templates mode="copy"/>
		</axsl:apply-templates>
	</xsl:template>

	<xsl:template match="bgn:with-param[@name]" mode="copy">
		<axsl:with-param name="{@name}">
			<xsl:apply-templates />
		</axsl:with-param>
	</xsl:template>

	<xsl:template match="node()|@*" mode="copy">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" mode="copy" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*|@*">
		<xsl:apply-templates select="*|@*" />
	</xsl:template>


</xsl:stylesheet>
