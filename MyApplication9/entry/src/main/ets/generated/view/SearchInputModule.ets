/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Component
export struct SearchInputModule {
  @State search_placeholder: string = "搜索新闻"
  @State buttonText: string = '搜索'
  @State translateY: number = 0;
  @State transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
  @Consume('appPathStack') appPathStack: NavPathStack;

  build() {
    /**
     * TODO:
     * please modify it according to the actual situation.
     * modify {@link SearchModuleWithButton#search_placeholder}
     */
    Column(){
      Search({ placeholder: this.search_placeholder })
        /**
         * TODO:
         * please modify it according to the actual situation.
         * modify {@link SearchModuleWithButton#buttonText}
         */
        .searchButton(this.buttonText)
        .width("92%")
        .enableKeyboardOnFocus(false)
        .placeholderColor($r('sys.color.font_secondary'))
        .placeholderFont({
          family: "HarmonyHeiTi",
          size: $r('sys.float.ohos_id_text_size_body1'),
          weight: 100
        })
        .borderColor($r('sys.color.font_primary'))
        .searchIcon({ src: $r('sys.symbol.search_things') })
        .fontColor($r('sys.color.font_primary'))
        .onClick(() => {
          this.appPathStack.pushPathByName('SearchPagePathStack', null)
        })
    }
    .width('100%')
  }
}
