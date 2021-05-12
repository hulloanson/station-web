<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet
	version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns='http://www.w3.org/1999/xhtml'
>
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>
<xsl:template name='menubar'>
	<div>
		<strong><xsl:value-of select='session/name'/></strong>:
		<em><xsl:value-of select='session/mark'/> point<xsl:if test='session/mark!=1'>s</xsl:if></em>
		| <a href='/learn'>Home</a>
		| <a href='/logout'>Log out</a>
	</div>
	<hr/>
</xsl:template>
<xsl:template name='header-head'>
	<link rel='stylesheet' type='text/css' href='/global.css'/>
	<link rel='stylesheet' type='text/css' href='/font-family.css'/>
	<link rel='stylesheet' type='text/css' href='/header.css'/>
	<link rel='stylesheet' type='text/css' href='/slide-show.css'/>
	<script type='application/ecmascript' src='/menu.js'></script>
</xsl:template>
<xsl:template name='header'>
	<header>
		<div class='header'>
			<div class='container-basic-info'>
				<div class='logo align-bot'>
					<div class='sponsor'>
						<a href='https://www.collaction.hk/s/station/'>
							<img src='/station_logo_black.png'/>
						</a>
					</div>
					<div class='sponsor'>
						<a href='https://www.eatonworkshop.com/hotel/hong-kong'>
							<img class='vice-sponsor' src='/eaton_logo_black.png'/>
						</a>
					</div>
				</div>
				<div class='user align-bot'>
					<xsl:if test='not(session)'>
						<form method='POST' action='/login'>
							<div class='account-login'>
								<div class='account-attribute attribute'>
									<div class='attribute-name'>
										<span>Name</span>
									</div>
									<div class='attribute-value'>
										<input type='text' class='value' name='username'/>
									</div>
								</div>
								<div class='account-attribute attribute final-attribute'>
									<div class='attribute-name'>
										<span>Password</span>
									</div>
									<div class='attribute-value'>
										<input type='password' class='value final-value' name='password'/>
									</div>
								</div>
								<div class='attribute'>
									<div class='attribute-name'></div>
									<div class='btn-submit'>
										<input type='submit' class='btn-login' value='Login'/>
									</div>
								</div>
							</div>
						</form>
					</xsl:if>
					<xsl:if test='session'>
						<div class='user-info'>
							<div class='welcome-msg basic-info-font'>
								<span>Welcome Back!</span>
							</div>
							<div class='user-data'>
								<div class='user-name align-bot basic-info-font'>
									<span class='first-name'><xsl:value-of select='session/name'/></span>
								</div>
								<div class='user-score align-bot basic-info-font'>
									<span>Point: <xsl:value-of select='session/mark'/></span>
								</div>
							</div>
						</div>
					</xsl:if>
				</div>
			</div>
			<div class='container-menu'>
				<div class='menu-icon' onclick='toggNavBar(this)'>
					<div></div>
					<div></div>
					<div></div>
				</div>
			</div>
		</div>
		<div class='menu-content'>
			<ul>
				<li><a href='/learn'>Tree of Knowledge</a></li>
				<li><a href='https://www.collaction.hk/s/station/'>Station</a></li>
				<li><a href='https://www.eatonworkshop.com/hotel/hong-kong'>EatonHK</a></li>
				<li><a href='https://g0vhk.io/'>g0vhk</a></li>
				<li><a href='/account'>My Account</a></li>
				<xsl:if test='session/role="SysOp"'>
					<li><a href='/sysop/account'>Account Management</a></li>
					<li><a href='/sysop/subjects'>Lesson Management</a></li>
				</xsl:if>
				<li><a href='/logout'>Log Out</a></li>
			</ul>
		</div>
	</header>
</xsl:template>
<xsl:template name='slide-head'>
	<script type='application/ecmascript' src='/slider.js'></script>
</xsl:template>
<xsl:template name='slide'>
	<div class='container-slide-show' onmouseover='stopAutoSlide()' onmouseout='contineSlide()'>
		<div class='slide'>
			<a href=''><img src='/slide/1.jpg'/></a>
		</div>
		<div class='slide'>
			<a href=''><img src='/slide/2.jpg'/></a>
		</div>
		<div class='slide'>
			<a href=''><img src='/slide/1.jpg'/></a>
		</div>
		<div class='slide'>
			<a href=''><img src='/slide/2.jpg'/></a>
		</div>
		<div class='slide'>
			<a href=''><img src='/slide/1.jpg'/></a>
		</div>
		<div class='container-btn-slide'>
			<span class='btn-slide' onclick='setShowImgIndex(0)'></span>
			<span class='btn-slide' onclick='setShowImgIndex(1)'></span>
			<span class='btn-slide' onclick='setShowImgIndex(2)'></span>
			<span class='btn-slide' onclick='setShowImgIndex(3)'></span>
			<span class='btn-slide' onclick='setShowImgIndex(4)'></span>
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>
