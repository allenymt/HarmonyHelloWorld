// objectLinkNestedObjects.ets
let NextID: number = 1;

@Observed
class ClassA {
  public id: number;
  public c: number;

  constructor(c: number) {
    this.id = NextID++;
    this.c = c;
  }
}

@Observed
class ClassB {
  public a: ClassA;

  constructor(a: ClassA) {
    this.a = a;
  }
}

@Component
struct ViewA {
  label: string = 'ViewA1';
  // @ObjectLink修饰，因此在viewA内部，修改a里的变量值，外部也能观测到
  @ObjectLink a: ClassA;

  build() {
    Row() {
      Button(`ViewA [${this.label}] this.a.c=${this.a.c} +1`)
        .onClick(() => {
          this.a.c += 1;
          // 如果加上这一句会崩溃，Error message: Cannot set property when setter is undefined
          // 原因是@ObjectLink修饰的变量是只读的
          // this.a =  new ClassA(0);
        })
    }
  }
}

// @Entry
@Component
struct ViewB {
  @State b: ClassB = new ClassB(new ClassA(0));

  build() {
    Column() {
      // in low version,DevEco may throw a warning,but it does not matter.
      // you can still compile and run.
      ViewA({ label: 'ViewA #1', a: this.b.a })
      ViewA({ label: 'ViewA #2', a: this.b.a })

      Button(`ViewB: this.b.a.c+= 1`)
        .onClick(() => {
          this.b.a.c += 1;
        })
      Button(`ViewB: this.b.a = new ClassA(0)`)
        .onClick(() => {
          // 执行这一步后，相当于a被重置，里面的数据恢复默认状态
          this.b.a = new ClassA(0);
        })
      Button(`ViewB: this.b = new ClassB(ClassA(0))`)
        .onClick(() => {
          // 同上，引用被重置
          this.b = new ClassB(new ClassA(0));
        })
    }
  }
}

//this.arrA[Math.floor(this.arrA.length/2)] = new ClassA(..) ：该状态变量的改变触发2次更新：
// ForEach：数组项的赋值导致ForEach的itemGenerator被修改，因此数组项被识别为有更改，ForEach的item builder将执行，创建新的ViewA组件实例。
// ViewA({ label: `ViewA this.arrA[last]`, a: this.arrA[this.arrA.length-1] })：上述更改改变了数组中第二个元素，所以绑定this.arrA[1]的ViewA将被更新；
// this.arrA.push(new ClassA(0)) ： 将触发2次不同效果的更新：
// ForEach：新添加的ClassA对象对于ForEach是未知的itemGenerator，ForEach的item builder将执行，创建新的ViewA组件实例。
// ViewA({ label: `ViewA this.arrA[last]`, a: this.arrA[this.arrA.length-1] })：数组的最后一项有更改，因此引起第二个ViewA的实例的更改。对于ViewA({ label: `ViewA this.arrA[first]`, a: this.arrA[0] })，数组的更改并没有触发一个数组项更改的改变，所以第一个ViewA不会刷新。
// this.arrA[Math.floor(this.arrA.length/2)].c：@State无法观察到第二层的变化，但是ClassA被@Observed装饰，ClassA的属性的变化将被@ObjectLink观察到。
@Entry
@Component
struct ViewC {
  // ViewB中有@State装饰的ClassA[]
  @State arrA: ClassA[] = [new ClassA(0), new ClassA(0)];

  build() {
    Column() {
      ForEach(this.arrA,
        (item) => {
          ViewA({ label: `#${item.id}`, a: item })
        },
        (item) => item.id.toString()
      )
      // 使用@State装饰的数组的数组项初始化@ObjectLink，其中数组项是被@Observed装饰的ClassA的实例
      ViewA({ label: `ViewA this.arrA[first]`, a: this.arrA[0] })
      ViewA({ label: `ViewA this.arrA[last]`, a: this.arrA[this.arrA.length-1] })

      Button(`ViewB: reset array`)
        .onClick(() => {
          this.arrA = [new ClassA(0), new ClassA(0)];
        })
      Button(`ViewB: push`)
        .onClick(() => {
          this.arrA.push(new ClassA(0))
        })
      Button(`ViewB: shift`)
        .onClick(() => {
          this.arrA.shift()
        })
      Button(`ViewB: chg item property in middle`)
        .onClick(() => {
          this.arrA[Math.floor(this.arrA.length / 2)].c = 10;
        })
      Button(`ViewB: chg item property in middle`)
        .onClick(() => {
          this.arrA[Math.floor(this.arrA.length / 2)] = new ClassA(11);
        })
    }
  }
}