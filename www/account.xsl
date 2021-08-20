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
			<xsl:call-template name='header-head'/>
			<link rel='stylesheet' href='/account.css' />
			<script>
				window.addEventListener('load', function() {
					const avatarInput = document.getElementById('avatar_upload')
					const fileNameDisplay = document.getElementById('avatar_upload_filename')
					const avatarPreview = document.getElementById('avatar_preview')
					avatarInput.addEventListener('change', function(e) {
						console.log(e)
						const file = e.target.files[0]
						console.log(file)
						fileNameDisplay.innerText = file.name
						const reader = new FileReader()
						reader.onload = function() {
							avatarPreview.querySelector('img').src = reader.result
							avatarPreview.style.display = 'unset'
						}
						reader.readAsDataURL(file)
					})
				})
			</script>
		</head>
		<body>
			<xsl:call-template name='header'/>
			<div class='container-content'>
				<div class='account-function'>
					<div class='title'>
						<span>Account Information</span>
					</div>
					<form method='POST' action='account'>
						<label>
							New password
							<input type='password' name='password'/>
						</label>
						<button type='submit'>Change</button>
					</form>
					<p>Current avatar</p>
					<img>
						<xsl:attribute name='src'>/avatar/<xsl:value-of select='session/name'/></xsl:attribute>
					</img>
					<form method='POST' enctype="multipart/form-data">
						<xsl:attribute name='action'>/avatar/<xsl:value-of select='session/name'/></xsl:attribute>
						<label for='avatar_upload'>
							Change
						</label>
						<div style='display: none' id='avatar_preview' >
							<p><small>Preview</small></p>
							<img/>
							<p id='avatar_upload_filename'></p>
						</div>
						<input type='file' name='avatar' id="avatar_upload"/>
						<p id='avatar-note'><i><small>Avatar image should be square, and will be scaled down to 64px x 64px</small></i></p>
						<input type="submit" />
					</form>
				</div>
			</div>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>
