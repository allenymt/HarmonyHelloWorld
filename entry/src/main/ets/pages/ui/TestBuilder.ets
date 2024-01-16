@Builder function GlobalBuilder1($$ : {label: string }) {
  Text($$.label)
    .width(400)
    .height(50)
    .backgroundColor(Color.Yellow)
}

@Component
struct Child {
  label: string = 'Child'
  // 无参数类，指向的componentBuilder也是无参数类型
  @BuilderParam aBuilder0: () => void;
  // 有参数类型，指向的GlobalBuilder1也是有参数类型的方法
  @BuilderParam aBuilder1: ($$ : { label : string}) => void;

  build() {
    Column() {
      this.aBuilder0()
      Divider().color(Color.Gray)
      this.aBuilder1({label: 'global Builder label' } )
    }
  }
}

// @Entry
@Component
struct Parent {
  label: string = 'Parent'

  @Builder componentBuilder() {
    Text(`${this.label}`)
  }

  build() {
    Column() {
      this.componentBuilder()
      Divider().height(20)
      Child({ aBuilder0: this.componentBuilder, aBuilder1: GlobalBuilder1 })
    }
  }
}




// xxx.ets
@Component
struct CustomContainer {
  @Prop header: string;
  @BuilderParam closer: () => void

  build() {
    Column() {
      Text(this.header)
        .fontSize(30)
      this.closer()
    }
  }
}

@Builder function specificParam(label1: string, label2: string) {
  Column() {
    Text(label1)
      .fontSize(30)
    Text(label2)
      .fontSize(30)
  }
}

@Entry
@Component
struct CustomContainerUser {
  @State text: string = 'header';

  build() {
    Column() {
      // 创建CustomContainer，在创建CustomContainer时，通过其后紧跟一个大括号“{}”形成尾随闭包
      // 作为传递给子组件CustomContainer @BuilderParam closer: () => void的参数
      CustomContainer({ header: this.text }) {
        Column() {
          specificParam('testA', 'testB')
        }.backgroundColor(Color.Yellow)
        .onClick(() => {
          this.text = 'changeHeader';
        })
      }
    }
  }
}