module Main where

import Html exposing (..)

type alias Model =
  { text : String }

initial : Model
initial = Model "Wowzers in my Trousers"

view : Model -> Html
view m = div []
  [ h1 []
      [ text (.text m) ]
  , input [] [] ]

main : Html
main = view initial

elmId : (List String, String)
elmId = (["Main"], "example/isomorphic-templating/main.js")
