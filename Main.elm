import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (Html)
import Html.App as Html
import Mouse


type alias Model =
  { position : Mouse.Position
  }


type Msg
  = MoveMouse Mouse.Position


model : Model
model =
  { position =
    { x = 0
    , y = 0
    }
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoveMouse newPosition ->
      { model | position = newPosition } ! []


view : Model -> Html Msg
view model =
  squares (model.position.x, model.position.y)
    |> Element.toHtml


main : Program Never
main =
  Html.program
    { init = (model, Cmd.none)
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.moves MoveMouse


squares : (Int, Int) -> Element
squares (x, y) =
  let
    theGroup =
      group
        [ move (0,-55) blueSquare
        , move (0, 55) redSquare
        ]

    originGroup =
      move (-400, 400) theGroup

    movedGroup =
        move (toFloat(x), toFloat(-y)) originGroup
  in
    collage 800 800 [ movedGroup ]


blueSquare : Form
blueSquare =
  traced (dashed blue) square


redSquare : Form
redSquare =
  traced (solid red) square


square : Path
square =
  path [ (50,50), (50,-50), (-50,-50), (-50,50), (50,50) ]
