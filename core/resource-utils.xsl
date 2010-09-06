<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:template name="resource-construct-uri">
		<xsl:param name="path" />
		<xsl:param name="path-transform" />

		<xsl:choose>
			<xsl:when test="$path-transform = 'lower-case'">
				<xsl:call-template name="lower-case">
					<xsl:with-param name="s">
						<xsl:call-template name="escape">
							<xsl:with-param name="s">
								<xsl:value-of select="$path" />
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="escape">
					<xsl:with-param name="s">
						<xsl:value-of select="$path" />
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="resource-ref">
		<xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="href">
				<xsl:value-of select="@uri" />
			</xsl:attribute>
			<xsl:apply-templates select="." mode="title" />
		</xsl:element>
	</xsl:template>

	<xsl:template name="resource-ref-by-id">
		<xsl:param name="resource-id" />
		<xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="href">
				<xsl:value-of select="//*[@id=$resource-id]/@uri" />
			</xsl:attribute>
			<xsl:apply-templates select="//*[@id=$resource-id]" mode="title" />
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
