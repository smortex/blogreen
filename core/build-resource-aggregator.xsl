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
  XXX: Auto-generated. DO NOT EDIT!

	This stylesheet aggregates all resources 

  Input:
	  resources.xml

	Parameters:
	- filename[="$OBJDIR/aggregated-resources.xml"]
	  Filename of the aggregated XML resource file.
</xsl:comment>
			<axsl:stylesheet version="1.0" xmlns:res="http://blogreen.org/TR/Resources">
				<axsl:output method="text" />
				<axsl:include href="{$BLOGREEN}/build-utils.xsl" />
				<axsl:include href="{$BLOGREEN}/resource-utils.xsl" />
				<axsl:include href="{$BLOGREEN}/string-utils.xsl" />

				<axsl:param name="filename" select="'{$OBJDIR}/aggregated-resources.xml'" />

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
							<axsl:apply-templates select="@*|*" />
						</axsl:copy>
					</axsl:document>
				</axsl:template>

				<axsl:template match="res:import">
					<axsl:call-template name="file-exists">
						<axsl:with-param name="href">
							<xsl:value-of select="@href" />
						</axsl:with-param>
					</axsl:call-template>
					<axsl:apply-templates select="document(@href)" />
				</axsl:template>

				<xsl:apply-templates />

				<!-- If no map is available, copy verbatim -->
				<axsl:template match="node()|@*">
					<axsl:copy>
						<axsl:apply-templates select="node()|@*" />
					</axsl:copy>
				</axsl:template>

			</axsl:stylesheet>
		</xsl:document>
	</xsl:template>


	<xsl:template match="map:map">
		<xsl:variable name="resource-uri">
			<xsl:choose>
				<xsl:when test="@path">
					<xsl:value-of select="@path" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>'/'</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<axsl:template match="{@resource}">
			<axsl:copy>
				<axsl:attribute name="uri">
					<axsl:call-template name="resource-construct-uri">
						<axsl:with-param name="path" select="{$resource-uri}" />
						<axsl:with-param name="path-transform">
							<xsl:value-of select="@path-transform" />
						</axsl:with-param>
					</axsl:call-template>

				</axsl:attribute>
				<axsl:attribute name="order">
					<axsl:value-of select="position()" />
				</axsl:attribute>
				<axsl:attribute name="mapping-order">
					<xsl:value-of select="position()" />
				</axsl:attribute>

				<xsl:for-each select="map:alias">
					<axsl:attribute name="{concat('uri-', @context)}">
					<axsl:call-template name="resource-construct-uri">
						<axsl:with-param name="path" select="{@path}" />
						<axsl:with-param name="path-transform">
							<xsl:value-of select="@path-transform" />
						</axsl:with-param>
					</axsl:call-template>
					</axsl:attribute>
				</xsl:for-each>

				<axsl:for-each select="@*">
					<axsl:apply-templates select="." />
				</axsl:for-each>

				<axsl:for-each select="node()|text()">
					<axsl:choose>
						<axsl:when test="self::res:*">
							<!--
							Proccess mapped node children.  If they are also mapped,
							proccess them, otherwise just copy the nodes.  The fact
							that a res:foo items can be mapped when it is a children
							of a res:bar element and not when it is the children of
							a res:baz elements makes the following a bit tricky.
							-->
							<xsl:choose>
								<xsl:when test="map:map">
									<axsl:choose>
										<xsl:for-each select="map:map">
											<axsl:when test="self::{@resource}">
												<axsl:apply-templates select="." />
											</axsl:when>
										</xsl:for-each>
										<axsl:otherwise>
											<axsl:copy-of select="." />
										</axsl:otherwise>
									</axsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<axsl:copy-of select="." />
								</xsl:otherwise>
							</xsl:choose>
						</axsl:when>
						<axsl:otherwise>
							<axsl:copy-of select="." />
						</axsl:otherwise>
					</axsl:choose>
					<axsl:apply-templates select="{@resource}" />
				</axsl:for-each>
			</axsl:copy>
		</axsl:template>

		<xsl:apply-templates />
	</xsl:template>
</xsl:stylesheet>
