<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns='http://www.w3.org/1999/xhtml'
>
<xsl:import href='/menubar.xsl'/>
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>
<xsl:template match='/account'>
	<html>
		<head>
			<title>Account</title>
		</head>
		<body>
			<xsl:call-template name='menubar'/>
			<form method='POST' action='account'>
				<label>
					New password
					<input type='password' name='password'/>
				</label>
				<button type='submit'>Change</button>
			</form>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>
