<?xml version="1.0" encoding="utf-8"?>
<!--
  This stylesheet generates a partial Makefile for converting partial
  templates (e.g. $SRCDIR/templates/page.xml) into self-contained
  templates (e.g. $OBJDIR/templates/page.xsl).

	Input: mapping.xml

  Parameters:
  - templates-directory[='templates']
    Name of the subdirectory in $SRCDIR and $OBJDIR where templates
    are stored.
  - makefile[=concat($SRCDIR, '/Makefile.templates')]
    Name of the partial Makefile to build.
  - aggregate-stylesheet[='${BLOGREEN}/aggregate-templates.xsl']
    Name of the stylesheet that will actually generates the templates
    in the $OBJDIR directory.
  - expand-stylesheet[='${BLOGREEN}/expand-template.xsl']
    Name of the stylesheet that will generate an XSL transformation
	stylesheet using the aggregated template in the $OBJDIR directory.
  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:map="http://blogreen.org/TR/Mapping" version="1.0">
	<xsl:output method="text" />

	<xsl:include href="build-utils.xsl" />
	<xsl:include href="string-utils.xsl" />

	<xsl:param name="templates-directory" select="'templates'" />
	<xsl:param name="makefile" select="concat($SRCDIR, '/Makefile.templates')" />
	<xsl:param name="aggregate-stylesheet" select="'${BLOGREEN}/aggregate-templates.xsl'" />
	<xsl:param name="expand-stylesheet" select="'${BLOGREEN}/expand-template.xsl'" />

	<xsl:template match="/">

		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'makefile'" />
			<xsl:with-param name="value" select="$makefile" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$makefile" />
		</xsl:call-template>

		<xsl:document href="{$makefile}" method="text">
			<xsl:value-of select="concat('# Templates rules', $new-line)" />
			<xsl:apply-templates />
			<xsl:value-of select="concat('# End of templates rules', $new-line)" />
		</xsl:document>
	</xsl:template>

	<xsl:template match="map:map">
				<xsl:variable name="template" select="@template" />

				<xsl:if test="count(preceding::map:map[@template = $template]) + count(ancestor::map:map[@template = $template]) = 0">
					<xsl:variable name="source" select="concat('${SRCDIR}/', $templates-directory, '/', @template, '.xml')" />
					<xsl:variable name="target-no-ext" select="concat('${OBJDIR}/', $templates-directory, '/', @template)" />
					<xsl:variable name="target-xml" select="concat($target-no-ext, '.xml')" />
					<xsl:variable name="target-xsl" select="concat($target-no-ext, '.xsl')" />

					<xsl:value-of select="concat('# ', $template, $new-line)" />

					<xsl:value-of select="concat('all: ', $target-xsl, $new-line)" />
					<xsl:value-of select="concat($target-xml, ': ', $source, ' ', $aggregate-stylesheet, ' ', $makefile, $new-line)" />
					<xsl:value-of select="concat('&#x09;@${XSLTPROC} ${XSLTPROC_FLAGS} --stringparam filename ', $target-xml, ' ', $aggregate-stylesheet, ' ', $source, $new-line)" />

					<xsl:value-of select="concat($target-xsl, ': ', $target-xml, ' ', $expand-stylesheet, ' ', $makefile, $new-line)" />
					<xsl:value-of select="concat('&#x09;@${XSLTPROC} ${XSLTPROC_FLAGS} --stringparam filename ', $target-xsl, ' ', $expand-stylesheet, ' ', $target-xml, $new-line, $new-line)" />
				</xsl:if>

		<!-- Process child maps -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*|text()" />

</xsl:stylesheet>
