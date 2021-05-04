module Station.HTTP (
	log, respond_500, respond_400, respond_401, respond_403, respond_404, respond_405, respond_409, respond_422,
	respond_redirect, respond_301, respond_303_headers, respond_303, respond_XML,
	cookies, set_cookie_header
) where

import Prelude ()
import Data.Bool (Bool (True, False))
import Data.Maybe (Maybe (Nothing, Just), maybe)
import Data.Tuple (fst)
import Data.Monoid ((<>))
import Data.List ((++), lookup)
import Data.String (String, fromString)
import Data.Function ((.))
import Control.Monad ((=<<))
import Text.Show (show)
import Data.Time (getZonedTime, formatTime, defaultTimeLocale)
import System.IO (putChar, putStr)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BS.C8
import qualified Data.ByteString.UTF8 as BS.U8
import qualified Data.ByteString.Lazy as BS.L
import qualified Data.ByteString.Lazy.UTF8 as BS.L.U8
import qualified Data.Binary.Builder as BS.Builder
import qualified Network.HTTP.Types as HTTP
import qualified Network.HTTP.Types.Header
import qualified Network.Wai as Wai
import qualified Network.Wai.Middleware.HttpAuth as HttpAuth
import qualified Web.Cookie as Cookie

log :: Bool -> Wai.Middleware
log False next request respond = next request respond
log True  next request respond =
	do
		putStr . formatTime defaultTimeLocale "%FT%T%z" =<< getZonedTime
		putStr " HTTP "
		putStr (show (Wai.remoteHost request))
		putChar ' '
		BS.C8.putStr (Wai.requestMethod request)
		putChar ' '
		putStr
			(maybe
				"()"
				(show . BS.U8.toString . fst)
				(HttpAuth.extractBasicAuth =<< lookup HTTP.hAuthorization (Wai.requestHeaders request)))
		putChar ' '
		BS.C8.putStrLn (Wai.rawPathInfo request)
		next request respond

respond_500 :: String -> Wai.Application
respond_500 message _ respond =
	respond (Wai.responseLBS HTTP.status500 [("Content-Type", "text/plain; charset=ASCII")] (BS.L.U8.fromString message))

respond_400 :: String -> Wai.Application
respond_400 message _ respond =
	respond (Wai.responseLBS HTTP.status400 [("Content-Type", "text/plain; charset=ASCII")] (BS.L.U8.fromString message))

respond_401 :: String -> Wai.Application
respond_401 realm _ respond =
	respond
		(Wai.responseLBS
			HTTP.status401
			[
				("Content-Type", "text/plain; charset=ASCII"),
				("WWW-Authenticate", fromString ("Basic realm=\"" ++ realm ++ "\", charset=\"UTF-8\""))]
			"UNAUTHORIZED")

respond_403 :: Wai.Application
respond_403 _ respond =
	respond (Wai.responseLBS HTTP.status403 [("Content-Type", "text/plain; charset=ASCII")] "FORBIDDEN")

respond_404 :: Wai.Application
respond_404 _ respond =
	respond (Wai.responseLBS HTTP.status404 [("Content-Type", "text/plain; charset=ASCII")] "NOT FOUND")

respond_405 :: Wai.Application
respond_405 _ respond =
	respond (Wai.responseLBS HTTP.status405 [("Content-Type", "text/plain; charset=ASCII")] "METHOD NOT ALLOWED")

respond_409 :: String -> Wai.Application
respond_409 message _ respond =
	respond (Wai.responseLBS HTTP.status409 [("Content-Type", "text/plain; charset=ASCII")] (BS.L.U8.fromString message))

respond_422 :: String -> Wai.Application
respond_422 message _ respond =
	respond (Wai.responseLBS HTTP.status422 [("Content-Type", "text/plain; charset=ASCII")] (BS.L.U8.fromString message))

respond_redirect :: HTTP.Status -> BS.L.ByteString -> HTTP.ResponseHeaders -> BS.ByteString -> Wai.Application
respond_redirect status text headers location _ respond =
	let
		location' = BS.L.fromStrict location
		content =
			"<html xmlns='http://www.w3.org/1999/xhtml'><head><meta http-equiv='refresh' content='0; url="
				<> location'
				<> "' /></head><body><script type='javascript'>location.href='"
				<> location'
				<> "'</script><a href='"
				<> location'
				<> "'>"
				<> text
				<> "</body></html>"
		in
		respond
			(Wai.responseLBS
				status
				(("Content-Type", "application/xhtml+xml") : ("Location", location) : headers)
				content)

respond_301 :: BS.ByteString -> Wai.Application
respond_301 = respond_redirect HTTP.status301 "MOVED PERMANENTLY" []

respond_303_headers :: HTTP.ResponseHeaders -> BS.ByteString -> Wai.Application
respond_303_headers = respond_redirect HTTP.status303 "SEE OTHER"

respond_303 :: BS.ByteString -> Wai.Application
respond_303 = respond_303_headers []

respond_XML :: String -> Wai.Application
respond_XML body _ respond =
	respond
		(Wai.responseLBS
			HTTP.status200
			[("Content-Type", "text/xml; charset=UTF-8")]
			(BS.L.U8.fromString body))

cookies :: Wai.Request -> Cookie.Cookies
cookies request =
	case lookup HTTP.hCookie (Wai.requestHeaders request) of
		Nothing -> []
		Just bytestring -> Cookie.parseCookies bytestring

set_cookie_header :: Cookie.SetCookie -> Network.HTTP.Types.Header.Header
set_cookie_header set_cookie =
	(
		Network.HTTP.Types.Header.hSetCookie,
		(BS.L.toStrict (BS.Builder.toLazyByteString (Cookie.renderSetCookie set_cookie))))
