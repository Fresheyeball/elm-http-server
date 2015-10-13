module Server where

import Http.Server.Simple exposing (..)
import Html exposing (h1,text)
import Effects exposing (Never)
import Task exposing (Task)
import Signal exposing (..)

type alias State = List Int

-- route : Request -> (State, Response) -> (State, Response)
route {url} _ = case url of
  "/" -> Html <| h1 [] [ text "Wowzers" ]
  _   -> Text "404"

server : Server
server sigreq =
  Task.succeed <~ (route <~ sigreq ~ constant EmptyRes)

port serve : Signal (Task Never ())
port serve = run 8080 server
