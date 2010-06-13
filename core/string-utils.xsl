<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:variable name="new-line"><xsl:text>
</xsl:text></xsl:variable>

	<xsl:variable name="unbreakable-space">&#160;</xsl:variable>

	<xsl:variable name="uc" select="'AÁÂÀáâàBCÇçDEÉÊÈéêèFGHIÍÎÌíîìJKLMNÑǸñǹOÓÔÒóôòPQRSTUÚÛÙúûùVWXYZ'" />
	<xsl:variable name="lc"	select="'aáâàáâàbcççdeéêèéêèfghiíîìíîìjklmnñǹñǹoóôòóôòpqrstuúûùúûùvwxyz'" />

	<xsl:template name="lower-case">
		<xsl:param name="s" />
		<xsl:value-of select="translate($s, $uc, $lc)" />
	</xsl:template>

	<xsl:template name="upper-case">
		<xsl:param name="s" />
		<xsl:value-of select="translate($s, $lc, $uc)" />
	</xsl:template>

	<xsl:template name="escape">
		<xsl:param name="s" />
		<xsl:value-of select="translate($s,
			' —ÁÂÀáâàÇçÉÊÈéêèÍÎÌíîìÑǸñǹÓÔÒóôòÚÛÙúûù',
			'--AAAaaaCcEEEeeeIIIiiiNNnnOOOoooUUUuuu')" />
	</xsl:template>

</xsl:stylesheet>
