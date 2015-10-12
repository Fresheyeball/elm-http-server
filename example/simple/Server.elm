module Server where

import Http.Server.Simple exposing (..)
import Html exposing (h1,text)
import Effects exposing (..)
import Signal exposing (..)

type alias State = List Int

server = foldp identity []
