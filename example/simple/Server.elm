module Server where

import Http.Server.Simple exposing (..)
import Html exposing (h1,text)
import Effects exposing (..)

-- update : (Request, action) -> (Response, Effects action)
update (req, a) = case .url req of
  "/" -> html <| h1 []
          [ text "wowzers!" ]
