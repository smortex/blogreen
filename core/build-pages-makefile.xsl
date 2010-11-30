<?xml version="1.0" encoding="utf-8"?>
<!--
	This stylesheet generates another stylesheet that generates a
	Makefile for rendering pages

	Input: mapping.xml

  Parameters:
	- template-directory[='templates']
    Name of the subdirectory in $SRCDIR and $OBJDIR where templates
    are stored.
	- filename[="$OBJDIR/pages-makefile.xsl"]
	  Name of the stylesheet to generate.
  -->
	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" xmlns:map="http://blogreen.org/TR/Mapping" version="1.0">
		<xsl:output method="text" />
		<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

		<xsl:include href="build-utils.xsl" />

		<xsl:param name="templates-directory" select="'templates'" />
		<xsl:param name="filename" select="concat($OBJDIR, '/pages-makefile.xsl')" />

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

	This stylesheet generates a Makefile to build pages. 

  Input:
	  resources.xml

	Parameters:
	- stylesheet[="$OBJDIR/pages-stylesheet.xsl"]
	  Filename of the stylesheet used to generate pages.
	- templates-directory[='templates']
    Name of the subdirectory in $SRCDIR and $OBJDIR where templates
    are stored.
	- makefile[="$SRCDIR/Makefile.pages"]
		Name of the makefile to generate.
</xsl:comment>
				<axsl:stylesheet version="1.0" xmlns:res="http://blogreen.org/TR/Resources">
					<axsl:include href="{$BLOGREEN}/build-utils.xsl" />
					<axsl:include href="{$BLOGREEN}/resource-utils.xsl" />
					<axsl:include href="{$BLOGREEN}/string-utils.xsl" />
					<axsl:param name="stylesheet" select="'${{OBJDIR}}/pages-stylesheet.xsl'" />
					<axsl:param name="templates-directory" select="{$templates-directory}" />
					<axsl:param name="makefile" select="concat($SRCDIR,'/Makefile.pages')" />
					<axsl:template match="/">
						<axsl:call-template name="progress">
							<axsl:with-param name="filename" select="$makefile" />
						</axsl:call-template>
						<axsl:document href="{{$makefile}}" method="text">
							<!--
							FIXME: Add dependencies on views.
							Generated pages don't have view they depend on in their
							dependency list.
							-->

							<axsl:apply-templates />
						</axsl:document>
					</axsl:template>
					<xsl:apply-templates />
					<axsl:template match="*|text()" />
				</axsl:stylesheet>
			</xsl:document>
		</xsl:template>

		<xsl:template match="map:map">
			<axsl:template match="{@resource}">
				<axsl:variable name="filename">
					<axsl:value-of select="@uri" />
					<!-- FIXME XSL 2.0
					<axsl:if test="ends-with(@uri, '/')">
					-->
					<axsl:if test="substring(@uri, string-length(@uri)) = '/'">
						<axsl:text>index.html</axsl:text>
					</axsl:if>
				</axsl:variable>


									<axsl:value-of select="concat('all: ${{PUBDIR}}', $filename, $new-line)" />
									<axsl:value-of select="concat('${{OBJDIR}}', $filename, ': ', $stylesheet, ' ${{OBJDIR}}/all-resources.xml', ' ${{OBJDIR}}/{$templates-directory}/{@template}.xsl', $new-line)" />
									<axsl:value-of select="concat('&#x09;@${{XSLTPROC}} ${{XSLTPROC_FLAGS}} ', $stylesheet, ' ${{OBJDIR}}/all-resources.xml', $new-line)" />
									<axsl:value-of select="concat('${{PUBDIR}}', $filename, ': ', '${{OBJDIR}}', $filename, $new-line)" />
									<axsl:value-of select="concat('&#x09;@${{XSLTPROC}} ${{XSLTPROC_FLAGS}} --stringparam filename ${{PUBDIR}}', $filename, ' --stringparam uri ', $filename ,' ${{OBJDIR}}/finish-page-pipeline.xsl ${{OBJDIR}}/', $filename, $new-line)" />
				<xsl:for-each select="map:alias">
					<axsl:variable name="alias-{position()}-filename">
						<!-- FIXME XSL 2.0
						<axsl:if test="ends-with(@uri, '/')">
						-->
						<xsl:text>/</xsl:text>
						<axsl:value-of select="{@path}" />
					</axsl:variable>

					<axsl:value-of select="concat('all: ${{PUBDIR}}', $alias-{position()}-filename, $new-line)" />
					<axsl:value-of select="concat('${{PUBDIR}}', $alias-{position()}-filename, ': ', '${{OBJDIR}}', $alias-{position()}-filename, $new-line)" />
					<axsl:value-of select="concat('&#x09;@${{XSLTPROC}} ${{XSLTPROC_FLAGS}} --stringparam filename ${{PUBDIR}}', $alias-{position()}-filename, ' --stringparam uri ', $alias-{position()}-filename, ' ${{OBJDIR}}/finish-page-pipeline.xsl ${{OBJDIR}}/', $alias-{position()}-filename, $new-line)" />

				</xsl:for-each>
				<xsl:for-each select="map:map">
					<axsl:apply-templates select="{@resource}" />
				</xsl:for-each>
			</axsl:template>

			<xsl:apply-templates />
		</xsl:template>
	</xsl:stylesheet>
