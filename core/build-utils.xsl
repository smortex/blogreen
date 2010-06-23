<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template name="check-required-parameter">
		<xsl:param name="name" />
		<xsl:param name="value" />

		<xsl:if test="$value = ''">
			<xsl:call-template name="error">
				<xsl:with-param name="message">
					<xsl:text>The '</xsl:text>
					<xsl:value-of select="$name" />
					<xsl:text>' parameter cannot be empty.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

  <xsl:template name="progress">
		<xsl:param name="filename" />
		<xsl:if test="not(starts-with($SRCDIR, filename))">
			<xsl:message terminate="no">
				<xsl:value-of select="concat('WARNING: ', $filename, ' does
					not starts with ', $SRCDIR)" />
			</xsl:message>
		</xsl:if>
		<xsl:message terminate="no">
			<xsl:value-of select="concat('  GEN    ', substring-after($filename, $SRCDIR))" />
		</xsl:message>
	</xsl:template>

	<xsl:template name="warning">
		<xsl:param name="message" />
		<xsl:message terminate="no">
			<xsl:value-of select="concat('WARNING: ', $message)" />
		</xsl:message>
	</xsl:template>

	<xsl:template name="error">
		<xsl:param name="message" />
		<xsl:message terminate="yes">
			<xsl:value-of select="concat('FATAL ERROR: ', $message)" />
		</xsl:message>
	</xsl:template>

</xsl:stylesheet>
