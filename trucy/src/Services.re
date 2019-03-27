type state =
  | Loading
  | Loaded(array(string));

type action =
  | GotServices(array(string));

let component = ReasonReact.reducerComponent("Services");

let service = json => {
  Json.Decode.(json |> field("name", string));
};

let services = json => {
  Json.Decode.(json |> field("services", array(service)));
};

let decodeData = json => {
  Json.Decode.(json |> field("data", services))
}

let make = _children => {
  ...component,
  initialState: _state => Loading,
  reducer: (action, _state) =>
    switch (action) {
    | GotServices(services) => ReasonReact.Update(Loaded(services))
    },
  didMount: self => {
    let query = "query{services{name}}";
    Js.Promise.(
      Fetch.fetchWithInit(
      "http://localhost:4000/api",
      Fetch.RequestInit.make(
        ~method_=Post,
        ~body=Fetch.BodyInit.make(query),
        (),
      ),
    )
      |> then_(Fetch.Response.json)
      |> then_(json => {
          let s = decodeData(json);
          Js.Promise.resolve(self.send(GotServices(s)));
        })
      |> ignore
    );
  },
  render: self => {
    switch (self.state) {
    | Loading => <div>{ReasonReact.string("Loading..")}</div>
    | Loaded(services) => <ul>{ReasonReact.array(Array.map(s => <li>{ReasonReact.string(s)}</li>, services))}</ul>
    }
  }
};
