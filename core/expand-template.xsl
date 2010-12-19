<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:bat="http://blogreen.org/TR/AggregatedTemplate" xmlns:c="http://blogreen.org/TR/Config" version="1.0">
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
	<xsl:template match="/bat:templates/bat:template[position()=last()]">

		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" method="xml" indent="yes">
			<axsl:stylesheet version="1.0" xmlns:res="http://blogreen.org/TR/Resources">

				<!--
				<xsl:call-template name="do-not-edit" />
				-->
				<axsl:import href="{$BLOGREEN}/template-utils.xsl" />

				<!-- Import plugins configured by the user -->
				<xsl:for-each select="document(concat($SRCDIR, '/config.xml'))//c:plugins/c:plugin">
					<axsl:import href="{$BLOGREEN}/../plugins/{@name}.xsl" />
				</xsl:for-each>

				<axsl:param name="output-language">en</axsl:param>

				<xsl:choose>
					<xsl:when test="xhtml:html">
						<!-- Template is an XHTML file -->
						<axsl:template name="{/bat:templates/bat:template[position()=1]/xhtml:html/xhtml:head/xhtml:title}">
							<axsl:param name="context" />
							<axsl:param name="position" />
							<axsl:param name="count" />
							<axsl:param name="page" />

							<axsl:element name="html" namespace="http://www.w3.org/1999/xhtml">
								<axsl:attribute name="xml:lang"><axsl:value-of select="$output-language" /></axsl:attribute>

								<!--
								TODO: Generate <head>…</head> contents.
								-->
								<head>
									<title>
										<axsl:apply-templates select="." mode="title">
											<axsl:with-param name="context" select="$context" />
											<axsl:with-param name="position" select="$position" />
											<axsl:with-param name="count" select="$count" />
											<axsl:with-param name="page" select="$page"/>
										</axsl:apply-templates>
									</title>

									<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
									<bgn:meta-tags warn="no" />

									<link rel="stylesheet" type="text/css" media="all" href="/css/blogreen.css" />
									<link rel="stylesheet" type="text/css" media="screen" href="/css/screen.css" />
									<link rel="stylesheet" type="text/css" media="print" href="/css/print.css" />

									<bgn:favicon warn="no" />

									<bgn:page-css warn="no" />

									<bgn:page-javascript warn="no" />
								</head>

								<axsl:element name="body" namespace="http://www.w3.org/1999/xhtml">
									<bgn:body-onload warn="no" />
									<xsl:apply-templates select="xhtml:html/xhtml:body/*" mode="copy" />
								</axsl:element>

							</axsl:element>
						</axsl:template>
					</xsl:when>
					<xsl:otherwise>
						<!-- Template is a plain XML file -->
						<xsl:if test="not(child::*[1]/@bgn:template-name)">
							<xsl:call-template name="error">
								<xsl:with-param name="message">No template name provided.</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
						<axsl:template name="{child::*[1]/@bgn:template-name}">
							<axsl:param name="context" />
							<axsl:param name="position" />
							<axsl:param name="count" />
							<axsl:param name="page" />
							<xsl:apply-templates select="*" mode="copy" />
						</axsl:template>
					</xsl:otherwise>
				</xsl:choose>

				<!--
				Generate default low-priority templates to warn the user about missing
				content for placeholders.
				-->
				<xsl:for-each select="//bgn:placeholder[@name]">
					<axsl:template match="*" mode="{@name}" priority="-10">
						<axsl:call-template name="no-template-for-placeholder">
							<axsl:with-param name="placeholder">
								<xsl:value-of select="@name" />
							</axsl:with-param>
						</axsl:call-template>
					</axsl:template>
				</xsl:for-each>

			</axsl:stylesheet>
		</xsl:document>
	</xsl:template>

	<!--
	Try to fill-in placeholders with partials
	-->
	<xsl:template match="bgn:placeholder[@name]" mode="copy">
		<xsl:choose>
			<xsl:when test="@phantom = true()">
				<xsl:call-template name="placeholder-content" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="div" namespace="http://www.w3.org/1999/xhtml">
					<xsl:attribute name="id">
						<xsl:value-of select="@name" />
					</xsl:attribute>
					<xsl:attribute name="class">drop-if-empty</xsl:attribute>
					<xsl:call-template name="placeholder-content" />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="placeholder-content">
		<xsl:variable name="name">
			<xsl:value-of select="@name" />
		</xsl:variable>
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
				<axsl:apply-templates select="." mode="{$name}">
					<axsl:with-param name="context" select="$context" />
					<axsl:with-param name="position" select="$position" />
					<axsl:with-param name="count" select="$count" />
					<axsl:with-param name="page" select="$page" />
				</axsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="bgn:plugin[@name]" mode="copy">
		<axsl:apply-templates select="." mode="plugin-{@name}">
			<axsl:with-param name="warn">yes</axsl:with-param>
			<axsl:with-param name="context" select="$context" />
			<axsl:with-param name="position" select="$position" />
			<axsl:with-param name="count" select="$count" />
			<axsl:with-param name="page" select="$page" />
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
