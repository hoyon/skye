type state = {text: string, message: string};

type action =
  | Click
  | GotResponse(string)
  | InputText(string);

let component = ReasonReact.reducerComponent("Placeholder");

let make = _children => {
  ...component,

  initialState: () => {text: "", message: ""},

  reducer: (action, state) =>
    switch (action) {
    | Click =>
      let payload = Js.Dict.empty();
      Js.Dict.set(payload, "message", Js.Json.string(state.message));
      ReasonReact.UpdateWithSideEffects(
        state,
        self =>
          Js.Promise.(
            Fetch.fetchWithInit(
              "http://localhost:4000/send-message",
              Fetch.RequestInit.make(
                ~method_=Post,
                ~body=Fetch.BodyInit.make(Js.Json.stringify(Js.Json.object_(payload))),
                ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
                (),
              ),
            )
            |> then_(Fetch.Response.text)
            |> then_(text =>
                 Js.Promise.resolve(self.send(GotResponse(text)))
               )
            |> ignore
          ),
      )
    | GotResponse(t) => ReasonReact.Update({...state, text: t})
    | InputText(t) => ReasonReact.Update({...state, message: t})
    },

  render: self => {
    <div>
      <button onClick={_event => self.send(Click)}>
        {ReasonReact.string("Send message")}
      </button>
      <input onInput={event => self.send(InputText(event->ReactEvent.Form.target##value))}>
      </input>
      {ReasonReact.string(self.state.text)}
    </div>;
  },
};
