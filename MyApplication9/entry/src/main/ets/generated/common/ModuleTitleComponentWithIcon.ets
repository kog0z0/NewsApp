
import { BreakpointConstants } from './BreakpointConstants';
import { CommonConstants } from './CommonConstants';

@Component
export struct ModuleTitleComponentWithIcon {
  @StorageLink('currentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  public moduleIcon: Resource = $r("app.media.icon");
  public title: string = '';
  public moduleRedirectContent: string = '';
  @Consume('appPathStack') appPathStack: NavPathStack;

  jump(): void {
    this.appPathStack.pushPathByName('EmptyPagePathStack', null);
  }

  build() {
    Row() {
      Row() {
        Image(this.moduleIcon)
          .height('20vp')
          .width('20vp')
          .margin({
            right: "4vp"
          })
        Text(this.title)
          .fontSize("16fp")
          .fontWeight(CommonConstants.FONT_WEIGHT_500)
          .fontColor($r('sys.color.font_primary'))
      }

      Text(this.moduleRedirectContent)
        .fontColor(Color.Gray)
        .fontSize('12fp')
        .fontWeight(CommonConstants.FONT_WEIGHT_500)
        .onClick(() => {
          this.jump()
        })
        .margin({
          right: "4vp"
        })
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({ left: 6, right: 6 })
    .height("30vp")
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius($r('sys.float.corner_radius_level6'))
  }
}
