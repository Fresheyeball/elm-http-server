module Http.Server.Isomorphic where

import String exposing (join)
import Html exposing (Html)
import FS exposing (readFile, ReadError)
import Task exposing (andThen, succeed, Task)
import VDOMtoHTML exposing (toHTML)

type alias Path = String
type alias ModuleName = List String

embed : (ModuleName, Path) -> Html -> Task ReadError String
embed (modulename, path) html = let
  joinOn = flip join modulename
  g js = """

    <!DOCTYPE HTML>
    <html>
      <head>
        <meta charset="UTF-8">
        <title>""" ++ joinOn " " ++ """</title>
      </head>
      <body>
        <div id="elm">
          """ ++ toHTML html ++ """
        </div>
        <script>
          """ ++ js ++ """
          Elm.embed
            ( Elm.""" ++ joinOn "." ++ """
            , document.getElementById("elm") );
        </script>
      </body>
    </html>"""

  in readFile path `andThen` (g >> succeed)
