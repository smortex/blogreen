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
					<axsl:include href="{$BLOGREEN}/string-utils.xsl" />
					<axsl:param name="stylesheet" select="'${{OBJDIR}}/pages-stylesheet.xsl'" />
					<axsl:param name="templates-directory" select="{$templates-directory}" />
					<axsl:param name="makefile" select="concat($SRCDIR,'/Makefile.pages')" />
					<axsl:template match="/res:resources">
						<axsl:call-template name="progress">
							<axsl:with-param name="filename" select="$makefile" />
						</axsl:call-template>
						<axsl:document href="{{$makefile}}" method="text">
							<!--
							FIXME: Add dependencies on views.
							Generated pages don't have view they depend on in their
							dependency list.
							-->

							<xsl:for-each select="map:map">
								<axsl:for-each select="{@resource}">
									<axsl:variable name="filename">
										<axsl:call-template name="escape">
											<axsl:with-param name="s" select="concat({@path}, '/index.html')" />
										</axsl:call-template>
									</axsl:variable>
									<axsl:value-of select="concat('all: ${{PUBDIR}}/', $filename, $new-line)" />
									<axsl:value-of select="concat('${{OBJDIR}}/', $filename, ': ', $stylesheet, ' ${{OBJDIR}}/all-resources.xml', ' ${{OBJDIR}}/{$templates-directory}/{@template}.xsl', $new-line)" />
									<axsl:value-of select="concat('&#x09;@${{XSLTPROC}} ${{XSLTPROC_FLAGS}} ', $stylesheet, ' ${{OBJDIR}}/all-resources.xml', $new-line)" />
									<axsl:value-of select="concat('${{PUBDIR}}/', $filename, ': ', '${{OBJDIR}}/', $filename, $new-line)" />
									<axsl:value-of select="concat('&#x09;@${{XSLTPROC}} ${{XSLTPROC_FLAGS}} --stringparam filename ${{PUBDIR}}/', $filename, ' ${{BLOGREEN}}/finish-page-pipeline.xsl ${{OBJDIR}}/', $filename, $new-line)" />
								</axsl:for-each>
							</xsl:for-each>
						</axsl:document>
					</axsl:template>
				</axsl:stylesheet>
			</xsl:document>
		</xsl:template>

	</xsl:stylesheet>
