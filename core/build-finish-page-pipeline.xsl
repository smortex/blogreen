<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns:c="http://blogreen.org/TR/Config" xmlns="http://www.w3.org/1999/xhtml" version="1.0">

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
			<axsl:stylesheet version="1.0" xmlns:bgn="http://blogreen.org">
				<axsl:import href="{$BLOGREEN}/finish-pages.xsl" />

				<!-- Load plugin filters -->
				<xsl:for-each select="//c:filters/c:filter">
					<axsl:import href="{$BLOGREEN}/../filters/{@name}.xsl" />
				</xsl:for-each>

				<!-- Load user filters -->
				<axsl:import href="{$SRCDIR}/filters.xsl" />

				<axsl:include href="{$BLOGREEN}/build-utils.xsl" />

				<axsl:param name="filename" />

				<axsl:output method="text" />

				<axsl:template match="/">
					<axsl:call-template name="check-required-parameter">
						<axsl:with-param name="name" select="'filename'" />
						<axsl:with-param name="value" select="$filename" />
					</axsl:call-template>

					<axsl:call-template name="progress">
						<axsl:with-param name="filename" select="$filename" />
					</axsl:call-template>

					<axsl:document href="{{$filename}}" method="xml" indent="yes" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" >
						<axsl:copy>
							<axsl:apply-templates select="*" />
						</axsl:copy>
					</axsl:document>
				</axsl:template>

				<axsl:template match="@*|node()">
					<axsl:if test="not((@class = 'drop-if-empty') and not (node()) or name(.) = 'class' and . = 'drop-if-empty' )">
						<axsl:apply-imports />
					</axsl:if>
				</axsl:template>

				<axsl:template match="bgn:body-onload">
					<axsl:variable name="onload-list"><axsl:apply-imports /></axsl:variable>

					<axsl:if test="$onload-list != ''">
						<axsl:attribute name="onload">javascript: <axsl:value-of select="$onload-list" /></axsl:attribute>
					</axsl:if>
				</axsl:template>
			</axsl:stylesheet>
		</xsl:document>

	</xsl:template>

</xsl:stylesheet>
