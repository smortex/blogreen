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
</xsl:stylesheet>
