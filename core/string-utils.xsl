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

	<xsl:template name="string-replace">
		<xsl:param name="s" />
		<xsl:param name="needle" />
		<xsl:param name="replacement" />

		<xsl:choose>
			<xsl:when test="contains ($s, $needle)">
				<xsl:value-of select="substring-before ($s, $needle)" />
				<xsl:value-of select="$replacement" />
				<xsl:call-template name="string-replace">
					<xsl:with-param name="s" select="substring-after ($s, $needle)" />
					<xsl:with-param name="needle" select="$needle" />
					<xsl:with-param name="replacement" select="$replacement" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$s" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="to-ascii">
		<xsl:param name="s" />
		<xsl:call-template name="string-replace">
			<xsl:with-param name="needle" select="'å'" />
			<xsl:with-param name="replacement" select="'aa'" />
			<xsl:with-param name="s">
				<xsl:call-template name="string-replace">
					<xsl:with-param name="needle" select="'Å'" />
					<xsl:with-param name="replacement" select="'AA'" />
					<xsl:with-param name="s">
						<xsl:call-template name="string-replace">
							<xsl:with-param name="needle" select="'ø'" />
							<xsl:with-param name="replacement" select="'oe'" />
							<xsl:with-param name="s">
								<xsl:call-template name="string-replace">
									<xsl:with-param name="needle" select="'Ø'" />
									<xsl:with-param name="replacement" select="'OE'" />
									<xsl:with-param name="s">
										<xsl:call-template name="string-replace">
											<xsl:with-param name="needle" select="'æ'" />
											<xsl:with-param name="replacement" select="'ae'" />
											<xsl:with-param name="s">
												<xsl:call-template name="string-replace">
													<xsl:with-param name="needle" select="'Æ'" />
													<xsl:with-param name="replacement" select="'AE'" />
													<xsl:with-param name="s">
														<xsl:call-template name="string-replace">
															<xsl:with-param name="needle" select="'œ'" />
															<xsl:with-param name="replacement" select="'oe'" />
															<xsl:with-param name="s">
																<xsl:call-template name="string-replace">
																	<xsl:with-param name="needle" select="'Œ'" />
																	<xsl:with-param name="replacement" select="'OE'" />
																	<xsl:with-param name="s">
																		<xsl:call-template name="string-replace">
																			<xsl:with-param name="needle" select="'ß'" />
																			<xsl:with-param name="replacement" select="'SS'" />
																			<xsl:with-param name="s">
																				<xsl:value-of select="translate($s,
																					'—ÁÂÄÀáâäàÇçÉÊËÈéêëèÍÎÌíîìÑǸñǹÓÔÖÒóôöòÚÛÜŮÙúûüůù',
																					'-AAAAaaaaCcEEEEeeeeIIIiiiNNnnOOOOooooUUUUUuuuuu')" />
																			</xsl:with-param>
																		</xsl:call-template>
																	</xsl:with-param>
																</xsl:call-template>
															</xsl:with-param>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="escape">
		<xsl:param name="s" />
		<xsl:call-template name="to-ascii">
			<xsl:with-param name="s">
				<xsl:value-of select="translate($s, ' ', '-')" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
