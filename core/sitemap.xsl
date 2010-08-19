<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:sm="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:res="http://blogreen.org/TR/Resources" xmlns:c="http://blogreen.org/TR/Config" version="1.0">
	<xsl:output method="text" />

	<xsl:include href="build-utils.xsl" />

	<xsl:param name="filename" select="concat($PUBDIR, '/sitemap.xml')" />

	<xsl:param name="root-uri">
		<xsl:value-of select="document(concat($SRCDIR, '/config.xml'))/c:config/c:RootUri" />
	</xsl:param>

	<xsl:template match="/res:resources">
		<xsl:call-template name="check-required-parameter">
			<xsl:with-param name="name" select="'filename'" />
			<xsl:with-param name="value" select="$filename" />
		</xsl:call-template>

		<xsl:call-template name="progress">
			<xsl:with-param name="filename" select="$filename" />
		</xsl:call-template>

		<xsl:document href="{$filename}" indent="yes">
			<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
				<xsl:for-each select="//res:*[@uri]">
					<url>
						<loc>
							<xsl:value-of select="concat($root-uri, @uri)" />
						</loc>
						<changefreq>monthly</changefreq>
						<priority>
							<xsl:choose>
								<xsl:when test="@sm:priority">
									<xsl:value-of select="@sm:priority" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0.5</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</priority>
					</url>
				</xsl:for-each>
			</urlset>
		</xsl:document>
	</xsl:template>

</xsl:stylesheet>
