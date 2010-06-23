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

	<xsl:template match="/map:mapping">

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
			<axsl:stylesheet version="1.0" xmlns:res="http://blogreen.org/TR/Resources" xmlns:hcal="http://microformats.org/profile/hcalendar">

			<!-- XXX import headers -->

			<!-- import templates -->
			<xsl:for-each select="map:map">
				<xsl:variable name="template" select="@template" />
				<xsl:if test="count(preceding-sibling::map:map[@template=$template]) = 0">
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

			<axsl:template match="/res:resources">
				<xsl:for-each select="map:map">
					<axsl:for-each select="{@resource}">
						<axsl:variable name="filename">
							<axsl:value-of select="$OBJDIR" />
							<axsl:call-template name="resource-construct-uri">
								<axsl:with-param name="path" select="concat('/', {@path}, '/index.html')" />
								<axsl:with-param name="path-transform">
									<xsl:value-of select="@path-transform" />
								</axsl:with-param>
							</axsl:call-template>
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
					</axsl:for-each>
				</xsl:for-each>
			</axsl:template>


		</axsl:stylesheet>
	</xsl:document>
	</xsl:template>

</xsl:stylesheet>
