module Server where

import Http.Server.Simple exposing (..)
import Html exposing (h1,text,Html)
import Effects exposing (Never)
import Task exposing (Task)
import Signal exposing (..)

type alias RequestCount = Int

view : RequestCount -> Html
view count = let
  times = toString count ++ if count == 1 then " time." else " times."
  in h1 [] [ text <| "Wowzers, server hit " ++ times ]

route : Request -> (RequestCount, Response) -> (RequestCount, Response)
route {url} (count, _) = let count' = count + 1 in case url of
    "/"      -> (count', Html (view count'))
    "/reset" -> (0,      Text "Count Reset")
    _        -> (count,  Text "404")

server : Server RequestCount
server sigreq = foldp route (0, EmptyRes) sigreq

port serve : Signal (Task Never ())
port serve = run 8080 server
