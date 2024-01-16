@Component
struct CountDownComponent {
  // 核心就是这里，被Prop注解修饰的变量，父组件修改可以影响到子组件，但子组件不能影响父组件，父组件的修改可以覆盖子组件的修改
  @Prop count: number;
  costOfOneAttempt: number = 1;

  build() {
    Column() {
      if (this.count > 0) {
        Text(`You have ${this.count} Nuggets left`)
      } else {
        Text('Game over!')
      }
      // @Prop装饰的变量不会同步给父组件
      Button(`Try again`).onClick(() => {
        this.count -= this.costOfOneAttempt;
      })
    }
  }
}

@Entry
@Component
struct ParentComponent {
  @State countDownStartValue: number = 10;

  build() {
    Column() {
      Text(`Grant ${this.countDownStartValue} nuggets to play.`)
      // 父组件的数据源的修改会同步给子组件
      Button(`+1 - Nuggets in New Game`).onClick(() => {
        this.countDownStartValue += 1;
      })
      // 父组件的修改会同步给子组件
      Button(`-1  - Nuggets in New Game`).onClick(() => {
        this.countDownStartValue -= 1;
      })

      CountDownComponent({ count: this.countDownStartValue, costOfOneAttempt: 2 })
    }
  }
}