
import { BuilderNode, FrameNode, NodeController, Size } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { CommonConstants } from '../common/CommonConstants';
import Logger from './Logger';

let nodeMap: Map<string, MyNodeController | undefined> = new Map();
let controllerMap: Map<string, WebviewController | undefined> = new Map();
let onPageEndMap: Map<string, Function | undefined> = new Map();
let onProgressChangeMap: Map<string, Function | undefined> = new Map();
let onResourceLoadMap: Map<string, Function | undefined> = new Map();
let context: UIContext;

class Data {
  public url: string;
  public controller: WebviewController;
  public onPageEndAction?: Function;
  public onProgressChangeAction?: Function;
  public onResourceLoadAction?: Function;

  constructor(url: string, controller: WebviewController) {
    this.url = url;
    this.controller = controller;
  }
}

// Developer-defined template
@Builder
function webBuilder(data: Data) {
  Web({ src: data.url.split('~')[0], controller: data.controller })
    .domStorageAccess(true)
    .zoomAccess(true)
    .fileAccess(true)
    .mixedMode(MixedMode.All)
    .cacheMode(CacheMode.Default)
    .verticalScrollBarAccess(false)
    .javaScriptAccess(true)
    .pinchSmooth(true)
    .onFirstContentfulPaint(() => {
      nodeMap.set('hmos_' + data.url, undefined);
    })
    .onPageEnd(() => {
      onPageEndMap.get(data.url)?.();
    })
    .onProgressChange((event) => {
      Logger.info('newProgress:' + event?.newProgress);
      if (event?.newProgress === 100) {
        onProgressChangeMap.get(data.url)?.();
      }
      Logger.info('onProgressChange weburl: ' + data.url);
    })
    .onResourceLoad((event) => {
      Logger.info('onResourceLoad:' + event?.url);
      onResourceLoadMap.get(data.url)?.(event.url);
    })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
}

let wrap = wrapBuilder<Data[]>(webBuilder);

export class MyNodeController extends NodeController {
  private rootNode: BuilderNode<Data[]> | null | undefined = null;
  private isRemove: boolean = false;

  makeNode(uiContext: UIContext): FrameNode | null {
    Logger.info('uiContext is undifined : ' + (uiContext === undefined));
    if (this.isRemove) {
      return null;
    }
    if (this.rootNode != undefined) {
      return this.rootNode.getFrameNode();
    }
    return null;
  }

  disposeNode() {
    this.rootNode?.dispose();
  }

  aboutToResize(size: Size) {
    Logger.info('aboutToResize width : ' + size.width + ' height : ' + size.height);
  }

  aboutToAppear() {
    if (this.rootNode == undefined) {
      return;
    }
  }

  aboutToDisappear() {
    Logger.info('aboutToDisappear');
  }


  initWeb(url: string, uiContext: UIContext, control: WebviewController, onPageEndAction?: Function) {
    if (this.rootNode != null) {
      return;
    }
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.dispose()
    this.rootNode.build(wrap, { url: url, controller: control });
  }
}

export function createNWeb(url: string, uiContext?: UIContext) {
  if (nodeMap.has(url)) {
    return;
  }
  if (!context && uiContext) {
    context = uiContext;
  }
  let baseNode = new MyNodeController();
  let controller = new webview.WebviewController();
  baseNode.initWeb(url, context, controller);
  controllerMap.set(url, controller)
  nodeMap.set(url, baseNode);
}

export const getNWeb = (url: string): MyNodeController | undefined => {
  return nodeMap.get(url);
}

export const deleteNode = (url: string) => {
  let nodeController = nodeMap.get(url);
  nodeController?.disposeNode();
  nodeMap.delete(url);
  controllerMap.delete(url);
  onPageEndMap.delete(url);
}