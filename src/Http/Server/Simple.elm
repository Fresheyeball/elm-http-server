module Http.Server.Simple where

import Http.Server as Raw
import Html
import Json.Encode as Json
import Effects exposing (Never)
import Task exposing (Task, andThen)
import VDOMtoHTML exposing (toHTML)
import Signal exposing (..)

type alias Head = List Raw.Header

type Response
  = Html Html.Html
  | Json Json.Value
  | Text String
  | EmptyRes

type alias Request =
  { url        : Raw.Url
  , method     : Raw.Method
  , statusCode : Raw.Code }

marshallRequest : Raw.Request -> Request
marshallRequest req =
  Request
    (Raw.url req)
    (Raw.method req)
    (Raw.statusCode req)

runResponse : Raw.Response -> Response -> Task Never ()
runResponse rawres res = case res of
  Html vdom -> Raw.writeHtml rawres (toHTML vdom)
  Json json -> Raw.writeJson rawres json
  Text text -> Raw.writeText rawres text

type alias Server model = Signal Request -> Signal (Task Never (model, Response))
type alias Port = Raw.Port

run : Port -> Server model -> Signal (Task Never ())
run p s = let

  server : Mailbox (Raw.Request, Raw.Response)
  server = mailbox (Raw.emptyReq, Raw.emptyRes)

  reply : Signal (Task Never ())
  reply =
    (\task rawres ->
      Task.map snd task `andThen` runResponse rawres)
    <~ s (marshallRequest <~ (fst <~ server.signal))
     ~ (snd <~ server.signal)

  create : Signal (Task Never ())
  create = constant <|
    Raw.createServer'
      server.address p ("Listening on " ++ toString p)
    `andThen` always (Task.succeed ())

  in merge create reply
