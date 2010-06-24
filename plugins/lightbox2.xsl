<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bgn="http://blogreen.org" version="1.0">

	<xsl:template match="bgn:page-css">
		<xsl:apply-imports />
		<xsl:if test="//*[@rel and starts-with(@rel, 'lightbox')]">
			<link rel="stylesheet" href="/css/lightbox.css" type="text/css" media="screen" />
		</xsl:if>
	</xsl:template>
	<xsl:template match="bgn:page-javascript">
		<xsl:apply-imports />
		<xsl:if test="//*[@rel and starts-with(@rel, 'lightbox')]">
			<script type="text/javascript" src="/js/prototype.js"><xsl:comment /></script>
			<script type="text/javascript" src="/js/scriptaculous.js?load=effects,builder"><xsl:comment /></script>
			<script type="text/javascript" src="/js/lightbox.js"><xsl:comment /></script>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
