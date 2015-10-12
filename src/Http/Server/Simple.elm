module Http.Server.Simple where

import Http.Server as Raw
import Html
import Json.Encode as Json
import Effects exposing (Effects, Never)
import Task exposing (Task, andThen)
import VDOMtoHTML exposing (toHTML)
import Signal exposing (..)
import Debug

type alias Head = List Raw.Header

type Response
  = Html Html.Html
  | Json Json.Value
  | Text String

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
runResponse rawres res =
  case res of
    Html vdom -> Raw.writeHtml rawres (toHTML vdom)
    Json json -> Raw.writeJson rawres json
    Text text -> Raw.writeText rawres text

type alias Server = Signal Request -> Signal (Effects Response)
type alias Port = Raw.Port

-- run : Port -> Server -> Signal (Task Never ())
run p s = let

  (>>=) = andThen

  server : Mailbox (Raw.Request, Raw.Response)
  server = mailbox (Raw.emptyReq, Raw.emptyRes)

  reply : Signal (Task Never ())
  reply = let
    reqs = fst <~ server.signal
    ress = snd <~ server.signal
    go : Effects Response -> Raw.Response -> Task Never ()
    go effres rawres =
      Effects.toTask (Debug.crash "sendy") effres >>= runResponse rawres
    in go <~ s (marshallRequest <~ reqs) ~ ress

  create : Signal (Task Never ())
  create = constant <|
    Raw.createServer'
      server.address p ("Listening on" ++ toString p)
    >>= always (Task.succeed ())

  in merge create reply



-- type alias Config req model =
--   { initial : (Request req, Effects model)
--   , update : model -> Request req -> (Request req, Effects model)
--   , respond : model -> Request req -> Response
--   , inputs : List (Signal action) }

-- type alias App model =
--
--
-- html : Html.Html -> Response a
-- html = Response [ Raw.textHtml ] << Html
--
-- startServer : Config -> App
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
-- the server has a shared state
-- each request has a state
-- response is IO
-- db is IO
--
-- a request can go through a cycle
--
--
--
--
-- update : model -> Request req -> (Request req, Effects model)
--
-- act     : model -> Request r -> a -> (model, Request r, Effects a)
-- respond : Request r -> model -> (Response, model)
--
--
-- f : Request r -> model -> (model, Effects action)
--
-- -- g : Request r -> model -> (model, Either Response (Request r, Effects action))
--
-- Request action -> model -> (model, Effects action)
--
-- g req model
