class Model {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

@Entry
@Component
struct EntryComponent {
  build() {
    Column() {
      // 此处指定的参数都将在初始渲染时覆盖本地定义的默认值，并不是所有的参数都需要从父组件初始化
      MyComponent({ count: 1, increaseBy: 2 })
      MyComponent({ title: new Model('Hello, World 2'), count: 7 })
    }
  }
}

@Component
struct MyComponent {
  // 暂时理解 @State对标了Flutter的setState， 这种应该是更轻量化
  @State title: Model = new Model('Hello World');
  @State count: number = 0;
  private increaseBy: number = 1;

  build() {
    Column() {
      Text(`${this.title.value}`)
      Button(`Click to change title`).onClick(() => {
        // @State变量的更新将触发上面的Text组件内容更新,
        // 但是如果value是个class，再嵌套一层就监听不到了，这个怎么解决呢？ todo
        // 嵌套的属性赋值观察不到: this.title.name.value = 'ArkUI'
        this.title.value = this.title.value === 'Hello ArkUI' ? 'Hello World' : 'Hello ArkUI';
      })

      Button(`Click to increase count=${this.count}`).onClick(() => {
        // @State变量的更新将触发该Button组件的内容更新
        this.count += this.increaseBy;
      })
    }
  }
}