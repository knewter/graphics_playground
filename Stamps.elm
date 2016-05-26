module Stamps exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (..)
import Html.App as Html
import Mouse


type alias Position =
  (Int, Int)


type alias Model =
  { clicks : List Position
  }


type Msg
  = AddClick Position


model : Model
model =
  { clicks = clicks
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddClick pos ->
      { model | clicks = pos :: model.clicks } ! []


-- drawStamp takes a position and return a graphics form
drawStamp : (Int, Int) -> Form
drawStamp (x, y) =
  -- Let's draw a polygon with a radius of 50
  ngon 5 50
  -- Fill it red
  |> filled red
  -- And move it to the appropriate position
  |> move (toFloat(x), toFloat(-1 * y))


view : Model -> Html Msg
view model =
  let
    theGroup =
      -- Map a list of positions through our drawstamp function to get a list
      -- of forms, and put them in a group
      group (List.map drawStamp model.clicks)

    -- We'll move the group to the origin like we did in the previous examples
    originGroup =
      move (-400, 400) theGroup
  in
    -- Now make a collage containing the group
    collage 800 800
      [ originGroup ]
      |> Element.toHtml


clicks : List (Int, Int)
clicks =
  -- We'll just hardcode a list of positions
  [(0, 0), (100, 100), (200, 100)]


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
  Mouse.clicks (\{x, y} -> AddClick (x, y))
