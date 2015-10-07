module Main where

import Html exposing (..)

main : Html
main = div []
  [ h1 []
      [ text "Wowzers in my Trousers" ]
  , input [] [] ]

elmId : (List String, String)
elmId = (["Main"], "example/main.js")
