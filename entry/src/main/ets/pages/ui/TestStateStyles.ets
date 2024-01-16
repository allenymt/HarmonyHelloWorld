@Entry
@Component
struct StateStylesSample {
  build() {
    Column() {
      Button("I am first")
      Button('Click me')
        .stateStyles({
          focused: {
            .backgroundColor(Color.Pink)
          },
          pressed: {
            .backgroundColor(Color.Black)
          },
          normal: {
            .backgroundColor(Color.Yellow)
          }
        })
    }.margin('30%')
  }
}