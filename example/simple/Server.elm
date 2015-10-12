module Server where

import Http.Server.Simple exposing (..)
import Html exposing (h1,text)
import Effects exposing (..)

server = foldp 
