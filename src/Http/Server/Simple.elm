module Http.Server.Simple where

import Http.Server as Raw
import Html
import Json.Encode as Json
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

runResponse : Response -> Raw.Response -> Task x ()
runResponse res rawres = case res of
  Html vdom -> Raw.writeHtml rawres (toHTML vdom)
  Json json -> Raw.writeJson rawres json
  Text text -> Raw.writeText rawres text
  EmptyRes  -> Task.succeed ()

type alias Server model = Signal Request -> Signal (model, Response)
type alias Port = Raw.Port

run : Port -> Server model -> Signal (Task x ())
run p s = let

  server : Mailbox (Raw.Request, Raw.Response)
  server = mailbox (Raw.emptyReq, Raw.emptyRes)

  reply : Signal (Task x ())
  reply = (runResponse << snd)
    <~ s (marshallRequest <~ (fst <~ server.signal))
     ~ (snd <~ server.signal)

  create : Signal (Task x ())
  create = constant <|
    Raw.createServer'
      server.address p ("Listening on " ++ toString p)
    `andThen` always (Task.succeed ())

  in merge create reply
