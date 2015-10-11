module Http.Server.Simple where

import Http.Server as S
import Html
import Json.Encode as Json
import Effects exposing (Effects)
import VDOMtoHTML exposing (toHTML)

type alias Head = List S.Header
type Body
  = Html Html.Html
  | Json Json.Value
  | Text

type alias Request a =
  { url        : S.Url
  , method     : S.Method
  , statusCode : S.Code
  , model      : a }

type alias Response a =
  { head  : Head
  , body  : Body
  , model : a }

type alias Config model action =
  { initial : (Request model, Effects action)
  , update : (Request, model -> (Response model, Effects action) }

html : Html.Html -> Response a
html = Response [ S.textHtml ] << Html




















the server has a shared state
each request has a state
response is returned


act     : Request r -> model -> (Request r, model, Effects r)
respond : Request r -> model -> (Response, model)
