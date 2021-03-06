<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet generates the main stylesheet in charge of
	generating all pages.

	Input: mapping.xml

	Parameters:
	- filename[=<undefined>]
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
			<xsl:for-each select="//map:map|//map:alias">
				<xsl:variable name="template" select="@template" />
				<xsl:if test="count(preceding::map:map[@template=$template]) + count(ancestor::map:map[@template = $template]) + count(preceding::map:alias[@template=$template]) + count(ancestor::map:alias[@template = $template]) = 0">
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

				<axsl:template name="page-uri">
					<axsl:param name="page" />
					<axsl:value-of select="@uri" />
					<axsl:if test="$page">
						<axsl:value-of select="concat('index-', $page, '.html')" />
					</axsl:if>
				</axsl:template>
				<axsl:template name="previous-page-uri">
					<axsl:param name="page" />
					<axsl:call-template name="page-uri">
						<axsl:with-param name="page" select="$page - 1" />
					</axsl:call-template>
				</axsl:template>
				<axsl:template name="next-page-uri">
					<axsl:param name="page" />
					<axsl:call-template name="page-uri">
						<axsl:with-param name="page" select="$page + 1" />
					</axsl:call-template>
				</axsl:template>

				<axsl:template match="*|text()">
				</axsl:template>

		</axsl:stylesheet>
	</xsl:document>
	</xsl:template>

	<xsl:template match="map:map">
		<axsl:template name="{generate-id()}-paginate">
			<axsl:param name="start" select="1" />
			<axsl:param name="n-per-page" select="10" />
			<axsl:param name="count" select="0" />

			<axsl:variable name="filename">
				<axsl:value-of select="$OBJDIR" />
				<axsl:value-of select="@uri" />
				<!-- FIXME XSL 2.0
				<axsl:if test="ends-with(@uri, '/')">
				-->
				<axsl:if test="substring(@uri, string-length(@uri)) = '/'">
					<axsl:text>index</axsl:text>
					<axsl:if test="$start > 1">
						<axsl:value-of select="concat('-', ($start - 1) div $n-per-page)" />
					</axsl:if>
					<axsl:text>.html</axsl:text>
				</axsl:if>
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
					<xsl:if test="@paginate">
						<axsl:with-param name="position" select="$start" />
						<axsl:with-param name="count" select="$n-per-page" />
						<axsl:with-param name="page" select="($start - 1) div $n-per-page" />
					</xsl:if>
				</axsl:call-template>
			</axsl:document>

			<axsl:if test="$start + $n-per-page &lt; $count">
				<axsl:call-template name="{generate-id()}-paginate">
					<axsl:with-param name="start" select="$start + $n-per-page" />
					<axsl:with-param name="n-per-page" select="$n-per-page" />
					<axsl:with-param name="count" select="$count" />
				</axsl:call-template>
			</axsl:if>
		</axsl:template>
		<axsl:template match="{@resource}">
			<axsl:call-template name="{generate-id()}-paginate">
				<xsl:if test="@paginate">
					<axsl:with-param name="count" select="count({@paginate})" />
				</xsl:if>
			</axsl:call-template>
			<xsl:for-each select="map:alias">
				<axsl:variable name="alias-{position()}-filename">
					<!--
					<axsl:value-of select="ancestor::res:*[1]/@uri" />
					-->
					<axsl:value-of select="$OBJDIR" />
					<axsl:value-of select="{concat('@uri-', @context)}" />
				</axsl:variable>
				<axsl:call-template name="progress">
					<axsl:with-param name="filename">
						<axsl:value-of select="$alias-{position()}-filename" />
					</axsl:with-param>
				</axsl:call-template>
				<axsl:document href="{{$alias-{position()}-filename}}">
					<axsl:call-template name="{@template}">
						<xsl:if test="@context">
							<axsl:with-param name="context">
								<xsl:value-of select="@context" />
							</axsl:with-param>
						</xsl:if>
					</axsl:call-template>
				</axsl:document>
			</xsl:for-each>
			<xsl:for-each select="map:map">
				<axsl:apply-templates select="{@resource}" />
			</xsl:for-each>
		</axsl:template>
		<xsl:apply-templates />
	</xsl:template>
</xsl:stylesheet>
