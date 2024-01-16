class GreenButtonState {
  width: number = 0;
  constructor(width: number) {
    this.width = width;
  }
}
@Component
struct GreenButton {
  // 双向绑定
  @Link greenButtonState: GreenButtonState;
  build() {
    Button('Green Button')
      .width(this.greenButtonState.width)
      .height(150.0)
      .backgroundColor('#00ff00')
      .onClick(() => {
        if (this.greenButtonState.width < 700) {
          // 更新class的属性，变化可以被观察到同步回父组件
          this.greenButtonState.width += 125;
        } else {
          // 更新class，变化可以被观察到同步回父组件
          this.greenButtonState = new GreenButtonState(100);
        }
      })
  }
}
@Component
struct YellowButton {
  @Link yellowButtonState: number;
  build() {
    Button('Yellow Button')
      .width(this.yellowButtonState)
      .height(150.0)
      .backgroundColor('#ffff00')
      .onClick(() => {
        // 子组件的简单类型可以同步回父组件
        this.yellowButtonState += 50.0;
      })
  }
}
@Entry
@Component
struct ShufflingContainer {
  @State greenButtonState: GreenButtonState = new GreenButtonState(300);
  @State yellowButtonProp: number = 100;
  build() {
    Column() {
      // 简单类型从父组件@State向子组件@Link数据同步
      Button('Parent View: Set yellowButton')
        .onClick(() => {
          this.yellowButtonProp = (this.yellowButtonProp < 700) ? this.yellowButtonProp + 100 : 100;
        })
      // class类型从父组件@State向子组件@Link数据同步
      Button('Parent View: Set GreenButton')
        .onClick(() => {
          this.greenButtonState.width = (this.greenButtonState.width < 700) ? this.greenButtonState.width + 100 : 100;
        })
      // class类型初始化@Link
      GreenButton({ greenButtonState: $greenButtonState })
      // 简单类型初始化@Link
      YellowButton({ yellowButtonState: $yellowButtonProp })
    }
  }
}