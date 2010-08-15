<?xml version="1.0" encoding="utf-8"?>
<!--
	This stylesheet generate another stylesheet suitable for merging all
	resources (possibly splited into multiple XML resource files) into a single
	XML resource file.

  Parameters:
  - filename[="$OBJDIR/resource-aggregator.xsl"]
    Name of the stylesheet to generate
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"  xmlns:map="http://blogreen.org/TR/Mapping" version="1.0">
	<xsl:output method="text" />
	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

	<xsl:include href="build-utils.xsl" />

	<xsl:param name="filename" select="concat($OBJDIR, '/resource-aggregator.xsl')" />

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
  XXX: Auto-generated. DO NOT EDIT!

	This stylesheet aggregates all resources 

  Input:
	  resources.xml

	Parameters:
	- filename[="$OBJDIR/all-resources.xml"]
	  Filename of the aggregated XML resource file.
</xsl:comment>
			<axsl:stylesheet version="1.0" xmlns:res="http://blogreen.org/TR/Resources">
				<axsl:include href="{$BLOGREEN}/build-utils.xsl" />
				<axsl:include href="{$BLOGREEN}/resource-utils.xsl" />
				<axsl:include href="{$BLOGREEN}/string-utils.xsl" />

				<axsl:param name="filename" select="'{$OBJDIR}/all-resources.xml'" />

				<axsl:template match="/res:resources">
					<axsl:call-template name="check-required-parameter">
						<axsl:with-param name="name" select="'filename'" />
						<axsl:with-param name="value" select="$filename" />
					</axsl:call-template>

					<axsl:call-template name="progress">
						<axsl:with-param name="filename" select="$filename" />
					</axsl:call-template>

					<axsl:document href="{{$filename}}" method="xml" indent="yes">
						<axsl:copy select=".">
							<axsl:attribute name="uri">/</axsl:attribute>
							<axsl:apply-templates />
						</axsl:copy>
					</axsl:document>
				</axsl:template>

				<axsl:template match="res:import">
					<axsl:apply-templates select="document(@href)" />
				</axsl:template>

				<xsl:for-each select="map:map">
					<axsl:template match="{@resource}">
						<axsl:copy>
							<axsl:attribute name="uri">
								<axsl:call-template name="resource-construct-uri">
									<axsl:with-param name="path" select="concat('/', {@path})" />
									<axsl:with-param name="path-transform">
										<xsl:value-of select="@path-transform" />
									</axsl:with-param>
								</axsl:call-template>
							</axsl:attribute>
							<!--
							Store the item position: the mappings/map items order
							may be used by some plugins (e.g. main-navigation).
							-->
							<axsl:attribute name="order">
								<xsl:value-of select="position()" />
							</axsl:attribute>
							<axsl:apply-templates select="node()|@*" />
						</axsl:copy>
					</axsl:template>

				</xsl:for-each>

				<!-- If no map is available, copy verbatim -->
				<axsl:template match="node()|@*">
					<axsl:copy>
						<axsl:apply-templates select="node()|@*" />
					</axsl:copy>
				</axsl:template>

			</axsl:stylesheet>
		</xsl:document>
	</xsl:template>
</xsl:stylesheet>
