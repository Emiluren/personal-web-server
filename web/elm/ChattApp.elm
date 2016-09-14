module ChattApp exposing (..)

import Html exposing (Html, text, div, input, br, form)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput, onSubmit)
import Html.App
import Json.Encode as JE
import Json.Decode as JD exposing ((:=))
import Phoenix.Socket exposing (Socket)
import Phoenix.Channel
import Phoenix.Push
import Debug


type Msg
    = PhoenixMsg (Phoenix.Socket.Msg Msg)
    | SetNewMessage String
    | SendMessage
    | ReceiveChatMessage JE.Value


type alias Model =
    { phxSocket : Socket Msg
    , currentMessage : String
    , messages : List String
    }


type alias ChatMessage =
    { body : String }


init : ( Model, Cmd Msg )
init =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
                |> Phoenix.Socket.on "new_msg" "room:lobby" ReceiveChatMessage
                |> Phoenix.Socket.join (Phoenix.Channel.init "room:lobby")

        -- |> Phoenix.Socket.withDebug
    in
        { phxSocket = phxSocket
        , currentMessage = ""
        , messages = []
        }
            ! [ Cmd.map PhoenixMsg phxCmd ]


chatMessageDecoder : JD.Decoder ChatMessage
chatMessageDecoder =
    JD.object1 ChatMessage
        ("body" := JD.string)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ReceiveChatMessage raw ->
            case JD.decodeValue chatMessageDecoder raw of
                Ok chatMessage ->
                    ( { model | messages = chatMessage.body :: model.messages }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        SetNewMessage str ->
            { model | currentMessage = str } ! []

        SendMessage ->
            let
                payload =
                    JE.object [ ( "body", JE.string model.currentMessage ) ]

                push =
                    Phoenix.Push.init "new_msg" "room:lobby"
                        |> Phoenix.Push.withPayload payload

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.push push model.phxSocket
            in
                ( { model
                    | currentMessage = ""
                    , phxSocket = phxSocket
                  }
                , Cmd.map PhoenixMsg phxCmd
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg


showMessage : String -> Html a
showMessage str =
    div []
        [ Html.text str
        ]


messageList : List String -> List (Html a)
messageList messages =
    List.map showMessage messages


view : Model -> Html Msg
view model =
    div []
        <| (messageList model.messages)
        ++ [ form [ onSubmit SendMessage ]
                [ input [ onInput SetNewMessage, value model.currentMessage ] []
                ]
           ]


main : Program Never
main =
    Html.App.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
