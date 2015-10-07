module Http.Server.Isomorphic where

import String exposing (join)
import FS exposing (readFile, ReadError)
import Task exposing (andThen, succeed, Task)

type alias Path = String
type alias ModuleName = List String

embed : (ModuleName, Path) -> String -> Task ReadError String
embed (modulename, path) html = let
  g js = """

    <!DOCTYPE HTML>
    <html>
      <head>
        <meta charset="UTF-8">
        <title>Line</title>
        <style>
          html, head, body { padding:0; margin:0; }
          body { font-family: calibri, helvetica, arial, sans-serif; }
          a:link { text-decoration: none; color: rgb(15,102,230); }
          a:visited { text-decoration: none; }
          a:active { text-decoration: none; }
          a:hover { text-decoration: underline; color: rgb(234,21,122); }
          html,body { height: 100%; margin: 0px; }
        </style>

      </head>
      <body>
        <div id="elm">
          """ ++ html ++ """
        </div>
        <script>
          """ ++ js ++ """
          var runningElmModule =
            Elm.embed(Elm.""" ++ join "." modulename ++ """,
            document.getElementById("elm"));
        </script>
      </body>
    </html>"""

  in

    readFile path `andThen` (g >> succeed)
